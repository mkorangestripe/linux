# Bash

#### Bash history, args

```shell script
!!          # executes last command in history
!58         # executes 58th command in history
!ssh        # executes last command starting with ssh
!?ssh       # executes last command containing the string ssh
echo !$     # echos last argument of last command
echo !*     # echos all but first word of last command

echo $?     # echos exit status of last command
echo $@     # echos all arguments given to the script
echo $#     # echos the number of arguments given to the script

^echo       # executes last command without echo
^eth0^lo^   # executes last command substituting eth0 with lo

history -a  # appends current session history to history file
```

```shell script
# This can be used to keep a password out of the bash history:
PASSWD=$(cat)
# Type the password
# Ctrl+d

# Get user input from a script:
echo -n "Enter password: "
read PASSWD
```

```shell script
pushd src   # cd to src/ and add to queue
pushd +1    # cd to #1 directory in queue
pushd       # cd to previous directory in queue

popd        # cd to last directory and remove from queue
popd +1     # remove #1 directory from queue

dirs -v     # show directories in queue with number
```

#### Environment and Shell Options

```shell script
exec bash    # replaces bash shell with new bash shell

grep -l PATH ~/.[^.]*  # finds file in ~ that sets PATH

.bash_profile  # User specific environment and startup programs, also sources .bashrc
export PS1="\[\033[1;31m\][\u@\h \w]# \[\033[0m\]"  # light red root prompt
export PS1="\[\033[1;32m\][\u@\h \w]$ \[\033[0m\]"  # light green user prompt

.bashrc       # user specific aliases and functions, also sources /etc/bashrc

env           # prints environment variables
export -p     # prints environment variables
# press $ Tab Tab (prints environment variables)

set           # prints names and values of all current shell variables
set -o emacs  # emacs style line editing
set -x        # turn on execution tracing, use in scripts to print commands during execution
set +x        # turn off execution tracing

alias grep='grep --color'  # color greps
alias         # prints aliases
alias grep    # prints the alias for grep
```

#### Redirection

```shell script
# File descriptors: 0 stdin, 1 stdout, 2 strerr

grep calc * 2> err.log      # redirects stderr to file
grep calc * &> err.log      # redirects stdout and stderr to file; useful if no read
grep calc * > err.log 2>&1  # redirects stderr to stdout; seems same as using &>
grep calc * > err.log 1>&2  # redirects stdout to stderr which in this case is tty
grep calc < err.log         # redirects stdin to grep, same as ‘grep cacl err.log’
./prime_gen.py < /dev/null  # EOFError, redirects stdin to /dev/null so the script doesn’t hang on user input
./prime_gen.py <&-          # IOError, closes stdin so the script doesn’t hang on user input
nohup ./ps1b.py &           # run ps1b.py in the background, ignore hangup signal
nohup mydaemonscript 0<&- 1>/dev/null 2>& &
nohup mydaemonscript >>/var/log/myadmin.log 2>&1 <&- &
>&-                         # closes stdout
```

```shell script
# Create file test1.txt with the lines below; the single quotes prevent command evaluation:
cat <<'EOF' > test1.txt
apple
`ls -l`
EOF
```

```shell script
# Set the second listed version of java as the system default:
alternatives --config java << EOF
2
EOF
```

```shell script
# Get system info on tester1:
ssh gp@tester1 << EOF
uname -a
lsb_release -d
EOF
```

#### fg, bg, jobs
```shell script
while True; do sleep 5; echo Yes; done   # run command in foreground
# Ctrl+z                                 # suspend execution
while True; do sleep 5; echo No; done &  # run command in background

jobs     # list jobs with state
fg %1    # continue execution of job 1 in the foreground
bg %1    # continue execution of job 1 in the background
kill %1  # kill job 1 if suspended or running in background
```

#### Loops and Tests

