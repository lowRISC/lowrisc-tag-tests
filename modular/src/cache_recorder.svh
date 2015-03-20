// a scoreboard to record the cache transactions

class ExtendedCacheBlock extends CacheBlock;

   int core_id, operation;
   realtime stamp;

endclass // ExtendedCacheBlock



class CacheRecorder;

   local Cache#(ExtendedCacheBlock) scorebard;
   
   
   function void record(CacheBlock cb, bit rw, int cid);
      if(rw) begin // write
         ExtendedCacheBlock ecb = new();
         ecb.copy(cb);
         ecb.operation = 1;
         ecb.core_id = cid;
         ecb.stamp = $realtime;
         scoreboard.add(ecb);
      end else begin // read
         if(scoreboard.exist(cb.addr)) // written before
           
      end
   endfunction // record

endclass // CacheRecorder
