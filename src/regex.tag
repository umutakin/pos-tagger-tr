
# add BOS and EOS markers 
s/^/<s> /
s/$/ <\/s>/

# normalize different kinds of quotes
s/''/\"/g
s/``/\"/g
