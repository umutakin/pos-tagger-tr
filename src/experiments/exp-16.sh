#################################################################################
#
# Experiment 16: Keep most frequent 800 tags in the data file.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

cat $WORK_FOLDER/clean_tag_file.txt | sort | uniq > $WORK_FOLDER/unique_tags

python $SRC_FOLDER/tag_freqs.py $WORK_FOLDER

cat $WORK_FOLDER/pruned.tmp | sort -nr | uniq | gawk '{print $2}' | sed -n 1,800\p > $WORK_FOLDER/most_freq800

python $SRC_FOLDER/most-freq-tags.py 800 $WORK_FOLDER $WORK_FOLDER/most_freq800.sed

chmod 777 $WORK_FOLDER/most_freq800.sed

find $DATA_FOLDER -name $(basename $DATA_FILE) | xargs sed -f $WORK_FOLDER/most_freq800.sed > $WORK_FOLDER/pruned.data
