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

}

function set_rc_local {

}


function set_xinitrc {

}

function download_release {
  wget -o presenter-release.tar.gz ${RELEASE_URL}
  tar -xvzf presenter-release.tar.gz
  cd presenter-release
}
