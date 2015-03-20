// a behaviour cache

class Cache #(type T = CacheBlock);

   // define a cache using an associate array
   protected T cache [ cacheBlockAddr_t ];

   // check whether a block exists, using a block
   function int exist (T cb);
      return exist(cb.addr);
   endfunction // exist

   // check whether a block exists, using an address
   function int exist (cacheBlockAddr_t cba);
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
   function void remove (T cb);
      remove(cb.addr);
   endfunction // remove

   // remove a block from the cache
   function void remove (cacheBlockAddr_t cba);
      assert(exist(cba));
      cache.delete(cba);
   endfunction // remove

   // get the content of a block
   function T get(cacheBlockAddr_t cba);
      assert(exist(cba));
      return cache[cba];
   endfunction // get

   // helper variable for get_random
   rand cacheBlockAddr_t random_block_addr;
   constraint must_exist { cache.exist(random_block_addr); }

   // get a random block from the cache
   function T get_random();
      assert(cache.size());
      this.randomize();
      return cache[random_block_addr];
   endfunction // get_random

endclass // Cache
