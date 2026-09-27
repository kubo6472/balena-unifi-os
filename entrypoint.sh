#!/usr/bin/env sh

# exit on any error
set -e

if [ "${REQUIRE_AUTH_KEY}" = "true" ] && [ -z "${TS_AUTH_KEY}" ]
then
    echo "TS_AUTH_KEY is required"
    exit 0
fi

# WireGuard may be compiled into the kernel rather than a loadable
# module, in which case modprobe reports failure even though support
# exists — so don't gate kernel networking on modprobe's exit code.
modprobe wireguard 2>/dev/null || true
dmesg | grep -i wireguard || true
export TS_USERSPACE="${TS_USERSPACE:-false}"

mkdir -p /dev/net
[ ! -c /dev/net/tun ] && mknod /dev/net/tun c 10 200

# https://github.com/tailscale/tailscale/blob/main/cmd/containerboot/main.go
exec /usr/local/bin/containerboot
