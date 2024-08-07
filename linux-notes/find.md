# Find

#### Find and exec
```shell script
# The semicolon is both a delimiter for the exec option and a Bash token.
# Without the backslash it would be interpreted by Bash not exec.
find . -type f -exec ls {} \;

# The plus sign and xargs append arguments to the command and then executes.
find . -type f -exec ls {} +
find . -type f | xargs ls
```

#### Find and grep
```shell script
# Run grep for each file found.
# The -H option or including /dev/null in the file list will force print the filename.
find . -maxdepth 1 -type f -name 'colors*.txt' -exec grep orange {} \;
find . -maxdepth 1 -type f -name 'colors*.txt' -exec grep -H orange {} \;
find . -maxdepth 1 -type f -name 'colors*.txt' -exec grep orange /dev/null {} \;

# Run grep once with all files found:
find . -maxdepth 1 -type f -name 'colors*.txt' -exec grep orange {} + 

# Run grep once with all files found using xargs.
# The -print0 and -0 are necessary for xargs to handle filenames containing spaces.
find . -maxdepth 1 -type f -name 'colors*.txt' -print0 | xargs -0 grep orange
```

#### Find by owner, name, size, mtime
```shell script
# Find files by owner:
find /home/ -type f -user gp > gp.regfile

# Find log files over 5MB (10,000 x 512 byte blocks) modified in the last day.
# Do not traverse paths that are mount points.
find / -mount -name '*.log' -size +10000 -type f -mtime -1 -exec du -sh {} \;

# Find and zip logs older than 14 days only in the current directory:
find . -maxdepth 1 -name '*.log' -type f -mtime +14 -exec gzip {} \;
```

#### Find and delete
```shell script
# Find and delete files not named *.conf and modified between 5 and 30 minutes ago:
find . -type f ! -name '*.conf' -mmin +5 -mmin -30 -print -delete  # print option prints the filenames
find . -type f ! -name '*.conf' -mmin +5 -mmin -30 -print0 | xargs -0 rm
```
