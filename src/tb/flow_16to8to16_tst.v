module flow_16to8to16_tst();

parameter DATAW = 16;

wire clk;
wire rst_n;
reg cfg_en = 1;
wire master_flow0_valid;
wire master_flow0_ready;
wire [DATAW-1:0] master_flow0_data;

wire slave_flow1_valid;
wire slave_flow1_ready;
wire [DATAW-1:0] slave_flow1_data;

wire dump_valid;
wire dump_ready;
wire [8-1:0] dump_data;

clk_rst_generator clk_gen (
    .clk (clk),
    .rst_n (rst_n)
);

master_vldrdy #(
  .DWIDTH(DATAW)
) master_vldrdy_inst (
  .clk      ( clk                   ),
  .rst_n    ( rst_n                 ),
  .cfg_en   ( cfg_en                ),
  .dst_val  ( master_flow0_valid    ),
  .dst_rdy  ( master_flow0_ready    ),
  .dst_data ( master_flow0_data     )
);

vld_rdy_checker #(
    .DATA_WIDTH (24)
) master_vld_rdy_checker(     
    .clk   (clk                 ) ,
    .rst_n (rst_n               ) ,
    .ready (master_flow0_ready  ) ,
    .valid (master_flow0_valid  ) ,
    .data  (master_flow0_data   )   
);

flow_8to16 flow_8to16_inst(
.clk      (clk),  // synchronous active on rising edge
.rst_n    (rst_n),  // asynchronous, active low
.cfg_en   (cfg_en),  // enable, active high  
.src_val  (master_flow0_valid),  // valid, active high
.src_rdy  (master_flow0_ready),  // ready, active high
.src_data (master_flow0_data),  // data, steady on valid
.dst_val  (dump_valid),  // valid, active high
.dst_rdy  (dump_ready),  // ready, active high
.dst_data (dump_data)   // data, steady on valid
);

dump_vldrdy#(
    .DATAW  (DATAW)
)dumo_vldrdy_inst(
    .clk    (clk)       ,
    .valid  (dump_valid),
    .ready  (dump_ready),
    .cfg_en (cfg_en)    ,
    .data   (dump_data)
);

vld_rdy_checker #(
    .DATA_WIDTH (24)
) dump_vld_rdy_checker(     
    .clk   (clk         )  ,     
    .rst_n (rst_n       )  , 
    .ready (dump_ready  )  ,
    .valid (dump_valid  )  ,
    .data  (dump_data   )   
);

flow_16to8 flow_16to8_inst(
.clk      (clk),
.rst_n    (rst_n),
.cfg_en   (cfg_en),
.src_val  (dump_valid),
.src_rdy  (dump_ready),
.src_data (dump_data),
.dst_val  (slave_flow1_valid),
.dst_rdy  (slave_flow1_ready),
.dst_data (slave_flow1_data)
);

slave_vldrdy #(
    .DWIDTH (DATAW)
)slave_vldrdy_inst(
 .clk         (clk)                 ,  
 .rst_n       (rst_n)               , 
 .cfg_en      (cfg_en)              , 
 .dst_val     (slave_flow1_valid)   , 
 .dst_rdy     (slave_flow1_ready)   , 
 .dst_data    (slave_flow1_data)    , 
 .read_counter(read_counter)
);

vld_rdy_checker #(
    .DATA_WIDTH (24)
) slave_vld_rdy_checker(     
    .clk   (clk                 ),   
    .rst_n (rst_n               ),
    .ready (slave_flow1_ready   ),                                                                           
    .valid (slave_flow1_valid   ),                                                                           
    .data  (slave_flow1_data    ) 
);

endmodule