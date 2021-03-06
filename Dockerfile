FROM ubuntu:latest
SHELL ["/bin/bash","-c"]
ARG serverVersion=latest
RUN apt-get update && \
    apt-get install -y git cmake extra-cmake-modules g++ libkf5archive-dev pkg-config libkf5dnssd-dev libmicrohttpd-dev libsodium-dev libminiupnpc-dev libgif-dev && \
    rm -rf /var/lib/apt/lists/*; \
    cd /tmp && \
    git clone https://github.com/drawpile/Drawpile.git && \
    cd /tmp/Drawpile; \
    if [ "$serverVersion" != "latest" ]; then \
    git checkout tags/$serverVersion; \
    fi; \
    mkdir -p /tmp/Drawpile/build && \
    cd /tmp/Drawpile/build && \
    cmake /tmp/Drawpile -DCMAKE_INSTALL_PREFIX=/usr -DCLIENT=off -DSERVERGUI=off && \
    make install && \
    useradd --system drawpile && \
    rm -rf /var/lib/apt/lists/* && \
    cd / && rm -rf /tmp/Drawpile

VOLUME ["/drawpile/sessions", "/drawpile/config", "/drawpile/templates", "/drawpile/recordings", "/drawpile/certs"]

ENTRYPOINT ["/usr/bin/drawpile-srv", "--database", "/drawpile/config/config.db", "--sessions", "/drawpile/sessions", "--templates", "/drawpile/templates", "--web-admin-port", "80", "--ssl-cert", "/drawpile/certs/cert.pem", "--ssl-key", "/drawpile/certs/key.pem", "--record", "/drawpile/recordings/%d_%h_%a.dprec"]

USER drawpile
EXPOSE 27750
