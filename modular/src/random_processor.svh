// a processor that generate random requests

`ifndef TC_RANDOM_PROCESSOR_H
 `define TC_RANDOM_PROCESSOR_H

class RandomProcessor extends Processor;
   
   // construct
   function new(Cache L2, mailbox acq, mailbox gnt, CacheRecorder sb, int cid);
      super.new(L2, acq, gnt, sb, cid);
   endfunction // new

   typedef enum {read_miss, write_miss, write_back} OpType;

   protected rand OpType operation;
   constraint opRange {operation dist {read_miss := 60, write_miss := 30, write_back := 10}; }

   // mem operation period
   protected const int  mem_period = 1000 / `LD_ST_Freq;

   virtual function CacheBlock cacheGen(OpType op);
      CacheBlock m = new();
      
      case(op)
        read_miss, write_miss: begin
           while(1'b1) begin
              m.randomize();
              if(!L1.exist(m.addr)) break;
           end
        end
        write_back: begin
           m = L1.get_random();
        end
      endcase // case (op)
      
      return m;
   endfunction // cacheGen
   
   // the operation thread
   virtual task execute;
      CacheBlock m;
      CacheBlock m_rand = new;

      $display("Processor %0d begins to execute.", core_id);
      
      while(1'b1) begin
         
         #(mem_period);
         
         this.randomize();
         
         case(operation)
           read_miss: begin
              if(L1.size() == `L1Size) begin // L1 full, write back first
                 m = cacheGen(write_back);
                 $display("%0t  Processor %0d write_back operation [%0h]%0h", $time, core_id, m.addr, m.data);
                 write(m);
                 L1.remove(m.addr);
                 L2_h.remove(m.addr);
              end
              
              // now there is space in L1 for sure
              m = cacheGen(operation);
              L2_h.add(m.addr, m);
              read(m);
              $display("%0t  Processor %0d read_miss operation [%0h]%0h", 
                       $time, core_id, m.addr, m.data);
           end // case: read_miss
           write_miss: begin
              CacheBlock m_copy = new;
              if(L1.size() == `L1Size) begin // L1 full, write back first
                 m = cacheGen(write_back);
                 $display("%0t  Processor %0d write_back operation [%0h]%0h", 
                          $time, core_id, m.addr, m.data);
                 write(m);
                 L1.remove(m.addr);
                 L2_h.remove(m.addr);
              end
              
              // now there is space in L1 for sure
              m = cacheGen(operation);
              m_copy.copy(m);
              L2_h.add(m.addr, m);
              read(m);
              $display("%0t  Processor %0d write_miss(read) operation [%0h]%0h", 
                          $time, core_id, m.addr, m.data);

              L1.add(m.addr, m_copy);
              L2_h.add(m.addr, m_copy);
              $display("%0t  Processor %0d write_miss(write) operation [%0h]%0h", $time, core_id, m.addr, m_copy.data);
              write(m_copy);
           end
           write_back: begin
              m = cacheGen(write_back);
              m_rand.randomize(); // always write a different daya when write back
              m.copy_data(m_rand);
              $display("%0t  Processor %0d write_back operation [%0h]%0h", $time, core_id, m.addr, m.data);
              write(m);
              L1.remove(m.addr);
              L2_h.remove(m.addr);
           end
         endcase

      end
      
   endtask
                                                                 

endclass // RandomProcessor

`endif //  `ifndef TC_RANDOM_PROCESSOR_H
