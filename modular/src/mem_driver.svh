// the driver for the memory interfaces

`ifndef TC_MEM_DRIVER_H
 `define TC_MEM_DRIVER_H

class MemReqDriver;

   virtual MemReqCMDInf mem_cmd;
   virtual MemDataInf mem_data;
   virtual ClockInf clock;

   protected mailbox MemCmd_h;
   protected mailbox MemDat_h;

   function new(mailbox mem_cmd_h, mailbox mem_data_h);
      MemCmd_h = mem_cmd_h;
      MemDat_h = mem_data_h;
   endfunction // new

   task execute;
      wait(clock.reset == 1'b1);

      mem_cmd.ready = 1'b0;
      mem_dat.ready = 1'b0;

      @(negedge clock.reset);
      @(posedge clock.clk);
      #0.1;

      while(1'b1) begin
         MemReqCMDMessage cmd_m;
         MemDataMessage dat_m;
         automatic int i=0;
         automatic bit rw = 0;

         mem_cmd.ready = 1'b1;
         
         if(mem_cmd.valid) begin
            mem_cmd.ready = 1'b0;

            cmd_m = new(mem_cmd.addr, mem_cmd.tag, mem_cmd.rw);
            MemCmd_h.put(cmd_m);
            rw = mem_cmd.rw;
            dat_m = new(0);
         end

         if(rw) begin
            mem_dat.ready = 1'b1;
            while (i < `MIFDataBeats) begin
               if(mem_dat.valid) begin
                  dat_m.data[i*`MIFDataBits +: `MIFDataBits] = mem_dat.data;
                  i++;
               end

               @(posedge clock.clk);
               #0.1;
            end
            mem_data.ready = 1'b0;
            MemDat_h.put(mem_dat);
         end else begin // if (rw)
            @(posedge clock.clk);
            #0.1;
         end // else: !if(rw)
      end // while (1'b1)
   endtask // wait

endclass // MemReqDriver

class MemRespDriver;

   virtual MemRespInf mem_resp;

   protected mailbox MemResp_h;

   function new(mailbox mem_resp_h);
      MemResp_h = mem_resp_h;
   endfunction // new

   task execute;

      wait(clock.reset == 1'b1);

      mem_resp.valid = 1'b0;

      @(negedge clock.reset);

      while(1'b1) begin
         MemRespMessage m;
         automatic int i = 0;
         
         MemResp_h.get(m);

         while(i<`MIFDataBeats) begin
            @(posedge clock.clk);
            #0.1;

            mem_resp.valid = 1'b1;
            mem_resp.data = m.data;
            mem_resp.tag = m.tag;
            m.data = m.data >> `MIFDataBits;
         end
      end // while (1'b1)
   endtask // wait

endclass // MemRespDriver


`endif //  `ifndef TC_MEM_DRIVER_H
