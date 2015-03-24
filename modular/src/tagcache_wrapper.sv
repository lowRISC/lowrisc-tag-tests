// Wrapper for the tag cache

module TagCacheWrapper 
  ( 
    interface clock, 
    interface uc_acq, 
    interface uc_gnt,
    interface uc_fin,
    interface mem_cmd,
    interface mem_data,
    interface mem_resp
    );

   TagCache
     TC (
         .clk                                              ( clock.clk                     ),
         .reset                                            ( clock.reset                   ),
         .init                                             ( clock.init                    ),
         .io_uncached_acquire_ready                        ( uc_acq.ready                  ),
         .io_uncached_acquire_valid                        ( uc_acq.valid                  ),
         .io_uncached_acquire_bits_header_src              ( uc_acq.header.src             ),
         .io_uncached_acquire_bits_header_dst              ( uc_acq.header.dst             ),
         .io_uncached_acquire_bits_payload_addr            ( uc_acq.payload.addr           ),
         .io_uncached_acquire_bits_payload_client_xact_id  ( uc_acq.payload.client_xact_id ),
         .io_uncached_acquire_bits_payload_data            ( uc_acq.payload.data           ),
         .io_uncached_acquire_bits_payload_a_type          ( uc_acq.payload.a_type         ),
         .io_uncached_acquire_bits_payload_write_mask      ( uc_acq.payload.write_mask     ),
         .io_uncached_acquire_bits_payload_subword_addr    ( uc_acq.payload.subword_addr   ),
         .io_uncached_acquire_bits_payload_atomic_opcode   ( uc_acq.payload.atomic_opcode  ),
         .io_uncached_grant_ready                          ( uc_gnt.ready                  ),
         .io_uncached_grant_valid                          ( uc_gnt.valid                  ),
         .io_uncached_grant_bits_header_src                ( uc_gnt.header.src             ),
         .io_uncached_grant_bits_header_dst                ( uc_gnt.header.dst             ),
         .io_uncached_grant_bits_payload_data              ( uc_gnt.payload.data           ),
         .io_uncached_grant_bits_payload_client_xact_id    ( uc_gnt.payload.client_xact_id ),
         .io_uncached_grant_bits_payload_master_xact_id    ( uc_gnt.payload.master_xact_id ),
         .io_uncached_grant_bits_payload_g_type            ( uc_gnt.payload.g_type         ),
         .io_uncached_finish_valid                         ( uc_fin.valid                  ),
         .io_uncached_finish_bits_header_src               ( uc_fin.header.src             ),
         .io_uncached_finish_bits_header_dst               ( uc_fin.header.dst             ),
         .io_uncached_finish_bits_payload_master_xact_id   ( uc_fin.payload.master_xact_id ),
         .io_mem_req_cmd_ready                             ( mem_req.ready                 ),
         .io_mem_req_cmd_valid                             ( mem_req.valid                 ),
         .io_mem_req_cmd_bits_addr                         ( mem_req.addr                  ),
         .io_mem_req_cmd_bits_tag                          ( mem_req.tag                   ),
         .io_mem_req_cmd_bits_rw                           ( mem_req.rw                    ),
         .io_mem_req_data_ready                            ( mem_data.ready                ),
         .io_mem_req_data_valid                            ( mem_data.valid                ),
         .io_mem_req_data_bits_data                        ( mem_data.data                 ),
         .io_mem_resp_valid                                ( mem_resp.valid                ),
         .io_mem_resp_bits_data                            ( mem_resp.data                 ),
         .io_mem_resp_bits_tag                             ( mem_resp.tag                  )
         );

endmodule // TagCacheWrapper

     
