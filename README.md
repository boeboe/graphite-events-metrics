# Graphite Events to Metrics convertor

## Introduction

This is a small Python3 based application the converts JSON based events to 
**Pickle** based metrics for **Graphite**.

The program listens on port 8000 on every path, ingest JSON data, converts them
to pickle and opens a socket to Graphite to send the pickle serialised metrics.

In order to convert the JSON data to metrics, the JSON is recursively 
searched for numerical values. The key of those values is the JSON path 
of that particular element.

For example...

```json
{
  "system": {
    "tmmTraffic": {
      "clientSideTraffic.bitsIn": 913320
    }
  }
}
```

... will be converted to:

```
bigip.system.tmmTraffic.bitsIn : 913320
```

The exact content of pickle metrics contains a timestamp as well. The timestamp
is generated locally (when the JSON blob is ingested). More info on the exact
pickle format can be found in the Graphite [documentation](https://graphite.readthedocs.io/en/latest/feeding-carbon.html#the-pickle-protocol).

## How to run

The docker image is available on Dockerhub 

https://hub.docker.com/repository/docker/boeboe/graphite-events-metrics

In order to run the docker image

```console
# docker run --name jsontopickle  -p 8008:8000 -e GRAPHITE_ADDRESS=<a.b.c.d> -e GRAPHITE_PICKLE_PORT='2004' boeboe/graphite-events-metrics
```

 - port 8000 is the port on within the container (fixed)
 - port 8008 is the port exposed to the host system (up to your preference)
 - env vars **GRAPHITE_ADDRESS** and **GRAPHITE_PICKLE_PORT** are mandatory

