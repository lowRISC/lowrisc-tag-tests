// define all macros

`ifndef TC_CONFIG_H
 `define TC_CONFIG_H

//-------------- Simulation related macros ------------//

// No. of cores
 `define NCore 4
// the size of L1 cache
 `define L1Size 1024
// the frequency of LD/ST operation in MHz
 `define LD_ST_Freq 2
// the warming up time in ns
 `define WarmUpTime 2000
// the depth of MemIF queues
 `define MemIFQueDepth 8
// clock period
 `define ClkPeriod 10
// the delay for the memory
 `define MemDly 30*(`ClkPeriod)
// the ratio of memory delay veriation
 `define MemDlyRRatio 0.5

//-------------- Hardware parameters ------------------//

// the number of tag bits attached to eadh 64-bit double word
// `define TagBits 4
// the width of a pyshical address
 `define PAddrBits 32
// the number of end points, including masters and clients
 `define LNEndpoints  2
// the width of addresses on TileLink channels
 `define TLAddrBits 26
// the bit size of the client transaction id field
 `define TLClientXactIdBits 5
// the bit size of the master transaction id field
 `define TLMasterXactIdBits 1
// the width of the data in one TileLink message
 `define TLDataBits 136
// the number of beats
 `define TLDataBeats 4
// the bit size of the Acquire type field
 `define acquireTypeWidth 2
 `define acquireUncachedRead 0
 `define acquireUncachedWrite 1
 `define acquireUncachedAtomic 2
// the bit size of the Grant type field
 `define grantTypeWidth 2
 `define grantUncachedRead 0
 `define grantUncachedWrite 1
 `define grantUncachedAtomic 2
// the bit width of sub-block field
 `define TLSubblockBits 129
// the width of the address on the memory interface
 `define MIFAddrBits 26
// the bit width of the tag field in memory messages
 `define MIFTagBits 5
// the width of data in a memory data message
 `define MIFDataBits 128
// the number of beats
 `define MIFDataBeats 4
`endif //  `ifndef TC_CONFIG_H
