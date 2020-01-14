# Copy files
cp -a # --archive, same as -dr --preserve=all
cp -d # same as --no-dereference --preserve=links
cp -r # --recursive, copy directories recursively
cp -p # same as --preserve=mode,ownership,timestamps
cp -n # --no-clobber, do not overwrite an existing file
cp -i # --interactive, prompt before overwrite
cp -f # --force, if dest file cannot be read, remove it, and try again
# recursive & replicate pipes, copy symlinks, preserve file attributes, preserve extended attributes, on Solaris
cp -RPp@ /nfs/pub/ .

# rsync unlike cp copies only when the source and destination files differ.
rsync -av /nfs/pub/ . # archive options and verbose, copy the contents of 'pub'
rsync -av /nfs/pub . # archive options and verbose, copy the whole 'pub' directory
rsync -avn /nfs/pub . # archive options and verbose, dry-run
rsync -v DSC_0002.MOV -e 'ssh -p 2222' --progress gp@tester1: # use port 2222 and show progress



# Archiving, Compression
# create a gzipped archive of Documents and all files in Documents including their path and preserve the leading forward slash
tar -cvPzf nothing.tar.gz /home/gpurcell/Documents/
tar -tf nothing.tar.gz # list the contents of nothing.tar, -v for verbose
tar -xvPzf nothing.tar.gz # extract nothing.tar.gz to absolute path

gzip nothing9 # nothing9.gz
bzip2 nothing9 # nothing9.bz2
gzip -9 -c drh.log > drh.log.1.gz # this method utilizes memory or swap space
gzip -d nothing9.gz # decompress nothing9.gz

zip -r backup.zip dir1 # create a zip file from directory dir1
unzip -l backup.zip # list the contents of backup.zip, -v for verbose list

star -xattr -H=exustar -c -f=homebackup.star /home/  # create archive of /home including SELinux attributes and ACLs
star -x -f=homebackup.star # extract homebackup.star

md5sum company-mskr-ora.zip # compute md5 checksum



# Find files
# The exec option needs an argument to terminate itself and because the semicolon is also a Bash token...
# Bash will evaluate the semicolon unless the semicolon is escaped with a backslash.
find . -type f -exec ls {} \;

# The plus sign and xargs append arguments to the command and then executes.
# Either of these constructs are necessary with a very large number of files.
find . -type f -exec ls {} +
find . -type f | xargs ls

# find regular files by owner
find /home/ -type f -user gp > gp.regfile

# find log files over 5MB (10,000 x 512 byte blocks) modified in the last day
find / -mount -name \*.log -size +10000 -type f -mtime -1 -exec du -sh {} \;

# find and zip logs older than 14 days only in the current directory
find . -maxdepth 1 -name \*.log -type f -mtime +14 -exec gzip {} \;

# find which files are growing
# Note, check1 and check2 might need to be on a filesystem other than the one filling up.  
find . -type f -exec du {} \; > /tmp/check1.txt
sleep 2m
find . -type f -exec du {} \; > /tmp/check2.txt
diff /tmp/check1.txt /tmp/check2.txt

# find files not named *.conf, modified between 5 and 30 minutes ago, and delete them
find . -type f ! -name '*.conf' -mmin +5 -mmin -30 -delete
find . -type f ! -name '*.conf' -mmin +5 -mmin -30 -print -delete
find . -type f ! -name '*.conf' -mmin +5 -mmin -30 -print0 | xargs -0 rm

# remove files with nonstandard filenames
find . -inum 782263 -exec rm -i {} \;  (remove the file with inode number 782263)
rm \\  (remove a file named \)

# compute md5 checksum on a directory
find src/ -type f -exec md5sum {} + | awk '{print $1}' | sort | md5sum

# compare directory contents
diff -rq misc/ test/misc/



# Hexadecimal, Octal, Strings
# convert between hexadecimal and decimal
printf "%x\n" 123 # 7b
printf "%d\n" 0x7b # 123

echo 123 | hexdump # 3231 0a33 (hex value of characters 123 - little-endian byte order)
echo ABC | hexdump # 4241 0a43 (hexadecimal 2-byte units of characters ABC)
echo ABC | od -x # 4241 0a43 (hexadecimal 2-byte units of characters ABC)
echo ABC | hexdump -C # 41 42 43 0a  |ABC.| (hex+ASCII of characters ABC)
echo ABC | od -a -b # A   B   C  nl (ASCII named characters of ABC, octal values on next line)
echo ABC | od -c # A   B   C  \n (ASCII characters or backslash escapes)

strings /dev/sdb | less # search for strings in raw disk space



# Base64
echo "green, yellow, bright orange" | base64 > encoded.txt
base64 -d encoded.txt # green, yellow, bright orange

# Overwrite files
badblocks -c 10240 -s -w -t random -v /dev/sdb1  # write random data to /dev/sdb1
shred -u nothing.log # overwrite and remove nothing.log

# Named pipe
mkfifo testpipe # terminal 1
gzip -c < testpipe > out.gz # terminal 1
cat file > testpipe # terminal 2
