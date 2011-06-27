#! /usr/bin/env sh
# Downloads latest build of Chromium for MacOS X.
# https://github.com/NoNoNo/shellscripts-update_chromium
# 
# Based on a script by: Tlalox on Jun 05, '09 08:15:49AM
# http://hints.macworld.com/article.php?story=20090604081030791

# setup ------------------------------------------------------------------------
tempDir="/tmp/`whoami`/chrome-nightly/";
baseURL="http://commondatastorage.googleapis.com/chromium-browser-continuous/Mac";
baseName="chrome-mac";
baseExt="zip";
appName="Chromium.app";
appDir="/Applications";
version=~/.CURRENT_CHROME;
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
function checkForErrors {
    if [ "$?" != "0" ]; then
        echo "Unkown error (see above for help)!";
        exit 3;
    fi
}
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
echo "Setup...";
mkdir -p "$tempDir";
cd "$tempDir";
checkForErrors;
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
echo "Checking current version...";
touch $version
currentVersion=`cat $version`;
latestVersion=`curl -s $baseURL/LAST_CHANGE`;
checkForErrors;
echo " * your/latest build: $currentVersion / $latestVersion";
if [ "$currentVersion" == "$latestVersion" ]; then
    echo " * build $currentVersion is the latest one.";
    exit 1;
fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
echo "Downloading and unpacking...";
chromePID=`ps wwaux|grep -v grep|grep "$appName"|awk '{print $2}'`;
if [ "$chromePID" != "" ];then
    echo " * chromium is running. Please stop it first.";
    exit 2;
fi
# echo "$baseURL/$latestVersion/$baseName.$baseExt"; exit
curl -L -o $baseName.$baseExt "$baseURL/$latestVersion/$baseName.$baseExt";
unzip -qo $baseName.$baseExt;
checkForErrors;
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
echo "Installing...";
cp -r $baseName/$appName $appDir
checkForErrors;
echo $latestVersion > $version;
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
echo "Done. You're now running build $latestVersion";
# ------------------------------------------------------------------------------
