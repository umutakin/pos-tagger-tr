
# Clear the file from <S> , </S> , \n , \t and whitespace .
# Cut out the first word i.e. the base of the word .
# Obtain the pure tag file, pass it to frequency.tree .
# Use the output of frequency.tree i.e "tassels-1" 
#	to construct the sed command argument .
# Use the sed command to obtain the pruned data.

sed -e '/<S>/d ; /<\/S>/d' | tr -d ' ' | cut -d "_" -f 2-20
