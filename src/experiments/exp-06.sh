#################################################################################
#
# Experiment 06: Unification of 2nd and 3rd experiments i.e. CASE and POSS markers.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

sed -e 's/_Abl_/_CASE_/g' -e 's/_Abl$/_CASE/g' -e 's/_Acc/_CASE/g
s/_Dat/_CASE/g
s/_Gen/_CASE/g
s/_Ins/_CASE/g
s/_Loc/_CASE/g
s/_P1sg/_POSS/g
s/_P2sg/_POSS/g
s/_P3sg/_POSS/g
s/_P1pl/_POSS/g
s/_P2pl/_POSS/g
s/_P3pl/_POSS/g
' 
