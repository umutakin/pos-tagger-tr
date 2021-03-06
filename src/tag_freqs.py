#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import sys

#########################################################################################
#
# Constructs frequency tree and creates sed commands for prunning.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
########################################################################################


# takes a pure tag file and prepares the file that has counts of tags in data file.
search_file = open(str(sys.argv[1]) + "/unique_tags","r").read().strip().split('\n')
clean_tag_file = open(str(sys.argv[1]) + "/clean_tag_file.txt", "r").read().strip().split('\n')
new_file = open(str(sys.argv[1]) + "/pruned.tmp","w")

for l1 in search_file:
	mc = 0
	for l2 in clean_tag_file:
		if l1 == l2:
			mc=mc+1
	new_file.write(str(mc) + " " + l1 + "\n")

