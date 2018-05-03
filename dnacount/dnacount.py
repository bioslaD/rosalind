#!/usr/bin/env python
file = open('./rosalind_dna.txt', 'r')
string = file.read().strip()
freq = {'A': 0, 'C': 0, 'G': 0, 'T': 0}
for i in string:
    freq[i] += 1

print freq['A'], freq['C'], freq['G'], freq['T']

# infile = open("./rosalind_dna.txt", "r")
# seq = infile.read()

# def qt(s):
#     return s.count("A"), s.count("G"), s.count("C"), s.count("T")

# print(qt(seq))
