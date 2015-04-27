#!/bin/bash

export RELEASE_URL="https://"

function disable_boot_to_ui {
  sudo update-rc.d lightdm disable 2
}


function enable_ssh {
  sudo update-rc.d ssh enable
  sudo invoke-rc.d ssh start
}

function install_packages {
  sudo apt-get update
  sudo apt-get dist-upgrade
  sudo apt-get install matchbox chromium x11-xserver-utils ttf-mscorefonts-installer xwit sqlite3 libnss3 libreoffice-impress impressive
}

function set_config {
  cat config.txt >> /boot/config.txt
}

function set_rc_local {
  cat rc.local >> /etc/rc.local
}


function set_xinitrc {
  cat xinitrc >> /boot/xinitrc
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

function download_release {
  wget -o presenter-release.tar.gz ${RELEASE_URL}
  tar -xvzf presenter-release.tar.gz
  cd presenter-release
}


wait_for_network
disable_boot_to_ui
enable_ssh
install_packages
set_config
set_xinitrc
set_rc_local
