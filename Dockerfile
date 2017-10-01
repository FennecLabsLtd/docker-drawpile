FROM ubuntu:xenial
SHELL ["/bin/bash","-c"]
ENV DRAWPILE_SRV_URL "https://drawpile.net/files/appimage/"

RUN apt-get update && \
    apt-get install -y curl html-xml-utils && \
    rm -rf /var/lib/apt/lists/*; \
    echo "Available server versions: "; \
    AVAILABLE_SRV=($(curl -s https://drawpile.net/files/appimage/ | hxwls | grep --color=never srv | sort -r)); \
    for SRV in ${AVAILABLE_SRV[*]}; do echo $SRV; done; \
    echo -n "Download which version [default: ${AVAILABLE_SRV[0]}]:"; \
    read DOWNLOAD_SRV; \
    if [ -z $DOWNLOAD_SRV ]; then curl -s https://drawpile.net/files/appimage/${AVAILABLE_SRV[0]} -o /usr/local/bin/drawpile-srv; \
    elif [[ ! " ${AVAILABLE_SRV[*]} " =~ " $DOWNLOAD_SRV " ]]; then echo "$DOWNLOAD_SRV is not valid" && exit 1; \
    else curl -s https://drawpile.net/files/appimage/$DOWNLOAD_SRV -o /usr/local/bin/drawpile-srv; \
    fi; \
    chmod a+x /usr/local/bin/drawpile-srv; \
    useradd --system drawpile

ENTRYPOINT ["/usr/local/bin/drawpile-srv"]

USER drawpile
EXPOSE 27750
