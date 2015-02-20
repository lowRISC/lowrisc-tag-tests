// See LICENSE for license details.

#include "env/tag.h"
#include <stdio.h>


main() {

  long a[100], i;
  
  printf("Begin store tags\n");

  for(i=0; i<100; i++) {
    printf("store tag %d\n", i);
    store_tag((a+i), i);
  }
  
  printf("Tags stored\n");

  for(i=0; i<100; i++) {
    int tag = load_tag(a+i);
    printf("load tag %d\n", i);
    if((i % TAG_WIDTH) != tag) {
    printf("Error! Wrong tag readed from a[%d], expecting %x but read %x\n",
           i, i%TAG_WIDTH, tag);
    }
  }

  printf("Success!\n");
}
