FROM alpine:3.18

# Install net-snmp and dependencies
RUN apk add --no-cache \
    net-snmp \
    net-snmp-tools \
    curl \
    bash

# Create directory for trap handler
RUN mkdir -p /usr/local/bin

# Copy configuration and handler script
COPY snmptrapd.conf /etc/snmp/snmptrapd.conf
COPY trap-handler.sh /usr/local/bin/trap-handler.sh
RUN chmod +x /usr/local/bin/trap-handler.sh

# Expose SNMP trap port
EXPOSE 162/udp

# Start snmptrapd on all interfaces
CMD ["snmptrapd", "-f", "-Lo", "-c", "/etc/snmp/snmptrapd.conf", "udp:0.0.0.0:162"]
