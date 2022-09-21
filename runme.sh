#!/bin/bash -x

CUSTOM_USER_AGENT="$(echo $customagent)"

DEFAULT_USER_AGENT="AnyConnect Linux_64 4.10.01075"

INPUT=$1

if [ ! -z "$CUSTOM_USER_AGENT" ]; then
  USER_AGENT=$CUSTOM_USER_AGENT
else
  USER_AGENT=$DEFAULT_USER_AGENT
fi

echo "Using $USER_AGENT as user-agent"

/usr/local/bin/openconnect-sso $INPUT -- --useragent "$USER_AGENT"

sleep 30
