# Tar, Gzip, Zip Notes

### Tar
```shell script
# Create a gzipped archive of Documents and all files in Documents...
# including their path and preserve the leading forward slash:
tar -cvPzf nothing.tar.gz /home/gpurcell/Documents/

tar -tf nothing.tar.gz  # List the contents of nothing.tar, -v for verbose
tar -xvPzf nothing.tar.gz  # Extract nothing.tar.gz to absolute path
```

### Gzip
```shell script
gzip nothing.log  # Compress to nothing.log.gz

# This method utilizes memory or swap space by initially writing to stdout:
gzip -9 -c drh.log > drh.log.1.gz

gzip -d nothing.log.gz  # Decompress to nothing.log
```

### Zip
```shell script
zip -r backup.zip dir1  # Create a zip file from directory dir1
unzip -l backup.zip  # List the contents of backup.zip, -v for verbose list

star -xattr -H=exustar -c -f=homebackup.star /home/  # Create archive of /home including SELinux attributes and ACLs
star -x -f=homebackup.star  # Extract homebackup.star
```

### md5sum
```shell script
md5sum company-mskr-ora.zip  # Compute md5 checksum
```
