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

cd $MODELS_FOLDER/$1

cat tren.pos.tdic |
gawk '{print $2, $1}' |
sort -rn |
gawk 'BEGIN {
  skip = "DICTIONARY"
  printf "tX_POS-TAGS ::\n\t[\n"
  row = 1
}
{
  if ($2 != skip) {
    if ($2 == "PX" || $2 == "NUM" || $2 == "<s>" || $2 == "</s>" || $2 == "D") 
      printf "\t%d { \"%s\", 0, \"N\" }\n", row, $2
    else
      printf "\t%d { \"%s\", 1, \"N\" }\n", row, $2
    row++
  }
}
END {
  printf "\t]\n"
}' |
$GTP_BIN_PATH/gtpfs -c
