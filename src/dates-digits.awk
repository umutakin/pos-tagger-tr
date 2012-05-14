#################################################################################
#
# Replace dates and digits.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

BEGIN {
regexdate = "[-/.A-Za-z>0-9]*(ocak|aralık|şubat|mart|nisan|mayıs|haziran|temmuz|ağustos|eylül|ekim|kasım)+[-/.A-Za-z>0-9]*"
	regexnum = "[-A-Za-z>0-9]*[0-9]+[-A-Za-z>0-9]*"
	mode = 0
	FS = "_"
}
{
	if(mode == 0) {
		if(index($1,"--separator--") > 0) {
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
			printf "</S>\n" > "tag.temp.txt"
		}
		else if(index($1,"<S>") > 0) {
			printf "<S>\n" > "tag.temp.txt"
		}
		else {
			if(match($1,regexdate) && index($1,"Cumar") <= 0 && index($1,"cumar") <= 0 && index($1,"Çeki") <= 0 && index($1,"çeki") <= 0) {
				printf "DATE" > "tag.temp.txt"
			}
			else if(match($1,regexnum)) {
				printf "NUM-DIGIT" > "tag.temp.txt"
			}
			else {
				printf "%s" , $2 > "tag.temp.txt"
			}
			i = 3;
			while(length($i) > 0) {
				printf "_%s", $i > "tag.temp.txt"
				i++;
			}
			printf "\n" > "tag.temp.txt"
		}
	}
	
}
