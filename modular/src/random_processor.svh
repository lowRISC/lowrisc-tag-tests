// a processor that generate random requests

`ifndef TC_RANDOM_PROCESSOR_H
 `define TC_RANDOM_PROCESSOR_H

class RandomProcessor extends Processor;
   
   // construct
   function new(Cache L2, mailbox acq, mailbox gnt, CacheRecorder sb, int cid);
      super.new(L2, acq, gnt, sb, cid);
   endfunction // new

   typedef enum {read_miss, write_miss, write_back} OpType;

   OpType operation;
   protected Operation dist {read_miss := 60, write_miss := 30; write_back := 10};

   // mem operation period
   protected const int  mem_period = 1000 / `LD_ST_Freq;

   virtual function CacheBlock cacheGen(OpType op);
      CacheBlock m = new();
      
      case(op)
        read_miss, write_miss: begin
           while(1'b1) begin
              m.randomize();
              if(!L2_h.exist(m)) break;
           end
        end
        write_back: begin
           m = L1.get_random();
        end
      endcase // case (op)

      return m;
   endfunction // cacheGen
   
   // the operation thread
   task execute;
      CacheBlock m;
      CacheBlock m_ran = new;
      
      while(1'b1) begin
         
         #(mem_period);
         
         this.randomize();
         
         case(operation)
           read_miss, write_miss: begin
              if(L1.size() == `L1Size) begin // L1 full, write back first
                 m = cachGen(write_back);
                 write(m);
                 L1.remove(m);
                 L2_h.remove(m);
              end

              // now there is space in L1 for sure
              m = cacheGen(operation);
              if(operation == read_miss)
                read(m);
              else
                write(m);
           end
           write_back: begin
              m = cachGen(write_back);
              m_rand.randomize(); // always write a different daya when write back
              m.copy_data(m_rand)
              write(m);
              L1.remove(m);
              L2_h.remove(m);
           end
         endcase

      end
      
   endtask
                                                                 

endclass // RandomProcessor

`endif //  `ifndef TC_RANDOM_PROCESSOR_H
