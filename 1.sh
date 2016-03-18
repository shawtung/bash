#!/bin/bash
# judge the validity of the two parameters
if [ $# != 2 ]; then
	echo "exactly two parameters required!"
	exit 0
fi

if [ "$1" == "" ]; then
	echo "keyword not valid!"
	exit 0
fi

if ! [ -d $2 ]; then
	echo "directory not valid!"
	exit 0
fi

# parameter1:keyword
# parameter2:directory
kw=$1
dir=$2

# set original directory and original directory flag
cur_dir=$dir
original_dir_flag=true

# list the sub-directories and files in the given directory,
# delete the blank rows, and then all colons.
# then for each row, set the flag to false if it's a new directory
# then make it the current directory if it's a directory
# or output the file name joined with the current directory
# if it's a file of which the name matches the keyword
file_list=`ls -R $dir | grep -v '^$' | sed 's/://'`
for file_name in $file_list
do
	temp_row=`echo $file_name`
	if [[ $temp_row =~ ./ ]] && $original_dir_flag; then
		original_dir_flag=false;
	fi

	if [ -d "$temp_row" ] && ! $original_dir_flag; then
		cur_dir=$temp_row
	else
		if [[ $temp_row =~ $kw ]]; then
			echo "$cur_dir/$temp_row :*$kw"
		fi
	fi
done
