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


module test_top;
   import cache_pkg::*;

   ClockInf clock();
   TLinkAcquireInf uc_acq();
   TLinkGrantInf uc_gnt();
   TLinkFinishInf uc_fin();
   MemReqCMDInf mem_cmd();
   MemDataInf mem_data();
   MemRespInf mem_resp();

   TagCacheWrapper DUT(.*);

   RandomTester #(.NCore(`NCore)) tester;
   
   initial begin
      tester = new;
      
      tester.acq = uc_acq;
      tester.gnt = uc_gnt;
      tester.mem_req =  mem_cmd;
      tester.mem_data =  mem_data;
      tester.mem_resp =  mem_resp;
      tester.clock = clock;

      tester.build();

      tester.execute();
   end // initial begin

   initial begin
      $vcdplusfile("tagcache.vpd");
      $vcdplusmemon();
      $vcdpluson();
   end

endmodule // test_top



      
