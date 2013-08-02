#################################################################################
#
# Experiment 30: Prune all and only agreement.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

sed -e '
s/_A1sg//g
s/_A2sg//g
s/_A3sg//g
s/_A1pl//g
s/_A2pl//g
s/_A3pl//g
s/_P1sg//g
s/_P2sg//g
s/_P3sg//g
s/_P1pl//g
s/_P2pl//g
s/_P3pl//g
'
