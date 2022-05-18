#!/usr/bin/env python

import sys
import os

def Usage ():
    print  """USAGE:
ParseTRFoutput.py -i <input_file> -o <output_dir>

input_file       .dat file output from Tandem Repeat Finder.
output_dir       Output directory.
"""  

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

def ParseTRFoutput(input_file, output_dir):
    fh = open(input_file, 'r')
    if not os.path.isdir(output_dir):
        print "Making directory: %s" % (output_dir)
        os.makedirs(output_dir)
    output_file = os.path.join(output_dir, "TRF_output.tsv")
    fh_out = open(output_file, 'w')
    column_names = "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s" % ("chr", "\t", "start", "\t", "end", "\t", "period_size", "\t", "n_copies", "\t", "consensus_size", "\t", "percent_matches", "\t", "percent_indels", "\t", "alignment_score", "\t", "consensus_sequence", "\t", "repeat_sequence")
    fh_out.write(column_names)
    fh_out.write("\n")
    for line in fh:
        line = line.strip("\n")
        line = line.split()
        if len(line) == 0:
            continue
        elif line[0] == "Sequence:":
            chr = line[1]
            continue
        elif is_number(line[0]):
            output = "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s" % (chr, "\t", line[0], "\t", line[1], "\t", line[2], "\t", line[3], "\t", line[4], "\t", line[5], "\t", line[6], "\t", line[7], "\t", line[13], "\t", line[14])
            fh_out.write(output)
            fh_out.write("\n")

    fh.close()
    fh_out.close()

def main():
    from optparse import OptionParser
    parser = OptionParser()
    parser.add_option("-i", dest="input_file", nargs=1, default=None, help=".dat file produced by Tandem Repeat Finder.")
    parser.add_option("-o", dest="output_dir", nargs=1, default=None, help="Output Directory.")
    (options, args) = parser.parse_args()

    if options.input_file == None:
        Usage()
        print "Error: need to specify -i."
        return

    if options.output_dir == None:
        Usage()
        print "Error: need to specify -o."
        return
    
    input_file = os.path.abspath(os.path.expanduser(options.input_file))
    output_dir = os.path.abspath(os.path.expanduser(options.output_dir))

    ParseTRFoutput(input_file, output_dir)

if __name__ == "__main__":
    main()
