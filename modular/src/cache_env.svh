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
   Cache#(CacheBlock, cacheBlockAddr_t) L2; // the shared L2 cache
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

   virtual function void build_processor();
      foreach(proc[i]) proc[i] = new(L2, acq_queue, gnt_queue[i], scoreboard, i);
   endfunction // build_processor

   function void build();
      // all mailboxes
      acq_queue = new(NCore);   // all 1 outstanding request from each core
      foreach(gnt_queue[i]) gnt_queue[i] = new();
      mem_req_queue = new(`MemIFQueDepth);
      mem_data_queue = new(`MemIFQueDepth);
      mem_resp_queue = new(`MemIFQueDepth);

      // the global scoreboard
      scoreboard = new();

      // the shared L2 cache
      L2 = new();

      // all other components
      build_processor();
      acq_driver = new(acq_queue);
      acq_driver.acq = acq;
      acq_driver.clock = clock;
      gnt_driver = new(gnt_queue);
      gnt_driver.gnt = gnt;
      gnt_driver.clock = clock;
      mem_req_driver = new(mem_req_queue, mem_data_queue);
      mem_req_driver.mem_cmd = mem_req;
      mem_req_driver.mem_data = mem_data;
      mem_req_driver.clock = clock;
      mem_resp_driver = new(mem_resp_queue);
      mem_resp_driver.mem_resp = mem_resp;
      mem_resp_driver.clock = clock;
      mem = new(mem_req_queue, mem_data_queue, mem_resp_queue, `MemDly, `MemDlyRRatio);
      
   endfunction // build

   task execute;
      // start all drivers as signals needs to be initialized
      fork
         acq_driver.execute();
         gnt_driver.execute();
         mem_req_driver.execute();
         mem_req_driver.execute();
      join_none

      // wait for reset
      @(negedge clock.reset);

      // start all other components
      fork
         foreach(proc[i]) proc[i].execute();
         memory.execute();
      join_none
      
   endtask // execute

endclass // CacheTestEnv

`endif
