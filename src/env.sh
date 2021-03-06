#!/bin/bash

#################################################################################
#
# Set environment variables.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

#################################################################################
# Environment variables used by the trainer.
#################################################################################
cd "$( dirname "${BASH_SOURCE[0]}" )"/..
export MAIN_FOLDER=`pwd`

export MODELS_FOLDER=$MAIN_FOLDER/models
export DATA_FOLDER=$MAIN_FOLDER/data
export SRC_FOLDER=$MAIN_FOLDER/src

export DATA_FILE=$DATA_FOLDER/tr-950K.data
export WORDS_FILE=$DATA_FOLDER/tr-950K.words

#################################################################################
# GTP variables
#################################################################################
export GTP_FS_PATH=$1
#export GTP_FS_PATH=/Users/skopru/xcode/fs-tren

export GTP_FS_NAME=tren
#GTPRUNNER_DIR=`which gtprunner`
GTPRUNNER_DIR=$1/gtprunner
if [ -z "$GTPRUNNER_DIR" ]
	then
	echo "Error   : GTP binaries not installed."
	exit 1
fi
export GTP_BIN_PATH=`dirname $GTPRUNNER_DIR`

#################################################################################
# Environment variables used by IRSTLM
#################################################################################
#NGT_DIR=`which ngt`
NGT_DIR="/usr/bin/local/bin/ngt"
if [ -z "$NGT_DIR" ]
	then
	echo "Error   : IRSTLM binaries not installed."
	exit 1
fi
export IRSTLM_BIN=`dirname $NGT_DIR`

export MACHTYPE=`uname -m`
export OSTYPE=`uname -s`

