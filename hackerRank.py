import re
import sys

pattern = re.compile('^(4|5|6)(\d)(\d)(\d)-?(\d)(\d)(\d)(\d)-?(\d)(\d)(\d)(\d)-?(\d)(\d)(\d)(\d)$')
infile = sys.stdin
next(infile)
for line in infile:
    if pattern.match(line):
        line = line.replace('-', '')
        if re.search(r'(\d)\1{3}', line):
            print('Invalid')
        else: print('Valid')
    else: print('Invalid')

