#!/bin/bash

#################################################################################
#
# Prepare the work environment for the training.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

#################################################################################
# Validate model name.
#################################################################################
if [ ! -e ./experiments/$1.sh ]
	then
	echo "Error   : "$1".sh script not found."
	exit 1
fi

#################################################################################
# Set environment variables.
#################################################################################
source ./env.sh $2

#################################################################################
# Check if the main folder path is set correctly.
#################################################################################
if [ ! -d $MODELS_FOLDER ] || [ ! -d $DATA_FOLDER ] || [ ! -d $SRC_FOLDER ]
	then
	echo "Error   : Main folder not set correctly."
	echo "        : Obtain a recent version from the github repository."
	exit 1
fi

#################################################################################
# Check GTP grammar rule files.
#################################################################################
if [ -d $GTP_FS_PATH ]
	then
	for f in CLex CTrans TLex TTrans ULex UTrans Par Symbols NEL
	do
		if [ ! -e $GTP_FS_PATH/$GTP_FS_NAME$f.db ]
			then
			echo "Error   : Missing GTP grammar rule file:" $GTP_FS_PATH/$GTP_FS_NAME$f.db
			exit 1
		fi
	done	
	for f in 1 2 3 4
	do
		if [ ! -e $GTP_FS_PATH/__db.00$f ]
			then
			echo "Error   : Missing GTP grammar rule file:" $GTP_FS_PATH/__db.00$f
			exit 1
		fi
	done	
else
	echo "Error   : GTP file system " $GTP_FS_NAME "not found."
	exit 1
fi

#################################################################################
# Delete previous model folder if it exists.
#################################################################################
if [ -d $MODELS_FOLDER/$1 ]
	then
	echo "Warning : Model folder already exists: " $MODELS_FOLDER/$1
	echo "Warning : Do you want to delete the existing model folder? (y/n)"
	read response
	if [ "$response" == "y" ] || [ "$response" == "Y" ]
		then
		rm -rf $MODELS_FOLDER/$1
	else
		exit 1
	fi
fi

#################################################################################
# Create the new model folder.
#################################################################################
mkdir $MODELS_FOLDER/$1
mkdir $MODELS_FOLDER/$1/train

export WORK_FOLDER=$MODELS_FOLDER/$1/train

#################################################################################
# Link GTP grammar rule files.
#################################################################################
cd $MODELS_FOLDER/$1

for f in CLex CTrans TLex TTrans ULex UTrans Par Symbols NEL
do
	ln -s $GTP_FS_PATH/$GTP_FS_NAME$f.db
done

ln -s $GTP_FS_PATH/SI"$GTP_FS_NAME"Symbols.db

for f in 1 2 3 4
do
	ln -s $GTP_FS_PATH/__db.00$f
done