```shell script
for i in `seq -w 0 20`; do touch file.$i; done  # creates 20 files with padding for zeros
for((j=0; j<9; j++)); do echo $j; done          # C-style for loop
ls -d */ 2> /dev/null | wc -l                   # returns the number for dirs only

while [ -f errors.log ]; do echo 'file exists'; sleep 1; done
while [ ! -d log ]; do echo 'log directory does not exist'; sleep 1; done

test $? == 0 && echo success || echo fail
[ $? == 0 ] && echo success || echo fail
if [ $? == 0 ]; then echo success; else echo fail; fi

c=17; f=15
[ $f < $c ] && echo true || echo false    # results in error when $f and $c are interpreted as filenames
[[ $f < $c ]] && echo true || echo false  # true

[ -z $FIRST_AVAIL_IP ] && echo "zero length"
[ ! $FIRST_AVAIL_IP ] && echo "zero length"
[ ! -z $FIRST_AVAIL_IP ] && echo "not zero length"

# Test whether $VAR1 is set:
if [ $VAR1 ]; then
    echo $VAR1
fi
```

```shell script
# Run commands from a file using a while-loop:
cat commands.txt | while read CMD; do echo $CMD; eval $CMD; done
while read CMD; do echo $CMD; eval $CMD; done < commands.txt

# Run commands from a file using a for-loop:
IFS=$'\n'
for CMD in `cat commands.txt`; do echo $CMD; eval $CMD; done
unset IFS
```

```shell script
# Returns the total count of files/dirs unless a file has spaces in the name:
COUNT=0; for FILE in `ls`; do COUNT=$((COUNT + 1)); done; echo $COUNT
```

```shell script
# Monitor disk usage on the root filesystem:
i=0; while i=$((i + 1)); do df -h / | grep "..[0-9]%"; sleep 15; [ $i == $(($(tput lines) - 2)) ] && i=0 && echo -e "\e[1;31m`hostname`\e[00m `date +%T`"; done

# Similar to above, but without using tput.  Eventually though “i“’ would become out of range.
i=0; while i=$((i + 1)); do df -h / | grep "..[0-9]%"; sleep 15; ((i % 20 == 0)) && echo -e "\e[1;31m`hostname`\e[00m `date +%T`"; done
```

```shell script
# “While loop” file-test with a red/green spinner:
while [ -d /etc ]; do printf "\r \e[31m[/]\e[00m"; sleep 0.5; printf "\r \e[32m[-]\e[00m"; sleep 0.5; printf "\r \e[31m[\\]\e[00m"; sleep 0.5; printf "\r \e[32m[|]\e[00m"; sleep 0.5; done; echo

# “Do while loop” that checks if a file exists:
while true; do [ -f nothing3.txt ] && echo "file present" || { echo "file not present"; break; }; sleep 2; done
```

```shell script
# A simple prime number generator finding prime numbers 2 through 100: 
for i in $(seq 2 100); do for j in $(seq 2 $((i / 2))); do [ $((i % j)) == 0 ] && i="" && break; done; [ -n "$i" ] && echo $i; done
```

```shell script
# Status bar:
for i in `seq 1 10`; do printf "\e[31m#\e[00m"; sleep 0.5; done; printf "\rDone      "; echo
```

#### Bitwise Operators

```shell script
# The left number in the double parenthesis is a decimal.
# The right number is the binary shift.
# With every shift, the decimal is either doubled or halved.

# The decimal 1 (binary: 1) shifted 8 places to the left becomes 256 (binary: 1 0000 0000)
echo $((1<<8))
# 256

# The decimal 8 (binary: 1000) shifted 1 place to the left becomes the decimal 16 (binary: 1 0000)
echo $((8<<1))
# 16

# The decimal 3 (binary: 11) shifted 2 places to the left becomes 12 (binary: 1100)
echo $((3<<2))
# 12

# The decimal 12 (binary: 1100) shifted 2 places to the right becomes 3 (binary: 11)
echo $((12>>2))
# 3
```

#### Scripts and shell vars

```shell script
# Pass shell variables to a python command; in this example, -c is sys.argv[0] and $COLOR is sys.argv[1].
COLOR=green
python -c "import sys; print sys.argv[1].lower()" $COLOR
# green

# The above in a Bash function:
lower() { python -c "import sys; print sys.argv[1].lower()" $1; }
lower BLUE
# blue
```


#### Arrays

