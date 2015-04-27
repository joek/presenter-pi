#!/bin/bash

export USB_STICK=/mnt/USB
export CONFIG_FILE=${USB_STICK}/startup.config

function start_chromium {
        wait_for_network
        start_ui
        mkdir -p /home/pi/.config/chromium/Default
        sqlite3 /home/pi/.config/chromium/Default/Web\ Data "CREATE TABLE meta(key LONGVARCHAR NOT NULL UNIQUE PRIMARY KEY, value LONGVARCHAR); INSERT INTO meta VALUES('version','46'); CREATE TABLE keywords (foo INTEGER);";
        chromium --app=$1 --disable-translate
}

function start_impress {
        rm -rf libreoffice/ .recently-used
        start_ui
        cd ${USB_STICK}
        libreoffice -show $1
}

function start_pdf {
        cd ${USB_STICK}
        impressive -a 10 -w $1
}

function start_video {
        cd ${USB_STICK}
        omxplayer -o both $1
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

function start_ui {

        # Clean up previously running apps, gracefully at first then harshly
        killall -TERM chromium 2>/dev/null;
        killall -TERM matchbox-window-manager 2>/dev/null;
        sleep 2;
        killall -9 chromium 2>/dev/null;
        killall -9 matchbox-window-manager 2>/dev/null;

        # Clean out existing profile information
        rm -rf /home/pi/.cache;
        rm -rf /home/pi/.config;
        rm -rf /home/pi/.pki;

        # Disable DPMS / Screen blanking
        xset -dpms
        xset s off

        # Reset the framebuffer's colour-depth
        fbset -depth $( cat /sys/module/*fb*/parameters/fbdepth );

        # Hide the cursor (move it to the bottom-right, comment out if you want mouse interaction)
        xwit -root -warp $( cat /sys/module/*fb*/parameters/fbwidth ) $( cat /sys/module/*fb*/parameters/fbheight )

        # Start the window manager (remove "-use_cursor no" if you actually want mouse interaction)
        matchbox-window-manager -use_titlebar no -use_cursor no &
}

while true; do
       grep ^start_browser ${CONFIG_FILE} >> /dev/null
       if [ $? -eq 0 ]
       then
          start_chromium $(grep start_browser ${CONFIG_FILE} | sed "s/start_browser=//")
       fi

       grep ^start_presentation ${CONFIG_FILE} >> /dev/null
       if [ $? -eq 0 ]
       then
          start_impress $(grep start_presentation ${CONFIG_FILE} | sed "s/start_presentation=//")
       fi

       grep ^start_pdf ${CONFIG_FILE} >> /dev/null
       if [ $? -eq 0 ]
       then
          start_pdf $(grep start_pdf ${CONFIG_FILE} | sed "s/start_pdf=//")
       fi

       grep ^start_video ${CONFIG_FILE} >> /dev/null
       if [ $? -eq 0 ]
       then
          start_video grep start_video ${CONFIG_FILE} | sed "s/start_video=//")
       fi

done;
