#
# Experiment 02
# Unification of CASE markers
#

cat mapped_ttb/concatenated.igs | sed '
s/Abl/CASE/g
s/Acc/CASE/g
s/Dat/CASE/g				
s/Gen/CASE/g
s/Ins/CASE/g
s/Loc/CASE/g
' > pruned.igs	
