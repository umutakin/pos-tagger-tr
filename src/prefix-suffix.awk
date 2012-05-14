#################################################################################
#
# Generate prefix and suffix training files.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

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
