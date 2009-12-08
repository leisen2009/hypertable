#
# Autogenerated by Thrift
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#
require 5.6.0;
use strict;
use warnings;
use Thrift;

package Hypertable::ThriftGen::CellFlag;
use constant DELETE_ROW => 0;
use constant DELETE_CF => 1;
use constant DELETE_CELL => 2;
use constant INSERT => 255;
package Hypertable::ThriftGen::MutatorFlag;
use constant NO_LOG_SYNC => 1;
use constant IGNORE_UNKNOWN_CFS => 2;
package Hypertable::ThriftGen::RowInterval;
use base qw(Class::Accessor);
Hypertable::ThriftGen::RowInterval->mk_accessors( qw( start_row start_inclusive end_row end_inclusive ) );

sub new {
  my $classname = shift;
  my $self      = {};
  my $vals      = shift || {};
  $self->{start_row} = undef;
  $self->{start_inclusive} = 1;
  $self->{end_row} = undef;
  $self->{end_inclusive} = 1;
  if (UNIVERSAL::isa($vals,'HASH')) {
    if (defined $vals->{start_row}) {
      $self->{start_row} = $vals->{start_row};
    }
    if (defined $vals->{start_inclusive}) {
      $self->{start_inclusive} = $vals->{start_inclusive};
    }
    if (defined $vals->{end_row}) {
      $self->{end_row} = $vals->{end_row};
    }
    if (defined $vals->{end_inclusive}) {
      $self->{end_inclusive} = $vals->{end_inclusive};
    }
  }
  return bless ($self, $classname);
}

sub getName {
  return 'RowInterval';
}

