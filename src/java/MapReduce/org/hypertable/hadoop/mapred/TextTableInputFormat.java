/**
 * Copyright (C) 2010 Doug Judd (Hypertable, Inc.)
 *
 * This file is part of Hypertable.
 *
 * Hypertable is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or any later version.
 *
 * Hypertable is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

package org.hypertable.hadoop.mapred;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.InputFormat;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.InputSplit;
import org.apache.hadoop.mapred.RecordReader;
import org.apache.hadoop.mapred.Reporter;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.JobConfigurable;

import org.hypertable.thriftgen.*;
import org.hypertable.Common.Time;
import org.hypertable.hadoop.mapreduce.ScanSpec;
import org.hypertable.hadoop.mapred.TableSplit;

import org.hypertable.thrift.ThriftClient;

import org.apache.thrift.transport.TTransportException;
import org.apache.thrift.TException;

public class TextTableInputFormat
implements org.apache.hadoop.mapred.InputFormat<Text, Text>, JobConfigurable {

  final Log LOG = LogFactory.getLog(InputFormat.class);

  public static final String NAMESPACE          = "hypertable.mapreduce.namespace";
  public static final String INPUT_NAMESPACE    = "hypertable.mapreduce.input.namespace";
  public static final String TABLE              = "hypertable.mapreduce.input.table";
  public static final String COLUMNS            = "hypertable.mapreduce.input.scan_spec.columns";
  public static final String OPTIONS            = "hypertable.mapreduce.input.scan_spec.options";
  public static final String ROW_INTERVAL       = "hypertable.mapreduce.input.scan_spec.row_interval";
  public static final String TIMESTAMP_INTERVAL = "hypertable.mapreduce.input.scan_spec.timestamp_interval";
  public static final String INCLUDE_TIMESTAMPS = "hypertable.mapreduce.input.include_timestamps";

  private ThriftClient m_client = null;
  private ScanSpec m_base_spec = null;
  private String m_namespace = null;
  private String m_tablename = null;
  private boolean m_include_timestamps = false;

  private static String stripQuotes(String str) {
    if (str != null && str.length() > 0) {
      if ((str.charAt(0) == '\'' && str.charAt(str.length()-1) == '\'') ||
          (str.charAt(0) == '"' && str.charAt(str.length()-1) == '"'))
        return str.substring(1, str.length()-1);
    }
    return str;
  }

  public void parseOptions(JobConf job) throws ParseException {
    String str = job.get(OPTIONS);
    if (str != null) {
      String [] strs = str.split("\\s");
      for (int i=0; i<strs.length; i++) {
        strs[i] = strs[i].toUpperCase();
        if (strs[i].equals("MAX_VERSIONS") || strs[i].equals("REVS")) {
          i++;
          if (i==strs.length)
            throw new ParseException("Bad OPTIONS spec", i);
          int value = Integer.parseInt(strs[i]);
          m_base_spec.setRevs(value);
        }
        else if (strs[i].equals("CELL_LIMIT")) {
          i++;
          if (i==strs.length)
            throw new ParseException("Bad OPTIONS spec", i);
          int value = Integer.parseInt(strs[i]);
          m_base_spec.setCell_limit(value);
        }
        else if (strs[i].equals("KEYS_ONLY")) {
          m_base_spec.setKeys_only(true);
        }
        else
          throw new ParseException("Bad OPTIONS spec: "+strs[i], i);
      }
    }
  }

  public void parseColumns(JobConf job) {
    String str = job.get(COLUMNS);
    if (str != null) {
      String [] columns = str.split(",");
      for (int i=0; i<columns.length; i++)
        m_base_spec.addToColumns(stripQuotes(columns[i]));
    }
  }

  public String [] parseRelopSpec(String str, String name) {
    String name_uppercase = name.toUpperCase();
    String name_lowercase = name.toLowerCase();
    String [] strs = new String [5];
    int ts_offset = str.indexOf(name_uppercase);
    if (ts_offset == -1)
      ts_offset = str.indexOf(name_lowercase);
    if (ts_offset == -1)
      return null;

    strs[0] = str.substring(0, ts_offset).trim();
    strs[2] = str.substring(ts_offset, ts_offset+name.length());
    strs[4] = str.substring(ts_offset+name.length()).trim();

    if (strs[0].length() > 0) {
      int offset = strs[0].length()-1;
      while (offset > 0 &&
             (strs[0].charAt(offset) == '<' ||
              strs[0].charAt(offset) == '=' ||
              strs[0].charAt(offset) == '>'))
        offset--;
      if (offset == -1 || offset == strs[0].length()-1)
        return null;
      strs[1] = strs[0].substring(offset+1);
      strs[0] = strs[0].substring(0, offset).trim();
    }

    if (strs[4].length() > 0) {
      int offset = 0;
      while (offset < strs[4].length() &&
             (strs[4].charAt(offset) == '<' ||
              strs[4].charAt(offset) == '=' ||
              strs[4].charAt(offset) == '>'))
        offset++;
      if (offset == strs[4].length() || offset == 0)
        return null;
      strs[3] = strs[4].substring(0, offset);
      strs[4] = strs[4].substring(offset).trim();
    }

    if (strs[0].length() == 0 && strs[4].length() == 0)
      return null;

    if (strs[0].length() == 0) {
      if (strs[3].equals(">") || strs[3].equals(">=")) {
        strs[0] = strs[4];
        if (strs[3].equals(">"))
          strs[1] = "<=";
        else if (strs[3].equals(">="))
          strs[1] = "<";
        strs[3] = null;
        strs[4] = null;
      }
    }
    else if (strs[4].length() == 0) {
      if (strs[1].equals(">") || strs[1].equals(">=")) {
        strs[4] = strs[0];
        if (strs[1].equals(">"))
          strs[3] = "<=";
        else if (strs[1].equals(">="))
          strs[3] = "<";
        strs[1] = null;
        strs[0] = null;
      }
    }
    else {
      if (strs[1].equals(">") || strs[1].equals(">=")) {
        if (!strs[3].equals(">") && !strs[3].equals(">="))
          return null;
        String tmp = strs[0];
        strs[0] = strs[4];
        strs[4] = tmp;
        if (strs[1].equals(">"))
          strs[1] = "<=";
        else if (strs[1].equals(">="))
          strs[1] = "<";
        if (strs[3].equals(">"))
          strs[3] = "<=";
        else if (strs[3].equals(">="))
          strs[3] = "<";
      }
    }

    if (strs[1] != null && strs[1].equals("=") && strs[3] != null && strs[3].equals("="))
      return null;

    strs[0] = stripQuotes(strs[0]);
    strs[4] = stripQuotes(strs[4]);

    return strs;
  }

  public void parseTimestampInterval(JobConf job) throws ParseException {
    String str = job.get(TIMESTAMP_INTERVAL);
    if (str != null) {
      Date ts;
      long epoch_time;
      String [] parsedRelop = parseRelopSpec(str, "TIMESTAMP");

      if (parsedRelop == null)
        throw new ParseException("Invalid TIMESTAMP interval: "+str, 0);

      if (parsedRelop[0] != null && parsedRelop[0].length() > 0) {
        ts = Time.parse_ts(parsedRelop[0]);
        epoch_time = ts.getTime() * 1000000;
        m_base_spec.setStart_time(epoch_time);
        if (parsedRelop[1].equals("="))
          m_base_spec.setEnd_time(epoch_time);
      }

      if (parsedRelop[4] != null && parsedRelop[4].length() > 0) {
        ts = Time.parse_ts(parsedRelop[4]);
        epoch_time = ts.getTime() * 1000000;
        m_base_spec.setEnd_time(epoch_time);
        if (parsedRelop[3].equals("="))
          m_base_spec.setStart_time(epoch_time);
      }
    }
  }

  public void parseRowInterval(JobConf job) throws ParseException {
    String str = job.get(ROW_INTERVAL);
    if (str != null) {
      Date ts;
      long epoch_time;
      String [] parsedRelop = parseRelopSpec(str, "ROW");
      RowInterval interval = new RowInterval();

      if (parsedRelop == null)
        throw new ParseException("Invalid ROW interval: "+str, 0);

      if (parsedRelop[0] != null && parsedRelop[0].length() > 0) {
        interval.setStart_row(parsedRelop[0]);
        interval.setStart_rowIsSet(true);
        if (parsedRelop[1].equals("<"))
          interval.setStart_inclusive(false);
        else if (parsedRelop[1].equals("<="))
          interval.setStart_inclusive(true);
        else
          throw new ParseException("Invalid ROW interval, bad RELOP (" + parsedRelop[1] + ")", 0);        
        interval.setStart_inclusiveIsSet(true);
      }

      if (parsedRelop[4] != null && parsedRelop[4].length() > 0) {
        interval.setEnd_row(parsedRelop[4]);
        interval.setEnd_rowIsSet(true);
        if (parsedRelop[3].equals("<"))
          interval.setEnd_inclusive(false);
        else if (parsedRelop[3].equals("<="))
          interval.setEnd_inclusive(true);
        else
          throw new ParseException("Invalid ROW interval, bad RELOP (" + parsedRelop[3] + ")", 0);
        interval.setEnd_inclusiveIsSet(true);
      }

      if(interval.isSetStart_row() || interval.isSetEnd_row()) {
        m_base_spec.addToRow_intervals(interval);
        m_base_spec.setRow_intervalsIsSet(true);
      }
    }
  }

  public void configure(JobConf job)
  {
    m_include_timestamps = job.getBoolean(INCLUDE_TIMESTAMPS, false);
    try {
      m_base_spec = new ScanSpec();

      parseColumns(job);
      parseOptions(job);
      parseTimestampInterval(job);
      parseRowInterval(job);

      System.out.println(m_base_spec);
    }
    catch (Exception e) {
      e.printStackTrace();
      System.exit(-1);
    }

  }

  protected class HypertableRecordReader
  implements org.apache.hadoop.mapred.RecordReader<Text, Text> {

    private ThriftClient m_client = null;
    private long m_ns = 0;
    private long m_scanner = 0;
    private String m_namespace = null;
    private String m_tablename = null;
    private ScanSpec m_scan_spec = null;
    private long m_bytes_read = 0;

    private List<Cell> m_cells = null;
    private Iterator<Cell> m_iter = null;
    private boolean m_eos = false;

    private Text m_key = new Text();
    private Text m_value = new Text();

    private byte[] t_row = null;
    private byte[] t_column_family = null;
    private byte[] t_column_qualifier = null;
    private byte[] t_timestamp = null;

    /* XXX make this less ugly and actually use stream.seperator */
    private byte[] tab = "\t".getBytes();
    private byte[] colon = ":".getBytes();

    /**
     *  Constructor
     *
     * @param client Hypertable Thrift client
     * @param namespace namespace containing table
     * @param tablename name of table to read from
     * @param scan_spec scan specification
     */
    public HypertableRecordReader(ThriftClient client, String namespace, String tablename, ScanSpec scan_spec)
     throws IOException {
      m_client = client;
      m_namespace = namespace;
      m_tablename = tablename;
      m_scan_spec = scan_spec;
      try {
        m_ns = m_client.namespace_open(m_namespace);
        m_scanner = m_client.scanner_open(m_ns, m_tablename, m_scan_spec);
      }
      catch (TTransportException e) {
        e.printStackTrace();
        throw new IOException(e.getMessage());
      }
      catch (TException e) {
        e.printStackTrace();
        throw new IOException(e.getMessage());
      }
      catch (ClientException e) {
        e.printStackTrace();
        throw new IOException(e.getMessage());
      }

    }

    public Text createKey() {
        return new Text("");
    }

    public Text createValue() {
        return new Text("");
    }

    public void close() {
      try {
        m_client.scanner_close(m_scanner);
        if (m_ns != 0)
          m_client.namespace_close(m_ns);
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }

    public long getPos() throws IOException {
            return m_bytes_read;
    }
    public float getProgress() {
      // Assume 200M split size
      if (m_bytes_read >= 200000000)
        return (float)1.0;
      return (float)m_bytes_read / (float)200000000.0;
    }

    private void fill_key(Text key, Key cell_key) {
      boolean clear = false;
      /* XXX not sure if "clear" is necessary */

      try {
        if (m_include_timestamps && cell_key.isSetTimestamp()) {
          t_timestamp = Long.toString(cell_key.timestamp).getBytes("UTF-8");
          clear = true;
        }

        if (cell_key.isSetRow()) {
          t_row = cell_key.row.getBytes("UTF-8");
          clear = true;
        }
        if (cell_key.isSetColumn_family()) {
          t_column_family = cell_key.column_family.getBytes("UTF-8");
          clear = true;
        }
        if (cell_key.isSetColumn_qualifier()) {
          t_column_qualifier = cell_key.column_qualifier.getBytes("UTF-8");
          clear = true;
        }
      }
      catch (UnsupportedEncodingException e) {
        e.printStackTrace();
        System.exit(-1);
      }

      if(clear) {
          key.clear();
          if(m_include_timestamps) {
              key.append(t_timestamp,0,t_timestamp.length);
              key.append(tab,0,tab.length);
          }
          key.append(t_row,0,t_row.length);
          key.append(tab,0,tab.length);
          key.append(t_column_family,0,t_column_family.length);
          if (t_column_qualifier.length > 0) {
            key.append(colon,0,colon.length);
            key.append(t_column_qualifier,0,t_column_qualifier.length);
          }
      }
    }

  public boolean next(Text key, Text value) throws IOException {
      try {
        if (m_eos)
          return false;
        if (m_cells == null || !m_iter.hasNext()) {
          m_cells = m_client.scanner_get_cells(m_scanner);
          if (m_cells.isEmpty()) {
            m_eos = true;
            return false;
          }
          m_iter = m_cells.iterator();
        }
        Cell cell = m_iter.next();
        fill_key(key, cell.key);
        m_bytes_read += 24 + cell.key.row.length();
        if (cell.value == null || !cell.value.hasRemaining()) {
          value.set("");
        } else {
          m_bytes_read +=  cell.value.remaining();
          value.set(cell.value.array(), cell.value.arrayOffset()+cell.value.position(),
                    cell.value.remaining());
        }

        if (cell.key.column_qualifier != null)
          m_bytes_read += cell.key.column_qualifier.length();
      }
      catch (TTransportException e) {
        e.printStackTrace();
        throw new IOException(e.getMessage());
      }
      catch (TException e) {
        e.printStackTrace();
        throw new IOException(e.getMessage());
      }
      catch (ClientException e) {
        e.printStackTrace();
        throw new IOException(e.getMessage());
      }
      return true;
    }

  }


  public RecordReader<Text, Text> getRecordReader(
      InputSplit split, JobConf job, Reporter reporter)
  throws IOException {
    try {
      TableSplit ts = (TableSplit)split;
      if (m_namespace == null) {
        m_namespace = job.get(INPUT_NAMESPACE);
        if (m_namespace == null)
          m_namespace = job.get(NAMESPACE);
      }
      if (m_tablename == null)
        m_tablename = job.get(TABLE);
      ScanSpec scan_spec = ts.createScanSpec(m_base_spec);
      System.out.println(scan_spec);

      if (m_client == null)
        m_client = ThriftClient.create("localhost", 38080);
      return new HypertableRecordReader(m_client, m_namespace, m_tablename, scan_spec);
    }
    catch (TTransportException e) {
      e.printStackTrace();
      throw new IOException(e.getMessage());
    }
    catch (TException e) {
      e.printStackTrace();
      throw new IOException(e.getMessage());
    }
  }

  public InputSplit[] getSplits(JobConf job, int numSplits) throws IOException {
    long ns=0;

    try {
      RowInterval ri = null;

      if (m_client == null)
        m_client = ThriftClient.create("localhost", 38080);

      String tablename = job.get(TABLE);
      String namespace = job.get(INPUT_NAMESPACE);
      if (namespace == null)
        namespace = job.get(NAMESPACE);

      java.util.Iterator<RowInterval> iter = m_base_spec.getRow_intervalsIterator();
      if (iter != null && iter.hasNext()) {
        ri = iter.next();
        if (iter.hasNext()) {
          System.out.println("InputFormat only allows a single ROW interval");
          System.exit(-1);
        }
      }

      ns = m_client.namespace_open(namespace);
      List<org.hypertable.thriftgen.TableSplit> tsplits =
          m_client.table_get_splits(ns, tablename);
      List<InputSplit> splits = new ArrayList<InputSplit>(tsplits.size());

      for (final org.hypertable.thriftgen.TableSplit ts : tsplits) {
        if (ri == null ||
            ((!ri.isSetStart_row() || ts.end_row == null || ts.end_row.compareTo(ri.getStart_row()) > 0 ||
              (ts.end_row.compareTo(ri.getStart_row()) == 0 && ri.isStart_inclusive())) &&
             (!ri.isSetEnd_row() || ts.start_row == null || ts.start_row.compareTo(ri.getEnd_row()) < 0))) {
          byte [] start_row = (ts.start_row == null) ? null : ts.start_row.getBytes("UTF-8");
          byte [] end_row = (ts.end_row == null) ? null : ts.end_row.getBytes("UTF-8");
          TableSplit split = new TableSplit(tablename.getBytes("UTF-8"), start_row, end_row, ts.hostname);
          splits.add(split);
        }
      }

      InputSplit[] isplits = new InputSplit[splits.size()];
      return splits.toArray(isplits);
    }
    catch (TTransportException e) {
      e.printStackTrace();
      throw new IOException(e.getMessage());
    }
    catch (TException e) {
      e.printStackTrace();
      throw new IOException(e.getMessage());
    }
    catch (ClientException e) {
      e.printStackTrace();
      throw new IOException(e.getMessage());
    }
    catch (UnsupportedEncodingException e) {
      e.printStackTrace();
      throw new IOException(e.getMessage());
    }
    finally {
      if (ns != 0) {
        try {
          m_client.namespace_close(ns);
        }
        catch (Exception e) {
          e.printStackTrace();
          throw new IOException(e.getMessage());
        }
      }
    }
  }


}
