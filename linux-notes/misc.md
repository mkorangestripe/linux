```shell script
screen -S green1  # start screen session green1
screen -ls        # list screen sessions
screen -d         # detach from current screen
screen -r 10514.nothing1   # reattach to screen nothing1
screen -dr 10514.nothing1  # detach the screen and reattach here
screen -x 10514.nothing1   # attach to currently attached screen

# If you cannot attach to a screen session because of permissions, execute the following then reattempt attaching:
script /dev/null

irssi -c <irc-server> -n <name>

mail -s 'Testing Mail' < file.txt user@domain
mail user@domain  # follow prompts, press ctrl D at end of message

sqlite3 test1.db
select * from sqlite_master;
.databases
.tables
.show
.help
.quit
.mode column
.headers on
```
