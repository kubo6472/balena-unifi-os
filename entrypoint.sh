#!/usr/bin/env sh

set -e

if [ "${REQUIRE_AUTH_KEY}" = "true" ] && [ -z "${TS_AUTH_KEY}" ]
then
    echo "TS_AUTH_KEY is required"
    exit 0
fi

modprobe wireguard 2>/dev/null || true
dmesg | grep -i wireguard || true
export TS_USERSPACE="${TS_USERSPACE:-false}"

mkdir -p /dev/net
[ ! -c /dev/net/tun ] && mknod /dev/net/tun c 10 200

echo 1 > /proc/sys/net/ipv4/ip_forward || true
[ -e /proc/sys/net/ipv6/conf/all/forwarding ] && echo 1 > /proc/sys/net/ipv6/conf/all/forwarding || true

exec /usr/local/bin/containerboot
