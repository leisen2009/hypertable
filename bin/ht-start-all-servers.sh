#!/usr/bin/env bash
#
# Copyright (C) 2007-2015 Hypertable, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# The installation directory
export HYPERTABLE_HOME=$(cd `dirname "$0"`/.. && pwd)
. $HYPERTABLE_HOME/bin/ht-env.sh

RANGESERVER_OPTS=
MASTER_OPTS=
HYPERSPACE_OPTS=

START_RANGESERVER="true"
START_MASTER="true"
START_THRIFTBROKER="true"

usage() {
  echo ""
  echo "usage: ht-start-all-servers.sh [OPTIONS] <fs-choice> [<global-options>]"
  echo ""
  echo "OPTIONS:"
  echo "  --heapcheck-rangeserver run RangeServer with tcmalloc heapcheck"
  echo "  --valgrind-hyperspace   run Hyperspace with valgrind"
  echo "  --valgrind-master       run Master with valgrind"
  echo "  --valgrind-rangeserver  run RangeServer with valgrind"
  echo "  --valgrind-thriftbroker run ThriftBroker with valgrind"
  echo "  --no-rangeserver        do not launch the RangeServer"
  echo "  --no-master             do not launch the Master"
  echo "  --no-thriftbroker       do not launch the ThriftBroker"
  echo ""
  echo "FS choices: qfs, hadoop, mapr, local"
  echo ""
}

while [ "$1" != "${1##[-+]}" ]; do
  case $1 in
    '')
      usage
      exit 1;;
    --heapcheck-rangeserver)
      RANGESERVER_OPTS="--heapcheck "
      shift
      ;;
    --valgrind-rangeserver)
      RANGESERVER_OPTS="--valgrind "
      shift
      ;;
    --heapcheck-master)
      MASTER_OPTS="--heapcheck "
      shift
      ;;
    --valgrind-master)
      MASTER_OPTS="--valgrind "
      shift
      ;;
    --valgrind-hyperspace)
      HYPERSPACE_OPTS="--valgrind "
      shift
      ;;
    --valgrind-thriftbroker)
      THRIFTBROKER_OPTS="--valgrind "
      shift
      ;;
    --no-rangeserver)
      START_RANGESERVER="false"
      shift
      ;;
    --no-master)
      START_MASTER="false"
      shift
      ;;
    --no-thriftbroker)
      START_THRIFTBROKER="false"
      shift
      ;;
    *)
      usage
      exit 1;;
  esac
done

if [ "$#" -eq 0 ]; then
  usage
  exit 1
fi

FS=$1
shift

#
# Start Hyperspace
#
$HYPERTABLE_HOME/bin/ht-start-hyperspace.sh $HYPERSPACE_OPTS $@ &

#
# Start FsBroker
#
$HYPERTABLE_HOME/bin/ht-start-fsbroker.sh $FS $@ &

wait

#
# Start Master
#
if [ $START_MASTER == "true" ] ; then
  $HYPERTABLE_HOME/bin/ht-start-master.sh $MASTER_OPTS $@
fi

#
# Start RangeServer
#
if [ $START_RANGESERVER == "true" ] ; then
  $HYPERTABLE_HOME/bin/ht-start-rangeserver.sh $RANGESERVER_OPTS $@
fi

#
# Start ThriftBroker (optional)
#
if [ $START_THRIFTBROKER == "true" ] ; then
  if [ -f $HYPERTABLE_HOME/bin/htThriftBroker ] ; then
    $HYPERTABLE_HOME/bin/ht-start-thriftbroker.sh $THRIFTBROKER_OPTS $@
  fi
fi
