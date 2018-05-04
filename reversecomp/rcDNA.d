#!/usr/bin/env rdmd
import std.stdio;
import std.algorithm: map, reverse;
// import std.array: replace, array;
import std.array;
import std.conv;
import std.file;

auto reverseSW(File f){
  dchar[dchar] translate = [ 'A': 'T', 'C': 'G', 'T' : 'A', 'G' : 'C', 'N': 'N'];
  string[] lines;

  foreach (line; f.byLine()){
    auto tran = line.map!(c => translate[c]).array;
    reverse(tran);
    lines ~= to!string(tran);
    }
  // Must return the reverse of lines because we were reversing line by line
  reverse(lines);
  return lines;

}

auto reverseComplement(File f){
  dchar[dchar] translate = [ 'A': 'T', 'C': 'G', 'T' : 'A', 'G' : 'C', 'N': 'N'];
  string[] lines;

  foreach (line; f.byLine()){
    auto tran = line.map!(c => translate[c]).array;
    reverse(tran);
    lines ~= to!string(tran);
    }
  // Must return the reverse of lines because we were reversing line by line
  reverse(lines);
  return lines;

}

version(unittest){
    import std.file         : remove, write;
    import std.path         : baseName;
    import std.conv         : text;
    string testFilename( string file = __FILE__, size_t line = __LINE__ ){
        return text("deleteme.", baseName(file), ".", line);
    }
}

unittest{

  string data = "ACT\nGTA\nACGTN";
  string[] expected = ["NACGT", "TAC", "AGT"];

  auto deleteme = testFilename();
  scope(exit) std.file.remove(deleteme);

  writeln(deleteme);
  auto fo = File(deleteme, "w");

  fo.write(data);
  fo.close();

  auto f = File(deleteme, "r");
  scope (exit) f.close();

  auto outdat = reverseComplement(f);
  foreach(e; outdat){
  writeln(e);
  }
  assert(expected == outdat);

}
void main(string [] args){
  File infile = File(args[1], "r");
  foreach (line; reverseComplement(infile)){
    writeln(line);
  }
}
