# Grep, Awk, Sed, Regex

```shell script
ps -e | awk '/firefox/ {print $1}'  # print the PID of firefox
awk -F: '{print $1}' /etc/passwd    # print 1st column in /etc/passwd
cut -d: -f 1-4 /etc/passwd          # prints 1st - 4th columns in /etc/passwd
cut -c 1-750 pershing.txt           # print first 750 characters in each line

sed -n 1,8p /etc/passwd  # prints 1st - 8th lines in /etc/passwd
sed '1d' /etc/passwd     # print all by the first line in /etc/passwd
sed '$d' /etc/passwd     # print all but the last line in /etc/passwd
```

```shell script
# Print the IP address of eth0, either of the following:
ifconfig eth0 | awk '/inet addr/ {print $2}' | awk -F: '{print $2}'
ifconfig eth0 | grep -w inet | awk '{print $2}' | awk -F: '{print $2}'

ps -ef | sort -k3n  # print process list sorted by (PPID)
ps -ef | awk '$8 == "ssh" {print $2}'  # print PIDs of ssh processes
ps aux | gawk 'BEGIN{OFS=":";} {print $1,$2;}'  # print username:PID

# Semicolon separated string of ps output:
PROC=$(ps aux | awk '{printf "%s;", $0}')
# Print all records using the semicolon as the record separator:
echo $PROC | awk '{print $0}' RS=";"

# Print total size of gzip'ed files in megabytes, either of the following:
du *.gz | awk '{total+=$1} {total/=1024} END {printf "%d%s\n", total,"M"}'
TOTAL=0; for NUM in $(du *.gz | awk '{print $1}'); do ((TOTAL+=NUM)); done; echo $((TOTAL/1024))M
```

#### Sed, tr

```shell script
# Substitute Dragonflies with Fireflies globally and redirect to insects2.txt:
sed 's/Dragonflies/Fireflies/g' insects.txt > insects2.txt

# Substitute Dragonflies with Fireflies globally in place:
sed -i 's/Dragonflies/Fireflies/g' insects.txt

# Remove entire line that contains string:
sed -i '/pl_haproxy_mfg_role/d' environments/*

# Use | instead of / for strings containing forward slashes:
sed 's|$OLD_URL|$NEW_URL|' url_list.txt

# Substitute 'app' with 'che' globally, either of the following:
cat hostlist.txt | grep app | sed 's/app/che/g'
cat hostlist.txt | gawk 'gsub(/app/,"che")'

# Strips everything but the ip address on checkip.dyndns.org, either of the following:
wget -q -O - checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'

# For all files in the current directory change the rtf file extension to txt, either of the following:
for i in *.rtf; do mv $i `echo $i | sed 's/rtf/txt/g'`; done
rename .rtf .txt * # be careful, do not precede the file extensions with an *

# Disable every service in runlevel 4:
cd /etc/rc4.d
for i in S*; do mv $i $(echo $i | sed 's/S/K/'); done

# Remove the carriage returns from keys.txt
tr -d '\r' < keys.txt > keys2.txt
dos2unix keys.txt

# Remove all whitespace from the start of lines in spcs.txt and direct output to nada.txt:
sed 's/^[ \t]*//' spcs.txt > nada.txt
```

#### Vi, Vim

```shell script
# Remove all whitespace from the start of all lines in vi:
%s/^\s\+
%le
# Remove all whitespace from the end of all lines in vi:
%s/\s\+$

# Remove the first 3 characters from each line in vi:
%normal 3x

# Prepend ### to all lines in vi:
%s/^/###
# Remove ### from the beginning of all lines in vi:
%s/^###
# Append ### to all lines in vi:
%s/$/###

# Prepend four spaces to lines in vi:
# Note, this will add four spaces to blank lines as well
# Select the lines
# Press :
norm I    # note the four spaces after the 'I'

# Set indents in vi:
set shiftwidth=4
# select lines
>
```

#### Grep, Regex

```shell script
grep ^apple fruitlist.txt   # matches words starting with apple
grep fruit$ fruitlist.txt   # matches words ending with fruit
grep ap.le fruitlist.txt    # matches any one char
grep -wo ... fruitlist.txt  # matches 3 letter words
grep a.*le fruitlist.txt    # matches patterns beginning with 'a', ending with 'le'
grep -a mixeddata.txt       # treat binary data as text

# Here is an example of Bash evaluating an expression thereby preventing grep from doing so:
# fruit.txt has three lines: aples, apples, and appples
# The current directory contains a file named aptles
grep ap*les fruit.txt  # nothing is returned
echo ap*les            # aptles (Bash is expanding ap*les to aptles)
# To prevent Bash from evaluating the expression do one of the following:
grep ap\*les fruit.txt
grep "ap*les" fruit.txt

grep 7[0-24-6] fruitlist   # matches 70-72 and 74-76
egrep '(6[89]|7[0-9]|80)'  # matches 68-80
egrep '(6[89]|7[^89]|80)'  # matches 68-80 except 78 and 79
grep -e node -e env        # matches node or env
grep 'node\|env'           # matches node or env

echo cardinal.xml.13 | egrep '\.xml\.[0-9]+'  # cardinal.xml.13
echo cardinal-xml.13 | egrep '\.xml\.[0-9]+'  # no match

# Regex
# ^ line starts with
# $ line ends with
# ? Zero or one occurrences of the preceding element
# * Zero or more occurrences of the preceding element
# + One or more occurrences of the preceding element
# . Any single character except for line terminators
# .* Zero or more characters
# .? The previous token between zero and unlimited times, as few times as possible
# {1,2} The previous token between 1 and 2 times, as many times as possible

# Match up to and including the first v2, simpler variations also work:
^(.*?/v\d{1,2}).*?
https://somedomain.com/api/Online/Users/v2/Users/137769/Applications/v2
https://somedomain.com/api/Online/Users/v2

# Alternative formats, useful for keeping the pattern at the end of the line:
cat flora.txt | grep maple
< flora.txt grep maple

# Print lines in newentries.txt that are not in completelist.txt:
for i in `cat newentries.txt`; do grep -q -x $i completelist.txt || echo $i; done
```

#### Sorting

```shell script
sort -r list.txt      # sort in reverse order - reverse alphabetically in this example
sort -u list.txt      # output list.txt sorted alphabetically and uniquely
sort list.txt | uniq  # output list.txt sorted alphabetically and uniquely

# Sort output from the host command by IP address:
cat hostlist.txt | awk '{print $4,$1,$2,$3}' | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 | awk '{print $2,$3,$4,$1}' > sorted_by_ip.txt
```
