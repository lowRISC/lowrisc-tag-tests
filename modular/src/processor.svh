// base class of a processor

`ifndef TC_PROCESSOR_H
 `define TC_PROCESSOR_H

class Processor;

   // processors private L1 cache
   Cache#(CacheBlock, cacheBlockAddr_t) L1;

   // the shared L2 cache
   Cache#(CacheBlock, cacheBlockAddr_t) L2_h;

   // Memory interface
   protected mailbox Acquire_h;
   protected mailbox Grant_h;

   // global scoreboard to checkfor errors
   local CacheRecorder scorboard;
   local core_id;
   
   // construct
   function new(Cache L2, mailbox acq, mailbox gnt, CacheRecorder sb, int cid);
      L1 = new();
      L2_h = L2;
      Acquire_h = acq;
      Grant_h = gnt;
      scoreboard = sb;
      core_id = cid;
   endfunction // new

   // write operation
   virtual task write(CacheBlock cb);
      AcquireMessage m = new(cb, 1'b1, core_id);
      Acquire_h.put(m);
      scoreboard.record(cb, 1'b1);
   endtask; // write

   // read operation
   virtual task read(CacheBlock cb);
      AcquireMessage acq= new(cb, 1'b0, core_id);
      Acquire_h.put(acq);

      // wait for grant
      GrantMessage gnt;
      Grant_h.get(gnt);

      // write it to L1 and L2
      CacheBlock mcb = gnt.extract();
      mcb.copy_addr(cb)
      scoreboard.record(mcb, 1'b0);
      L1.add(mcb);
      L2_h.add(mcb);
      
   endtask // read

endclass // Processor

`endif //  `ifndef TC_PROCESSOR_H

