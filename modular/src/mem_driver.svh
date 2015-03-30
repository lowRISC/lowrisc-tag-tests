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
      mem_data.ready = 1'b0;

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

            //$display({"%0t  generate a memory cmd: ", cmd_m.convert2string()}, $time);
            if(!MemCmd_h.try_put(cmd_m)) begin
               MemCmd_h.put(cmd_m);
               @(posedge clock.clk);
               #0.1;
            end

            mem_cmd.ready = 1'b1;
            rw = mem_cmd.rw;
            dat_m = new(0);
            @(posedge clock.clk);
            #0.1;
            
            if(rw) begin
               mem_cmd.ready = 1'b0;
               mem_data.ready = 1'b1;
               while (i < `MIFDataBeats) begin
                  if(mem_data.valid) begin
                     dat_m.data[i*`MIFDataBits +: `MIFDataBits] = mem_data.data;
                     i++;
                  end
                  
                  @(posedge clock.clk);
                  #0.1;
               end
               mem_data.ready = 1'b0;
               mem_cmd.ready = 1'b1;
               //$display("MemIF write: [%0h]%0h", cmd_m.addr, dat_m.data);
               if(!MemDat_h.try_put(dat_m)) begin
                  $display("cannot put a data message, should not happen.");
               end
            end else begin // if (rw)
               //$display("MemIF read:  [%0h]", cmd_m.addr);
            end // else: !if(rw)
         end else begin // if (mem_cmd.valid)
            @(posedge clock.clk);
            #0.1;
         end
      end // while (1'b1)
   endtask // wait

endclass // MemReqDriver

class MemRespDriver;

   virtual MemRespInf mem_resp;
   virtual ClockInf clock;

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
         
         mem_resp.valid = 1'b0;
         
         if(!MemResp_h.try_get(m)) begin
            MemResp_h.get(m);
            @(posedge clock.clk);
            #0.1;
         end

         while(i<`MIFDataBeats) begin
            mem_resp.valid = 1'b1;
            mem_resp.data = m.data;
            mem_resp.tag = m.tag;
            m.data = m.data >> `MIFDataBits;

            @(posedge clock.clk);
            #0.1;

            i++;
         end
      end // while (1'b1)
   endtask // wait

endclass // MemRespDriver


`endif //  `ifndef TC_MEM_DRIVER_H
