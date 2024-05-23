//-------------------------------------------------------------------------------------------------
// Description     : A 8 bit data flow should be converted into a 16 bit data flow.
//                   Both sides uses valid-ready protocols.
//                   The module has an enable (cfg_en) active high.
//-------------------------------------------------------------------------------------------------
// Modification history :
// May 23, 2024  : DN, initial
//-------------------------------------------------------------------------------------------------

module flow_8to16 (
// system
input                   clk      ,  // synchronous active on rising edge
input                   rst_n    ,  // asynchronous, active low
input                   cfg_en   ,  // enable, active high
                                    // protocol can be violated on disable
// 8 bit input flow       
input                   src_val  ,  // valid, active high
output reg              src_rdy  ,  // ready, active high
input      [8-1:0]      src_data ,  // data, steady on valid
// 16 bit output flow     
output reg              dst_val  ,  // valid, active high
input                   dst_rdy  ,  // ready, active high
output reg [16-1:0]     dst_data    // data, steady on valid
);

// place your code here

endmodule // flow_8to16