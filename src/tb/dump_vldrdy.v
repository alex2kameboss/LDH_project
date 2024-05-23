module dump_vldrdy#(
    parameter DATAW = 16
)(
    input clk,
    input valid,
    input ready,
    input cfg_en,
    input [DATAW - 1 : 0] data
);

integer fd;
initial begin
    if(DATAW == 8)
        fd = $fopen("file_out8b.raw", "wb");
    else
        fd = $fopen("file_out16b.raw", "wb");
end

always @(posedge clk)
    if(valid & ready & cfg_en) begin
        if (DATAW == 8) begin
            $fwriteb(fd, data);
            $fwriteb(fd, "\n");
        end
        else if (DATAW == 16) begin
            $fwriteb(fd, data);
            $fwriteb(fd, "\n");
        end
    end

endmodule