#################################################################################
#
# Experiment 37: Keep POS & last 5 morphemes.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

awk '
BEGIN {
        FS = "_"
}
{
	i = 1;	
	while(length($i) > 0)
		i++;
	if(i == 2)
		printf "%s" , $1 > "pruned.data"
	else {
		if(i == 3)
			printf "%s_%s", $1, $2 > "pruned.data"	
		else if(i == 4)
			printf "%s_%s_%s", $1, $2, $3 > "pruned.data"
		else if(i == 5)
                        printf "%s_%s_%s_%s", $1, $2, $3, $4 > "pruned.data"
		else if(i == 6)
                        printf "%s_%s_%s_%s_%s", $1, $2, $3, $4, $5 > "pruned.data"
		else if(i == 7)
                        printf "%s_%s_%s_%s_%s_%s", $1, $2, $3, $4, $5, $6 > "pruned.data"
		else
			printf "%s_%s_%s_%s_%s_%s_%s", $1, $2, $(i-5), $(i-4), $(i-3), $(i-2), $(i-1) > "pruned.data"
		
	}
	printf "\n" > "pruned.data";
}

'

