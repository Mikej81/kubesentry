FROM alpine:latest

RUN apk add --no-cache net-snmp-tools procps

ENV TRAP_RECEIVER=192.168.2.25
ENV COMMUNITY_STRING=public

COPY monitor.sh /monitor.sh
RUN chmod +x /monitor.sh

#CMD ["/monitor.sh"]

CMD [ "sh" ]