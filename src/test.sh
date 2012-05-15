#!/bin/bash

#################################################################################
#
# Tag the test file and measure WER.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

# Generate the POS sequence.
cat $1 |
$GTP_BIN_PATH/gtprunner -s --suffix-weight=$2 --max-affix=$3 --lambda-1=0.254157 --lambda-2=0.745843 2> gtp.err |
sed "s/[-_]//g" > pos.out

# Calculate word error rates and display the scores.
perl $SRC_FOLDER/word_error.pl pos.ref pos.out > wer.out
tail -n 3 wer.out

# Perform error analysis.
# python pos-error-analyze.py | sort | uniq -c | sort -nr
