FROM alpine:edge AS build

RUN apk update && \
    apk --no-cache upgrade && \
    apk add --no-cache alpine-sdk git pkgconf autoconf automake \
        cargo rust-bindgen nasm cmake clang-libclang openssl-dev \
        alsa-lib-dev

WORKDIR /root

RUN git clone https://github.com/allinurl/gwsocket && \
    cd gwsocket && \
    autoreconf -fiv && \
    ./configure && \
    make

RUN git clone https://github.com/librespot-org/librespot && \
    cd librespot && \
    cargo build --release --no-default-features \
        --features "native-tls alsa-backend passthrough-decoder"

FROM alpine:edge

RUN echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk update && \
    apk --no-cache upgrade && \
    apk --no-cache add alsa-lib snapcast-server snapweb@testing

COPY --from=build /root/gwsocket/gwsocket /usr/bin/
COPY --from=build /root/librespot/target/release/librespot /usr/bin/

WORKDIR /script
COPY entrypoint.sh /script/

ENTRYPOINT ["/script/entrypoint.sh"]
CMD ["/music/snapserver.conf"]
