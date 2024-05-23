module master_top;

  localparam DWIDTH = 8;
  localparam M = 32;

master_vldrdy #(
  .DWIDTH(DWIDTH)
) i_master_vldrdy (
        // system
  .clk   (clk   ),  // [o]synchronous active on rising edge
  .rst_n (rst_n ),  // [o]asynchronous, active low
  .cfg_en(cfg_en),  // [i]enable, active high
                                               // protocol can be violated on disable
        // 8 bit output flow     
  .dst_val     (dst_val     ),  // [i]valid, active high
  .dst_rdy     (dst_rdy     ),  // [o]ready, active high
  .dst_data    (dst_data    ),  // [i]data, steady on valid
  .read_counter(read_counter)   // [i]
);


        // system
logic                clk          ;  // synchronous active on rising edge
logic                rst_n        ;  // asynchronous, active low
logic                cfg_en       ;  // enable, active high  
logic                dst_val      ;  // valid, active high
logic                dst_rdy      ;  // ready, active high
logic [DWIDTH -1: 0] dst_data     ;  // data, steady on valid
logic                read_counter ;
logic [DWIDTH -1: 0] mem [M -1: 0];


initial begin
  clk <= 'd0;
    forever begin
      #10 clk = ~clk;
    end
end

initial begin
  rst_n   <= 0;
  dst_rdy <= 0;
  @(posedge clk);
  rst_n   <= 1;
  repeat(10) @(posedge clk);
  dst_rdy <= 1;
  repeat(30) @(posedge clk);
  dst_rdy <= 0;
  $stop;
end

// always @(posedge clk or negedge rst_n)
// if(dst_val & dst_rdy) mem <= dst_data;


endmodule