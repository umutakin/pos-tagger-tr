#!/bin/bash

#################################################################################
#
# Create n-gram files using IRSTLM.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

# 1. Create 1st order and 2nd order tag dictionary frequency files
$IRSTLM_BIN/dict -i=tag.pos -o=../tren.pos.tdic -f=y -sort=no
$IRSTLM_BIN/dict -i=tag2.pos -o=../tren.pos.t2dic -f=y -sort=no
$IRSTLM_BIN/dict -i=tag3.pos -o=../tren.pos.t3dic -f=y -sort=no

# 2. Build the pos-tag n-gram from the tag sequence
$IRSTLM_BIN/ngt -i=tag.pos -n=3 -gooout=y -o=3gram.pos -fd=../tren.pos.tdic

# Use the below command instead of the above for improved Kneser-Ney smoothing
# $IRSTLM_BIN/ngt -i=tag.pos -n=3 -gooout=y -o=3gram.pos -fd=../tren.pos.tdic -iknstat=ikn.stat

# 3. For each pos-tag n-gram level estimate an independent sub-lm
$IRSTLM_BIN/build-sublm.pl --size 3 --ngrams 3gram.pos --sublm pos.lm --witten-bell

# Use the below command instead of the above for improved Kneser-Ney smoothing
# $IRSTLM_BIN/build-sublm.pl --size 3 --ngrams 3gram.pos --sublm pos.lm --improved-kneser-ney ikn.stat

# 4. Merge all sub-lm's
$IRSTLM_BIN/merge-sublm.pl --size 3 --sublm pos. -lm pos.lm.gz

# 5. Quantize lm
$IRSTLM_BIN/quantize-lm pos.lm.gz pos.qlm

# 6. Compile lm into a binary table
$IRSTLM_BIN/compile-lm pos.qlm ../tren.pos.ngram

# 7. Create 1st order and 2nd order word/pos-tag dictionary frequency files
$IRSTLM_BIN/dict -i=key.pos -o=../tren.pos.kdic -f=y -sort=no
$IRSTLM_BIN/dict -i=key2.pos -o=../tren.pos.k2dic -f=y -sort=no

# 8. create word dictionary frequency file
$IRSTLM_BIN/dict -i=word.pos -o=../tren.pos.wdic -f=y -sort=no

# 9. Build the word n-gram to calculate OOV for a test file. Can be omitted if OOV is not  
$IRSTLM_BIN/ngt -i=word.pos -n=3 -gooout=y -o=3gram.word -fd=../tren.pos.wdic -iknstat=ikn.stat
$IRSTLM_BIN/build-sublm.pl --size 3 --ngrams 3gram.word --sublm word.lm --improved-kneser-ney ikn.stat
$IRSTLM_BIN/merge-sublm.pl --size 3 --sublm word. -lm word.lm.gz
$IRSTLM_BIN/quantize-lm word.lm.gz word.qlm
$IRSTLM_BIN/compile-lm word.qlm --eval ../pos-test.txt

# 10. Generate suffix analysis files.
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
	$IRSTLM_BIN/dict -i=suf$i-wordtag.txt -o=../tren.suf$i.kdic -f=y -sort=no
	$IRSTLM_BIN/dict -i=suf$i-word.txt -o=../tren.suf$i.wdic -f=y -sort=no
	$IRSTLM_BIN/dict -i=pref$i-wordtag.txt -o=../tren.pref$i.kdic -f=y -sort=no
	$IRSTLM_BIN/dict -i=pref$i-word.txt -o=../tren.pref$i.wdic -f=y -sort=no
	$IRSTLM_BIN/dict -i=ps$i-tag.txt -o=../tren.pref$i.tdic -f=y -sort=no
done
