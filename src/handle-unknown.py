#!/usr/bin/python
# coding=utf-8

#################################################################################
#
# Handle unknown tags.
#
# Copyright (c) 2012 Teknoloji Yazılımevi. All rights reserved.
#
#################################################################################

word_tag = open("word-tag.temp","r").read().strip().split('\n')
tag = open("tag.temp.txt","r").read().strip().split('\n')
word_tag_out = open("word-tag.temp2.txt","w")
tag_out = open("tag.temp2.txt","w")

for i in range(len(word_tag)):
	if "punc" in word_tag[i]:
		word_tag_out.write("punc/PUNC\n")
		tag_out.write("PUNC\n")
	elif "date" in word_tag[i]:
		word_tag_out.write("date/DATE\n")
		tag_out.write("DATE\n")
	elif "num-digit" in word_tag[i]:
		word_tag_out.write("num-digit/NUM-DIGIT\n")
		tag_out.write("NUM-DIGIT\n")
	else:
		word_tag_out.write(word_tag[i] + "\n")
		tag_out.write(tag[i] + "\n")

word_tag_out.close()
tag_out.close()		
