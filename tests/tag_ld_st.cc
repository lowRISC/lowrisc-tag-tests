// See LICENSE for license details.

#include "env/tag.h"
#include <stdio.h>
#include <stdlib.h>

#define VECT_SIZE 1<<9

main() {

  long a[VECT_SIZE], i;
  
  for(i=0; i<VECT_SIZE; i++) {
    *(a+i) = rand();
    store_tag((a+i), *(a+i));
  }
  
  for(i=0; i<VECT_SIZE; i++) {
    int value = *(a+i);
    int tag = load_tag(a+i);
    if((value % (1 << TAG_WIDTH)) != tag) {
    printf("Error! Wrong tag readed from a[%d], expecting %x but read %x\n",
           i, value % (1 << TAG_WIDTH), tag);
    return 0;
    }
  }
  printf("Tag load and store tests passed.\n");
}
