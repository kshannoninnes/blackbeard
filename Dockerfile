FROM elixir:alpine as builder
LABEL stage=builder

ENV MIX_ENV=prod

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mix local.hex --force
RUN mix local.rebar --force
RUN apk --no-cache add git
RUN mix deps.get

COPY config config
COPY lib lib

RUN MIX_ENV=prod mix release

FROM elixir:alpine as runner
RUN apk update && \
  apk add openssl ncurses-libs libgcc libstdc++ && \
  adduser -h /home/app -D app_user

WORKDIR /app
COPY --from=builder /app /app
RUN chown -R app_user: /app/_build/prod/rel/bot/bin/bot
USER app_user
CMD ["/app/_build/prod/rel/bot/bin/bot", "start"]