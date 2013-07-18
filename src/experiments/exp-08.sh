#################################################################################
#
# Experiment 08: Unification of all markers
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
s/_Past/_TENSE/g
s/_Fut/_TENSE/g
s/_Narr/_TENSE/g
s/_Prog1/_TENSE/g
s/_Prog2/_TENSE/g
s/_Aor/_TENSE/g
s/_A1sg/_PERS/g
s/_A2sg/_PERS/g
s/_A3sg/_PERS/g
s/_A1pl/_PERS/g
s/_A2pl/_PERS/g
s/_A3pl/_PERS/g
'
