#!/bin/sh

now=$(date +%Y.%m.%d)
nowb=$(date +%Y-%m-%d)
filedate=$(stat -c '%y' working_list.txt | cut -d ' ' -f1)

server_base=/home/elnews/elnews2/
project_name=project_name
backup_base=./backup_files/
media_base=./files_to_push/

my_path=$(dirname $(dirname $(dirname $(readlink -f "$0"))))

sudo mount -o rw,remount $my_path

# usb permission check
if [ ! -w ./working_list.txt ]
then
	echo 'permission error: remount usb by yourself.'
	echo 'sudo su -> mount -o rw,remount ./'
	echo 'or move to media directory to run\n'
	exit
else
	echo 'start pushing...\n'
fi


# working_list.txt modified date check
cat working_list.txt
if [ $nowb != $filedate ] ; then
	echo 'file was modified on ' $filedate
	echo -n 'Do you still want to proceed? yes or no : '
	read ouranswer
		if [ $ouranswer = 'yes' ] || [ $ouranswer = 'y' ] 
		then
			echo 'proceed....'
		else
			echo 'terminating program....'
			echo 'bye'
			exit
		fi
else
	echo 'working list modified date checked... ok\n'
fi		


# create backup directory with date
if [ ! -d $backup_base$now/ ]
then
	backup_base=$backup_base$now/$project_name/
	sudo mkdir $backup_base
else
	echo 'directory exists, creating new...\n'
	pattern=$now
	counts=$(find $backup_base -maxdepth 2 -type d | grep $pattern | wc -l)
	if [ $counts -ge 1 ]
	then 
		backup_base=$backup_base$pattern\($counts\)/$project_name/
		sudo mkdir $backup_base
	else
		echo 'Could not make directory. Backup might not be done correctly.'
		echo 'Terminating program...' 
		echo 'bye'
		exit
	fi
fi

	
# pull server's original file to usb in backup_files folder
while read p
do
	if [ -w $server_base$p ]
	then
		sudo mkdir -p $backup_base${p%/*} && cp $server_base$p $backup_base$p 
	else
		echo $p 'in server does not exist. Maybe it is not required to backup'				
	fi
done <working_list.txt



# find directory and show in tree
dir_now=$(find ./files_to_push -maxdepth 1 -type d -name "$now*" | sort -nr | head -1)
tree $dir_now/$project_name


echo -n 'Is it ok to push final data to server? ok or no : '
read myanswer


if [ $myanswer = 'ok' ]
then
	media_base=$dir_now/$project_name/
	# push final data to server
	while read p
	do
		if [ -e $media_base$p ]
		then
			mkdir -p $server_base${p%/*} && cp $media_base$p $server_base$p
		else
			echo $p 'does not exist or permission denied'
		fi
	done <working_list.txt
else
	echo 'You have stopped doing final data push.'
	echo 'Check if original server files are correctly pulled in backup_files folder,'
	echo 'or just make backup of whole project directory in server'
fi

cat memo.txt
	





