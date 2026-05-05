#!/bin/bash
set -e

# Ensure TUN device exists (requires --cap-add=NET_ADMIN and --device=/dev/net/tun)
if [ ! -c /dev/net/tun ]; then
    echo "Creating TUN device..."
    sudo mkdir -p /dev/net
    sudo mknod /dev/net/tun c 10 200
    sudo chmod 600 /dev/net/tun
fi

# Setup User Agent (Reference: runme.sh)
CUSTOM_USER_AGENT="$(echo $customagent)"
DEFAULT_USER_AGENT="AnyConnect Linux_64 4.10.01075"

if [ ! -z "$CUSTOM_USER_AGENT" ]; then
  USER_AGENT=$CUSTOM_USER_AGENT
else
  USER_AGENT=$DEFAULT_USER_AGENT
fi

echo "Using $USER_AGENT as user-agent"

# Start dbus-daemon if not running
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    echo "Starting dbus-daemon..."
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
fi

# Run openconnect-saml
# Pass all arguments to the connect command
echo "Starting openconnect-saml connect..."
openconnect-saml connect --useragent "$USER_AGENT" "$@" || echo "OpenConnect exited."

echo "Waiting 60 seconds for routing cleanup..."
sleep 60