#!/bin/bash

#################################################################################
#
# Preprocess POS training data.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

cat $WORDS_FILE |
$SRC_FOLDER/lowercase-tr.sh | 
sed "s/\([a-zığüşöç0-9]\)'\([a-zğüşöçı0-9]\)/\1\2/g" | 
sed ' 
s/-lrb-/punc/g
s/-rrb-/punc/g
s/^\-$/punc/g
s/?/punc/g
s/[!:;,]/punc/g
s/^\...$/punc/g
s/^\..$/punc/g
s/^\.$/punc/g
s/^`$/punc/g
s/^\"$/punc/g' | 
sed "s/^'$/punc/g" |
sed 's/_/-/g' > $WORK_FOLDER/words.temp

echo "------separator------\n" > temp

cat words.temp temp pruned.data | gawk -f $SRC_FOLDER/dates-digits.awk 

paste word.temp.txt tag.temp.txt | tr '\t' '/' > $WORK_FOLDER/word-tag.temp

# to handle *UNKNOWN* cases for punc, date, and num-digit in yuret's data
python $SRC_FOLDER/handle-unknown.py

awk '
BEGIN {  }
{
	if(index($1,"</S>") > 0) 
		printf "\n" > "tag.txt"
	else if(index($1, "<S>") <= 0)
		printf "%s ", $1 > "tag.txt"
}
' tag.temp2.txt

awk '
BEGIN {  }
{
	if(index($1,"</s>") > 0) 
		printf "\n" > "word-tag.txt"
	else if(index($1, "<s>") <= 0)
		printf "%s ", $1 > "word-tag.txt"
}
' word-tag.temp2.txt
