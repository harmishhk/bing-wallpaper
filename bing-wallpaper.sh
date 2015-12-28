#!/usr/bin/env bash
# Simple bing picture of the day downloader
# Author: Przemysław Świercz <przemyslaw.swiercz@gmail.com>
# 02 Feb 2014
# Maintainer: Harmish Khambhaita <harmish.khambhaita@hotmail.com>
# 28 Dec 2015

# directories to keep wallpaper of the day and archive
PICTURE_DIR="/DOWNLOAD_DIR/pictures/"

# attempt to create directories
mkdir -p $PICTURE_DIR

# setting commands
PING="/bin/ping"
GAWK="/usr/bin/gawk"

# just for loggin purposes
echo $(date)

# test internet connection
connection_ok=0
for i in {1..3}
do
  test=$( $PING -q -c 1 8.8.4.4 | grep received | cut -d ' ' -f 4)
  if [[ test -eq 1 ]]; then
    connection_ok=1
    break
  else
    sleep 8
  fi
done
if [[ connection_ok -ne 1 ]]; then
  echo -e "internet is no more\n"
  exit 1
fi

# urls and primary/secondary resolution
bing="http://www.bing.com"
xml="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-US"
res="_1920x1200.jpg"
res2="_1366x768.jpg"

# extract image url and filename
url=$(curl -s "$xml" | $GAWK 'match($0, /<urlBase>(.*)<\/urlBase>/, u) {print u[1]}' )
filename=$(echo $url | $GAWK 'match($0, /\/([^\/]*)_EN/, n){print n[1]}' )

# check if file already exists
if [ -e $PICTURE_DIR/$filename.jpg ]; then
  echo "File $filename.jpg already exists in the download directory."
  exit 0
fi

# download primary resulotion image
echo $bing$url$res
curl -Lo "$PICTURE_DIR/$filename.jpg" $bing$url$res

# if failed, try to download secondary resolution
head=$(head -c 9 "$PICTURE_DIR/$filename.jpg")
if [[ $head == "<!DOCTYPE" ]]; then
  echo $bing$url$res2
  curl -Lo "$PICTURE_DIR/$filename.jpg" $bing$url$res2
fi

# when succeed, immediatly set downloaded file as background image in ubuntu
head=$(head -c 9 "$PICTURE_DIR/$filename.jpg")
if [[ $head == "<!DOCTYPE" ]]; then
  exit 0
else
  # set downloaded file as wallpaper
  feh --bg-scale $PICTURE_DIR/$filename.jpg
  # remove old files
  find $PICTURE_DIR -maxdepth 1  -type f  ! -name $filename.jpg | xargs --no-run-if-empty rm
fi

exit 0
