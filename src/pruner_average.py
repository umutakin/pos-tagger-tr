from copy import deepcopy
import os
import sys

class Node(object):
    def __init__(self, morph,freq,level):
        self.morph = morph
        self.freq = freq
        self.level = level
        self.children = []
        self.used = 0

    def add_child(self, obj):
        self.children.append(obj)

root = Node("root",1,0)

infile = open(str(sys.argv[3]) + "/clean_tag_file.txt", "r")
allTagList = []
for line in infile:
	s = line.strip()
	fields = s.split("_")
	allTagList.append(fields)


infile.close()
outfile = open(str(sys.argv[3] + "/frequency_tree"), "w")

def fill_node(level):
	for i in range(len(allTagList)):
		currTag = allTagList[i]
		currNode = root
		#print currTag
		shortTag = False
		for j in range(level):
			if(j >= len(currTag)):
				shortTag = True
				break
			currMorph = currTag[j]
			#print currMorph
			found = False
			for n in currNode.children:
				if(n.morph == currMorph):
					currNode = n
					found = True
					#print "middle node is found"
					break
			if(not found):
				newNode = Node(currMorph,0,j)
				#print "not found middle node"
				currNode.add_child(newNode)
				currNode = currNode.children[len(currNode.children)-1]


		if shortTag == True or len(currTag) <= level:
			continue
		found = False
		for j in range(len(currNode.children)):
			if(currNode.children[j].morph == currTag[level]):
				found = True
				break
		if(found):
			currNode.children[j].freq += 1 # for this line we do same thing as above again in a separate code block.

		else:
			newNode = Node(currTag[level],1,level+1)
			currNode.add_child(newNode)
			ind = len(currNode.children)-1

	return


def print_dfs(currNode,level):
	for i in range(level):
		outfile.write("\t")
	outfile.write(currNode.morph)
	outfile.write(", ")
	outfile.write(str(currNode.freq))
	outfile.write("\n")
	for i in range(len(currNode.children)):
		level += 1
		print_dfs(currNode.children[i],level)
		level -= 1
	return


def add_leaves_freq(node):
    res = 0;
    for n in node.children:
        res += n.freq
    return res


def extract_leaves(node):
    if len(node.children) == 0:
        return
    for n in node.children:
        totalLeavesFreq = add_leaves_freq(n)
        if totalLeavesFreq < n.freq and totalLeavesFreq != 0 :
            newNode = Node(n.morph,n.freq-totalLeavesFreq,n.level)
            node.children.insert(node.children.index(n)+1,newNode)
	    n.freq = totalLeavesFreq
        extract_leaves(n)


print "filling levels..."
for i in range(8):
    print "filling level ",
    print i
    fill_node(i)
    print "finished."
print "finised filling levels."

print "started to extract hidden leaves."

extract_leaves(root)

print "finished to extract hidden leaves."

print "started to write the tree into a file."

# print the three in a depth first manner.
print_dfs(root,0)

print "writing is completed."
outfile.close()

# outputs sed expression to unify node, and its ith child and all of the children of its ith child.
outfile3 = open(str(sys.argv[3] + "/tassels"),"w")
def unify_with_parent(path,node,i,th):
	isThereAnother = 0
	for j in range(len(node.children)) :
		if i != j and node.children[j].morph == node.children[i].morph and node.children[j].freq >= th:
			isThereAnother = 1
	if isThereAnother == 0:
		if node.morph != "root":  # do not remove the pos-tags
			outfile3.write("s/" + path + node.morph + "_" + node.children[i].morph + ".*/" + path + node.morph + "/g\n")
		else:
			outfile3.write("s/" + path + node.morph + "_" + node.children[i].morph + ".*/" + path + node.morph + "_" + node.children[i].morph + "/g\n")
	node.children[i].used = 1

# get rid of tassels
def remove_tassels(path,node,th):
	if len(node.children) == 0 :
		return
	for i in range(len(node.children)):
		if node.children[i].used == 0 and node.children[i].freq < th:
			unify_with_parent(path,node,i,th)

	path += node.morph + "_"
	for i in range(len(node.children)):
		if node.children[i].used == 0 :
			remove_tassels(path,node.children[i],th) # TODO th giderek azaltilabilir.


