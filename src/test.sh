#!/bin/bash

#################################################################################
#
# Pos tag test files and measure WER.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

gtprunner -s -i $1 --suffix-weight=$2 --max-affix=$3 --lambda-1=0.254157 --lambda-2=0.745843 2> /dev/null | sed "s/[-_]//g" > pos-out.txt
cat pos-ref.txt | sed "s/[-_]//g" > pos-ref2.txt 
perl word_error.pl pos-ref2.txt pos-out.txt > wer.out 
python pos-error-analyze.py | sort | uniq -c | sort -nr
tail -n 3 wer.out
