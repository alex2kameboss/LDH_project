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

reg [1:0] out_cnt;
//1 - dst_data = input[7:0]
//2 - dst_data = input[15:8]

wire inp_val;
assign inp_val = src_val & src_rdy;

always @(posedge clk or negedge rst_n)
if (~rst_n)            out_cnt <= 0          ; else
if (~cfg_en)           out_cnt <= 0          ; else
if (out_cnt == 2)      out_cnt <= 0          ; else
if (dst_val & dst_rdy) out_cnt <= out_cnt + 1;

always @(posedge clk or negedge rst_n)
if (~rst_n)       dst_data <= 0             ; else
if (~cfg_en)      dst_data <= 0             ; else
if (out_cnt == 1) dst_data <= src_data[15:8] ; else
if (out_cnt == 2) dst_data <= src_data[7:0];

always @(posedge clk or negedge rst_n)
if (~rst_n)                  src_rdy <= 0; else
if (~cfg_en)                 src_rdy <= 0; else
if (~dst_val & out_cnt == 0) src_rdy <= 1; else
                             src_rdy <= 0; 

always @(posedge clk or negedge rst_n)
if (~rst_n)       dst_val <= 0; else
if (~cfg_en)      dst_val <= 0; else
if (inp_val)      dst_val <= 1; else
if (out_cnt == 2) dst_val <= 0;
                                 
endmodule // flow_16to8