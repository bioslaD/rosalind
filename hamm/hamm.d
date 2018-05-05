// Written in the D programming language.
// Solves the Hamming distance problem, see http://rosalind.info/problems/hamm/
import std.stdio;
import std.file;
import std.string;

void main(string[] args)
{
	if (args.length != 2)
	{
		writeln("Requires filename as argument");
		return ;
	}
	auto text = readText!string(args[1]).splitLines();
	if (text.length < 2)
	{
		writeln("File requires at least two lines");
		return;
	}
	writefln("Line 1: %s", text[0]);
	writefln("Line 2: %s", text[1]);
	try
	{
	    writefln("Hamming distance: %d", hamm(text[0], text[1]));
    }
    catch (Exception e)
    {
    	writefln("%s", e.msg);
    }
}

long hamm(string a, string b)
{
	if (a.length != b.length) throw new Exception("Strings must have same length");
	long distance = 0;
	foreach(i; 0..a.length)
	{
		if (a[i] != b[i])
			distance++;
	}
	return distance;
}

unittest
{
	assert(0 == hamm("AAA", "AAA"));
	assert(3 == hamm("AAA", "BBB"));
	assert(7 == hamm("GAGCCTACTAACGGGAT", "CATCGTAATGACGGCCT"));
	
	bool thrown = false;
	try
	{
		hamm("a", "bc");
	}
	catch (Exception)
	{
		thrown = true;
	}
	assert(thrown);
}