#!/usr/bin/bash
# Cron driven package updater for systems with apt
# Intended to run hourly within a window, 6am - 12pm
# If out file is 6hrs (21600 seconds) or older, upgrade packages
# If out file does not exist, create it, backdate it 6hrs, and upgrade packages
# mtime of out file is updated initially to prevent overlapping hourly runs

export TERM=xterm-256color
CRON_APT_OUT=/var/log/cron.apt.out

test ! -f $CRON_APT_OUT &&
touch -t $(date --date="6 hours ago" "+%Y%m%d%H%M") $CRON_APT_OUT

test $(( $(date +"%s") - $(stat -c '%Y' $CRON_APT_OUT) )) -ge 21600 &&
{ touch $CRON_APT_OUT
  /usr/bin/date
  /usr/bin/apt update &&
  /usr/bin/apt -y dist-upgrade
  /usr/bin/apt -y autoremove; } > $CRON_APT_OUT 2>&1
