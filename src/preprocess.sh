#!/bin/bash

#################################################################################
#
# Preprocess POS training data.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

# Perform various preprocessing: lowercase, translate punctuations, etc.
cat $WORDS_FILE |
$SRC_FOLDER/lowercase-tr.sh | 
sed "s/\([a-zığüşöç0-9]\)'\([a-zğüşöçı0-9]\)/\1\2/g" | 
sed -f $SRC_FOLDER/regex.punc | 
sed "s/^'$/punc/g" |
sed 's/_/-/g' > $WORK_FOLDER/words.temp

# Normalize dates and digits 
echo "--separator--" | cat words.temp - pruned.data | gawk -f $SRC_FOLDER/dates-digits.awk 

# Create temporary key file
paste word.temp.txt tag.temp.txt | tr '\t' '/' > $WORK_FOLDER/word-tag.temp

# Handle *UNKNOWN* tokens for punc, date, and num-digit in yuret's data
python $SRC_FOLDER/handle-unknown.py

# Join tokens so that each line contains one sentence
cat tag.temp2.txt | gawk '{
	if(index($1,"</S>") > 0) 
		printf "\n" > "tag.txt"
	else if(index($1, "<S>") <= 0)
		printf "%s ", $1 > "tag.txt"
}'

cat word-tag.temp2.txt | gawk '{
	if(index($1,"</s>") > 0) 
		printf "\n" > "word-tag.txt"
	else if(index($1, "<s>") <= 0)
		printf "%s ", $1 > "word-tag.txt"
}'
