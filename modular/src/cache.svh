// a behaviour cache

`ifndef TC_CACHE_H
 `define TC_CACHE_H

class Cache #(type T = CacheBlock, type TA = cacheBlockAddr_t);

   // define a cache using an associate array
   protected T cache [ TA ];

   // check whether a block exists
   function int exist (TA cba);
      return cache.exists(cba);
   endfunction // exist
   
   // get the current size of the cache
   function int size();
      return cache.size();
   endfunction // size
   
   // add a block into the cache
   function void add (T cb);
      cache[cb.addr] = cb;
   endfunction // add

   // remove a block from the cache
   function void remove (TA cba);
      assert(exist(cba));
      cache.delete(cba);
   endfunction // remove

   // get the content of a block
   function T get(TA cba);
      assert(exist(cba));
      return cache[cba];
   endfunction // get

   // helper variable for get_random
   rand TA random_block_addr;
   constraint must_exist { cache.exist(random_block_addr); }

   // get a random block from the cache
   function T get_random();
      assert(cache.size());
      this.randomize();
      return cache[random_block_addr];
   endfunction // get_random

endclass // Cache

`endif //  `ifndef TC_CACHE_H
