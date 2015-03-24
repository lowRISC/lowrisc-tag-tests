// a testing package for testing tag cache

`include "config.svh"

package cache_pkg;

   // definition of cache blocks
`include "packet.svh"

   // definition of cache
`include "cache.svh"

   // global scoreboard to record memory read/write
`include "cache_recorder.svh"

   // definition of a processor
`include "processor.svh"

   // random processor tester
`include "random_processor.svh"

   // behavioural memory
`include "memory.svh"

   // drivers
`include "tilelink_driver.svh"
`include "mem_driver.svh"

   // the test environment
`include "cache_env.svh"

endpackage // cache_pkg
   
