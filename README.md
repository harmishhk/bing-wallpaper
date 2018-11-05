Bing Picture of the Day Wallpaper
=================================

This script downloads "Bing wallpaper of the day" and keeps history of previous pictures. It also sets up a cronjob to update the wallpaper regularly.
Adapted from [memek/bing-wallpaper](https://github.com/memek/bing-wallpaper).
Based on [thejandroman](https://github.com/thejandroman/bing-Wallpaper) script.

This bash script requires curl, grep, gawk, jq and nitrogen (for i3wm) installed in your system.

How to use?
-----------

Clone this repository and run
`sh setup.sh`

You need to add `exec nitrogen --restore` to you i3 configuration file.

This script does the following
* in **bing-cron** set path of the script. It defaults to DOWNLOAD_DIR/.bing-wallpaper/bing-wallpaper.sh
* in **bing-cron** set the path of the log file. It defaults to DOWNLOAD_DIR/.bing-wallpaper/log.log
* in **bing-wallpaper.sh** set PICTURE_DIR variable to keep the current wallpaper. It defaults to DOWNLOAD_DIR/.bing-wallpaper/pictures
* in **bing-wallpaper.sh** set PICTURE_DIR_OLD to the path to keep history of previous wallpapers. It defaults to DOWNLOAD_DIR/.bing-wallpaper/pictures_old
* you can change schedule settings in **bing-cron** to your personal needs. By default the script will be run at 9:20, 11:20, 13:20, 15:20, 17:20 and 19:20
* run `crontab bing-cron` to setup the cronjob.