sub read {
  my ($self, $input) = @_;
  my $xfer  = 0;
  my $fname;
  my $ftype = 0;
  my $fid   = 0;
  $xfer += $input->readStructBegin(\$fname);
  while (1) 
  {
    $xfer += $input->readFieldBegin(\$fname, \$ftype, \$fid);
    if ($ftype == TType::STOP) {
      last;
    }
    SWITCH: for($fid)
    {
      /^1$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{start_row});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^2$/ && do{      if ($ftype == TType::BOOL) {
        $xfer += $input->readBool(\$self->{start_inclusive});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^3$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{end_row});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^4$/ && do{      if ($ftype == TType::BOOL) {
        $xfer += $input->readBool(\$self->{end_inclusive});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
        $xfer += $input->skip($ftype);
    }
    $xfer += $input->readFieldEnd();
  }
  $xfer += $input->readStructEnd();
  return $xfer;
}

sub write {
  my ($self, $output) = @_;
  my $xfer   = 0;
  $xfer += $output->writeStructBegin('RowInterval');
  if (defined $self->{start_row}) {
    $xfer += $output->writeFieldBegin('start_row', TType::STRING, 1);
    $xfer += $output->writeString($self->{start_row});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{start_inclusive}) {
    $xfer += $output->writeFieldBegin('start_inclusive', TType::BOOL, 2);
    $xfer += $output->writeBool($self->{start_inclusive});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{end_row}) {
    $xfer += $output->writeFieldBegin('end_row', TType::STRING, 3);
    $xfer += $output->writeString($self->{end_row});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{end_inclusive}) {
    $xfer += $output->writeFieldBegin('end_inclusive', TType::BOOL, 4);
    $xfer += $output->writeBool($self->{end_inclusive});
    $xfer += $output->writeFieldEnd();
  }
  $xfer += $output->writeFieldStop();
  $xfer += $output->writeStructEnd();
  return $xfer;
}

package Hypertable::ThriftGen::CellInterval;
use base qw(Class::Accessor);
Hypertable::ThriftGen::CellInterval->mk_accessors( qw( start_row start_column start_inclusive end_row end_column end_inclusive ) );

sub new {
  my $classname = shift;
  my $self      = {};
  my $vals      = shift || {};
  $self->{start_row} = undef;
  $self->{start_column} = undef;
  $self->{start_inclusive} = 1;
  $self->{end_row} = undef;
  $self->{end_column} = undef;
  $self->{end_inclusive} = 1;
  if (UNIVERSAL::isa($vals,'HASH')) {
    if (defined $vals->{start_row}) {
      $self->{start_row} = $vals->{start_row};
    }
    if (defined $vals->{start_column}) {
      $self->{start_column} = $vals->{start_column};
    }
    if (defined $vals->{start_inclusive}) {
      $self->{start_inclusive} = $vals->{start_inclusive};
    }
    if (defined $vals->{end_row}) {
      $self->{end_row} = $vals->{end_row};
    }
    if (defined $vals->{end_column}) {
      $self->{end_column} = $vals->{end_column};
    }
    if (defined $vals->{end_inclusive}) {
      $self->{end_inclusive} = $vals->{end_inclusive};
    }
  }
  return bless ($self, $classname);
}

sub getName {
  return 'CellInterval';
}

sub read {
  my ($self, $input) = @_;
  my $xfer  = 0;
  my $fname;
  my $ftype = 0;
  my $fid   = 0;
  $xfer += $input->readStructBegin(\$fname);
  while (1) 
  {
    $xfer += $input->readFieldBegin(\$fname, \$ftype, \$fid);
    if ($ftype == TType::STOP) {
      last;
    }
    SWITCH: for($fid)
    {
      /^1$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{start_row});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^2$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{start_column});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^3$/ && do{      if ($ftype == TType::BOOL) {
        $xfer += $input->readBool(\$self->{start_inclusive});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^4$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{end_row});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^5$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{end_column});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^6$/ && do{      if ($ftype == TType::BOOL) {
        $xfer += $input->readBool(\$self->{end_inclusive});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
        $xfer += $input->skip($ftype);
    }
    $xfer += $input->readFieldEnd();
  }
  $xfer += $input->readStructEnd();
  return $xfer;
}

sub write {
  my ($self, $output) = @_;
  my $xfer   = 0;
  $xfer += $output->writeStructBegin('CellInterval');
  if (defined $self->{start_row}) {
    $xfer += $output->writeFieldBegin('start_row', TType::STRING, 1);
    $xfer += $output->writeString($self->{start_row});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{start_column}) {
    $xfer += $output->writeFieldBegin('start_column', TType::STRING, 2);
    $xfer += $output->writeString($self->{start_column});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{start_inclusive}) {
    $xfer += $output->writeFieldBegin('start_inclusive', TType::BOOL, 3);
    $xfer += $output->writeBool($self->{start_inclusive});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{end_row}) {
    $xfer += $output->writeFieldBegin('end_row', TType::STRING, 4);
    $xfer += $output->writeString($self->{end_row});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{end_column}) {
    $xfer += $output->writeFieldBegin('end_column', TType::STRING, 5);
    $xfer += $output->writeString($self->{end_column});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{end_inclusive}) {
    $xfer += $output->writeFieldBegin('end_inclusive', TType::BOOL, 6);
    $xfer += $output->writeBool($self->{end_inclusive});
    $xfer += $output->writeFieldEnd();
  }
  $xfer += $output->writeFieldStop();
  $xfer += $output->writeStructEnd();
  return $xfer;
}

package Hypertable::ThriftGen::ScanSpec;
use base qw(Class::Accessor);
Hypertable::ThriftGen::ScanSpec->mk_accessors( qw( row_intervals cell_intervals return_deletes revs row_limit start_time end_time columns ) );

sub new {
  my $classname = shift;
  my $self      = {};
  my $vals      = shift || {};
  $self->{row_intervals} = undef;
  $self->{cell_intervals} = undef;
  $self->{return_deletes} = 0;
  $self->{revs} = 0;
  $self->{row_limit} = 0;
  $self->{start_time} = undef;
  $self->{end_time} = undef;
  $self->{columns} = undef;
  if (UNIVERSAL::isa($vals,'HASH')) {
    if (defined $vals->{row_intervals}) {
      $self->{row_intervals} = $vals->{row_intervals};
    }
    if (defined $vals->{cell_intervals}) {
      $self->{cell_intervals} = $vals->{cell_intervals};
    }
    if (defined $vals->{return_deletes}) {
      $self->{return_deletes} = $vals->{return_deletes};
    }
    if (defined $vals->{revs}) {
      $self->{revs} = $vals->{revs};
    }
    if (defined $vals->{row_limit}) {
      $self->{row_limit} = $vals->{row_limit};
    }
    if (defined $vals->{start_time}) {
      $self->{start_time} = $vals->{start_time};
    }
    if (defined $vals->{end_time}) {
      $self->{end_time} = $vals->{end_time};
    }
    if (defined $vals->{columns}) {
      $self->{columns} = $vals->{columns};
    }
  }
  return bless ($self, $classname);
}

sub getName {
  return 'ScanSpec';
}

sub read {
  my ($self, $input) = @_;
  my $xfer  = 0;
  my $fname;
  my $ftype = 0;
  my $fid   = 0;
  $xfer += $input->readStructBegin(\$fname);
  while (1) 
  {
    $xfer += $input->readFieldBegin(\$fname, \$ftype, \$fid);
    if ($ftype == TType::STOP) {
      last;
    }
    SWITCH: for($fid)
    {
      /^1$/ && do{      if ($ftype == TType::LIST) {
        {
          my $_size0 = 0;
          $self->{row_intervals} = [];
          my $_etype3 = 0;
          $xfer += $input->readListBegin(\$_etype3, \$_size0);
          for (my $_i4 = 0; $_i4 < $_size0; ++$_i4)
          {
            my $elem5 = undef;
            $elem5 = new Hypertable::ThriftGen::RowInterval();
            $xfer += $elem5->read($input);
            push(@{$self->{row_intervals}},$elem5);
          }
          $xfer += $input->readListEnd();
        }
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^2$/ && do{      if ($ftype == TType::LIST) {
        {
          my $_size6 = 0;
          $self->{cell_intervals} = [];
          my $_etype9 = 0;
          $xfer += $input->readListBegin(\$_etype9, \$_size6);
          for (my $_i10 = 0; $_i10 < $_size6; ++$_i10)
          {
            my $elem11 = undef;
            $elem11 = new Hypertable::ThriftGen::CellInterval();
            $xfer += $elem11->read($input);
            push(@{$self->{cell_intervals}},$elem11);
          }
          $xfer += $input->readListEnd();
        }
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^3$/ && do{      if ($ftype == TType::BOOL) {
        $xfer += $input->readBool(\$self->{return_deletes});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^4$/ && do{      if ($ftype == TType::I32) {
        $xfer += $input->readI32(\$self->{revs});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^5$/ && do{      if ($ftype == TType::I32) {
        $xfer += $input->readI32(\$self->{row_limit});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^6$/ && do{      if ($ftype == TType::I64) {
        $xfer += $input->readI64(\$self->{start_time});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^7$/ && do{      if ($ftype == TType::I64) {
        $xfer += $input->readI64(\$self->{end_time});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^8$/ && do{      if ($ftype == TType::LIST) {
        {
          my $_size12 = 0;
          $self->{columns} = [];
          my $_etype15 = 0;
          $xfer += $input->readListBegin(\$_etype15, \$_size12);
          for (my $_i16 = 0; $_i16 < $_size12; ++$_i16)
          {
            my $elem17 = undef;
            $xfer += $input->readString(\$elem17);
            push(@{$self->{columns}},$elem17);
          }
          $xfer += $input->readListEnd();
        }
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
        $xfer += $input->skip($ftype);
    }
    $xfer += $input->readFieldEnd();
  }
  $xfer += $input->readStructEnd();
  return $xfer;
}

sub write {
  my ($self, $output) = @_;
  my $xfer   = 0;
  $xfer += $output->writeStructBegin('ScanSpec');
  if (defined $self->{row_intervals}) {
    $xfer += $output->writeFieldBegin('row_intervals', TType::LIST, 1);
    {
      $output->writeListBegin(TType::STRUCT, scalar(@{$self->{row_intervals}}));
      {
        foreach my $iter18 (@{$self->{row_intervals}}) 
        {
          $xfer += ${iter18}->write($output);
        }
      }
      $output->writeListEnd();
    }
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{cell_intervals}) {
    $xfer += $output->writeFieldBegin('cell_intervals', TType::LIST, 2);
    {
      $output->writeListBegin(TType::STRUCT, scalar(@{$self->{cell_intervals}}));
      {
        foreach my $iter19 (@{$self->{cell_intervals}}) 
        {
          $xfer += ${iter19}->write($output);
        }
      }
      $output->writeListEnd();
    }
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{return_deletes}) {
    $xfer += $output->writeFieldBegin('return_deletes', TType::BOOL, 3);
    $xfer += $output->writeBool($self->{return_deletes});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{revs}) {
    $xfer += $output->writeFieldBegin('revs', TType::I32, 4);
    $xfer += $output->writeI32($self->{revs});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{row_limit}) {
    $xfer += $output->writeFieldBegin('row_limit', TType::I32, 5);
    $xfer += $output->writeI32($self->{row_limit});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{start_time}) {
    $xfer += $output->writeFieldBegin('start_time', TType::I64, 6);
    $xfer += $output->writeI64($self->{start_time});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{end_time}) {
    $xfer += $output->writeFieldBegin('end_time', TType::I64, 7);
    $xfer += $output->writeI64($self->{end_time});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{columns}) {
    $xfer += $output->writeFieldBegin('columns', TType::LIST, 8);
    {
      $output->writeListBegin(TType::STRING, scalar(@{$self->{columns}}));
      {
        foreach my $iter20 (@{$self->{columns}}) 
        {
          $xfer += $output->writeString($iter20);
        }
      }
      $output->writeListEnd();
    }
    $xfer += $output->writeFieldEnd();
  }
  $xfer += $output->writeFieldStop();
  $xfer += $output->writeStructEnd();
  return $xfer;
}

package Hypertable::ThriftGen::MutateSpec;
use base qw(Class::Accessor);
Hypertable::ThriftGen::MutateSpec->mk_accessors( qw( appname flush_interval flags ) );

sub new {
  my $classname = shift;
  my $self      = {};
  my $vals      = shift || {};
  $self->{appname} = "";
  $self->{flush_interval} = 1000;
  $self->{flags} = 2;
  if (UNIVERSAL::isa($vals,'HASH')) {
    if (defined $vals->{appname}) {
      $self->{appname} = $vals->{appname};
    }
    if (defined $vals->{flush_interval}) {
      $self->{flush_interval} = $vals->{flush_interval};
    }
    if (defined $vals->{flags}) {
      $self->{flags} = $vals->{flags};
    }
  }
  return bless ($self, $classname);
}

sub getName {
  return 'MutateSpec';
}

sub read {
  my ($self, $input) = @_;
  my $xfer  = 0;
  my $fname;
  my $ftype = 0;
  my $fid   = 0;
  $xfer += $input->readStructBegin(\$fname);
  while (1) 
  {
    $xfer += $input->readFieldBegin(\$fname, \$ftype, \$fid);
    if ($ftype == TType::STOP) {
      last;
    }
    SWITCH: for($fid)
    {
      /^1$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{appname});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^2$/ && do{      if ($ftype == TType::I32) {
        $xfer += $input->readI32(\$self->{flush_interval});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^3$/ && do{      if ($ftype == TType::I32) {
        $xfer += $input->readI32(\$self->{flags});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
        $xfer += $input->skip($ftype);
    }
    $xfer += $input->readFieldEnd();
  }
  $xfer += $input->readStructEnd();
  return $xfer;
}

sub write {
  my ($self, $output) = @_;
  my $xfer   = 0;
  $xfer += $output->writeStructBegin('MutateSpec');
  if (defined $self->{appname}) {
    $xfer += $output->writeFieldBegin('appname', TType::STRING, 1);
    $xfer += $output->writeString($self->{appname});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{flush_interval}) {
    $xfer += $output->writeFieldBegin('flush_interval', TType::I32, 2);
    $xfer += $output->writeI32($self->{flush_interval});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{flags}) {
    $xfer += $output->writeFieldBegin('flags', TType::I32, 3);
    $xfer += $output->writeI32($self->{flags});
    $xfer += $output->writeFieldEnd();
  }
  $xfer += $output->writeFieldStop();
  $xfer += $output->writeStructEnd();
  return $xfer;
}

package Hypertable::ThriftGen::Cell;
use base qw(Class::Accessor);
Hypertable::ThriftGen::Cell->mk_accessors( qw( row_key column_family column_qualifier value timestamp revision flag ) );

sub new {
  my $classname = shift;
  my $self      = {};
  my $vals      = shift || {};
  $self->{row_key} = undef;
  $self->{column_family} = undef;
  $self->{column_qualifier} = undef;
  $self->{value} = undef;
  $self->{timestamp} = undef;
  $self->{revision} = undef;
  $self->{flag} = 255;
  if (UNIVERSAL::isa($vals,'HASH')) {
    if (defined $vals->{row_key}) {
      $self->{row_key} = $vals->{row_key};
    }
    if (defined $vals->{column_family}) {
      $self->{column_family} = $vals->{column_family};
    }
    if (defined $vals->{column_qualifier}) {
      $self->{column_qualifier} = $vals->{column_qualifier};
    }
    if (defined $vals->{value}) {
      $self->{value} = $vals->{value};
    }
    if (defined $vals->{timestamp}) {
      $self->{timestamp} = $vals->{timestamp};
    }
    if (defined $vals->{revision}) {
      $self->{revision} = $vals->{revision};
    }
    if (defined $vals->{flag}) {
      $self->{flag} = $vals->{flag};
    }
  }
  return bless ($self, $classname);
}

sub getName {
  return 'Cell';
}

sub read {
  my ($self, $input) = @_;
  my $xfer  = 0;
  my $fname;
  my $ftype = 0;
  my $fid   = 0;
  $xfer += $input->readStructBegin(\$fname);
  while (1) 
  {
    $xfer += $input->readFieldBegin(\$fname, \$ftype, \$fid);
    if ($ftype == TType::STOP) {
      last;
    }
    SWITCH: for($fid)
    {
      /^1$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{row_key});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^2$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{column_family});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^3$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{column_qualifier});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^4$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{value});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^5$/ && do{      if ($ftype == TType::I64) {
        $xfer += $input->readI64(\$self->{timestamp});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^6$/ && do{      if ($ftype == TType::I64) {
        $xfer += $input->readI64(\$self->{revision});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^7$/ && do{      if ($ftype == TType::I16) {
        $xfer += $input->readI16(\$self->{flag});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
        $xfer += $input->skip($ftype);
    }
    $xfer += $input->readFieldEnd();
  }
  $xfer += $input->readStructEnd();
  return $xfer;
}

sub write {
  my ($self, $output) = @_;
  my $xfer   = 0;
  $xfer += $output->writeStructBegin('Cell');
  if (defined $self->{row_key}) {
    $xfer += $output->writeFieldBegin('row_key', TType::STRING, 1);
    $xfer += $output->writeString($self->{row_key});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{column_family}) {
    $xfer += $output->writeFieldBegin('column_family', TType::STRING, 2);
    $xfer += $output->writeString($self->{column_family});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{column_qualifier}) {
    $xfer += $output->writeFieldBegin('column_qualifier', TType::STRING, 3);
    $xfer += $output->writeString($self->{column_qualifier});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{value}) {
    $xfer += $output->writeFieldBegin('value', TType::STRING, 4);
    $xfer += $output->writeString($self->{value});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{timestamp}) {
    $xfer += $output->writeFieldBegin('timestamp', TType::I64, 5);
    $xfer += $output->writeI64($self->{timestamp});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{revision}) {
    $xfer += $output->writeFieldBegin('revision', TType::I64, 6);
    $xfer += $output->writeI64($self->{revision});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{flag}) {
    $xfer += $output->writeFieldBegin('flag', TType::I16, 7);
    $xfer += $output->writeI16($self->{flag});
    $xfer += $output->writeFieldEnd();
  }
  $xfer += $output->writeFieldStop();
  $xfer += $output->writeStructEnd();
  return $xfer;
}

package Hypertable::ThriftGen::ClientException;
use base qw(Thrift::TException);
use base qw(Class::Accessor);
Hypertable::ThriftGen::ClientException->mk_accessors( qw( code message ) );

sub new {
  my $classname = shift;
  my $self      = {};
  my $vals      = shift || {};
  $self->{code} = undef;
  $self->{message} = undef;
  if (UNIVERSAL::isa($vals,'HASH')) {
    if (defined $vals->{code}) {
      $self->{code} = $vals->{code};
    }
    if (defined $vals->{message}) {
      $self->{message} = $vals->{message};
    }
  }
  return bless ($self, $classname);
}

sub getName {
  return 'ClientException';
}

sub read {
  my ($self, $input) = @_;
  my $xfer  = 0;
  my $fname;
  my $ftype = 0;
  my $fid   = 0;
  $xfer += $input->readStructBegin(\$fname);
  while (1) 
  {
    $xfer += $input->readFieldBegin(\$fname, \$ftype, \$fid);
    if ($ftype == TType::STOP) {
      last;
    }
    SWITCH: for($fid)
    {
      /^1$/ && do{      if ($ftype == TType::I32) {
        $xfer += $input->readI32(\$self->{code});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^2$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{message});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
        $xfer += $input->skip($ftype);
    }
    $xfer += $input->readFieldEnd();
  }
  $xfer += $input->readStructEnd();
  return $xfer;
}

sub write {
  my ($self, $output) = @_;
  my $xfer   = 0;
  $xfer += $output->writeStructBegin('ClientException');
  if (defined $self->{code}) {
    $xfer += $output->writeFieldBegin('code', TType::I32, 1);
    $xfer += $output->writeI32($self->{code});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{message}) {
    $xfer += $output->writeFieldBegin('message', TType::STRING, 2);
    $xfer += $output->writeString($self->{message});
    $xfer += $output->writeFieldEnd();
  }
  $xfer += $output->writeFieldStop();
  $xfer += $output->writeStructEnd();
  return $xfer;
}

1;
