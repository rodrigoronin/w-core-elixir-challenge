# ---- Build stage ----

FROM hexpm/elixir:1.19.1-erlang-26.2.5.7-alpine-3.19.9 AS build

RUN apk add --no-cache build-base git npm

WORKDIR /app

# Install hex/rebar

RUN mix local.hex --force && mix local.rebar --force

# Copy dependencies

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get --only prod
RUN mix deps.compile

# Copy the project

COPY . .

# Compile assets

COPY assets assets
RUN mix assets.deploy

# Compile release

RUN MIX_ENV=prod mix release

# ---- Runtime stage ----

FROM alpine:3.18 AS app

RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

COPY --from=build /app/_build/prod/rel/elixir_telemetry_engine ./

ENV HOME=/app

CMD ["bin/elixir_telemetry_engine", "start"]
