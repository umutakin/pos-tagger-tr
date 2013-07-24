#!/bin/bash

#########################################################################################
#
# Main script used to train a POS tagger.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#########################################################################################

#########################################################################################
# 1. Get ready for the training!
#########################################################################################

# 1.1. Validate command line arguments.
if [ $# -eq 0 ] || [ $# -eq 1 ]
	then
	echo "Error   : Missing parameters."
	echo "Usage   : ./train.sh <model-name> <gtp-fs-path>"
	echo "        : <model-name> is the name of an experiment in the reference paper."
	echo "        : <fs-path> is the path to the GTP file system."
	echo "        : e.g. './train.sh exp-02 /Users/skopru/xcode/fs-tren'"
	exit 1
fi

# 1.2. Initiate work environment.
source ./init.sh $1 $2

#########################################################################################
# 2. Start training the POS tagging model.
#########################################################################################

# parameter for N-fold cross-validation
N="10"

# initialize sum variables
sum_words="0"
sum_correct="0"
sum_errors="0"
sum_insertion="0"
sum_deletion="0"
sum_substitution="0"

########## Prepare files for frequency experiments i.e. exp11-16.
cat $DATA_FILE | $SRC_FOLDER/cutter.sh > $WORK_FOLDER/clean_tag_file.txt

# call pruner_average script with arguments as exp_number, exp_path, work_folder
# avg
python $SRC_FOLDER/pruner_average.py "11" $SRC_FOLDER/experiments/exp-11.sh $WORK_FOLDER

# avg/2
python $SRC_FOLDER/pruner_average.py "12" $SRC_FOLDER/experiments/exp-12.sh $WORK_FOLDER

# avg/4
python $SRC_FOLDER/pruner_average.py "13" $SRC_FOLDER/experiments/exp-13.sh $WORK_FOLDER

# 2*avg
python $SRC_FOLDER/pruner_average.py "14" $SRC_FOLDER/experiments/exp-14.sh $WORK_FOLDER

#avg < 1000
$SRC_FOLDER/counter.sh

##################################################################

# 'for' loop for 10-fold cross-validation 
k="1"
while [ $k -le $N ]
do
echo "Info    : Training started with k= " $k  " ."

# 2.1. Go to the workfolder.
cd $WORK_FOLDER



# 2.2. Prune training data according to the model name specified in the CL.
cat $DATA_FILE | $SRC_FOLDER/experiments/$1.sh > $WORK_FOLDER/pruned.data

# last line of all experiments i.e. s/.*_Punc/PUNC_PUNC/g. Since applied to all, its done here.
sed 's/.*_Punc/PUNC_PUNC/g' pruned.data > temp && mv temp pruned.data

# 2.3. Preprocess training data.
$SRC_FOLDER/preprocess.sh

# 2.4 Create the necessary files.
$SRC_FOLDER/create-files.sh $k

# 2.5 Create the model files.
$SRC_FOLDER/irstlm.sh 2> irstlm.log

# 2.6 Update the file system parameters.
$SRC_FOLDER/update-fs.sh $1

#########################################################################################
# 3. Test the model
#########################################################################################

echo "Info    : Testing started with k= " $k  " ."

cd $MODELS_FOLDER/$1
$SRC_FOLDER/test.sh pos.test 0.99 20 2> test.log

#echo "dev-test results:"
#./dev-pos.sh pos-dev.txt 0.99 20

sum_words=$[$sum_words + $(tail -n 3 wer.out | tr -cd " [:digit:] |[:digit:].[:digit:]" | gawk '{print $1}')]
sum_correct=$[$sum_correct + $(tail -n 3 wer.out | tr -cd " [:digit:] |[:digit:].[:digit:]" | gawk '{print $2}')]
sum_errors=$[$sum_errors + $(tail -n 3 wer.out | tr -cd " [:digit:] |[:digit:].[:digit:]" | gawk '{print $3}')]
sum_insertion=$[$sum_insertion + $(tail -n 3 wer.out | tr -cd " [:digit:] |[:digit:].[:digit:]" | gawk '{print $7}')]
sum_deletion=$[$sum_deletion + $(tail -n 3 wer.out | tr -cd " [:digit:] |[:digit:].[:digit:]" | gawk '{print $8}')]
sum_substitution=$[$sum_substitution + $(tail -n 3 wer.out | tr -cd " [:digit:] |[:digit:].[:digit:]" | gawk '{print $9}')]

#echo $sum_words
#echo $sum_correct
#echo $sum_errors
#echo $sum_insertion
#echo $sum_deletion
#echo $sum_substitution

k=$[$k+1]
done

perc_correct=$(echo $sum_correct*100/$sum_words | bc -l | cut -c 1-5)
perc_error=$(echo $sum_errors*100/$sum_words | bc -l | cut -c 1-5)
perc_acc=$(echo 100-$perc_error | bc -l)


echo "OVERALL # OF Words: " $sum_words " Corrects: " $sum_correct " Errors: " $sum_errors
echo "OVERALL # OF Insertions: " $sum_insertion " Deletions: " $sum_deletion " Substitutions: " $sum_substitution
echo "OVERALL % OF Correct= " $perc_correct "% Error= " $perc_error "% Accuracy= " $perc_acc "%"
