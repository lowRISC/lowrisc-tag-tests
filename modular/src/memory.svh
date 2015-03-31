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
      mem = new;
   endfunction // new

   virtual task working_thread;
      while(1'b1) begin
         automatic int mdelay = memory_delay + $random%(int'(memory_delay*memory_delay_random_ratio));
      
         automatic MemReqCMDMessage cmd_msg;
         automatic MemDataMessage data_msg;
         automatic MemRespMessage resp_msg;
         
         cmd.get(cmd_msg);
         //$display({"%0t  Memory cmd: ", cmd_msg.convert2string()}, $time);
         
         if(cmd_msg.rw) begin
            data.get(data_msg);
            
            // check first
            if(!mem.exist(cmd_msg.addr)) begin
               $display("%0t  Error! Try to write a memory block not being read yet:", $time);
               $display({"    The MemCMDReq: ", cmd_msg.convert2string()});
               $display({"    The MemCMDData: ", data_msg.convert2string()});
            end
            mem.add(cmd_msg.addr, data_msg);
            #(mdelay);
            
         end else begin
            
            if(!mem.exist(cmd_msg.addr)) begin
               data_msg = new;
               mem.add(cmd_msg.addr, data_msg);
            end else
              data_msg = mem.get(cmd_msg.addr);
            
            resp_msg = new(data_msg.data, cmd_msg.tag);

            #(mdelay);
            
            resp.put(resp_msg);
         end // else: !if(cmd_msg.rw)
      end // while (1'b1)
   endtask
      

   virtual task execute;
      automatic int i;

      for(i=0; i<`MemThreads; i++) begin
         fork
            working_thread();
         join_none
      end
      
   endtask
   
endclass // Memory

`endif
