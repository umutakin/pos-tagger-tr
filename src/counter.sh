#!/bin/bash

# take data, extract pure tags and uniquely sort them.
# take 1000 most frequent tags from freq tree and take the average of them.
# use the avg of them and obtain the exp-15.sh from them.

cat $DATA_FILE | $SRC_FOLDER/cutter.sh | sort | uniq > $WORK_FOLDER/avg1000.tmp

python $SRC_FOLDER/tag_freqs.py $WORK_FOLDER

cat $WORK_FOLDER/pruned.tmp | sort -nr | uniq | sed -n 1,1000\p > $WORK_FOLDER/avg1000.tmp

avg=$(cat $WORK_FOLDER/avg1000.tmp | gawk 'BEGIN{s=0;c=0}{s+=$1;c+=1}END{print s/c}')

python $SRC_FOLDER/pruner_average.py "15" $SRC_FOLDER/experiments/exp-15.sh $WORK_FOLDER $avg

