#!/usr/bin/env bash

# set direcoty paths in bing-cron and bing-wallpaper.sh
if [ $# -eq 0 ]; then
    PWD=`pwd`
else
    PWD=$1
fi
gawk "{ gsub(\"/DOWNLOAD_DIR\", \"${PWD}\",\$0); print \$0 }" ${PWD}/bing-cron > ${PWD}/tmp.tmp
mv ${PWD}/tmp.tmp ${PWD}/bing-cron
gawk "{ gsub(\"/DOWNLOAD_DIR\", \"${PWD}\",\$0); print \$0 }" ${PWD}/bing-wallpaper.sh > ${PWD}/tmp.tmp
mv ${PWD}/tmp.tmp ${PWD}/bing-wallpaper.sh
chmod a+x ${PWD}/bing-wallpaper.sh

# setup crontab
crontab ${PWD}/bing-cron

# and run bing-wallpaper.sh once
${PWD}/bing-wallpaper.sh
