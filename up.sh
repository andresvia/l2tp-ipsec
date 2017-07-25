#!/bin/bash

/usr/bin/rsyslogd -n -i /run/rsyslogd.pid &

while ! ls -l /dev/log; do
	sleep 1
done

for envsubst in /etc/ipsec.conf.envsubst \
	/etc/ipsec.secrets.envsubst \
	/etc/xl2tpd/xl2tpd.conf.envsubst \
	/etc/ppp/options.l2tpd.client.envsubst ; do
  dest="${envsubst%%.envsubst}"
  envsubst < "$envsubst" > "$dest"
done

mkdir -p /var/run/xl2tpd

touch /var/run/xl2tpd/l2tp-control

/usr/lib/systemd/scripts/ipsec --start &

while ! ls -l /var/run/pluto/pluto.ctl; do
	sleep 1
done

/usr/sbin/xl2tpd -D &

ipsec auto --up L2TP-PSK

echo 'c vpn-connection' > /var/run/xl2tpd/l2tp-control

exec "$@"
