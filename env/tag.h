// See LICENSE for license details.

#ifndef LOWRISC_TAG_H
#define LOWRISC_TAG_H

#define TAG_WIDTH 4

inline int load_tag(void *addr) {
  int rv;
  asm volatile ("ld %1, 0(%0)"
                :"=r"(addr)
                :"r"(rv)
                );
  return rv;
}


inline void store_tag(void *addr, int tag) {
  asm volatile ("sd %0, 0(%1)"
                :
                :"r"(tag), "r"(addr)
                );
}

#endif
