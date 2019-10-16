#!/usr/bin/python

import re

pattern = re.compile('^(4|5|6)(\d)(\d)(\d)-?(\d)(\d)(\d)(\d)-?(\d)(\d)(\d)(\d)-?(\d)(\d)(\d)(\d)$')

with open('cc.txt', 'r') as cc:
  for row in cc:
    row = row.strip('\n')
    if pattern.match(row):
       if re.search(r'(\d)\1{3}', row):
         print row, "Invalid"
       else: print row, "Valid"
    else: print row, "Invalid"

cc.close()

