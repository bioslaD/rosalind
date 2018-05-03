#include<stdio.h>
#include<stdlib.h>

int main() {
  int count[256] = { 0 };
  int k;
  FILE *fp = fopen("./rosalind_dna.txt", "r");
  int c;
  while ((c = fgetc(fp)) != EOF) {
    if (c == '\n') continue;
    count[c]+=1;
  }
  for(k=0; k<256; k++) {
    if (count[k] > 0)
      printf("Nu: %c: %d\n", k, count[k]);
  }
  fclose(fp);
  return 0;
}
