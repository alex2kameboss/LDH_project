module slave_vldrdy #(
    parameter DWIDTH = 8
)
(
    input                 clk      ,  // synchronous active on rising edge
    input                 rst_n    ,  // asynchronous, active low
    input                 cfg_en   ,  // enable, active high
                                        // protocol can be violated on disable
    // 16 bit output flow     
    input                 dst_val  ,  // valid, active high
    output                dst_rdy  ,  // ready, active high
    input  [DWIDTH-1:0]   dst_data    // data, steady on valid
);

int write_counter = 0;

integer fd;

initial begin
    if(DWIDTH == 8)
        fd = $fopen("file_output8b.raw","w" );
    else
        fd = $fopen("file_output16b.raw","w");
end

always @(posedge clk)
if (cfg_en && dst_val && dst_rdy)
begin
    write_counter++;
    if(DWIDTH == 'd8)
        $fwrite(fd,"%c",dst_data  );
    else
        $fwrite(fd,"%c%c",dst_data);
end

endmodule