// the tag cache test environment

`ifndef TC_CACHE_ENV_H
 `define TC_CACHE_ENV_H

class CacheTestEnv #(int NCore = 2);
   
   // physical interfaces to connect the DUT
   virtual TLinkAcquireInf acq;
   virtual TLinkGrantInf gnt;
   virtual MemReqCMDInf mem_req;
   virtual MemDataInf mem_data;
   virtual MemRespInf mem_resp;
   virtual ClockInf clock;

   // behavioural test bench components
   Processor proc [NCore-1:0];  // processors
   AcquireDriver acq_driver;    // TileLink Acquire message driver
   GrantDriver gnt_driver;      // TileLink Grant message driver

   CacheRecorder scorboard;     // Global scoreboard for cache read/write transactions

   MemReqDriver mem_req_driver; // Memory interface request driver
   MemRespDriver mem_resp_driver; // Memory interface response driver

   Memory mem;                  // memory

   // channels
   mailbox acq_queue;
   mailbox gnt_queue [NCore-1:0];
   mailbox mem_req_queue;
   mailbox mem_data_queue;
   mailbox mem_resp_queue;

   function new(
                TLinkAcquireInf acq_h,
                TLinkGrantInf gnt_h,
                MemReqCMDInf mem_req_h,
                MemDataInf mem_data_h,
                MemRespInf mem_resp_h,
                ClockInf clock_h         
                );
      acq = acq_h;
      gnt = gnt_h;
      mem_req = mem_req_h;
      mem_data = mem_data_h;
      mem_resp = mem_resp_h;
      clock = clock_h;
   endfunction // new

   function void build();

   endfunction // build

   function void connect();
   endfunction // connect

   task execute;
   endtask //

endclass // CacheTestEnv

`endif
