#################################################################################
#
# Experiment 12: Prune nodes lower than average/2 frequency.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

python $SRC_FOLDER/pruner_average.py "12" $WORK_FOLDER/avg_div2.sh $WORK_FOLDER

chmod 777 $WORK_FOLDER/avg_div2.sh

cat $DATA_FILE | $WORK_FOLDER/avg_div2.sh > $WORK_FOLDER/pruned.data
