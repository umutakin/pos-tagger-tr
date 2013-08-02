#################################################################################
#
# Experiment 31: Prune last 2 morphemes.
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
		printf "%s_%s", $1, $2 > "pruned.data"	
		j = 3;
		while(j < i-2) {
			printf "_%s",$j > "pruned.data";
			j++;
		}
	}
	printf "\n" > "pruned.data";
}

'

