#################################################################################
#
# Experiment 13: Prune nodes lower than average/4 frequency.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

python $SRC_FOLDER/pruner_average.py "13" $WORK_FOLDER/avg_div4.sh $WORK_FOLDER

chmod 777 $WORK_FOLDER/avg_div4.sh

cat $DATA_FILE | $WORK_FOLDER/avg_div4.sh > $WORK_FOLDER/pruned.data
