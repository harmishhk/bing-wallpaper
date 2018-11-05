#!/usr/bin/env bash
# Simple bing picture of the day downloader
# Author: Przemysław Świercz <przemyslaw.swiercz@gmail.com>
# 02 Feb 2014
# Maintainer: Harmish Khambhaita <harmish.khambhaita@hotmail.com>
# 28 Dec 2015

# directories to keep wallpaper of the day and archive
PICTURE_DIR="/DOWNLOAD_DIR/pictures"

# attempt to create directories
mkdir -p $PICTURE_DIR

# setting commands
WGET="/usr/bin/wget"
GAWK="/usr/bin/gawk"

# just for loggin purposes
echo $(date)

# test internet connection
connection_ok=0
for i in {1..3}
do
    test = $( $WGET -q --spider http://bing.com )
    if [[ test -eq 0 ]]; then
        connection_ok=1
        break
    else
        sleep 8
    fi
done
if [[ connection_ok -ne 1 ]]; then
    echo -e "internet is no more"
    exit
fi

# urls and primary/secondary resolution
bing="http://www.bing.com"
json="http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US"

# extract image url and filename
url=$(curl -s "$json" | jq -r '.images|.[0]|.url')
filename=$(echo $url | $GAWK 'match($0, /\/([^\/]*)_EN/, n){print n[1]}' )

# check if file already exists
if [ -e $PICTURE_DIR/$filename.jpg ]; then
    echo "file $filename.jpg already exists in the download directory"
else
    # download image
    echo "downloading $bing$url"
    curl -Lo "$PICTURE_DIR/$filename.jpg" $bing$url

    # if download fails, select last downloaded file
    head=$(head -c 9 "$PICTURE_DIR/$filename.jpg")
    if [ ! -e "$PICTURE_DIR/$filename.jpg" -o "$head" == "<!DOCTYPE" ]; then
        filename=$(find $PICTURE_DIR -maxdepth 1 -type f -printf '%T@ %f\n' | sort -n | tail -1 | cut -f 2- -d' ' | cut -f -1 -d'.')
    fi
fi

# last check for file existance and size
if [ ! -f $PICTURE_DIR/$filename.jpg ]; then
    echo "picture file not found!"
    exit
fi
if [ $(wc -c <"$PICTURE_DIR/$filename.jpg") -eq 0 ]; then
    echo "picture file is empty!"
    exit
fi

# set wallpaper in genome-session
GS_PID=$(pgrep gnome-session)
if [ ! -z ${GS_PID} ]; then
    DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$GS_PID/environ | cut -d= -f2-) gsettings set org.gnome.desktop.background picture-uri file://$PICTURE_DIR/$filename.jpg 2>&1
fi

# set wallpaper in i3
# I3_PID=$(pgrep -x i3)
# if [ ! -z ${I3_PID} ]; then
    feh --bg-scale $PICTURE_DIR/$filename.jpg
    chmod a+rx $HOME/.fehbg
# fi


# remove old files
find $PICTURE_DIR -maxdepth 1  -type f  ! -name $filename.jpg | xargs --no-run-if-empty rm
