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
      logic [`TLWriteMaskBits-1:0]    write_mask;
      logic [`TLWordAddrBits-1:0]     subword_addr;
      logic [`TLAtomicOpBits-1:0]     atomic_opcode
   } payload;
   
endinterface // TLinkAcquireInf

// TileLink Grant
interface TLinkGrantInf;
   logic valid;
   logic ready;
   
   TLink_header_t header;

   struct {
      logic [`TLClientXactIdBits-1:0] client_xact_id;      // client transaction identifier
      logic [`TLMasterXactIdBits-1:0] master_xact_id;      // master transaction identifier
      logic [`TLDataBits-1:0]         data;
      logic [`grantTypeWidth-1:0]     g_type;              // message type
   } payload;
   
endinterface // TLinkGrantInf

// TileLink Finish
interface TLinkFinishInf;
   logic valid;
   logic ready;
   
   TLink_header_t header;

   typedef struct {
      logic [`TLMasterXactIdBits-1:0] master_xact_id;      // master transaction identifier
   } payload;
   
endinterface // TLinkFinishInf
