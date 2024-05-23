//-------------------------------------------------------------------------------------------------
// Description     : A 16 bit data flow should be converted into a 8 bit data flow.
//                   Both sides uses valid-ready protocols.
//                   The module has an enable (cfg_en) active high.
//-------------------------------------------------------------------------------------------------
// Modification history :
// May 23, 2024  : DN, initial
//-------------------------------------------------------------------------------------------------

module flow_16to8(
// system
input                   clk      ,  // synchronous active on rising edge
input                   rst_n    ,  // asynchronous, active low
input                   cfg_en   ,  // enable, active high
                                    // protocol can be violated on disable
// 16 bit input flow       
input                   src_val  ,  // valid, active high
output reg              src_rdy  ,  // ready, active high
input      [16-1:0]     src_data ,  // data, steady on valid
// 8 bit output flow     
output reg              dst_val  ,  // valid, active high
input                   dst_rdy  ,  // ready, active high
output reg [8-1:0]      dst_data    // data, steady on valid
);
reg cnt;
wire output_accepted;
wire inp_val;

assign inp_val = src_val & src_rdy & cfg_en;
assign output_accepted = dst_val & dst_rdy ;

always @(posedge clk or negedge rst_n)
if (~rst_n)             cnt <= 1'b0   ; else
if (~cfg_en)            cnt <= 1'b0   ; else
if (output_accepted)    cnt <= ~cnt;

always @(posedge clk or negedge rst_n)
if (~rst_n)       dst_data <= 1'b0                                   ; else
if (~cfg_en)      dst_data <= 1'b0                                   ; else
                  dst_data <= cnt ? src_data[15:8] : src_data[7:0];

always @(posedge clk or negedge rst_n)
if (~rst_n)                 src_rdy <= 1'b1; else
if (inp_val)                src_rdy <= 1'b0; else
if (cnt & output_accepted)  src_rdy <= 1'b1; 

always @(posedge clk or negedge rst_n)
if (~rst_n)                dst_val <= 1'b0; else
if (~cfg_en)               dst_val <= 1'b0; else
if (inp_val)               dst_val <= 1'b1; else
if (cnt & output_accepted) dst_val <= 1'b0;
                                 
endmodule // flow_16to8