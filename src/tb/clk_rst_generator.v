module clk_rst_generator(
    output reg clk,
    output reg rst_n
);

initial begin
    clk   = 0;
    forever begin 
        #5 	clk=~clk;
    end
end

initial begin
    rst_n = 0;
    repeat(10) @(posedge clk);
    rst_n = 1;
end 

endmodule