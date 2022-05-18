#!/usr/bin/python

# This program was written by Jon Ambler

# Search on keyword
# Preform functions on that data

# Initialization
import csv
import re
import sys
##################################################################################


# Functions

def get_Feature_Value(feature):
	out_list = []
	for x in items_matrix:
		out_list.append(x[feature])
	return out_list

def get_Feature_Length(feature):
	out_list = []
	for x in items_matrix:
		if x['type'] == feature:
			f_length = float(x['end']) - float(x['start'])
			f_length = str(f_length)
			out_list.append(f_length)
	return out_list

def get_Average(list):
	list = [ float(x) for x in list]
	average = sum(list)/len(list)
	return average
	
	
def get_exon_count_dict():
	#This function returns the average number of introns and exons in the annotated genes
	list_of_genes = {}
	for x in items_matrix:
		if x['type'] == 'CDS':
			info_string = x['attribues']
			if "Parent" in info_string:
				index_start = info_string.find('Parent')
				index_start = index_start + 7
				gene_id = info_string[index_start:]
				if gene_id in list_of_genes:
					list_of_genes[gene_id] += 1
				else:
					list_of_genes[gene_id] = 1
			elif "Parent" not in info_string:
				print "error"
		else:
			this = 1
	return list_of_genes

def get_dict_average(in_dict):
	val_list = []
	for key in in_dict:
		int_value = float(in_dict[key])
		val_list.append(int_value)
	average = sum(val_list)/len(in_dict)
	return average
	
def get_Number_of_Features(feature):
	count = 0
	variable_list = []
	for x in items_matrix:
		variable_list.append(x['type'])
	count = variable_list.count(feature)
	return count
##################################################################################


# Start - User input
print "Welcome to the GFF statistics toolkit!"

#filePath = raw_input("Where is the input file located? ")
filePath = sys.argv[1]
input_gff = open(filePath,'r')

#remove excess from file and add col names

if input_gff.readline().startswith('##gff-version 3') == True:
	format = "GFF3"
else:
	format = "GFF"

output = "seqid\tsource\ttype\tstart\tend\tscore\tstrand\tphase\tattribues\n"

print ""
# removing comments
for line in input_gff:
    if not line.startswith('#'):
        output = output + line
    else:
    	output = output

input_gff_stripped = output

#print input_gff_stripped


items_matrix = []
#reading the new file
reader = csv.DictReader(input_gff_stripped.splitlines(), delimiter='\t')
for row in reader:
    items_matrix.append(row)
    #print row

# Correcting the file if it is not in GFF format

if format == "GFF":
	print "The file apprears not to be in GFF3 format, assuming GFF"
	for x in items_matrix:
		if 'gene_id' in x['attribues']:
			old_string = x['attribues']
			string_index_start = old_string.find('gene_id')
			newstring = old_string[string_index_start:]
			newstring = "Parent=" + newstring[9:-2]
			x['attribues'] = x['attribues'] + newstring
else:
	# Well what can I say, sometimes we do things not because we truly understand the reason but
	# just because part of us knows it needs to be done. It was an idea that we once called
	# duty. Perhaps our constant questing for reason has led us only act when reason is present. 
	# This in itself is not bad I guess, but sometimes, I miss the "Just because". The thought 
	# that we can still do something, not because it benefits ourselves, or serves some higher
	# purpose, or even duty for that matter, but just... because. Maybe thats why I am writing this 
	# in the comment section of some obscure code. Maybe.
	print "GFF 3 detected"

#Pre-processing complete
#Begin main loop of the program

print "###############################################################################"
running = True
while running == True:
	print ""
	analysis = raw_input("What analysis would you like to run? \na) Get average feature lengths \nb) Get the average number of Exons \nc) Get the occurence of a feature \nl) Get the lengths of the feature \nQ) Quit \n")
	if analysis == "a":
		target_feature = raw_input("For which feature? ")
		print get_Average(get_Feature_Length(target_feature))
	elif analysis == "l":
		target_feature = raw_input("For which feature? ")
		print get_Feature_Length(target_feature)
	elif analysis == "b":
		print "The average is: " + str(get_dict_average(get_exon_count_dict()))
	elif analysis == "c":
		target_feature = raw_input("For which feature? ")
		print "There are " + str(get_Number_of_Features(target_feature)) + " " + target_feature + "\'s "
	elif analysis == "q" or analysis == "Q":
		running = False

print "End"
