#!/bin/bash
echo "local result:"
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


kw=$1
dir=$2


cur_dir=$dir
original_dir_flag=true


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
			echo "local:$cur_dir/$temp_row :*$kw"
		fi
	fi
done


echo "remote result:"
ssh username@remotehost << EOF
if ! [ -d $2 ]; then
	echo "directory not valid!"
	exit 0
fi


kw=$1
dir=$2


cur_dir=$dir
original_dir_flag=true


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
			echo "local:$cur_dir/$temp_row :*$kw"
		fi
	fi
done

exit
EOF




