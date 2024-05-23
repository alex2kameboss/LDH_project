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

reg counter;

wire valid_input;
assign valid_input = ~dst_val & (src_rdy & src_val) & cfg_en;

always@(posedge clk)
    if(valid_input)     dst_data<={src_data,dst_data[15:8]};

// place your code here

always @(posedge clk or rst_n)
if(~rst_n)                  src_rdy <= 1'b1;    else
if(dst_val & dst_rdy)       src_rdy <= 1'b1;    else
if(counter & valid_input)   src_rdy <= 1'b0;      

always @(posedge clk or rst_n)
    if (~rst_n)         counter <= 'd0;             else
    if (valid_input)    counter <= ~counter;     

always @(posedge clk or rst_n)
    if (~rst_n)                 dst_val <= 1'b0;            else
    if (counter & valid_input)  dst_val <= 1'b1;            else
    if (dst_val & dst_rdy)      dst_val <= 1'b0;

endmodule // flow_8to16