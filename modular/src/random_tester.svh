// a random test bench

`ifndef TC_RAMDOM_TESTER_H
 `define TC_RANDOM_TESTER_H

class RandomTester #(int NCore = 2) extends CacheTestEnv #(NCore);

   local RandomProcessor rproc [NCore-1:0]

   function new(
                TLinkAcquireInf acq_h,
                TLinkGrantInf gnt_h,
                MemReqCMDInf mem_req_h,
                MemDataInf mem_data_h,
                MemRespInf mem_resp_h,
                ClockInf clock_h         
                );
      super.new(acq_h, gnt_h, mem_req_h, mem_data_h, mem_resp_h, clock_h);
   endfunction // new

   virtual function void build_processor();
      foreach(proc[i]) begin
         rproc[i] = new(L2, acq_queue, gnt_queue[i], scoreboard, i);
         proc[i] = rproc[i];
      end
   endfunction // build_processor

endclass // RandomTester

`endif
