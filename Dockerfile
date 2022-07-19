FROM elixir:1.13-alpine

ENV FUNCTION ExCloudflare.list_all_zone()
ENV API_KEY_CLOUDFLARE api_key
WORKDIR /app
COPY ./ /app
RUN cd /app && \
mix local.hex --force && \
mix deps.get && \
mix compile
CMD mix run -e "IO.inspect($FUNCTION, limit: :infinity)"
# RUN if [[ -z "$arg" ]] ;then echo Argument not provided ; else echo Argument is $arg ; fi

