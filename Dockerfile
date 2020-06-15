FROM python:3.8.3-slim

WORKDIR /usr/app/src

ENV PIP_NO_CACHE_DIR=true

COPY Pipfile.lock ./

RUN set -eux; \
  echo 'micropipenv==0.1.6 --hash=sha256:7b6e78797d6475273d66f059ec7ccc91b29a7bdb9d0b74305574cbfb5da9af9c' | \
    pip install --no-cache-dir --require-hashes -r /dev/stdin; \
  mkdir serverdir; \
  micropipenv install; \
  echo Done

ENV DEVPISERVER_HOST=0.0.0.0
ENV DEVPISERVER_NO_ROOT_PYPI=true
ENV DEVPISERVER_PORT=8080
ENV DEVPISERVER_RESTRICT_MODIFY=
ENV DEVPISERVER_SERVERDIR=/usr/app/src/serverdir

RUN set -eux; \
  devpi-init --no-root-pypi; \
  echo Done

EXPOSE 8080

CMD ["devpi-server"]
