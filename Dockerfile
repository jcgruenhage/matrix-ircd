FROM docker.io/alpine:3.9 as builder
COPY . /src
RUN apk add --no-cache \
      cargo \
      build-base \
      openssl-dev \
 && cd /src \
 && cargo build --release


FROM docker.io/alpine:3.9
COPY --from=builder /src/target/release/matrix-ircd /usr/local/bin/matrix-ircd
RUN apk add --no-cache \
      libssl1.1 \
      libgcc \
      ca-certificates
CMD /usr/local/bin/matrix-ircd --bind ${BIND_ADDRESS:=0.0.0.0:5999} --url ${HOMESERVER:=https://matrix.org}
