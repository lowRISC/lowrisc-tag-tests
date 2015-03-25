// a random test bench

`ifndef TC_RAMDOM_TESTER_H
 `define TC_RANDOM_TESTER_H

class RandomTester #(parameter int NCore = 2) extends CacheTestEnv #(NCore);

   local RandomProcessor rproc [NCore-1:0];

   virtual function void build_processor();
      foreach(proc[i]) begin
         rproc[i] = new(L2, acq_queue, gnt_queue[i], scoreboard, i);
         proc[i] = rproc[i];
      end
   endfunction // build_processor

endclass // RandomTester

`endif
