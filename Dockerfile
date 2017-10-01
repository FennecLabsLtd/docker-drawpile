FROM ubuntu:xenial
SHELL ["/bin/bash","-c"]
ENV DRAWPILE_SRV_URL "https://drawpile.net/files/appimage/"

RUN apt-get update && \
    apt-get install -y curl html-xml-utils && \
    rm -rf /var/lib/apt/lists/*; \
    MAXDATE = 0; for file in `curl -s https://drawpile.net/files/appimage/ | hxwls | grep srv`; do curl -sI https://drawpile.net/files/appimage/$file | grep "Last-Modified: " | awk "{print  $2" "$3" "$4" "$5" "$6" "$7}" | xargs -I {} date -d {} "+%s" | read FILEDATE; test $FILEDATE -gt $MAXDATE && MAXDATE = $FILEDATE && filetodownload = $file; done; curl -s https://drawpile.net/files/appimage/$filetodownload -o /usr/local/bin/drawpile-srv; \
    chmod a+x /usr/local/bin/drawpile-srv; \
    useradd --system drawpile

ENTRYPOINT ["/usr/local/bin/drawpile-srv"]

USER drawpile
EXPOSE 27750
