FROM ubuntu:xenial
SHELL ["/bin/bash","-c"]
ARG DRAWPILE_SRV_URL="https://drawpile.net/files/appimage/"
ARG DOWNLOAD_SRV

RUN apt-get update && \
    apt-get install -y curl html-xml-utils && \
    rm -rf /var/lib/apt/lists/*; \
    AVAILABLE_SRV=($(curl -s $DRAWPILE_SRV_URL | hxwls | grep --color=never srv | sort -r)); \
    if [ -z $DOWNLOAD_SRV ]; then \
    echo -e "\e[92mAvailable server versions: \e[39m"; \
    for SRV in ${AVAILABLE_SRV[*]}; do \
    echo -e "\e[92m$SRV\e[39m"; done; \
    echo -e "\e[91mPlease specify which server to install at build e.g. docker build --build-arg DOWNLOAD_SRV=${AVAILABLE_SRV[0]} .\e[39m"; \
    exit 1; \
    else \
    if [[ ! " ${AVAILABLE_SRV[*]} " =~ " $DOWNLOAD_SRV " ]]; then \
    echo -e "\e[91m$DOWNLOAD_SRV is not valid\e[39m"; \
    echo -e "\e[92mAvailable server versions: \e[39m"; \
    for SRV in ${AVAILABLE_SRV[*]}; do echo -e "\e[92m$SRV\e[39m"; done; \
    exit 2; \
    else \
    curl $DRAWPILE_SRV_URL$DOWNLOAD_SRV -o /usr/local/bin/drawpile-srv; \
    fi; \
    chmod a+x /usr/local/bin/drawpile-srv; \
    apt-get purge -y curl html-xml-utils && \
    apt-get autoremove -y; \
    useradd --system drawpile; \
    fi

ENTRYPOINT ["/usr/local/bin/drawpile-srv"]

USER drawpile
EXPOSE 27750