print "calculate average freq."
count = 0
total = 0
def traverse(root):
	global count
	count += 1
	for n in root.children:
		traverse(n)

traverse(root)
for n in root.children:
	total += n.freq

print total
print "avg:",  total/count


print "started to write tassels using average frequency."
temproot = deepcopy(root)

if str(sys.argv[1]) == "11":
	remove_tassels("",temproot,total/count)
	print "11-----------------------------------------------"
elif str(sys.argv[1]) == "12":
	remove_tassels("",temproot,(total/count)/2)
	print "12-----------------------------------------------"
elif str(sys.argv[1]) == "13":
	remove_tassels("",temproot,(total/count)/4)
	print "13-----------------------------------------------"
elif str(sys.argv[1]) == "14":
	remove_tassels("",temproot,2*(total/count))
	print "14-----------------------------------------------"
elif str(sys.argv[1]) == "15":
	remove_tassels("",temproot,int(float(str(sys.argv[4]))))
	print "15-----------------------------------------------"
outfile3.close()

# turn output into usable sed expressions
os.system("cat $WORK_FOLDER/tassels | sed 's/root_//g' | sed 's/_\//\//g' | sort | uniq > $WORK_FOLDER/sed_commands")
outfileExp = open(str(sys.argv[2]), "w")
fin = open(str(sys.argv[3] + "/sed_commands"), "r")
data1 = fin.read();
fin.close()
outfileExp.write("sed -e '" + data1 + "'")

print "finished."

outfile4 = open(str(sys.argv[3] + "/sub-tree.clusters"),"w")
def get_most_freq_children(node,th):
	maxcs = []
	for n in node.children:
		if n.freq > th:
			maxcs.append(n)
	return maxcs

def paths(root,newroot,th):	
	maxcs = get_most_freq_children(root,th)	
	for c in maxcs:
		newNode = Node(c.morph,c.freq,c.level)
		newroot.children.append(newNode)
	for i in range(len(maxcs)):
		paths(maxcs[i],newroot.children[i],th)			
	

def print_dfs2(currNode,path,level):	
	if len(currNode.children) == 0:
		outfile4.write(path + currNode.morph + "\n")
	path += currNode.morph + "_"			
	for i in range(len(currNode.children)):				
		print_dfs2(currNode.children[i],path,level)		
	return
	

def print_dfs3(currNode,level):
	for i in range(level):
		outfile4.write("\t")
	outfile4.write(currNode.morph)
	outfile4.write(", ")
	outfile4.write(str(currNode.freq))
	outfile4.write("\n")
	for i in range(len(currNode.children)):
		level += 1
		print_dfs3(currNode.children[i],level)
		level -= 1
	return

print "started to extract co-occurences."
temproot2 = deepcopy(root)
newroot = Node("root",1,0)
#paths(temproot2,newroot,total/count)
if str(sys.argv[1]) == "11":
	paths(temproot2,newroot,total/count)
	print "1-----------------------------------------------"
elif str(sys.argv[1]) == "12":
	paths(temproot2,newroot,(total/count)/2)
	print "2-----------------------------------------------"
elif str(sys.argv[1]) == "13":
	paths(temproot2,newroot,(total/count)/4)
	print "3-----------------------------------------------"
elif str(sys.argv[1]) == "14":
	paths(temproot2,newroot,2*(total/count))
	print "4-----------------------------------------------"
elif str(sys.argv[1]) == "15":
	paths(temproot2,newroot,int(float(str(sys.argv[4]))))
	print "15-----------------------------------------------"
#print_dfs2(newroot,"",0)
print_dfs3(newroot,0)

outfile4.close()

#os.system("cat sub-tree.clusters | sed 's/root_//g' | sort | uniq > sub-tree.clusters-1")
print "finished."

print "\ndone!\n"

