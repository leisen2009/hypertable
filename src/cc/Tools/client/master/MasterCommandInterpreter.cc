/*
 * Copyright (C) 2007-2015 Hypertable, Inc.
 *
 * This file is part of Hypertable.
 *
 * Hypertable is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 3 of the
 * License, or any later version.
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

#include <Common/Compat.h>

#include "MasterCommandInterpreter.h"

#include <Hypertable/Lib/HqlHelpText.h>
#include <Hypertable/Lib/HqlParser.h>

using namespace Hypertable;
using namespace Tools::client::master;
using namespace Hql;
using namespace std;

MasterCommandInterpreter::MasterCommandInterpreter(Lib::Master::ClientPtr &master)
  : m_master(master) {
  HqlHelpText::install_master_client_text();
}


int MasterCommandInterpreter::execute_line(const String &line) {
  Hql::ParserState state;
  Hql::Parser parser(state);
  parse_info<> info;

  info = parse(line.c_str(), parser, space_p);

  if (info.full) {

    if (state.command == COMMAND_SHUTDOWN) {
      m_master->shutdown();
    }
    else if (state.command == COMMAND_STATUS) {
      Status status;
      string output;
      Status::Code code;
      m_master->status(status);
      status.get(&code, output);
      if (!m_silent) {
        cout << "Master " << Status::code_to_string(code);
        if (!output.empty())
          cout << " - " << output;
        cout << endl;
      }
      return static_cast<int>(code);
    }
    else if (state.command == COMMAND_HELP) {
      const char **text = HqlHelpText::get(state.str);
      if (text) {
        for (size_t i=0; text[i]; i++)
          cout << text[i] << endl;
      }
      else
        cout << endl << "no help for '" << state.str << "'" << endl << endl;
    }
    else
      HT_THROW(Error::HQL_PARSE_ERROR, "unsupported command");
  }
  else
    HT_THROW(Error::HQL_PARSE_ERROR, String("parse error at: ") + info.stop);
  return 0;
}

