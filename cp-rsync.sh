# Copy files
cp -a  # --archive, same as -dr --preserve=all
cp -d  # same as --no-dereference --preserve=links
cp -r  # --recursive, copy directories recursively
cp -p  # same as --preserve=mode,ownership,timestamps

# recursive & replicate pipes, copy symlinks, preserve file attributes, preserve extended attributes, on Solaris
cp -RPp@ /nfs/pub/ .

# rsync unlike cp copies only when the source and destination files differ.
rsync -av /nfs/pub/ .  # archive options and verbose, copy the contents of 'pub'
rsync -av /nfs/pub .  # archive options and verbose, copy the whole 'pub' directory
rsync -avn /nfs/pub .  # archive options and verbose, dry-run
rsync -v DSC_0002.MOV -e 'ssh -p 2222' --progress gp@tester1:  # use port 2222 and show progress
