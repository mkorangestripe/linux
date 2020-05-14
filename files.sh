# Search for strings in raw disk space:
strings /dev/sdb | less

# Overwrite files
badblocks -c 10240 -s -w -t random -v /dev/sdb1  # write random data to /dev/sdb1
shred -u nothing.log # overwrite and remove nothing.log

# Named pipe
mkfifo testpipe # terminal 1
gzip -c < testpipe > out.gz # terminal 1
cat file > testpipe # terminal 2
