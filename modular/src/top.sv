// the simulation top

interface ClockInf;
   logic clk;
   logic reset;
   logic init;

   initial begin
      reset = 1;
      # 130 reset = 0;
   end

   initial begin
      clk = 0;
      forever clk = #(`ClkPeriod / 2) ~clk;
   end
   
endinterface // ClockInf


module top;
   import cache_pkg::*;

   ClockInf clock;
   TLinkAcquireInf uc_acq;
   TLinkGrantInf uc_gnt;
   MemReqCMDInf mem_cmd;
   MemDataInf mem_data;
   MemRespInf mem_resp;

   TagCacheWrapper DUT(*);

   RandomTester #(`NCore) tester;

   
   initial begin
      tester = new(uc_acq, uc_gnt, mem_cmd, mem_data, mem_resp, clock);

      tester.execute();
   end

endmodule // top


      
