// the driver for TileLink on-chip communication

`ifndef TC_TILELINK_DRIVER_H
 `define TC_TILELINK_DRIVER_H

class AcquireDriver;
   
   virtual TLinkAcquireInf acq;
   virtual ClockInf clock;
   
   protected mailbox Acquire_h;

   function new (mailbox acq_h);
      Acquire_h = acq_h;
   endfunction // new
   
   task execute;
      
      wait(clock.reset == 1'b1);

      acq.valid = 1'b0;
      
      @(negedge clock.reset);
      @(posedge clock.clk);
      #0.1;
      
      while(1'b1) begin
         AcquireMessage m;
         automatic int i = 0;

         acq.valid = 1'b0;
         if(!Acquire_h.try_get(m)) begin
            Acquire_h.get(m);
            @(posedge clock.clk);
            #0.1;
         end

         while(i==0 || (m.write && i<`TLDataBeats)) begin
            acq.payload.addr = m.addr;
            acq.payload.client_xact_id = m.core_id;
            acq.payload.uncached = 1'b1;
            if(m.write) begin
               acq.payload.a_type = `acquireUncachedWrite;
               acq.payload.data = m.data[`TLDataBits:0];
               m.data = m.data >> `TLDataBits;
            end else
              acq.payload.a_type = `acquireUncachedRead;

            acq.valid = 1'b1;

            #0.1;
            
            while(acq.ready != 1'b1) begin
               @(posedge clock.clk);
               #0.1;
            end

            i++;
            
            @(posedge clock.clk);
            #0.1;
               
         end // while (i==0 || (m.write && i<`TLDataBeats))
      end // while (1'b1)
   endtask // while

endclass // AcquireDriver


class GrantDriver #(int NCore = 2);

   virtual TLinkGrantInf gnt;
   virtual ClockInf clock;
   
   protected mailbox Grant_h [NCore-1:0];

   function new(mailbox gnt_h[NCore-1:0]);
      foreach(Grant_h[i]) Grant_h[i] = gnt_h[i];
   endfunction // new

   task execute;
      wait(clock.reset == 1'b1);

      gnt.ready = 1'b0;
      
      @(negedge clock.reset);
      @(posedge clock.clk);
      #0.1;
      
      gnt.ready = 1'b1;
      
      while(1'b1) begin
         GrantMessage m = new();
         automatic int i = 0;
         automatic int core_id = NCore; // an impossible core
         
         while(i<`TLDataBeats) begin
            if(gnt.valid) begin
               core_id = gnt.payload.client_xact_id;
               m.data[i*`TLDataBits +: `TLDataBits] = gnt.payload.data;
               i++;
            end
            
            @(posedge clock.clk);
            #0.1;
         end

         gnt.ready = 1'b0;
         if(!Grant_h[core_id].try_put(m)) begin
            $display("%t  Error! Grant queue for core %d is full.", 
                     $time, core_id);
            #10 $finish();
         end
         gnt.ready = 1'b1;
      end
   endtask // while

endclass // GrantDriver

`endif
