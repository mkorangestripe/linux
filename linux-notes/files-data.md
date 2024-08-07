# Files, Data

#### Character encoding

```shell script
# Convert between hexadecimal and decimal:
printf "%x\n" 123   # 7b
printf "%d\n" 0x7b  # 123

echo 123 | hexdump     # 3231 0a33  (hex value of characters 123 - little-endian byte order)
echo ABC | hexdump     # 4241 0a43  (hexadecimal 2-byte units of characters ABC)
echo ABC | od -x       # 4241 0a43  (hexadecimal 2-byte units of characters ABC)
echo ABC | hexdump -C  # 41 42 43 0a  |ABC.|  (hex+ASCII of characters ABC)
echo ABC | od -a -b    # A   B   C  nl  (ASCII named characters of ABC, octal values on next line)
echo ABC | od -c       # A   B   C  \n  (ASCII characters or backslash escapes)

# encoding='ISO-8859-1' -- Latin 1, single byte encodeing, used for several nonprinting characters
```

#### Base64 encoding, Encryption
```shell script
# Base64 encode/decode:
echo "green, yellow, bright orange" | base64 > encoded.txt
base64 -d encoded.txt  # green, yellow, bright orange

# Encrypt/decrypt a password with a key:
echo "p@sswd123" > passwd.txt
echo "redgreenblue" | base64 > key.txt
openssl enc -base64 -aes256 -in passwd.txt -out passwd_encrypted.txt -kfile key.txt
openssl enc -base64 -aes256 -d -in passwd_encrypted.txt -kfile key.txt  # p@sswd123

fold -w76 colors3.txt  # wrap each line to be no more than 76 characters
```

#### Checksums, Directory compare

```shell script
# Compute MD5 (Message Digest 5) checksum on colors*.txt:
md5sum colors*.txt
md5 colors*.txt

# Compute SHA-256 (Secure Hash Algorithm) checksum on colors*.txt:
sha256sum colors*.txt
shasum -a 256 colors*.txt

# Compute MD5 checksum for all files in the directory.
# Because the individual checksums are sorted, filenames and paths do not affect the final checksum.
find src/ -type f -exec md5sum {} + | awk '{print $1}' | sort | md5sum
find src/ -type f -exec md5 {} + | awk '{print $4}' | sort | md5

# Compare directory contents, file and directory names and file contents:
diff -rq colorsA colorsB
```

#### Removing files and data

```shell script
# Instead of removing a log file that has grown to large, null it.
# This preserves the inode data and should free disk space if the file is being
# used by a process (open file descriptor).
cat /dev/null > file.log

# If the file is removed while a process is using the file, the file
# descriptor can be nulled to release disk space.
lsof | grep FILE  # 2nd column is PID, 4th column has FD followed by r,w,u, - read, write, both
cat /dev/null > /proc/PID/fd/FD

# When using rm -rf, try to add the -rf last.  This is to avoid removing parent directories 
# by accidentally pressing enter before the full path has been typed.
rm /var/logs/nada/ -rf

# Remove files with nonstandard filenames:
find . -inum 782263 -exec rm -i {} \;  # remove the file with inode number 782263, prompt before
find . -inum 782263 -print -delete     # remove the file with inode number 782263
rm \\                                  # remove a file named \

dd if=/dev/zero of=localhost_access_log.txt bs=1024 count=33000  # create a 33M file
badblocks -c 10240 -s -w -t random -v /dev/sdb1  # write random data to /dev/sdb1
shred -u nothing.log  # overwrite and remove nothing.log

strings /dev/sdb1 | less  # search for strings in raw disk space
```

#### File copy

```shell script
cp -d  # same as --no-dereference --preserve=links
cp -r  # --recursive, copy directories recursively
cp -p  # same as --preserve=mode,ownership,timestamps
cp -a  # --archive, same as -dr --preserve=all

cp -n  # --no-clobber, do not overwrite an existing file
cp -i  # --interactive, prompt before overwrite
cp -f  # --force, if dest file cannot be read, remove it, and try again

# Copy only when access or modify timestamp of source file is newer than destination:
cp -uv file1.txt src/file1.txt

# same as above, but recursive, this works on individual files:
cp -ruv dir1 src/

# Recursive & replicate pipes, copy symlinks, preserve file attributes,
# preserve extended attributes - on Solaris:
cp -RPp@ /nfs/pub/ .

# rsync unlike cp, copies only when the source and destination files differ.
rsync -av /nfs/pub/ .  # archive options and verbose, copy the contents of 'pub'
rsync -av /nfs/pub .   # archive options and verbose, copy the whole 'pub' directory
rsync -avn /nfs/pub .  # archive options and verbose, dry-run

rsync -v DSC_0002.MOV -e 'ssh -p 2222' --progress gp@tester1:  # use port 2222 and show progress
```

#### Archiving, Compression

```shell script
# Create a gzipped archive of Documents and all files in Documents
# including their path and preserve the leading forward slash:
tar -cvPzf nothing.tar.gz /home/gp/Documents/

tar -tf nothing.tar.gz     # list the contents of nothing.tar, -v for verbose
tar -xvPzf nothing.tar.gz  # extract nothing.tar.gz to absolute path

gzip nothing9                      # nothing9.gz
gzip -9 -c drh.log > drh.log.1.gz  # this utilizes memory or swap
bzip2 nothing9                     # nothing9.bz2
gzip or bzip2 -d nothing9          # decompress nothing9

# Create archive of /home including SELinux attributes and ACLs:
star -xattr -H=exustar -c -f=homebackup.star /home/

star -x -f=homebackup.star  # extract homebackup.star

zip -r backup.zip dir1  # create a zip file from directory dir1
unzip -l backup.zip     # list the contents of backup.zip, -v for verbose list
```

#### Named pipe

```shell script
mkfifo testpipe              # in terminal 1
gzip -c < testpipe > out.gz  # in terminal 1
cat file > testpipe          # in terminal 2
```
