FROM debian:latest
LABEL maintainer="team@silverbulleters.org"

ADD  setup.sh /opt/  
RUN  /bin/bash /opt/setup.sh

ADD build.sh /opt


RUN mkdir -p /opt/builder/
ADD ovm  /opt/builder/
ADD ovm-completion /opt/builder/
ADD ovm.exe /opt/builder/

RUN chmod +x /opt/build.sh

VOLUME /opt/debian

VOLUME /opt/

WORKDIR /opt

ENTRYPOINT [ "./build.sh" ]
