#!/usr/bin/env rdmd
import std.stdio;
version = nosort;
version(sortout) import std.algorithm;
void main(string [] args){
    int[dchar] charcount = ['A': 0, 'C' : 0 , 'G' : 0, 'T' : 0];
    auto infile = File("./rosalind_dna.txt", "r");

    foreach (line; infile.byLine()){
        foreach (c; line){
            charcount[c] += 1;
        }
    }

    version(sortout){
        auto keys = charcount.keys;
        sort!( "a < b", SwapStrategy.stable)(keys);
        foreach (k; keys) writeln("Count %s: %i",  k, charcount[k]);
    }
    version(nosort){
        foreach (k; charcount.keys){
            writeln("Count %s: %i",  k, charcount[k]);
        }
    }

}
