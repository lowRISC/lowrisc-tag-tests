// See LICENSE for license details.

#include "env/tag.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAX_VECT_SIZE 1024*16
#define MAX_NUM_VECT 1024*16

int parity_gen(long data, int pwidth) {
  int i, rv=0;
  for(i=0; i*pwidth < 16; i++) {
    rv ^= data;
    data >>= pwidth;
  }
  return rv % (1 << pwidth);
}

main() {

  long ** root_table;
  long max_vects = 0;
  long count = 0;
  long i;

  // malloc the root table
  root_table = (long **)malloc(sizeof(long *)*MAX_NUM_VECT);
  if(root_table == NULL) {
    printf("Error! Can not malloc for the root table\n");
    exit(1);
  }

  // clean the root table
  memset(root_table, 0, MAX_NUM_VECT*sizeof(long *));

  printf("INFO: Root table ready\n", count);
      
  // set tags
  while(1) {
    long * vect = (long *)malloc(sizeof(long)*MAX_VECT_SIZE);
    if(vect == NULL) {
    //if(count == 2) {
      printf("INFO: Reach maximal allocatable space at count %d\n", count);
      printf("INFO: The maximal address being malloced is %lx\n", root_table[count-1] + MAX_VECT_SIZE);
      max_vects = count;
      count = 0;
      break;
    } else {
      root_table[count] = vect;
    }

    for(i=0; i<MAX_VECT_SIZE; i++) {
      int tag = i % (1 << TAG_WIDTH);
      vect[i] = tag;
      store_tag(vect + i, tag);
    }

    count++;

    if(count % 256 == 0) {
      printf("INFO: Set up tags to count %d\n", count);
    }
  }

  // check tags
  while(1) {
    long * vect = root_table[count];
    
    if(vect == NULL) {
      printf("INFO: Tag check finished at count %d\n", count);
      count = 0;
      break;
    }

    for(i=0; i<MAX_VECT_SIZE; i++) {
      if(load_tag(vect+i) != *(vect+i)) {
        printf("Error! Tag error @[%lx], %x != %x. [[count = %d, i=%d]]\n", vect + i, *(vect+i) , load_tag(vect+i), count, i);
        exit(1);
      }
    }
    
    count++;

    if(count % 256 == 0) {
      printf("INFO: Check tags to count %d\n", count);
    }
  }

  // ramdom checks
  long index = 0;
  long count_orig = rand();
  long i_orig = rand();
  while(1) {
    int tag = index % (1 << TAG_WIDTH);
    count = count_orig % max_vects;
    i = i_orig % MAX_VECT_SIZE;
    
    if(load_tag(root_table[count] + i) != root_table[count][i]) {
      printf("Error! Tag error @[%lx], %x != %x. [[count = %d, i=%d]]\n", root_table[count] + i, root_table[count][i] , load_tag(root_table[count] + i), count, i);
      exit(1);
    } else {
      store_tag(root_table[count] + i, tag);
      root_table[count][i] = tag;
    }
    index++;
    count_orig += rand();
    i_orig += rand();

    if(index % (256*16*1024) == 0) {
      printf("INFO: Random check tags for %d K times. [[count = %d, i=%d]]\n", index/1024, count, i);
    }
  }
  
}
