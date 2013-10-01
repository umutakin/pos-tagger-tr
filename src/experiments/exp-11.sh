#################################################################################
#
# Experiment 11: Prune nodes lower than average frequency.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

python $SRC_FOLDER/pruner_average.py "11" $WORK_FOLDER/avg.sh $WORK_FOLDER

chmod 777 $WORK_FOLDER/avg.sh

sed -i '/s\/\.\*\/\/g/d' $WORK_FOLDER/avg.sh

cat $DATA_FILE | $WORK_FOLDER/avg.sh > $WORK_FOLDER/pruned.data
