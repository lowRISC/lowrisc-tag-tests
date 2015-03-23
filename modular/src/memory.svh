// memory behavioural model

`ifndef TC_MEMORY_H
 `define TC_MEMORY_H

class Memory;

   protected Cache#(MemDataMessage, mif_addr_t) mem;

   protected mailbox cmd;
   protected mailbox data;
   protected mailbox resp;

   protected const int memory_delay;
   protected const real memory_delay_random_ratio;

   function new(mailbox cmd_h, mailbox data_h, mailbox resp_h, int mdelay, real mratio);
      cmd = cmd_h;
      data = data_h;
      resp = resp_h;
      memory_delay = mdelay;
      memory_delay_random_ratio = mratio;
   endfunction // new

   virtual task execute;

      while(1'b1) begin
         automatic int mdelay = memory_delay + $random%(memory_delay*memory_delay_random_ratio);

         MemReqCMDMessage cmd_msg;
         MemDataMessage data_msg;
         MemRespMessage resp_msg;

         cmd.get(cmd_msg);
         if(cmd_msg.rw) begin
            data.get(data_msg);

            #(mdelay)
            
            // check first
            if(!mem.exist(cmd_msg.addr)) begin
               $display("%t  Error! Try to write a memory block not being read yet:", $time);
               $display({"    The MemCMDReq: ", cmd_msg.convert2string()});
               $display({"    The MemCMDData: ", data_msg.convert2string()});
            end
            mem[cmd_msg.addr] = data_msg;
         end else begin

            #(mdelay)
            
            if(!mem.exist(cmd_msg.addr))
              mem[cmd_msg.addr] = MemDataMessage(0);

            resp_msg = new(mem[cmd_msg.addr].data, cmd_msg.tag);
            resp.put(resp_msg);
         end
      end
   endtask // while
   
endclass // Memory

`endif
