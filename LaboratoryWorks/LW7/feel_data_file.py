#!/usr/bin/python3
import random

FILE_NAME = "data.tsv"
ALLOWED_CHARS = "abcdefghijklmnopqrstuvwxyz"
ALLOWED_CHARS += ALLOWED_CHARS.upper()
CHARS_IN_STRING = random.randint(1, 20)
NUMS_IN_ARRAY = random.randint(100, 255)
LINES_IN_FILE = random.randint(100, 300)

with open(FILE_NAME, 'w') as f:
    for _ in range( LINES_IN_FILE ):
        string = ''
        for _ in range( CHARS_IN_STRING ):
            string += random.choice(ALLOWED_CHARS)
        
        arr = []
        for _ in range( NUMS_IN_ARRAY ):
            arr.append( random.randint(0, 32767) )
        
        string += '\t'
        string += '\t'.join([ str(i) for i in arr ])
        f.write(string + '\n')
