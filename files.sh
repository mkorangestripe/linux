# Copy files
cp -a # --archive, same as -dr --preserve=all
cp -d # same as --no-dereference --preserve=links
cp -r # --recursive, copy directories recursively
cp -p # same as --preserve=mode,ownership,timestamps

# recursive & replicate pipes, copy symlinks, preserve file attributes, preserve extended attributes, on Solaris
cp -RPp@ /nfs/pub/ .

# rsync unlike cp copies only when the source and destination files differ.
rsync -av /nfs/pub/ . # archive options and verbose, copy the contents of 'pub'
rsync -av /nfs/pub . # archive options and verbose, copy the whole 'pub' directory
rsync -avn /nfs/pub . # archive options and verbose, dry-run
rsync -v DSC_0002.MOV -e 'ssh -p 2222' --progress gp@tester1: # use port 2222 and show progress


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
