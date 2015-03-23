// a scoreboard to record the cache transactions

`ifndef TC_CACHE_RECORDER_H
`define TC_CACHE_RECORDER_H

class ExtendedCacheBlock extends CacheBlock;

   int core_id, operation;
   realtime stamp;

   virtual function string convert2string();
      $sformat(convert2string,
               {super.convert2string, "{%t, %d, %d}"},
               stamp, core_id, operation);
   endfunction

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
         if(scoreboard.exist(cb.addr)) begin // written before
            // check
            ecb = scoreboard[cb.addr];
            if(!ecb.is_equal(cb)) begin
               $display("%t  Error! Cache line read mismatch:", $time);
               $display({"    The recorded cache line: ", ecb.convert2string()});
               $display({"    The read cache line: ", cb.convert2string()});
               #10 $finish();
            end
            ecb.operation = 0;
            ecb.core_id = cid;
            ecb.stamp = $realtime;
         end // if (scoreboard.exist(cb.addr))
      end // else: !if(rw)
   endfunction // record

endclass // CacheRecorder

`endif //  `ifndef TC_CACHE_RECORDER_H

