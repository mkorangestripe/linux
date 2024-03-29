# Find

```shell script
# The exec option needs an argument to terminate itself and because the semicolon is also a Bash token.
# Bash will evaluate the semicolon unless the semicolon is escaped with a backslash.
find . -type f -exec ls {} \;

# The plus sign and xargs append arguments to the command and then executes.
# Either of these constructs are necessary with a very large number of files.
find . -type f -exec ls {} +
find . -type f | xargs ls

# Find regular files by owner:
find /home/ -type f -user gp > gp.regfile

# Find log files over 5MB (10,000 x 512 byte blocks) modified in the last day:
find / -mount -name \*.log -size +10000 -type f -mtime -1 -exec du -sh {} \;

# Find and zip logs older than 14 days only in the current directory:
find . -maxdepth 1 -name \*.log -type f -mtime +14 -exec gzip {} \;
```

```shell script
# Find which files are growing:
# Note, check1 and check2 might need to be on a filesystem other than the one filling up.
find . -type f -exec du {} \; > /tmp/check1.txt
sleep 2m
find . -type f -exec du {} \; > /tmp/check2.txt
diff /tmp/check1.txt /tmp/check2.txt
```

```shell script
# Find files not named *.conf, modified between 5 and 30 minutes ago, and delete them:
find . -type f ! -name '*.conf' -mmin +5 -mmin -30 -delete
find . -type f ! -name '*.conf' -mmin +5 -mmin -30 -print -delete
find . -type f ! -name '*.conf' -mmin +5 -mmin -30 -print0 | xargs -0 rm
```

```shell script
# Remove files with nonstandard filenames:
find . -inum 782263 -exec rm -i {} \; # remove the file with inode number 782263
rm \\  # remove a file named \
```
