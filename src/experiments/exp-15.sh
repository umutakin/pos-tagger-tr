#!/bin/bash

#################################################################################
#
# Experiment 15: Prune nodes lower than the average frequency of most frequent 
#					1000 nodes.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

# take data, extract pure tags and uniquely sort them.
# take 1000 most frequent tags from freq tree and take the average of them.
# use the avg of them and obtain the exp-15.sh from them.

cat $WORK_FOLDER/clean_tag_file.txt | sort | uniq > $WORK_FOLDER/unique_tags

python $SRC_FOLDER/tag_freqs.py $WORK_FOLDER

cat $WORK_FOLDER/pruned.tmp | sort -nr | uniq | sed -n 1,1000\p > $WORK_FOLDER/avg1000.tmp

avg=$(cat $WORK_FOLDER/avg1000.tmp | gawk 'BEGIN{s=0;c=0}{s+=$1;c+=1}END{print s/c}')

python $SRC_FOLDER/pruner_average.py "15" $WORK_FOLDER/avg_of1000.sh $WORK_FOLDER $avg

chmod 777 $WORK_FOLDER/avg_of1000.sh

cat $DATA_FILE | $WORK_FOLDER/avg_of1000.sh > $WORK_FOLDER/pruned.data

