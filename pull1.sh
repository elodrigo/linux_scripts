#!/bin/sh

now=$(date +%Y.%m.%d)
nowb=$(date +%Y-%m-%d)
filedate=$(stat -c '%y' working_list.txt | cut -d ' ' -f1)

dev_base=$MY_HOME/
project_name=project_name
media_base=./files_to_push/

my_path=$(dirname $(dirname $(dirname $(readlink -f "$0"))))


sudo mount -o rw,remount $my_path


# usb permission check
if [ ! -w ./working_list.txt ]
then
	echo 'permission error: remount usb by yourself.'
	echo 'sudo su -> mount -o rw,remount ./'
	echo 'or move to media directory to run program.'
	exit
else
	echo -e 'start pushing...\n'
fi

# working_list.txt modified date check
cat working_list.txt
if [ $nowb != $filedate ] ; then
	echo 'file was modified on ' $filedate
	echo -n 'Do you still want to proceed? yes or no : '
	read weanswer
		if [ $weanswer = 'yes' ] || [ $weanswer = 'y' ] 
		then
			echo 'proceed....'
		else
			echo 'terminating program....'
			echo 'bye'
			exit
		fi
else
	echo -e 'working list modified date checked... ok\n'
fi		


# create push directory with date
if [ ! -d $media_base$now ]
then
	media_base=$media_base$now/$project_name/
	sudo mkdir -p $media_base
else
	echo 'directory exists, creating new...'
	pattern=$now
	counts=$(find $backup_base -maxdepth 2 -type d | grep $pattern | wc -l)
	if [ $counts -ge 1 ]
	then 
		media_base=$media_base$pattern\($counts\)/$project_name/
	else
		echo 'Could not make directory. Backup might not be done correctly.'
		echo 'Terminating program...' 
		echo 'bye'
		exit
	fi
	
fi


cat working_list.txt
echo -n 'Are the list correct? yes or no : '
read youranswer

if [ $youranswer = 'yes' -o $youranswer = 'y' ]
then
	# pull files from the list
	while read p
	do
		if [ -w $dev_base$p ]
		then
			mkdir -p $media_base${p%/*} && cp $dev_base$p $media_base$p
		else
			echo $p 'does not exist or cannot be written.'
		fi
	done <working_list.txt
else
	echo 'terminating program.....'
fi
