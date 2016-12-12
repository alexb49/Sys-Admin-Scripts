#!/bin/bash

# Variables init.
seq=$1		# Max value of the loop interval.
block_size=$2	# Size of each block.
nb_block=$3 	# Number of blocks to create.
od_path=$4 	# Output directory path of lest files.

display_launching_permission(){
	echo "This script must be launched as root or support group member"
}

display_usage(){
	echo -e "\nUsage:\n$0 nb_element block_size nb_block output_dir\n"
	echo -e "\tnb_element = Number of files to create\n"
	echo -e "\tblock_size = Size of each block\n"
	echo -e "\tnb_block = Number of block to create for each file\n"
	echo -e "\tod_path = Output directory path for created files\n" 
}

# Looking for arguments number
if [ $# -le 3 ]
then
  display_usage
  exit 1
fi

# If right, display help
if [[ ( $# == "--help" ) || ( $# == "-h" ) ]]
then
  display_launching_permission
  display_usage
  exit 0
fi

# Test if script is launched with an authorized user
if [ $EUID -ne 0 ] && [ ! groups $USER | grep &>/dev/null 'support' ]
then
  display_launching_permission
  exit 1
fi

if [ ! -d "$od_path" ]
then
  echo "The directory $od_path doesn't exist"
  exit 1
fi

echo "Script starting"

for i in `seq 1 $seq`
do
  if [ $od_path -eq 0 ] ; then
    mkdir $dir
  fi
  dd if=/dev/zero of="$od_path/lest_$i" bs=$block_size count=$nb_block &>/dev/null
  echo "created file : $od_path/lest_$i"
done

echo "Script done"

exit 0