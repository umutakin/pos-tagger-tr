#################################################################################
#
# Experiment 19: Keep most frequent 2000 tags in the data file.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

cat $WORK_FOLDER/clean_tag_file.txt | sort | uniq > $WORK_FOLDER/unique_tags

python $SRC_FOLDER/tag_freqs.py $WORK_FOLDER

cat $WORK_FOLDER/pruned.tmp | sort -nr | uniq | gawk '{print $2}' | sed -n 1,2000\p > $WORK_FOLDER/most_freq2000

python $SRC_FOLDER/most-freq-tags.py 2000 $WORK_FOLDER $WORK_FOLDER/most_freq2000.sh

chmod 777 $WORK_FOLDER/most_freq2000.sh

cat $DATA_FILE | $WORK_FOLDER/most_freq2000.sh > $WORK_FOLDER/pruned.data

