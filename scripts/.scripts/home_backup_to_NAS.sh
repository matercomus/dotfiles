sudo rsync -aAXm --no-specials --no-xattrs --info=progress2 --delete --delete-excluded --bwlimit=5000 --log-file=/mnt/TrueNAS/envy/rsync.log --files-from=$HOME/.rsync_include.txt $HOME /mnt/TrueNAS/envy/BACKUP/home

