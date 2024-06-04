#### Screen
```shell script
screen -S green1   # start new screen session green1

screen -ls         # list screen sessions

screen -d          # detach from current screen
screen -r          # reattach to the screen
screen -r green1   # reattach to green1 screen, include pid e.g. 84010.green1 if multiples
screen -dr green1  # detach green1 screen and reattach here
screen -x green1   # attach to currently attached green1 screen

# Ctrl+a, d  # detach from current screen

# If you cannot attach to a screen session because of permissions, execute the following then reattempt:
script /dev/null
```

#### Tmux
```shell script
tmux new -s orange1            # start new session orange1
tmux new -s orange3 -n colors  # start new session orange3 and window colors

tmux ls  # list sessions

tmux a                  # attach to last session
tmux a -t orange1       # attach to session orange1
tmux new -A -s orange2  # attach to session orange2, create if doesn't exist

# Ctrl+b, d  # detach from session
# Ctrl+b, s  # show all sessions
# Ctrl+b, (  # move to previous session
# Ctrl+b, )  # move to next session

# Ctrl+b, new -s orange3  # create a new session orange3 from within a session
```

#### Irssi
```shell script
irssi -c ircserver.example.com -n user1  # connect to irc server
```

#### Mail
```shell script
# Create & send email. Follow prompts, press Ctrl+D at end of message.
mail user1@example.com

# Send text file as email:
mail -s 'Testing Mail' < mailbody.txt user1@example.com
```
