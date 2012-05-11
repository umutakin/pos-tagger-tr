#!/bin/bash
#
# Main script used to train a POS tagger.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#

# Validate command line arguments.
if [ $# -eq 0 ]
	then
	echo "Usage   : ./train.sh <model-name>"
	echo "        : <model-name> can be a name of an experiment in the reference paper."
	echo "        : e.g. './train.sh ex-02'"
	exit 1
fi

# Validate model name.
if [ ! -e ./experiments/$1.sh ]
	then
	echo "Error   : "$1".sh script not found."
	exit 1
fi

# Set environment variables.
source ./env.sh

# Check GTP grammar rule files.
if [ -d $GTP_FS_PATH ]
	then
	for f in CLex CTrans TLex TTrans ULex UTrans Par Symbols NEL
	do
		if [ ! -e $GTP_FS_PATH/$GTP_FS_NAME$f.db ]
			then
			"Error   : Missing GTP grammar rule file:" $GTP_FS_PATH/$GTP_FS_NAME$f.db
			exit 1
		fi
	done	
	for f in 1 2 3
	do
		if [ ! -e $GTP_FS_PATH/__db.00$f ]
			then
			"Error   : Missing GTP grammar rule file:" $GTP_FS_PATH/__db.00$f
			exit 1
		fi
	done	
else
	echo "Error   : GTP file system " $GTP_FS_NAME "not found."
	exit 1
fi

# Delete previous model folder.
if [ -d $MODELS_FOLDER/$1 ]
	then
	echo "Warning : Model folder already exists: " $MODEL_FOLDER/$1
	echo "Do you want to delete the existing model folder? (y/n)"
	read response
	if [ "$response" == "y" ] || [ "$response" == "Y" ]
		then
		rm -rf $MODELS_FOLDER/$1
	else
		exit 1
	fi
fi

# Create the new model folder.
mkdir $MODELS_FOLDER/$1
mkdir $MODELS_FOLDER/$1/train
cd $MODELS_FOLDER/$1

# Link GTP grammar rule files.
for f in CLex CTrans TLex TTrans ULex UTrans Par Symbols NEL
do
	ln -s $GTP_FS_PATH/$GTP_FS_NAME$f.db
done

for f in 1 2 3
do
	ln -s $GTP_FS_PATH/__db.00$f
done

# 