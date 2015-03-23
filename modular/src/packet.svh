// define the packets used by caches

`ifndef TC_PACKET_H
`define TC_PACKET_H

typedef bit [`PAddrBits-1:0] cacheBlockAddr_t;

class CacheBlock;
   rand cacheBlockAddr_t addr;
   rand bit [`CacheBlockBytes*8-1:0] data;
   rand bit [`CacheBlockBytes*`TagBits/8-1:0] tag;

   constraint dw_align { addr[2:0] == 3'b000; }

   // a deep copy function
   virtual function void copy(CacheBlock rhs);
      addr = rhs.addr;
      data = rhs.data;
      tag = rhs.tag;
   endfunction // copy
   
   // a deep copy function for data only
   virtual function void copy_data(CacheBlock rhs);
      data = rhs.data;
      tag = rhs.tag;
   endfunction // copy_data

   // a deep copy function for address only
   virtual function void copy_addr(CacheBlock rhs);
      addr = rhs.addr;
   endfunction // copy_addr

   virtual function int is_equal(CacheBlock rhs);
      return
        (addr == rhs.addr) &&
        (data == rhs.data) &&
        (tag == rhs.tag);
   endfunction // is_equal

   virtual function string convert2string();
      $sformat(convert2string, "[%0h]%0h(%0h)", addr, data, tag);
   endfunction

endclass // CacheBlock

class AcquireMessage;
   bit write;                   // identify if this is a write message
   cacheBlockAddr_t addr;
   bit [`CacheBlockBytes*8-1:0] data;
   bit [`CacheBlockBytes*`TagBits/8-1:0] tag;

   function new(CacheBlock cb, bit w);
      write = w;
      addr = cb.addr;
      if(w) begin
         data = cb.data;
         tag = cb.tag;
      end else begin
         data = 0;
         tag = 0;
      end
   endfunction // new

   function CacheBlock extract();
      CacheBlock rv = new();
      rv.addr = addr;
      rv.data = data;
      rv.tag = tag;
   endfunction // extract
   
endclass // AcquireMessage

class GrantMessage;
   bit [`CacheBlockBytes*8-1:0] data;
   bit [`CacheBlockBytes*`TagBits/8-1:0] tag;

   function CacheBlock extract();
      CacheBlock rv = new();
      rv.data = data;
      rv.tag = tag;
   endfunction // extract
   
endclass // GrantMessage

`endif //  `ifndef TC_PACKET_H


