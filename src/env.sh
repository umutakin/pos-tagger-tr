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
export MAIN_FOLDER=/Users/skopru/repos/pos-tagger

export MODELS_FOLDER=$MAIN_FOLDER/models
export DATA_FOLDER=$MAIN_FOLDER/data
export SRC_FOLDER=$MAIN_FOLDER/src

export DATA_FILE=$DATA_FOLDER/tr-950K.data
export WORDS_FILE=$DATA_FOLDER/tr-950K.words

export GTP_FS_PATH=/Users/skopru/xcode/fs-tren
export GTP_FS_NAME=tren
export GTP_BIN_PATH=/Users/skopru/xcode/Build/Products/Debug

#################################################################################
# Environment variables used by IRSTLM
#################################################################################
export IRSTLM_BIN=/Users/skopru/packages/irstlm-5.60.02/bin
export MACHTYPE=`uname -m`
export OSTYPE=`uname -s`

