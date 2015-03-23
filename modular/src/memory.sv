// Memory interface, memory block and memory controller

// Memory Request Command
interface MemReqCMDInf;
   logic valid, ready;
   
   logic [`MIFAddrBits-1:0] addr;
   logic [`MIFTagBits-1:0]  tag;
   logic                    rw;
endinterface // MemReqCMDInf

// Memory Request Data
interface MemDataInf;
   logic valid, ready;

   logic [`MIFDataBits-1:0] data;
endinterface // MemDataInf

// Memory Response
interface MemRespInf;
   logic valid;
   
   logic [`MIFDataBits-1:0] data;
   logic [`MIFTagBits-1:0]  tag;
endinterface // MemRespInf


