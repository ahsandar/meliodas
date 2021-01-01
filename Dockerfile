########################
### Dependency stage ###
########################
FROM hexpm/elixir:1.11.2-erlang-23.1.3-debian-buster-20201012 AS base

# install build dependencies
RUN apt-get -qq update && \
  apt-get -qq -y install build-essential --fix-missing --no-install-recommends

# prepare build dir
WORKDIR /app

ARG MIX_ENV

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Update timezone
ENV TZ=Asia/Singapore

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV=${MIX_ENV}

COPY mix.exs mix.lock ./
COPY config config

# install mix dependencies
RUN mix deps.get --only ${MIX_ENV}
RUN mix deps.compile

COPY lib ./lib
COPY priv ./priv

########################
# Build Phoenix assets #
########################

FROM node:14.15.3-buster AS assets
WORKDIR /app

COPY --from=base /app/deps /app/deps/
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY lib ./lib
COPY priv ./priv
COPY assets/ ./assets/

RUN npm run --prefix ./assets deploy


#########################
# Create Phoenix digest #
#########################
FROM base AS digest
WORKDIR /app

# set build ENV
ARG MIX_ENV
ENV MIX_ENV=${MIX_ENV}

COPY --from=assets /app/priv ./priv
RUN mix phx.digest


#######################
#### Create release ###
#######################
FROM digest AS release
WORKDIR /app

ARG MIX_ENV
ENV MIX_ENV=${MIX_ENV}

COPY --from=digest /app/priv/static ./priv/static

RUN mix do compile, release



#################################################
# Create the actual image that will be deployed #
#################################################
FROM debian:buster AS deploy

# Install stable dependencies that don't change often 
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  apt-utils \
  openssl \
  curl \
  ca-certificates \
  wget && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG SPEEDTESTARCH
ENV SPEEDTESTARCH=${SPEEDTESTARCH}
RUN export SPEEDTESTVERSION="1.0.0" && \
  export SPEEDTESTPLATFORM="linux" && \
  mkdir -p bin && \
  curl -Ss -L https://ookla.bintray.com/download/ookla-speedtest-$SPEEDTESTVERSION-$SPEEDTESTARCH-$SPEEDTESTPLATFORM.tgz | tar -zx -C /app/bin && \
  chmod +x bin/speedtest

ARG BUILD_DATE
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="ahsan/meliodas"
LABEL org.label-schema.description="Dashboard - Meliodas"
LABEL org.label-schema.url="https://github.com/ahsan/meliodas"

ARG MIX_ENV

ENV MIX_ENV=${MIX_ENV}

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Update timezone
ENV TZ=Asia/Singapore

COPY --from=release /app/_build/${MIX_ENV}/rel/meliodas ./

ENV HOME=/app
# Exposes port to the host machine
EXPOSE 4000

CMD ["bin/meliodas", "start"]
