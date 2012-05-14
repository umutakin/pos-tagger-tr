#!/bin/bash

#################################################################################
#
# Generate tX_POS-TAGS entry which has to be compiled into the FS before any POS
# tagging can be performed. This entry is required to define the tag set used in
# training. Important: The first tag in the entry should be the default tag.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

echo "Generating aX_POS-TAGS entry and compiling it into the FS."
awk '{print $2, $1}' ../tren.pos.tdic | sort -rn > atb.taglist
awk '
BEGIN {
  skip = "DICTIONARY"
  printf "tX_POS-TAGS ::\n\t[\n" > "../ax-pos-tags.txt"
  row = 1
}
{
  if ($2 != skip) {
    if ($2 == "PX" || $2 == "NUM" || $2 == "<s>" || $2 == "</s>" || $2 == "D") 
      printf "\t%d { \"%s\", 0, \"N\" }\n", row, $2 > "../ax-pos-tags.txt"
    else
      printf "\t%d { \"%s\", 1, \"N\" }\n", row, $2 > "../ax-pos-tags.txt"
    row++
  }
}
END {
  printf "\t]\n" > "../ax-pos-tags.txt"
}' atb.taglist

cd $MODELS_FOLDER/$1

$GTP_BIN_PATH/gtpfs -c -f tren -i ax-pos-tags.txt

tagsize=`cat ax-pos-tags.txt | wc -l`
echo "tag size: ${tagsize}"  