#################################################################################
#
# Experiment 29: Prune final morpheme if agreement.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

sed -e '
s/_A1sg$//
s/_A2sg$//
s/_A3sg$//
s/_A1pl$//
s/_A2pl$//
s/_A3pl$//
s/_P1sg$//
s/_P2sg$//
s/_P3sg$//
s/_P1pl$//
s/_P2pl$//
s/_P3pl$//
'
