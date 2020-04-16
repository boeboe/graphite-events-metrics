FROM python:3

LABEL name="Graphite JSON events to Pickle metrics convertor"
LABEL description="Python based app that ingest Graphite events and forwards them as metrics"
LABEL source-repo="https://github.com/boeboe/graphite-events-metrics"
LABEL version=${VERSION}

ADD entrypoint.sh /
ADD jsontopickle.py /

EXPOSE 8000

ENV GRAPHITE_ADDRESS ""
ENV GRAPHITE_PICKLE_PORT ""

ENTRYPOINT ["/entrypoint.sh"]
