// See LICENSE for license details.

#include "env/tag.h"
#include <stdio.h>
#include <stdlib.h>
//#include <time.h>

#define VECT_SIZE 1<<10

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
  //int seed = time(NULL);    // time() does not work, always return 0
  int seed = 41521;

  printf("randomize using seed:%d\n", seed);
  srand(seed);            // reset random seed

  for(i=0; i<VECT_SIZE; i++) {
    int tag;
    *(a+i) = (long *)malloc(sizeof(long));
    *(a[i]) = rand();
    tag = parity_gen(*(a[i]), TAG_WIDTH);
    store_tag(a[i], tag);
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

  for(i=0; i<VECT_SIZE; i++) {
    free(a[i]);
  }
  printf("Parity check passed.\n");
}
