import std.exception;
import std.stdio;
import std.conv;
import std.range;
import std.algorithm;
import std.datetime.stopwatch;
import std.meta;

// Biotronic on http://forum.dlang.org/post/unjujeqnqjtwgsrhvphr@forum.dlang.org
string randomDna(int length) {
    import std.random;
    auto rnd = Random(unpredictableSeed);
    enum chars = ['A','C','G','T'];
    return iota(length).map!(a=>chars[uniform(0,4, rnd)]).array;
}

unittest {
    auto input = randomDna(2000);

    string previous = null;
    foreach (fn; AliasSeq!(revComp0, revComp1, revComp2, revComp3, revComp4, revComp5, revComp6, revComp7)) {
        auto timing = benchmark!({fn(input);})(10_000);
        writeln((&fn).stringof[2..$], ": ", timing[0].to!Duration);
        auto current = fn(input);
        if (previous != null) {
            if (current != previous) {
                writeln((&fn).stringof[2..$], " did not give correct results.");
            } else {
                previous = current;
            }
        }
    }
}

// 216 ms, 3 us, and 8 hnsecs
string revComp0(string bps) {
    const N = bps.length;
    char[] result = new char[N];
    for (int i = 0; i < N; ++i) {
        result[i] = {switch(bps[N-i-1]){
            case 'A': return 'T';
            case 'C': return 'G';
            case 'G': return 'C';
            case 'T': return 'A';
            default: return '\0';
            }}();
    }
    return result.assumeUnique;
}

// 2 secs, 752 ms, and 969 us
string revComp1(string bps) {
    return bps.retro.map!((a){switch(a){
            case 'A': return 'T';
            case 'C': return 'G';
            case 'G': return 'C';
            case 'T': return 'A';
            default: assert(false);
            }}).array;
}

// 10 secs, 419 ms, 335 us, and 6 hnsecs
string revComp2(string bps) {
    enum chars = ['A': 'T', 'T': 'A', 'C': 'G', 'G': 'C'];
    auto result = appender!string;
    foreach_reverse (c; bps) {
        result.put(chars[c]);
    }
    return result.data;
}

// 1 sec, 972 ms, 915 us, and 9 hnsecs
string revComp3(string bps) {
    const N = bps.length;
    static immutable chars = [Repeat!('A'-'\0', '\0'), 'T',
                Repeat!('C'-'A'-1, '\0'), 'G',
                Repeat!('G'-'C'-1, '\0'), 'C',
                Repeat!('T'-'G'-1, '\0'), 'A'];

    char[] result = new char[N];
    for (int i = 0; i < N; ++i) {
        result[i] = chars[bps[N-i-1]];
    }
    return result.assumeUnique;
}

string revComp4(string bps) {
  const N = bps.length;
  char[] result = new char[N];
  for (int i = 0; i < N; ++i) {
    switch(bps[N-i-1]) {
    case 'A': result[i] = 'T'; break;
    case 'C': result[i] = 'G'; break;
    case 'G': result[i] = 'C'; break;
    case 'T': result[i] = 'A'; break;
    default: assert(false);

    }

  }
  return result.assumeUnique;

}

string revComp5(string bps) {
  const N = bps.length;
  char[] result = new char[N];
  foreach (i, ref e; result) {
    switch(bps[N-i-1]) {
    case 'A': e = 'T'; break;
    case 'C': e = 'G'; break;
    case 'G': e = 'C'; break;
    case 'T': e = 'A'; break;
    default: assert(false);

    }

  }
  return result.assumeUnique;

}

string revComp6(string bps) {
  char[] result = new char[bps.length];
  auto p1 = result.ptr;
  auto p2 = &bps[$-1];

  while (p2 > bps.ptr) {
    switch(*p2) {
    case 'A': *p1 = 'T'; break;
    case 'C': *p1 = 'G'; break;
    case 'G': *p1 = 'C'; break;
    case 'T': *p1 = 'A'; break;
    default: assert(false);

    }
    p1++; p2--;

  }
  return result.assumeUnique;
}

// crimaniak
string revComp7(string bps)
{
  char[] result = new char[bps.length];
  auto p1 = result.ptr;
  auto p2 = &bps[$ - 1];
  enum AT = 'A'^'T';
  enum CG = 'C'^'G';

  while (p2 > bps.ptr)
    {
      *p1 = *p2 ^ ((*p2 == 'A' || *p2 == 'T') ? AT : CG);
      p1++;
      p2--;

    }
  return result.assumeUnique;

}

void main(){

  enum AT = 'A'^'T';
  enum CG = 'C'^'G';
  enum chars = [Repeat!('A'-'\0', '\0'), 'T',
                Repeat!('C'-'A'-1, '\0'), 'G',
                Repeat!('G'-'C'-1, '\0'), 'C',
                Repeat!('T'-'G'-1, '\0'), 'A'];


  writef("BIN %08b DEC %d CHAR %c\n", 'A', 'A', 'A');
  writef("BIN %08b DEC %d\n", 'T', 'T');
  writef("XOR %08b DEC %d\n", AT, AT);
  writef("TOR %08b DEC %d CHAR %c\n", AT^'T', AT^'T', to!char(AT^'T'));
  writef("AOR %08b DEC %d CHAR %c\n", AT^'A', AT^'A', to!char(AT^'A'));

  foreach (i, c; chars){
    if (i >= 60) writef("% 2c: %0 8b, %c\n",to!char(i), c, to!char(c)); // elements before 60 are all \0
  }
}
