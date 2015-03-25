// TileLink interface

typedef struct {
   logic [`LNEndpoints-1:0] src;
   logic [`LNEndpoints-1:0] dst;
} TLink_header_t;


// TileLink Acquire
interface TLinkAcquireInf;
   logic valid;
   logic ready;
   
   TLink_header_t header;

   struct {
      logic [`TLAddrBits-1:0]         addr;                // physical address
      logic [`TLClientXactIdBits-1:0] client_xact_id;      // client transaction identifier
      logic [`TLDataBits-1:0]         data;
      logic                           uncached;
      logic [`acquireTypeWidth-1:0]   a_type;              // message type
      logic [`TLSubblockBits-1:0]     subblock;
   } payload;

   function bit is_write();
      return (payload.a_type == `acquireUncachedWrite) || (payload.a_type == `acquireUncachedAtomic);
   endfunction // is_write

   function bit is_read();
      return (payload.a_type == `acquireUncachedRead) || (payload.a_type == `acquireUncachedAtomic);
   endfunction // is_read
   
endinterface // TLinkAcquireInf

// TileLink Grant
interface TLinkGrantInf;
   logic valid;
   logic ready;
   
   TLink_header_t header;

   struct {
      logic [`TLClientXactIdBits-1:0] client_xact_id;      // client transaction identifier
      logic [`TLMasterXactIdBits-1:0] manager_xact_id;     // manager transaction identifier
      logic [`TLDataBits-1:0]         data;
      logic [`grantTypeWidth-1:0]     g_type;              // message type
   } payload;
   
endinterface // TLinkGrantInf

// TileLink Finish
interface TLinkFinishInf;
   logic valid;
   logic ready;
   
   TLink_header_t header;

   struct {
      logic [`TLMasterXactIdBits-1:0] manager_xact_id;     // manager transaction identifier
   } payload;
   
endinterface // TLinkFinishInf

