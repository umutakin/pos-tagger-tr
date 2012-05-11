#!/bin/bash
#
# Train POS tagger using a corpus.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#

# prepare training data

# apply pruning

echo "pruning started."

# read from $1 to prune, output to "pruned.igs"
./$1

echo "pruning finished."

# preprocess words
echo "preprocessing started."

# tokenize words file

# Remove ' symbol from words like Ahmet'i --> - remove ' if it is surrounded by its two sides by some chars.
sed "s/\([a-zA-ZığüşöçĞÜŞİÖÇ0-9]\)'\([a-zA-ZğüşöçıĞÜŞİÖÇ0-9]\)/\1\2/g" mapped_ttb/words > word.temp1.txt 

# lowercaser, tr didn't work with I->ı and İ->i convertings, that's why I have used sed expression for them.
cat  word.temp1.txt  |
tr 'Ğ' 'ğ' |
tr 'Ü' 'ü' |
sed "s/I/ı/g" |
tr 'Ö' 'ö' |
tr 'Ç' 'ç' |	
tr 'Ş' 'ş' |
sed "s/İ/i/g" |
tr '[:upper:]' '[:lower:]' > word.temp2.txt 

# append words and concatenated.ig files then apply preprocessing

# puncs
# see punc.list file, for list of PUNCs in the corpus. this list is derived from concatenated.igs file.

