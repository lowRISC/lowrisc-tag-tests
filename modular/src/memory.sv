// Memory interface, memory block and memory controller

// Memory Request Command
interface MemReqCMD;

   logic [`MIFAddrBits-1:0] addr;
   logic [`MIFTagBits-1:0]  tag;
   logic                    rw;

endinterface // MemReqCMD

// Memory Request Data
interface MemDataInf;

   logic [`MIFDataBits-1:0] data;

endinterface // MemDataInf

// Memory Request Command
interface MemReqCMDInf;
   
   logic [`MIFAddrBits-1:0] addr;
   logic [`MIFTagBits-1:0]  tag;
   logic                    rw;

endinterface // MemReqCMDInf

// Memory Response
interface MemRespInf;
   
   logic [`MIFDataBits-1:0] data;
   logic [`MIFTagBits-1:0]  tag;

endinterface // MemRespInf


