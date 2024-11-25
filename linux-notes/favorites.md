# Favorites

### Find which files are growing

This will find files that are growing or shrinking. The sleep time here is 2 minutes but may need to be longer. check1.txt and check2.txt may need to be on a filesystem other than the one filling up.

```shell script
find . -type f -exec du {} \; > /tmp/check1.txt
sleep 2m
find . -type f -exec du {} \; > /tmp/check2.txt
diff /tmp/check1.txt /tmp/check2.txt
```

### Checking a directory for file modifications

Find whether the content of any files in a directory have been modified. This is done here by computing an md5 checksum for each file in the directory and it's subdirectories. The filenames are filtered out with awk and the checksums are sorted and a combined checksum is generated. This way, whether the files are moved or renamed, the combined checksum will be the same. This method is more thorough then relying on mtime which can be adjusted or changes in file size which do not necessarily reflect changes in file content.

```shell script
find src/ -type f -exec md5sum {} + | awk '{print $1}' | sort | md5sum
```

![combined_checksum](../readme_images/combined_checksum.png)

Here's the example above broken down. This shows that newfile.txt has changed. To see all modified files, redirect the second find command to a separate text file and then run diff on the two.

![separate_checksums](../readme_images/separate_checksums.png)

For more like this, see [Checksums, Directory compare](files-data.md#checksums-directory-compare)

### Find when an annual calendar repeats

This happens when the day of the month and day of the week are the same in multiple annual calendars. This one's just for fun.

```shell script
calr() {
    YEAR_ARG=$1
    echo "The annual calendar repeats as shown below."
    echo "Non-leap year calendar cycle: 6,11,11 years"
    echo "Leap year calendar cycle:     28 years (6+11+11)"; echo

    for YEAR in {1970..2070}; do
        diff -q <(cal -y $YEAR_ARG | tail -34) <(cal $YEAR | tail -34) > /dev/null && echo $YEAR
    done
}
```

![calr_output](../readme_images/calr_output.png)
