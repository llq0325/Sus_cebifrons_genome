#!/usr/bin/env/ python3
"""
Author: Langqing Liu


"""

from sys import argv
import os.path
import re



def addhashtags(tree):
    for line in tree:
        a = re.sub(r'(pig:[0-9]\.[0-9]+)',r'\1 #1 ',line)
        print(a)

if __name__ == "__main__":
    tree = open(argv[1])
    addhashtags(tree)
