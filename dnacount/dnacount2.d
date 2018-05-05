// Written in the D programming language.
// Counting DNA Nucleotides, see http://rosalind.info/problems/dna/
import std.stdio;
import std.file;
import std.string;

struct SymbolCount
{
	size_t A, C, G, T;
}

void main(string[] args)
{
	if (args.length != 2)
	{
		writeln("Requires filename as argument");
		return ;
	}
	auto text = readText!string(args[1]).splitLines();
	try
	{
		auto sc = count(text[0]);
	    writefln("%d %d %d %d", sc.A, sc.C, sc.G, sc.T);
    }
    catch (Exception e)
    {
    	writefln("%s", e.msg);
    }
}

SymbolCount count(string s)
{
	SymbolCount sc;
	foreach (c; s)
	{
		switch (c)
		{
			case 'A':
				sc.A++;
				break;
			case 'C':
				sc.C++;
				break;
			case 'G':
				sc.G++;
				break;
			case 'T':
				sc.T++;
				break;
			default:
				throw new Exception("Unexpected character in string");
		}
	}
	return sc;
}

unittest
{
	assert(count("AAA") == SymbolCount(3, 0, 0, 0));
	assert(count("ACGT") == SymbolCount(1, 1, 1, 1));
	bool thrown = false;
	try
	{
		count("XXX");
	}
	catch (Exception)
	{
		thrown = true;
	}
	assert(thrown);
}