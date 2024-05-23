module flow_simple_generic#(
    parameter TYPE = 0 
)
(
    input clk,
    input rst_n
);

localparam DWIDTH = TYPE ? 16: 8;

master_vldrdy i_master #(
  .DWIDTH (DWIDTH)
) (
  // system
  .clk      (),  // synchronous active on rising edge
  .rst_n    (),  // asynchronous, active low
  .cfg_en   (),  // ena.            // protocol can be violated on disable
  .dst_val  (),  // valid, active high
  .dst_rdy  (),  // ready, active high
  .dst_data (),   // data, steady on valid
  .read_counter()
)
generate
    if(!TYPE)
        begin:8to16
            flow_8to16 i_flow_8to16 (
            // system
            .clk      (),  // synchronous active on rising edge
            .rst_n    (),  // asynchronous, active low
            .cfg_en   (),  // enable, active high

            .src_val  (),  // valid, active high
            .src_rdy  (),  // ready, active high
            .src_data (),  // data, steady on valid

            .dst_val  (),  // valid, active high
            .dst_rdy  (),  // ready, active high
            .dst_data ()   // data, steady on valid
            )
        end
    else
        begin:16to8
        flow_16to8 i_flow_16to8 (
            // system
            .clk      (),  // synchronous active on rising edge
            .rst_n    (),  // asynchronous, active low
            .cfg_en   (),  // enable, active high

            .src_val  (),  // valid, active high
            .src_rdy  (),  // ready, active high
            .src_data (),  // data, steady on valid

            .dst_val  (),  // valid, active high
            .dst_rdy  (),  // ready, active high
            .dst_data ()   // data, steady on valid
            )
        end
endgenerate

slave_vldrdy i_slave(
    .DWIDTH (DWIDTH)
)
(
    .clk      (),  // synchronous active on rising edge
    .rst_n    (),  // asynchronous, active low
    .cfg_en   (),  // enable, active high
                   // protocol can be violated on disable
        
    .dst_val  (),  // valid, active high
    .dst_rdy  (),  // ready, active high
    .dst_data (),   // data, steady on valid
    .read_counter()
);

vld_rdy_checker i_checker1 #(
    .DATA_WIDTH(DWIDTH) // Data width;
)     
(     
    .clk    () , // System clock;                                                  
    .rst_n  () , // Asynchronous reset, active low;                .
    .ready  () , // frame ready                                                                          
    .valid  () , // frame valid                                                                          
    .data   ()   // cfg nr of bits using DATA_WIDTH parameter, Pixel read chanel bus;  
);

vld_rdy_checker i_checker2 #(
    .DATA_WIDTH(DWIDTH) // Data width;
)     
(     
    .clk    () , // System clock;                                                  
    .rst_n  () , // Asynchronous reset, active low;                .
    .ready  () , // frame ready                                                                          
    .valid  () , // frame valid                                                                          
    .data   ()   // cfg nr of bits using DATA_WIDTH parameter, Pixel read chanel bus;  
);

endmodule