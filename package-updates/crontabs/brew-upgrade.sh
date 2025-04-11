#!/bin/bash
# Cron driven package updater for macOS with brew
# Intended to run hourly within a window, 6am - 12pm
# If out file is 6hrs (21600 seconds) or older, upgrade packages
# If out file does not exist, create it, backdate it 6hrs, and upgrade packages
# mtime of out file is updated initially to prevent overlapping hourly runs

CRON_DIR=/Users/user1/cron
CRON_BREW_OUT=$CRON_DIR/cron.brew.out

test ! -d $CRON_DIR && mkdir $CRON_DIR
test ! -f $CRON_BREW_OUT && touch -t $(date -v -6H "+%Y%m%d%H%M") $CRON_BREW_OUT

test $(( $(date +"%s") - $(stat -f "%m" $CRON_BREW_OUT) )) -ge 21600 &&
{ touch $CRON_BREW_OUT
  /bin/date; echo
  /usr/local/bin/brew upgrade; } > $CRON_BREW_OUT 2>&1
