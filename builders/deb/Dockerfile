FROM debian:latest
LABEL maintainer="team@silverbulleters.org"

ADD  setup.sh /opt/  
RUN  /bin/bash /opt/setup.sh

ADD build.sh /opt

RUN chmod +x /opt/build.sh

VOLUME /opt/debian

WORKDIR /opt

ENTRYPOINT [ "./build.sh" ]
