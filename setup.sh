#!/bin/bash

export LATEST_URL="https://api.github.com/repos/joek/presenter-pi/releases/latest"

function disable_boot_to_ui {
  sudo update-rc.d lightdm disable 2
}


function enable_ssh {
  sudo update-rc.d ssh enable
  sudo invoke-rc.d ssh start
}

function install_packages {
  sudo apt-get update
  sudo apt-get -y dist-upgrade
  sudo apt-get -y install matchbox chromium x11-xserver-utils ttf-mscorefonts-installer xwit sqlite3 libnss3 libreoffice-impress impressive
}

function set_config {
  cat config.txt > /boot/config.txt
}

function set_rc_local {
  cat rc.local > /etc/rc.local
}


function set_xinitrc {
  cat xinitrc > /boot/xinitrc
}

function set_network {
  cat interfaces > /etc/network/interfaces
}

function set_fstab {
  cat fstab > /etc/fstab
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
  echo $LATEST_VERSION > /etc/presenter_version
}


wait_for_network
check_version
download_release
disable_boot_to_ui
enable_ssh
install_packages
set_network
set_fstab
set_config
set_xinitrc
set_rc_local
# Setup update (cron) job

reboot
