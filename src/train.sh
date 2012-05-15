#!/bin/bash

#########################################################################################
#
# Main script used to train a POS tagger.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#########################################################################################

#########################################################################################
# 1. Get ready for the training!
#########################################################################################

# 1.1. Validate command line arguments.
if [ $# -eq 0 ]
	then
	echo "Usage   : ./train.sh <model-name>"
	echo "        : <model-name> can be a name of an experiment in the reference paper."
	echo "        : e.g. './train.sh ex-02'"
	exit 1
fi

# 1.2. Initiate work environment.
source ./init.sh $1

#########################################################################################
# 2. Start training the POS tagging model.
#########################################################################################

# 2.1. Go to the workfolder.
cd $WORK_FOLDER

# 2.2. Prune training data according to the model name specified in the CL.
cat $DATA_FILE | $SRC_FOLDER/experiments/$1.sh > $WORK_FOLDER/pruned.data

# 2.3. Preprocess training data.
$SRC_FOLDER/preprocess.sh

# 2.4 Create the necessary files.
$SRC_FOLDER/create-files.sh

# 2.5 Create the model files.
$SRC_FOLDER/irstlm.sh 2> irstlm.log

# 2.6 Update the file system parameters.
$SRC_FOLDER/update-fs.sh $1

#########################################################################################
# 3. Test the model
#########################################################################################

cd $MODELS_FOLDER/$1
$SRC_FOLDER/test.sh pos.test 0.99 20 2> test.log

#echo "dev-test results:"
#./dev-pos.sh pos-dev.txt 0.99 20 