'''

def get_most_freq_child(tree,morph,maxchild):
	maxn = maxchild
	for n in tree.children:
		if n.morph == morph:			
			for c in n.children:				
				if c.freq > maxn.freq :
					maxn = c				
	for n in tree.children:
		maxn = get_most_freq_child(n,morph,maxn)
	
	return maxn
				

outfile4 = open("clusters","w")
def paths(tree,node,th,path):
	newpath = path	
	most_freq_child = get_most_freq_child(tree,node.morph,Node("xxx",th,-1))
	#print node.morph, most_freq_child.morph
	if most_freq_child.morph == "xxx":		
		outfile4.write(path + "\n")
		return
	elif most_freq_child.morph == node.morph:
		outfile4.write(node.morph + "_" + most_freq_child.morph + "\n")
		return
	else:
		newpath += "_" + most_freq_child.morph
		paths(node,most_freq_child,th,newpath)

# print leaves of each ADJ, ADV etc..


outfile2 = open("leaves","w")
def print_leaves(node):
    if len(node.children) == 0:
        outfile2.write(node.morph)
        outfile2.write(" ")
        outfile2.write(str(node.freq))
        outfile2.write(" ")
        outfile2.write(str(node.level))
        outfile2.write("\n")
    else:
        for n in node.children:
            print_leaves(n)

print "leaves are being printed."

print_leaves(root)
outfile2.close();
print "leaves are printed."


# print each node with its most freq children
outfile3 = open("most-freq-children","w")
def print_most_freq_childrenl1(node):
    if len(node.children) == 0:
        return
    else:
        outfile3.write(node.morph)
        outfile3.write(" ")
        max = node.children[0].freq
        morph = node.children[0].morph
        for i in range(len(node.children)):
            for j in range(len(node.children)):
                if i != j and node.children[i].morph == node.children[j].morph and node.children[i].freq != -1 and node.children[j].freq != -1:
                    #print node.morph, node.children[i].morph, node.children[i].freq, node.children[j].morph, node.children[j].freq
                    node.children[i].freq += node.children[j].freq
                    node.children[j].freq = -1
        for n in node.children:
            if max < n.freq:
                max = n.freq
                morph = n.morph
        outfile3.write(morph)
        outfile3.write(" ")
        outfile3.write(str(max))
        outfile3.write("\n")
        for n in node.children:
            print_most_freq_children(n)

def print_most_freq_childrenl2(node,level):
    if len(node.children) == 0:
        return
    elif level == 2:
        for i in range(len(node.children)):
            for j in range(len(node.children)):
                if i != j and node.children[i].morph == node.children[j].morph and node.children[i].used != 1 and node.children[j].used != 1:
                    #print node.morph, node.children[i].morph, node.children[i].freq, node.children[j].morph, node.children[j].freq
                    node.children[i].freq += node.children[j].freq
                    node.children[j].used = 1
        for n in node.children:
            n.used = 0

        maxnode = node.children[0]
        max = node.children[0].freq
        morph = node.children[0].morph
        for n in node.children:
            if max < n.freq:
                max = n.freq
                morph = n.morph
                maxnode = n
        outfile3.write(morph)
        outfile3.write(" ")
        #outfile3.write(str(max))
        return
    else:
        outfile3.write(node.morph)
        outfile3.write(" ")
        for i in range(len(node.children)):
            for j in range(len(node.children)):
                if i != j and node.children[i].morph == node.children[j].morph and node.children[i].freq != -1 and node.children[j].freq != -1:
                    #print node.morph, node.children[i].morph, node.children[i].freq, node.children[j].morph, node.children[j].freq
                    node.children[i].freq += node.children[j].freq
                    node.children[j].freq = -1
        maxnode = node.children[0]
        max = node.children[0].freq
        morph = node.children[0].morph
        for n in node.children:
            if max < n.freq:
                max = n.freq
                morph = n.morph
                maxnode = n
        outfile3.write(morph)
        outfile3.write(" ")
        #outfile3.write(str(max))
        #outfile3.write(" ")
        print_most_freq_childrenl2(maxnode,level+1)
        outfile3.write("\n")
        for n in node.children:
            print_most_freq_childrenl2(n,1)


print "start to print most frequent children level1."

temproot1 = deepcopy(root)
print_most_freq_childrenl1(temproot1)
outfile3.close();
print "finished."


print "start to print most frequent children level2."

temproot2 = deepcopy(root)
print_most_freq_childrenl2(temproot2,1)
outfile3.close();
print "finished."
'''


