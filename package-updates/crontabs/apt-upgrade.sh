#!/usr/bin/bash
# Cron driven package updater for systems with apt
# Intended to run hourly within a window, e.g. 6am - 12pm
# If out file is 18hrs (61200 seconds) or older, upgrade packages
# If out file does not exist, create it, backdate it 17hrs, and upgrade packages

export TERM=xterm-256color
CRON_APT_OUT=/var/log/cron.apt.out

test -f $CRON_APT_OUT ||
touch -t $(date --date="17 hours ago" "+%Y%m%d%H%M") $CRON_APT_OUT &&
test $(( $(date +"%s") - $(stat -c '%Y' $CRON_APT_OUT) )) -ge 61200 &&
{ /usr/bin/date
  /usr/bin/apt update &&
  /usr/bin/apt -y dist-upgrade &&
  /usr/bin/apt -y autoremove; } > /var/log/cron.apt.out 2>&1
