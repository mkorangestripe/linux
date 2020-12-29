# Create a gzipped archive of Documents and all files in Documents...
# including their path and preserve the leading forward slash:
tar -cvPzf nothing.tar.gz /home/gpurcell/Documents/
tar -tf nothing.tar.gz  # list the contents of nothing.tar, -v for verbose
tar -xvPzf nothing.tar.gz  # extract nothing.tar.gz to absolute path

gzip nothing.log  # compress to nothing.log.gz
# This method utilizes memory or swap space by initially writing to stdout:
gzip -9 -c drh.log > drh.log.1.gz
gzip -d nothing.log.gz  # decompress to nothing.log

zip -r backup.zip dir1  # create a zip file from directory dir1
unzip -l backup.zip  # list the contents of backup.zip, -v for verbose list

star -xattr -H=exustar -c -f=homebackup.star /home/  # create archive of /home including SELinux attributes and ACLs
star -x -f=homebackup.star  # extract homebackup.star

md5sum company-mskr-ora.zip  # compute md5 checksum
