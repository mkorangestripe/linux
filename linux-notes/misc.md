Screen
```shell script
screen -S green1  # start screen session named green1
screen -ls        # list screen sessions
screen -d         # detach from current screen
screen -r         # reattach to the screen
screen -r 10514.yellow1   # reattach to yellow1 screen
screen -dr 10514.yellow1  # detach yellow1 screen and reattach here
screen -x 10514.yellow1   # attach to currently attached yellow1 screen

# Ctrl+a, d  # detach from screen session

# If you cannot attach to a screen session because of permissions, execute the following then reattempt:
script /dev/null
```

Irssi
```shell script
irssi -c ircserver.example.com -n user1  # connect to irc server
```

Mail
```shell script
# Create & send email. Follow prompts, press Ctrl+D at end of message.
mail user1@example.com

# Send text file as email:
mail -s 'Testing Mail' < mailbody.txt user1@example.com
```
