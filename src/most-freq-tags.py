#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import sys

#########################################################################################
#
# Prepares sed commands for frequency experiments.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#########################################################################################

search_file = open(str(sys.argv[2]) + "/most_freq"+ str(sys.argv[1]),"r").read().strip().split('\n')
clean_tag_file = open(str(sys.argv[2]) + "/clean_tag_file.txt", "r").read().strip().split('\n')
new_file = open(str(sys.argv[3]),"w")

new_file.write("sed -e '")
for l1 in clean_tag_file:
	tempTag = l1
	found = "0"
	for i in range(8):
		for l2 in search_file:
			if l1 == l2:
				#print "found : " + l1
				found = "1"
		if (found == "0"):
			#print "not found so trim l1: " + l1
			l1 = l1[:l1.rfind("_")]
			#print "to l1: " + l1
		if (found == "1") and (tempTag != l1):
			#print "sub found so sed for tempTag: " + tempTag + " and l1: " + l1
			new_file.write("s/" + tempTag + "/" + l1 + "/\n")
			found = "0"
			break




new_file.write("'")