cat word.temp2.txt | sed ' 
			s/-lrb-/punc/g
			s/-rrb-/punc/g
			s/^\-$/punc/g
			s/?/punc/g
			s/!/punc/g
			s/:/punc/g
			s/;/punc/g
			s/,/punc/g
			s/^\...$/punc/g
			s/^\..$/punc/g
			s/^\.$/punc/g
			s/^`$/punc/g
			s/^\"$/punc/g' | sed "s/^'$/punc/g" | sed 's/_/-/g' > word.temp3.txt

cat pruned.igs | sed 's/.*_PUNC/PUNC_PUNC/g'  > pruned.igs.temp

cp word.temp3.txt word.temp2.txt
cp pruned.igs.temp pruned.igs

cat word.temp2.txt temp pruned.igs >> words.igs.temp

# convert dates and digits

gawk '
BEGIN {
	regexdate = "[-/.A-Za-z>0-9]*\(ocak\|aralık\|şubat\|mart\|nisan\|mayıs\|haziran\|temmuz\|ağustos\|eylül\|ekim\|kasım\)\+[-/.A-Za-z>0-9]*"
	regexnum = "[-A-Za-z>0-9]*[0-9]\+[-A-Za-z>0-9]*"
	mode = 0
	FS = "_"
}
{
	if(mode == 0) {
		if(index($1,"--seperator--") > 0) {
			mode = 1
		}
		else {
			if(index($1,"</s>") > 0) {
				printf "\n" > "word.txt"
				printf "</s>\n" > "word.temp.txt"
			}
			else if(index($1,"<s>") > 0) {
				printf "<s>\n" > "word.temp.txt"
			}
			else {
				if(match($1,regexdate) && index($1,"Cumar") <= 0 && index($1,"cumar") <= 0 && index($1,"Çeki") <= 0 && index($1,"çeki") <= 0) {
					printf "date" > "word.txt"	
					printf "date" > "word.temp.txt"
				}
				else if(match($1,regexnum)) {
					printf "num-digit" > "word.txt"
					printf "num-digit" > "word.temp.txt"
				}
				else {
					printf "%s" , $1 > "word.txt"	
					printf "%s" , $1 > "word.temp.txt"	
				}
				i = 2;
				while(length($i) > 0) {
					printf "_%s", $i > "word.txt"
					printf "_%s", $i > "word.temp.txt"
					i++;
				}
				printf " " > "word.txt"
				printf "\n" > "word.temp.txt"
			}
		}
	}
	else {
		if(index($1,"</S>") > 0) {
			#printf "\n" > "tag.txt"
			printf "</S>\n" > "tag.temp.txt"
		}
		else if(index($1,"<S>") > 0) {
			printf "<S>\n" > "tag.temp.txt"
		}
		else {
			if(match($1,regexdate) && index($1,"Cumar") <= 0 && index($1,"cumar") <= 0 && index($1,"Çeki") <= 0 && index($1,"çeki") <= 0) {
				#printf "DATE" > "tag.txt"	
				printf "DATE" > "tag.temp.txt"
			}
			else if(match($1,regexnum)) {
				#printf "NUM-DIGIT" > "tag.txt"
				printf "NUM-DIGIT" > "tag.temp.txt"
			}
			else {
				#printf "%s" , $2 > "tag.txt"
				printf "%s" , $2 > "tag.temp.txt"
			}
			i = 3;
			while(length($i) > 0) {
				#printf "_%s", $i > "tag.txt"
				printf "_%s", $i > "tag.temp.txt"
				i++;
			}
			#printf " " > "tag.txt"
			printf "\n" > "tag.temp.txt"
		}
	}
	
}
' words.igs.temp

paste word.temp.txt tag.temp.txt | tr '\t' '/' > word-tag.temp.txt

# to handle *UNKNOWN* cases for punc, date, and num-digit in yuret's data
python handle-unknown.py

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

echo "preprocessing finised."


# put every 50th sentence into the test file.
echo "create test and reference files."
if [ `uname -o` = Cygwin ]; then 
  sed -n '0~50p' word.txt | sed -f regex.train | $GTP/vs/bin/iconv -f UTF-8 -t UTF-16LE > $GTP/fs-tren/pos-test.txt
else
  sed -n '0~50p' word.txt | sed -f regex.train > $GTP/fs-tren/pos-test.txt
fi
sed -n '0~50p' tag.txt | sed -f regex.train > $GTP/fs-tren/pos-ref.txt

# delete the selected test sentences from the training data.
sed '0~50d' tag.txt > tag.train.temp.txt
sed '0~50d' word-tag.txt > word-tag.train.temp.txt
sed '0~50d' word.txt > word.train.temp.txt

# put every 50th sentence into the development file.
if [ `uname -o` = Cygwin ]; then 
  sed -n '0~50p' word.train.temp.txt | sed -f regex.train | $GTP/vs/bin/iconv -f UTF-8 -t UTF-16LE > $GTP/fs-tren/pos-dev.txt
else
  sed -n '0~50p' word.train.temp.txt | sed -f regex.train > $GTP/fs-tren/pos-dev.txt
fi
sed -n '0~50p' tag.train.temp.txt | sed -f regex.train > $GTP/fs-tren/pos-dev-ref.txt

# delete the selected development sentences from the training data.
sed '0~50d' tag.train.temp.txt > tag.train.txt
sed '0~50d' word-tag.train.temp.txt > word-tag.train.txt
sed '0~50d' word.train.temp.txt > word.train.txt

# apply regular expressions to normalize the data files
echo "normalize data files."
cat tag.train.txt | sed -f regex.tag > tag.pos
cat word-tag.train.txt | sed -f regex.word > key.pos
cat word.train.txt | sed -f regex.train > word.pos

echo "generate prefix and suffix training files."
awk '
{ for (i=1; i<NF; i++) {
    split($i, field, "/")
    worlen = length(field[1])
    if (worlen > 1 && field[1] != "<s>" && field[1] != "</s>" && field[2] != "NUM-DIGIT" && field[2] != "num-digit" && field[2] != "DATE" && field[2] != "PUNC" && field[2] != "punc") {
      printf "%s/%s\n", substr(field[1], worlen), field[2] > "suf1-wordtag.txt"
      printf "%s\n", substr(field[1], worlen) > "suf1-word.txt"
      printf "%s\n", field[2] > "ps1-tag.txt"
      printf "%s/%s\n", substr(field[1], 1, 1), field[2] > "pref1-wordtag.txt"
      printf "%s\n", substr(field[1], 1, 1) > "pref1-word.txt"
      if (worlen > 2) {
        printf "%s/%s\n", substr(field[1], worlen-1), field[2] > "suf2-wordtag.txt"
        printf "%s\n", substr(field[1], worlen-1) > "suf2-word.txt"
        printf "%s\n", field[2] > "ps2-tag.txt"
        printf "%s/%s\n", substr(field[1], 1, 2), field[2] > "pref2-wordtag.txt"
        printf "%s\n", substr(field[1], 1, 2) > "pref2-word.txt"
        if (worlen > 3) {
          printf "%s/%s\n", substr(field[1], worlen-2), field[2] > "suf3-wordtag.txt"
          printf "%s\n", substr(field[1], worlen-2) > "suf3-word.txt"
          printf "%s\n", field[2] > "ps3-tag.txt"
          printf "%s/%s\n", substr(field[1], 1, 3), field[2] > "pref3-wordtag.txt"
          printf "%s\n", substr(field[1], 1, 3) > "pref3-word.txt"
          if (worlen > 4) {
            printf "%s/%s\n", substr(field[1], worlen-3), field[2] > "suf4-wordtag.txt"
            printf "%s\n", substr(field[1], worlen-3) > "suf4-word.txt"
            printf "%s\n", field[2] > "ps4-tag.txt"
            printf "%s/%s\n", substr(field[1], 1, 4), field[2] > "pref4-wordtag.txt"
            printf "%s\n", substr(field[1], 1, 4) > "pref4-word.txt"
            if (worlen > 5) {
              printf "%s/%s\n", substr(field[1], worlen-4), field[2] > "suf5-wordtag.txt"
              printf "%s\n", substr(field[1], worlen-4) > "suf5-word.txt"
              printf "%s\n", field[2] > "ps5-tag.txt"
              printf "%s/%s\n", substr(field[1], 1, 5), field[2] > "pref5-wordtag.txt"
              printf "%s\n", substr(field[1], 1, 5) > "pref5-word.txt"
              if (worlen > 6) {
                printf "%s/%s\n", substr(field[1], worlen-5), field[2] > "suf6-wordtag.txt"
                printf "%s\n", substr(field[1], worlen-5) > "suf6-word.txt"
                printf "%s\n", field[2] > "ps6-tag.txt"
                printf "%s/%s\n", substr(field[1], 1, 6), field[2] > "pref6-wordtag.txt"
                printf "%s\n", substr(field[1], 1, 6) > "pref6-word.txt"
                if (worlen > 7) {
                  printf "%s/%s\n", substr(field[1], worlen-6), field[2] > "suf7-wordtag.txt"
                  printf "%s\n", substr(field[1], worlen-6) > "suf7-word.txt"
                  printf "%s\n", field[2] > "ps7-tag.txt"
                  printf "%s/%s\n", substr(field[1], 1, 7), field[2] > "pref7-wordtag.txt"
                  printf "%s\n", substr(field[1], 1, 7) > "pref7-word.txt"
                  if (worlen > 8) {
                    printf "%s/%s\n", substr(field[1], worlen-7), field[2] > "suf8-wordtag.txt"
                    printf "%s\n", substr(field[1], worlen-7) > "suf8-word.txt"
                    printf "%s\n", field[2] > "ps8-tag.txt"
                    printf "%s/%s\n", substr(field[1], 1, 8), field[2] > "pref8-wordtag.txt"
                    printf "%s\n", substr(field[1], 1, 8) > "pref8-word.txt"
                    if (worlen > 9) {
                      printf "%s/%s\n", substr(field[1], worlen-8), field[2] > "suf9-wordtag.txt"
                      printf "%s\n", substr(field[1], worlen-8) > "suf9-word.txt"
                      printf "%s\n", field[2] > "ps9-tag.txt"
                      printf "%s/%s\n", substr(field[1], 1, 9), field[2] > "pref9-wordtag.txt"
                      printf "%s\n", substr(field[1], 1, 9) > "pref9-word.txt"
                      if (worlen > 10) {
                        printf "%s/%s\n", substr(field[1], worlen-9), field[2] > "suf10-wordtag.txt"
                        printf "%s\n", substr(field[1], worlen-9) > "suf10-word.txt"
                        printf "%s\n", field[2] > "ps10-tag.txt"
                        printf "%s/%s\n", substr(field[1], 1, 10), field[2] > "pref10-wordtag.txt"
                        printf "%s\n", substr(field[1], 1, 10) > "pref10-word.txt"
                         if (worlen > 11) {
                           printf "%s/%s\n", substr(field[1], worlen-10), field[2] > "suf11-wordtag.txt"
                           printf "%s\n", substr(field[1], worlen-10) > "suf11-word.txt"
                           printf "%s\n", field[2] > "ps11-tag.txt"
                           printf "%s/%s\n", substr(field[1], 1, 11), field[2] > "pref11-wordtag.txt"
                           printf "%s\n", substr(field[1], 1, 11) > "pref11-word.txt"
				if (worlen > 12) {
		                   printf "%s/%s\n", substr(field[1], worlen-11), field[2] > "suf12-wordtag.txt"
		                   printf "%s\n", substr(field[1], worlen-11) > "suf12-word.txt"
		                   printf "%s\n", field[2] > "ps12-tag.txt"
		                   printf "%s/%s\n", substr(field[1], 1, 12), field[2] > "pref12-wordtag.txt"
		                   printf "%s\n", substr(field[1], 1, 12) > "pref12-word.txt"
					if (worlen > 13) {
				           printf "%s/%s\n", substr(field[1], worlen-12), field[2] > "suf13-wordtag.txt"
				           printf "%s\n", substr(field[1], worlen-12) > "suf13-word.txt"
				           printf "%s\n", field[2] > "ps13-tag.txt"
				           printf "%s/%s\n", substr(field[1], 1, 13), field[2] > "pref13-wordtag.txt"
				           printf "%s\n", substr(field[1], 1, 13) > "pref13-word.txt"
						if (worlen > 14) {
						   printf "%s/%s\n", substr(field[1], worlen-13), field[2] > "suf14-wordtag.txt"
						   printf "%s\n", substr(field[1], worlen-13) > "suf14-word.txt"
						   printf "%s\n", field[2] > "ps14-tag.txt"
						   printf "%s/%s\n", substr(field[1], 1, 14), field[2] > "pref14-wordtag.txt"
						   printf "%s\n", substr(field[1], 1, 14) > "pref14-word.txt"
							if (worlen > 15) {
							   printf "%s/%s\n", substr(field[1], worlen-14), field[2] > "suf15-wordtag.txt"
							   printf "%s\n", substr(field[1], worlen-14) > "suf15-word.txt"
							   printf "%s\n", field[2] > "ps15-tag.txt"
							   printf "%s/%s\n", substr(field[1], 1, 15), field[2] > "pref15-wordtag.txt"
							   printf "%s\n", substr(field[1], 1, 15) > "pref15-word.txt"	
								if (worlen > 16) {
								   printf "%s/%s\n", substr(field[1], worlen-15), field[2] > "suf16-wordtag.txt"
								   printf "%s\n", substr(field[1], worlen-15) > "suf16-word.txt"
								   printf "%s\n", field[2] > "ps16-tag.txt"
								   printf "%s/%s\n", substr(field[1], 1, 16), field[2] > "pref16-wordtag.txt"
								   printf "%s\n", substr(field[1], 1, 16) > "pref16-word.txt"
									if (worlen > 17) {
									   printf "%s/%s\n", substr(field[1], worlen-16), field[2] > "suf17-wordtag.txt"
									   printf "%s\n", substr(field[1], worlen-16) > "suf17-word.txt"
									   printf "%s\n", field[2] > "ps17-tag.txt"
									   printf "%s/%s\n", substr(field[1], 1, 17), field[2] > "pref17-wordtag.txt"
									   printf "%s\n", substr(field[1], 1, 17) > "pref17-word.txt"
										if (worlen > 18) {
										   printf "%s/%s\n", substr(field[1], worlen-17), field[2] > "suf18-wordtag.txt"
										   printf "%s\n", substr(field[1], worlen-17) > "suf18-word.txt"
										   printf "%s\n", field[2] > "ps18-tag.txt"
										   printf "%s/%s\n", substr(field[1], 1, 18), field[2] > "pref18-wordtag.txt"
										   printf "%s\n", substr(field[1], 1, 18) > "pref18-word.txt"
											if (worlen > 19) {
											   printf "%s/%s\n", substr(field[1], worlen-18), field[2] > "suf19-wordtag.txt"
											   printf "%s\n", substr(field[1], worlen-18) > "suf19-word.txt"
											   printf "%s\n", field[2] > "ps19-tag.txt"
											   printf "%s/%s\n", substr(field[1], 1, 19), field[2] > "pref19-wordtag.txt"
											   printf "%s\n", substr(field[1], 1, 19) > "pref19-word.txt"
												if (worlen > 20) {
												   printf "%s/%s\n", substr(field[1], worlen-19), field[2] > "suf20-wordtag.txt"
												   printf "%s\n", substr(field[1], worlen-19) > "suf20-word.txt"
												   printf "%s\n", field[2] > "ps20-tag.txt"
												   printf "%s/%s\n", substr(field[1], 1, 20), field[2] > "pref20-wordtag.txt"
												   printf "%s\n", substr(field[1], 1, 20) > "pref20-word.txt"
												 }
											 }
										 }
									 }
								 }
							 }
						 }
				         }  
		                 }                         
			}
		      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
' key.pos

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


echo "start training."
# create 1st order and 2nd order tag dictionary frequency files
dict -i=tag.pos -o=$GTP/fs-tren/tren.pos.tdic -f=y -sort=no
dict -i=tag2.pos -o=$GTP/fs-tren/tren.pos.t2dic -f=y -sort=no
dict -i=tag3.pos -o=$GTP/fs-tren/tren.pos.t3dic -f=y -sort=no

# build the pos-tag n-gram from the tag sequence
ngt -i=tag.pos -n=3 -gooout=y -o=3gram.pos -fd=../tren.pos.tdic
# use the below command instead of the above for improved Kneser-Ney smoothing
#ngt -i=tag.pos -n=3 -gooout=y -o=3gram.pos -fd=../tren.pos.tdic -iknstat=ikn.stat

# for each pos-tag n-gram level estimate an independent sub-lm
build-sublm.pl --size 3 --ngrams 3gram.pos --sublm pos.lm --witten-bell
# use the below command instead of the above for improved Kneser-Ney smoothing
#build-sublm.pl --size 3 --ngrams 3gram.pos --sublm pos.lm --improved-kneser-ney ikn.stat

# merge all sub-lm's
merge-sublm.pl --size 3 --sublm pos. -lm pos.lm.gz

# quantize lm
quantize-lm pos.lm.gz pos.qlm

# compile lm into a binary table
if [ `uname -o` = Cygwin ]; then
  # conversion to binary format doesn't work in IRSTLM; just copying the text form
  cp pos.qlm $GTP/fs-tren/tren.pos.ngram
else
  compile-lm pos.qlm $GTP/fs-tren/tren.pos.ngram
fi

# create 1st order and 2nd order word/pos-tag dictionary frequency files
dict -i=key.pos -o=$GTP/fs-tren/tren.pos.kdic -f=y -sort=no
dict -i=key2.pos -o=$GTP/fs-tren/tren.pos.k2dic -f=y -sort=no

# create word dictionary frequency file
dict -i=word.pos -o=$GTP/fs-tren/tren.pos.wdic -f=y -sort=no

# uncomment below part to get the OOV rate of the test file.
# build the word n-gram to calculate OOV for a test file
echo "building the word n-gram to calculate OOV."
ngt -i=word.pos -n=3 -gooout=y -o=3gram.word -fd=../tren.pos.wdic -iknstat=ikn.stat
build-sublm.pl --size 3 --ngrams 3gram.word --sublm word.lm --improved-kneser-ney ikn.stat
merge-sublm.pl --size 3 --sublm word. -lm word.lm.gz
quantize-lm word.lm.gz word.qlm
compile-lm word.qlm --eval ../pos-test.txt

# Generate suffix analysis files.
echo "building suffix dictionaries."
dict -i=suf1-wordtag.txt -o=$GTP/fs-tren/tren.suf1.kdic -f=y -sort=no
dict -i=suf1-word.txt -o=$GTP/fs-tren/tren.suf1.wdic -f=y -sort=no
dict -i=suf2-wordtag.txt -o=$GTP/fs-tren/tren.suf2.kdic -f=y -sort=no
dict -i=suf2-word.txt -o=$GTP/fs-tren/tren.suf2.wdic -f=y -sort=no
dict -i=suf3-wordtag.txt -o=$GTP/fs-tren/tren.suf3.kdic -f=y -sort=no
dict -i=suf3-word.txt -o=$GTP/fs-tren/tren.suf3.wdic -f=y -sort=no
dict -i=suf4-wordtag.txt -o=$GTP/fs-tren/tren.suf4.kdic -f=y -sort=no
dict -i=suf4-word.txt -o=$GTP/fs-tren/tren.suf4.wdic -f=y -sort=no
dict -i=suf5-wordtag.txt -o=$GTP/fs-tren/tren.suf5.kdic -f=y -sort=no
dict -i=suf5-word.txt -o=$GTP/fs-tren/tren.suf5.wdic -f=y -sort=no
dict -i=suf6-wordtag.txt -o=$GTP/fs-tren/tren.suf6.kdic -f=y -sort=no
dict -i=suf6-word.txt -o=$GTP/fs-tren/tren.suf6.wdic -f=y -sort=no
dict -i=suf7-wordtag.txt -o=$GTP/fs-tren/tren.suf7.kdic -f=y -sort=no
dict -i=suf7-word.txt -o=$GTP/fs-tren/tren.suf7.wdic -f=y -sort=no
dict -i=suf8-wordtag.txt -o=$GTP/fs-tren/tren.suf8.kdic -f=y -sort=no
dict -i=suf8-word.txt -o=$GTP/fs-tren/tren.suf8.wdic -f=y -sort=no
dict -i=suf9-wordtag.txt -o=$GTP/fs-tren/tren.suf9.kdic -f=y -sort=no
dict -i=suf9-word.txt -o=$GTP/fs-tren/tren.suf9.wdic -f=y -sort=no
dict -i=suf10-wordtag.txt -o=$GTP/fs-tren/tren.suf10.kdic -f=y -sort=no
dict -i=suf10-word.txt -o=$GTP/fs-tren/tren.suf10.wdic -f=y -sort=no
dict -i=suf11-wordtag.txt -o=$GTP/fs-tren/tren.suf11.kdic -f=y -sort=no
dict -i=suf11-word.txt -o=$GTP/fs-tren/tren.suf11.wdic -f=y -sort=no
dict -i=suf12-wordtag.txt -o=$GTP/fs-tren/tren.suf12.kdic -f=y -sort=no
dict -i=suf12-word.txt -o=$GTP/fs-tren/tren.suf12.wdic -f=y -sort=no
dict -i=suf13-wordtag.txt -o=$GTP/fs-tren/tren.suf13.kdic -f=y -sort=no
dict -i=suf13-word.txt -o=$GTP/fs-tren/tren.suf13.wdic -f=y -sort=no
dict -i=suf14-wordtag.txt -o=$GTP/fs-tren/tren.suf14.kdic -f=y -sort=no
dict -i=suf14-word.txt -o=$GTP/fs-tren/tren.suf14.wdic -f=y -sort=no
dict -i=suf15-wordtag.txt -o=$GTP/fs-tren/tren.suf15.kdic -f=y -sort=no
dict -i=suf15-word.txt -o=$GTP/fs-tren/tren.suf15.wdic -f=y -sort=no
dict -i=suf16-wordtag.txt -o=$GTP/fs-tren/tren.suf16.kdic -f=y -sort=no
dict -i=suf16-word.txt -o=$GTP/fs-tren/tren.suf16.wdic -f=y -sort=no
dict -i=suf17-wordtag.txt -o=$GTP/fs-tren/tren.suf17.kdic -f=y -sort=no
dict -i=suf17-word.txt -o=$GTP/fs-tren/tren.suf17.wdic -f=y -sort=no
dict -i=suf18-wordtag.txt -o=$GTP/fs-tren/tren.suf18.kdic -f=y -sort=no
dict -i=suf18-word.txt -o=$GTP/fs-tren/tren.suf18.wdic -f=y -sort=no
dict -i=suf19-wordtag.txt -o=$GTP/fs-tren/tren.suf19.kdic -f=y -sort=no
dict -i=suf19-word.txt -o=$GTP/fs-tren/tren.suf19.wdic -f=y -sort=no
dict -i=suf20-wordtag.txt -o=$GTP/fs-tren/tren.suf20.kdic -f=y -sort=no
dict -i=suf20-word.txt -o=$GTP/fs-tren/tren.suf20.wdic -f=y -sort=no

dict -i=pref1-wordtag.txt -o=$GTP/fs-tren/tren.pref1.kdic -f=y -sort=no
dict -i=pref1-word.txt -o=$GTP/fs-tren/tren.pref1.wdic -f=y -sort=no
dict -i=pref2-wordtag.txt -o=$GTP/fs-tren/tren.pref2.kdic -f=y -sort=no
dict -i=pref2-word.txt -o=$GTP/fs-tren/tren.pref2.wdic -f=y -sort=no
dict -i=pref3-wordtag.txt -o=$GTP/fs-tren/tren.pref3.kdic -f=y -sort=no
dict -i=pref3-word.txt -o=$GTP/fs-tren/tren.pref3.wdic -f=y -sort=no
dict -i=pref4-wordtag.txt -o=$GTP/fs-tren/tren.pref4.kdic -f=y -sort=no
dict -i=pref4-word.txt -o=$GTP/fs-tren/tren.pref4.wdic -f=y -sort=no
dict -i=pref5-wordtag.txt -o=$GTP/fs-tren/tren.pref5.kdic -f=y -sort=no
dict -i=pref5-word.txt -o=$GTP/fs-tren/tren.pref5.wdic -f=y -sort=no
dict -i=pref6-wordtag.txt -o=$GTP/fs-tren/tren.pref6.kdic -f=y -sort=no
dict -i=pref6-word.txt -o=$GTP/fs-tren/tren.pref6.wdic -f=y -sort=no
dict -i=pref7-wordtag.txt -o=$GTP/fs-tren/tren.pref7.kdic -f=y -sort=no
dict -i=pref7-word.txt -o=$GTP/fs-tren/tren.pref7.wdic -f=y -sort=no
dict -i=pref8-wordtag.txt -o=$GTP/fs-tren/tren.pref8.kdic -f=y -sort=no
dict -i=pref8-word.txt -o=$GTP/fs-tren/tren.pref8.wdic -f=y -sort=no
dict -i=pref9-wordtag.txt -o=$GTP/fs-tren/tren.pref9.kdic -f=y -sort=no
dict -i=pref9-word.txt -o=$GTP/fs-tren/tren.pref9.wdic -f=y -sort=no
dict -i=pref10-wordtag.txt -o=$GTP/fs-tren/tren.pref10.kdic -f=y -sort=no
dict -i=pref10-word.txt -o=$GTP/fs-tren/tren.pref10.wdic -f=y -sort=no
dict -i=pref11-wordtag.txt -o=$GTP/fs-tren/tren.pref11.kdic -f=y -sort=no
dict -i=pref11-word.txt -o=$GTP/fs-tren/tren.pref11.wdic -f=y -sort=no
dict -i=pref12-wordtag.txt -o=$GTP/fs-tren/tren.pref12.kdic -f=y -sort=no
dict -i=pref12-word.txt -o=$GTP/fs-tren/tren.pref12.wdic -f=y -sort=no
dict -i=pref13-wordtag.txt -o=$GTP/fs-tren/tren.pref13.kdic -f=y -sort=no
dict -i=pref13-word.txt -o=$GTP/fs-tren/tren.pref13.wdic -f=y -sort=no
dict -i=pref14-wordtag.txt -o=$GTP/fs-tren/tren.pref14.kdic -f=y -sort=no
dict -i=pref14-word.txt -o=$GTP/fs-tren/tren.pref14.wdic -f=y -sort=no
dict -i=pref15-wordtag.txt -o=$GTP/fs-tren/tren.pref15.kdic -f=y -sort=no
dict -i=pref15-word.txt -o=$GTP/fs-tren/tren.pref15.wdic -f=y -sort=no
dict -i=pref16-wordtag.txt -o=$GTP/fs-tren/tren.pref16.kdic -f=y -sort=no
dict -i=pref16-word.txt -o=$GTP/fs-tren/tren.pref16.wdic -f=y -sort=no
dict -i=pref17-wordtag.txt -o=$GTP/fs-tren/tren.pref17.kdic -f=y -sort=no
dict -i=pref17-word.txt -o=$GTP/fs-tren/tren.pref17.wdic -f=y -sort=no
dict -i=pref18-wordtag.txt -o=$GTP/fs-tren/tren.pref18.kdic -f=y -sort=no
dict -i=pref18-word.txt -o=$GTP/fs-tren/tren.pref18.wdic -f=y -sort=no
dict -i=pref19-wordtag.txt -o=$GTP/fs-tren/tren.pref19.kdic -f=y -sort=no
dict -i=pref19-word.txt -o=$GTP/fs-tren/tren.pref19.wdic -f=y -sort=no
dict -i=pref20-wordtag.txt -o=$GTP/fs-tren/tren.pref20.kdic -f=y -sort=no
dict -i=pref20-word.txt -o=$GTP/fs-tren/tren.pref20.wdic -f=y -sort=no

dict -i=ps1-tag.txt -o=$GTP/fs-tren/tren.pref1.tdic -f=y -sort=no
dict -i=ps2-tag.txt -o=$GTP/fs-tren/tren.pref2.tdic -f=y -sort=no
dict -i=ps3-tag.txt -o=$GTP/fs-tren/tren.pref3.tdic -f=y -sort=no
dict -i=ps4-tag.txt -o=$GTP/fs-tren/tren.pref4.tdic -f=y -sort=no
dict -i=ps5-tag.txt -o=$GTP/fs-tren/tren.pref5.tdic -f=y -sort=no
dict -i=ps6-tag.txt -o=$GTP/fs-tren/tren.pref6.tdic -f=y -sort=no
dict -i=ps7-tag.txt -o=$GTP/fs-tren/tren.pref7.tdic -f=y -sort=no
dict -i=ps8-tag.txt -o=$GTP/fs-tren/tren.pref8.tdic -f=y -sort=no
dict -i=ps9-tag.txt -o=$GTP/fs-tren/tren.pref9.tdic -f=y -sort=no
dict -i=ps10-tag.txt -o=$GTP/fs-tren/tren.pref10.tdic -f=y -sort=no
dict -i=ps11-tag.txt -o=$GTP/fs-tren/tren.pref11.tdic -f=y -sort=no
dict -i=ps12-tag.txt -o=$GTP/fs-tren/tren.pref12.tdic -f=y -sort=no
dict -i=ps13-tag.txt -o=$GTP/fs-tren/tren.pref13.tdic -f=y -sort=no
dict -i=ps14-tag.txt -o=$GTP/fs-tren/tren.pref14.tdic -f=y -sort=no
dict -i=ps15-tag.txt -o=$GTP/fs-tren/tren.pref15.tdic -f=y -sort=no
dict -i=ps16-tag.txt -o=$GTP/fs-tren/tren.pref16.tdic -f=y -sort=no
dict -i=ps17-tag.txt -o=$GTP/fs-tren/tren.pref17.tdic -f=y -sort=no
dict -i=ps18-tag.txt -o=$GTP/fs-tren/tren.pref18.tdic -f=y -sort=no
dict -i=ps19-tag.txt -o=$GTP/fs-tren/tren.pref19.tdic -f=y -sort=no
dict -i=ps20-tag.txt -o=$GTP/fs-tren/tren.pref20.tdic -f=y -sort=no

# Generate aX_POS-TAGS entry which has to be compiled into the FS before any pos tagging can be done.
# This entry is required to define the tag set used in training.
# Note: The first tag in the entry should be the default tag.
echo "Generating aX_POS-TAGS entry and compiling it into the FS."
awk '{print $2, $1}' $GTP/fs-tren/tren.pos.tdic | sort -rn > atb.taglist
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

cd $GTP/fs-tren

if [ `uname -o` = Cygwin ]
then ../vs/bin/iconv -f UTF-8 -t UTF-16LE ax-pos-tags.txt > ax-pos-tags-utf16.txt
  $GTP/vs/bin/gtpfs -c -f tren -i ax-pos-tags-utf16.txt
else
  /usr/local/bin/gtpfs -c -f tren -i ax-pos-tags.txt
fi

tagsize=`cat ax-pos-tags.txt | wc -l`
echo "tag size: ${tagsize}"  

echo "test results:"
./test-pos.sh pos-test.txt 0.99 20 
#echo ""
#echo "dev-test results:"
#./dev-pos.sh pos-dev.txt 0.99 20 


