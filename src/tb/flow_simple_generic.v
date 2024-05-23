module flow_simple_generic#(
    parameter TYPE = 0 
)
();

localparam DWIDTH = TYPE ? 16: 8;

wire clk;
wire rst_n;

clk_rst_generator i_clk(
    .clk   (clk)  ,
    .rst_n (rst_n)
);

wire master_dut_val;
wire master_dut_rdy;
wire master_dut_data;

master_vldrdy #(
  .DWIDTH (DWIDTH)
) i_master  (
  // system
  .clk      (clk),  // synchronous active on rising edge
  .rst_n    (rst_n),  // asynchronous, active low
  .cfg_en   (cfg_en),  // ena.            // protocol can be violated on disable
  .dst_val  (master_dut_val),  // valid, active high
  .dst_rdy  (master_dut_rdy),  // ready, active high
  .dst_data (master_dut_data),   // data, steady on valid
  .read_counter()
);


wire dut_slave_val;
wire dut_slave_rdy;
wire dut_slave_data;




generate
    if(TYPE==0)
        begin: flow8to16
            flow_8to16 i_flow_8to16 (
            // system
            .clk      (clk),  // synchronous active on rising edge
            .rst_n    (rst_n),  // asynchronous, active low
            .cfg_en   (cfg_en),  // enable, active high

            .src_val  (master_dut_val),  // valid, active high
            .src_rdy  (master_dut_rdy),  // ready, active high
            .src_data (master_dut_data),  // data, steady on valid

            .dst_val  (dut_slave_val),  // valid, active high
            .dst_rdy  (dut_slave_rdy),  // ready, active high
            .dst_data (dut_slave_data)   // data, steady on valid
            );
        end
    else
        begin: flow16to8
        flow_16to8 i_flow_16to8 (
            // system
            .clk      (clk),  // synchronous active on rising edge
            .rst_n    (rst_n),  // asynchronous, active low
            .cfg_en   (cfg_en),  // enable, active high

            .src_val  (master_dut_val),  // valid, active high
            .src_rdy  (master_dut_rdy),  // ready, active high
            .src_data (master_dut_data),  // data, steady on valid

            .dst_val  (dut_slave_val),  // valid, active high
            .dst_rdy  (dut_slave_rdy),  // ready, active high
            .dst_data (dut_slave_data)   // data, steady on valid
            );
        end
endgenerate

slave_vldrdy #(
    .DWIDTH (DWIDTH)
)
i_slave
(
    .clk      (clk),  // synchronous active on rising edge
    .rst_n    (rst_n),  // asynchronous, active low
    .cfg_en   (cfg_en),  // enable, active high
                   // protocol can be violated on disable
        
    .dst_val  (dut_slave_val),  // valid, active high
    .dst_rdy  (dut_slave_rdy),  // ready, active high
    .dst_data (dut_slave_data),   // data, steady on valid
    .read_counter()
);

vld_rdy_checker #(
    .DATA_WIDTH(DWIDTH) // Data width;
)  
i_checker1    
(     
    .clk    (clk) , // System clock;                                                  
    .rst_n  (rst_n) , // Asynchronous reset, active low;                .
    .ready  (master_dut_rdy) , // frame ready                                                                          
    .valid  (master_dut_val) , // frame valid                                                                          
    .data   (master_dut_data)   // cfg nr of bits using DATA_WIDTH parameter, Pixel read chanel bus;  
);

vld_rdy_checker  #(
    .DATA_WIDTH(DWIDTH) // Data width;
)   
i_checker2  
(     
    .clk    (clk) , // System clock;                                                  
    .rst_n  (rst_n) , // Asynchronous reset, active low;                .
    .ready  (dut_slave_rdy) , // frame ready                                                                          
    .valid  (dut_slave_val) , // frame valid                                                                          
    .data   (dut_slave_data)  // cfg nr of bits using DATA_WIDTH parameter, Pixel read chanel bus;  
);



endmodule