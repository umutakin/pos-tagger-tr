#################################################################################
#
# Experiment 07: Unification of 4th and 5th experiments i.e. TENSE and PERS markers.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

sed '
s/_Past/_TENSE/g
s/_Narr/_TENSE/g
s/_Fut/_TENSE/g
s/_Aor/_TENSE/g
s/_Prog1/_TENSE/g
s/_Prog2/_TENSE/g
s/_A1sg/_PERS/g
s/_A2sg/_PERS/g
s/_A3sg/_PERS/g
s/_A1pl/_PERS/g
s/_A2pl/_PERS/g
s/_A3pl/_PERS/g
' 
