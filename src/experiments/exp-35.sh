#################################################################################
#
# Experiment 35: Keep POS & last 3 morphemes.
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
		else
			printf "%s_%s_%s_%s_%s", $1, $2, $(i-3), $(i-2), $(i-1) > "pruned.data"
		
	}
	printf "\n" > "pruned.data";
}

'

