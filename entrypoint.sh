#!/bin/sh
set -e

graphite_address=$GRAPHITE_ADDRESS
graphite_pickle_port=$GRAPHITE_PICKLE_PORT

if [ -z "$graphite_address" ] ; then
  echo "No graphite address found, please set GRAPHITE_ADDRESS"
fi

if [ -z "$graphite_pickle_port" ] ; then
  echo "No graphite pickle port found, please set GRAPHITE_PICKLE_PORT"
fi

echo "Going to run: python jsontopickle.py $graphite_address $graphite_pickle_port"

exec python -u jsontopickle.py $graphite_address $graphite_pickle_port
