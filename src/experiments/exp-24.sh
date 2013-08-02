#################################################################################
#
# Experiment 24: Keep prunning level as 5.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

awk '
BEGIN {
        FS = "_"
}
{
	printf "%s", $1 > "pruned.data"
	i = 2
        while(length($i) > 0 && i < 7) {
                printf "_%s", $i > "pruned.data"
		i++
        }        
	printf "\n" > "pruned.data"
}


'

