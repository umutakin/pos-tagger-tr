#################################################################################
#
# Experiment 02: Unification of CASE markers
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

# if we change Abl tag by default, then it changes Able tag too.
# if we change Gen tag by default, we change words like 'Genelkurmay'.
# other tags are added _ to the beginning just in case of a similar bug.

sed -e 's/_Abl_/_CASE_/g' -e 's/_Abl$/_CASE/g' -e 's/_Acc/_CASE/g
s/_Dat/_CASE/g
s/_Gen/_CASE/g
s/_Ins/_CASE/g
s/_Loc/_CASE/g
'
