#!/bin/bash

export LATEST_URL="https://api.github.com/repos/joek/presenter-pi/releases/latest"


function check_version {
  export LATEST_VERSION=`curl -s ${LATEST_URL} | grep tag_name | sed "s/.*: \"//" | sed "s/\",//"`
  export CURRENT_VERSION=`cat /etc/presenter_version`
  if [ -e /etc/presenter_version ] && [ $CURRENT_VERSION == $LATEST_VERSION ]
  then
    echo "Nothing to do here..."
    exit 0
  fi
}

function download_release {
  rm -rf *-presenter-pi-*
  RELEASE_URL=`curl -s ${LATEST_URL} | grep tarball_url | sed "s/.*: \"//" | sed "s/\",//"`
  wget -O presenter-release.tar.gz ${RELEASE_URL}
  tar -xvzf presenter-release.tar.gz
  cd *-presenter-pi-*
  chmod a+x setup.sh
  echo $LATEST_VERSION > /etc/presenter_version
  ./setup.sh
}


function wait_for_network {
  echo "##### Wait for network"
  IP=$(ip route | awk '/default/ { print $3 }')
  while ( ! ping -c1 $IP >/dev/null 2>&1 ); do
    echo "Network not connected"
    sleep 5
    IP=$(ip route | awk '/default/ { print $3 }')
  done
}


cd ~
wait_for_network
check_version
download_release
