// define all macros

// the number of tag bits attached to eadh 64-bit double word
`define TagBits 4

// the width of a pyshical address
`define PAddrBits 32

// the number of end points, including masters and clients
`define LNEndpoints  2

// the width of addresses on TileLink channels
`define TLAddrBits 26

// the bit size of the client transaction id field
`define TLClientXactIdBits 3

// the bit size of the master transaction id field
`define TLMasterXactIdBits 1;

// the width of the data in one TileLink message
`define TLDataBits 544

// the bit size of the Acquire type field
`define acquireTypeWidth 3

// the bit width of write mask field
`define TLWriteMaskBits 6

// the bit width of word address field
`define TLWordAddrBits 3

// the bit width of the atomic operation
`define TLAtomicOpBits 4

// the width of the address on the memory interface
`define MIFAddrBits

// the bit width of the tag field in memory messages
`define MIFTagBits

// the width of data in a memory data message
`define MIFDataBits

// the size of L1 cache
`define L1Size 1024

// the frequency of LD/ST operation in MHz
`define LD_ST_Freq 2

// the warming up time in ns
`define WarmUpTime 2000
