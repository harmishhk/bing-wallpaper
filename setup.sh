#!/usr/bin/env bash

# set direcoty paths in bing-cron and bing-wallpaper.sh
PWD="`pwd`"
gawk "{ gsub(\"/DOWNLOAD_DIR\", \"$PWD\",\$0); print \$0 }" bing-cron > tmp.tmp
mv tmp.tmp bing-cron
gawk "{ gsub(\"/DOWNLOAD_DIR\", \"$PWD\",\$0); print \$0 }" bing-wallpaper.sh > tmp.tmp
mv tmp.tmp bing-wallpaper.sh
chmod a+x bing-wallpaper.sh

# setup crontab
crontab bing-cron

# and run bing-wallpaper.sh once
./bing-wallpaper.sh
