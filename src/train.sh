#!/bin/bash
#
# Main script used to train a POS tagger.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#

#################################################################################
# 1. Getting ready for the training.
#################################################################################

# 1.1. Validate command line arguments.
if [ $# -eq 0 ]
	then
	echo "Usage   : ./train.sh <model-name>"
	echo "        : <model-name> can be a name of an experiment in the reference paper."
	echo "        : e.g. './train.sh ex-02'"
	exit 1
fi

# 1.2. Initiate work environment.
./init.sh $1

#################################################################################
# 2. Begin training the POS tagging model.
#################################################################################

# 2.1. Prune data according to the model name specified in the command line.
source ./experiments/$1.sh

