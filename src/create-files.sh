#!/bin/bash

#################################################################################
#
# Train POS tagger using a corpus.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

# put every 50th sentence into the test file.
sed -n '0~50p' word.txt | sed -f $SRC_FOLDER/regex.train > ../pos.test
sed -n '0~50p' tag.txt | sed -f $SRC_FOLDER/regex.train | sed "s/[-_]//g" > ../pos.ref

# delete the selected test sentences from the training data and
# apply regular expressions to normalize the data files.
sed '0~50d' tag.txt | sed -f $SRC_FOLDER/regex.tag > tag.pos
sed '0~50d' word-tag.txt | sed -f $SRC_FOLDER/regex.word > key.pos
sed '0~50d' word.txt | sed -f $SRC_FOLDER/regex.train > word.pos

# generate prefix and suffix training files.
cat key.pos | gawk -f $SRC_FOLDER/prefix-suffix.awk

# create second order word-tag file
cat key.pos |
sed 's/<\/s>/_eof_/g' |
gawk '{
  line++
  split($1, wt, "/")
  prevt = wt[2]
  for (i = 2; i <= NF; i++) {
    printf "%s/%s\n", $i, prevt > "key2-prime.pos"
    split($i, wt, "/")
    printf "%s/%s\n", wt[2], prevt > "tag2-prime.pos"
#    if (wt[2] == "") { print line, i }
    if (i > 2) { printf "%s/%s/%s\n", wt[2], prevt, prevprevt > "tag3-prime.pos" }
    prevprevt = prevt
    prevt = wt[2]
  }
}'

sed 's/_eof_/<\/s>/g' key2-prime.pos > key2.pos
sed 's/_eof_/<\/s>/g' tag2-prime.pos > tag2.pos
sed 's/_eof_/<\/s>/g' tag3-prime.pos > tag3.pos

# remove intermediate files.
rm key2-prime.pos
rm tag2-prime.pos
rm tag3-prime.pos
