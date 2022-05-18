infile = 'EVM.aa'
outfile = 'EVM.nodot.aa'

with open(infile) as f:
    with open(outfile, 'w') as f2:
        for line in f:
	    if '>' not in line:
            	f2.write(line.replace('.',''))
	    else:
		f2.write(line)