```shell script
arr[0]=asdf1234
arr[1]=777
arr[2]=black

colors=([91]=red [92]=yellow [93]=yellow)
 
echo ${arr[@]}      # This prints all elements in the array
asdf1234 777 black
echo ${#arr[@]}     # prints the number of elements in the array (length of the array)
# 3
echo ${#string[0]}  # prints the length of the first element
# 8
echo ${#string[1]}  # prints the length of the second element
# 3
echo ${#string[2]}  # prints the length of the third element
# 5
```

#### Subshells and Code Blocks

```shell script
touch nothing
test -f nothing || cd / && ls       # ls runs on current dir
test -f nothing || { cd / && ls; }  # neither cd nor ls runs
rm nothing
test -f nothing || { cd / && ls; }  # ls is run on / and the current dir is now /
test -f nothing || (cd / && ls)     # ls is run on / but the current dir does not change

# Redirect output of a subshell to a script or command:
./stack-check.sh <(cat hostlist.txt | grep -v dc1)

# Redirect output from two subshells to diff:
diff <(ssh host1 "cat /config/bigip.conf") <(ssh host2 "cat /config/bigip.conf")

# Redirect output from tailing a log to terminal and two separate subshells: 
tail -f words.log | tee >(grep leaf > leaves.txt) >(grep apple > apples.txt)

# Run script on remote host over ssh:
ssh USER@$HOSTNAME /bin/bash < drhloggzip-ssh.sh
```

```shell script
# The following script uses subshells and background execution to run commands in parallel.
# The "wait" ensures the terminal will not display a prompt until execution is complete
# and also that the terminal will in fact display a prompt when processing is complete.
# Invoking subshells isn’t absolutely necessary in this example.

#!/bin/bash
# Example usage: ./ppss.sh 3 scriptA scriptB scriptC scriptD scriptE
MAXFORKS=$1
shift
FORKS=0
for SCRIPT in $@; do
    if [ $FORKS -ge $MAXFORKS ]; then
        wait
        FORKS=0
    fi
    echo "Working on $SCRIPT"
    ($SCRIPT) &
    FORKS=$(( $FORKS + 1 ))
done
wait
```

#### Evaluation, Expansion

```shell script
VAR1=apple

VAR2="orange
grape"

echo $VAR1        # apple
echo "$VAR1"      # apple
echo "$VAR2"      # line1: orange; line 2: grape
echo '$VAR1'      # $VAR1
echo cart$VAR1    # cartapple
echo $VAR1cart    # (no output)
echo ${VAR1}cart  # applecart

echo a{pp,,is}le  # apple ale aisle

VAR3=PINEapple
echo ${VAR3,,}  # pineapple
echo ${VAR3^^}  # PINEAPPLE

PERSHING_RECORD=f220_a
echo ${PERSHING_RECORD%_*}  # f220
echo ${PERSHING_RECORD#*_}  # a

REGEXs_EGREP_ARGS=" -e 208.79.249 -e 208.79.253 -e 207.67.0 -e 207.67.50"
echo $REGEXs_EGREP_ARGS    # 208.79.249 -e 208.79.253 -e 207.67.0 -e 207.67.50
echo "$REGEXs_EGREP_ARGS"  # -e 208.79.249 -e 208.79.253 -e 207.67.0 -e 207.67.50

COLOR=yellow ./fruit.sh
# yellow pear (COLOR is only set for the following ./fruit.sh)
```

```shell script
touch img.{00..23}  # creates img.00 through img.23
ls img.{00..09}     # matches the first 10

touch apple  # create a file named apple
ls ap?le     # apple (matches any one char)
ls a*le      # apple (matches patterns beginning with a, ending with le)

# Useful if the ls command is hanging on a broken symlink
# Also good practice before using rm on multiple files
echo *
```

```shell script
ffpid="ps -e | grep firefox"
eval $ffpid
# 8393 ?        01:01:43 firefox

alias insert='printf "|%s|\n"'
insert "camera operator"
# |camera operator|
```

#### Misc

```shell script
basename $0       # filename of the script being run
dirname $0        # relative path of the script being executed
readlink -f $0    # full path and filename of the script being run

command -v grep   # show full path or alias for grep if either exist
which -a python   # list all matching executables in PATH for python

chsh -s /bin/zsh  # set zsh as default shell on OSX
```
