#!/bin/bash

#################################################################################
#
# Train POS tagger using a corpus.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

# put every 50th sentence into the test file.
echo "create test and reference files."
sed -n '0~50p' word.txt | sed -f $SRC_FOLDER/regex.train > pos-test.txt
sed -n '0~50p' tag.txt | sed -f $SRC_FOLDER/regex.train > pos-ref.txt

# delete the selected test sentences from the training data.
sed '0~50d' tag.txt > tag.train.temp.txt
sed '0~50d' word-tag.txt > word-tag.train.temp.txt
sed '0~50d' word.txt > word.train.temp.txt

# put every 50th sentence into the development file.
sed -n '0~50p' word.train.temp.txt | sed -f $SRC_FOLDER/regex.train > pos-dev.txt
sed -n '0~50p' tag.train.temp.txt | sed -f $SRC_FOLDER/regex.train > pos-dev-ref.txt

# delete the selected development sentences from the training data.
sed '0~50d' tag.train.temp.txt > tag.train.txt
sed '0~50d' word-tag.train.temp.txt > word-tag.train.txt
sed '0~50d' word.train.temp.txt > word.train.txt

# apply regular expressions to normalize the data files
echo "normalize data files."
cat tag.train.txt | sed -f $SRC_FOLDER/regex.tag > tag.pos
cat word-tag.train.txt | sed -f $SRC_FOLDER/regex.word > key.pos
cat word.train.txt | sed -f $SRC_FOLDER/regex.train > word.pos

echo "generate prefix and suffix training files."
cat key.pos | gawk -f prefix-suffix.awk

# create second order word-tag file
sed 's/<\/s>/_eof_/g' key.pos | awk '
{
  line++
  split($1, wt, "/")
  prevt = wt[2]
  for (i = 2; i <= NF; i++) {
    printf "%s/%s\n", $i, prevt > "key2-prime.pos"
    split($i, wt, "/")
    printf "%s/%s\n", wt[2], prevt > "tag2-prime.pos"
    if (wt[2] == "") {
      print line, i
    }
    if (i > 2) {
      printf "%s/%s/%s\n", wt[2], prevt, prevprevt > "tag3-prime.pos"
    }
    prevprevt = prevt
    prevt = wt[2]
  }
}
'

sed 's/_eof_/<\/s>/g' key2-prime.pos > key2.pos
sed 's/_eof_/<\/s>/g' tag2-prime.pos > tag2.pos
sed 's/_eof_/<\/s>/g' tag3-prime.pos > tag3.pos
rm key2-prime.pos
rm tag2-prime.pos
rm tag3-prime.pos





