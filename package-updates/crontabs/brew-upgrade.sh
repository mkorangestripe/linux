#!/bin/bash
# Cron driven package updater for macOS with brew
# Intended to start within a 6 hour window
# If the out file is 6hrs (21600 seconds) or older, upgrade packages
# If the out file does not exist, create it, backdate it 6hrs, and upgrade packages
# mtime of the out file is updated initially to prevent potential overlapping runs

CRON_DIR=/Users/user1/cron
CRON_BREW_OUT=$CRON_DIR/cron.brew.out

test ! -d $CRON_DIR && mkdir $CRON_DIR
test ! -f $CRON_BREW_OUT && touch -t $(date -v -6H "+%Y%m%d%H%M") $CRON_BREW_OUT

test $(( $(date +"%s") - $(stat -f "%m" $CRON_BREW_OUT) )) -ge 21600 &&
{ touch $CRON_BREW_OUT
  /bin/date; echo
  /usr/local/bin/brew upgrade; } > $CRON_BREW_OUT 2>&1
