#!/usr/bin/env bash

ZABBIX_SERVER="127.0.0.1"
ZABBIX_PORT="10051"
ZABBIX_SENDER="/usr/bin/zabbix_sender"
HOST="UPS"
COMMAND_READ_DATA="/usr/bin/upsc snr@localhost"

$COMMAND_READ_DATA | while read -r line
do
  if [[ $line =~ .*.\..*.: ]]; then
    KEY=$(echo "$line"| cut -d ":" -f 1)
    VALUE=$(echo "$line"| cut -d ":" -f 2 | sed 's/ //g')
    if [ ! -z "${VALUE}" ]; then
      $ZABBIX_SENDER -z "${ZABBIX_SERVER}" -p "${ZABBIX_PORT}" -s "${HOST}" -k "${KEY}" -o "${VALUE}"
    fi
  fi
done
