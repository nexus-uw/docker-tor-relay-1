#!/bin/bash

if [ -z "$TORRC" ]; then
  TORRC=/etc/tor/torrc
fi

# Assumes a key-value'ish pair
# $1 is the key and $2 is the value
function update_or_add {
  FINDINFILE=$(grep -e "^$1.*$" $TORRC)

  echo "Adding $1 $2 to Torrc"

  # Append if missing.
  # Update if exist.
  if [ -z "$FINDINFILE" ]; then
    echo "$1 $2" >> $TORRC
  else
    sed -i "s/^$1.*/$1 $2/g" $TORRC
  fi
}

# Default communcation port
update_or_add 'ORPort' '9001'

# Disable Socks connections
update_or_add  'SocksPort' '0'

# Reject all exits. Only relay.
update_or_add 'Exitpolicy' 'reject *:*'

# Set $NICKNAME to the node nickname
if [ -n "$NICKNAME" ]; then
  update_or_add 'Nickname' "$NICKNAME"
else
  update_or_add 'Nickname' 'DockerTorrelay'
fi

# Set $CONTACTINFO to your contact info
if [ -n "$CONTACTINFO" ]; then
  update_or_add 'ContactInfo' "$CONTACTINFO"
else
  update_or_add 'ContactInfo' 'Anonymous'
fi
