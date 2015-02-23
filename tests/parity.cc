// See LICENSE for license details.

#include "env/tag.h"
#include <stdio.h>
#include <stdlib.h>

#define VECT_SIZE 1<<9

int parity_gen(long data, int pwidth) {
  int i, rv=0;
  for(i=0; i*pwidth < sizeof(data)*8; i++) {
    rv ^= data;
    data >>= pwidth;
  }
  return rv % (1 << pwidth);
}

main() {

  long *a[VECT_SIZE], i;
  
  for(i=0; i<VECT_SIZE; i++) {
    *(a+i) = (long *)malloc(sizeof(long));
    *(a[i]) = rand();
    store_tag(a[i], parity_gen(*(a[i]), TAG_WIDTH));
  }
  
  for(i=0; i<VECT_SIZE; i++) {
    int value = parity_gen(*(a[i]), TAG_WIDTH);
    int tag = load_tag(a[i]);
    if(value != tag) {
    printf("Error! Wrong tag readed from a[%d], expecting %x but read %x\n",
           i, value, tag);
    return 0;
    }
  }
}
