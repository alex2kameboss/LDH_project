module master_vldrdy #(
  parameter DWIDTH = 8
) (
  // system
  input                   clk         ,  // synchronous active on rising edge
  input                   rst_n       ,  // asynchronous, active low
  output reg              cfg_en      ,  // enable, active high
                                         // protocol can be violated on disable
  // 8 bit output flow     
  output reg              dst_val     ,  // valid, active high
  input                   dst_rdy     ,  // ready, active high
  output reg [DWIDTH-1:0] dst_data    ,  // data, steady on valid
  output reg [9: 0]       read_counter 
);

// Parameters
localparam int    M        = 32             ; // Number of lines 32x (8 or 16 bits)
localparam string FILENAME = "/home/raul/Desktop/Master/Anul1/Sem2/HDL/proiect_echipa/LDH_project/src/tb/master_vldrdy/file_in8b.raw"; // File name

// Register to store the input file data
reg [DWIDTH -1:0] mb_data [M- 1: 0];

task read_data(string FILENAME, int M); // (filename, number of rows)
  // Variables for file I/O
  int file;
  int i;
  reg [DWIDTH -1:0] value;
  int r;
  
  // Open the file
  file = $fopen(FILENAME, "r");
  $display("GOOD: File opened");
  if (file == 0) begin
    $display("Error: Failed to open file %s", FILENAME);
    $finish;
  end

  // Read the data from the file and store it in the register
  // for (i = 0; i < M; i = i + 1) begin
    while (1) begin
      r = $fscanf(file, "%b", value);
      if (r == 1) begin
        mb_data[i] = value;
        $display("Good: Value = %b", mb_data[i]);
        read_counter = read_counter + 1;
      end
      else begin
        break;
      end
    end
  // end

  // Close the file
  $fclose(file);

  // Display the contents of the register array
  $display("Contents of mb_data_in:");
  for (i = 0; i < M; i = i + 1) begin
    $display("%0d: %0d", i, mb_data[i]);
  end
endtask

//send data on 8 bits eg: [00] [01] [02]
task send_8bit_data(int i, int M);
  dst_data = mb_data[i];
endtask

//send data on 16 bits eg: [0001] [0203] [0405]
task send_16bit_data(int i, int M);
  dst_data = {mb_data[i], mb_data[i+1]};
endtask

initial begin

  @(posedge rst_n);
  dst_val  <= 0;
  dst_data <= 0;
  read_data(FILENAME, M);

  repeat(10) @(posedge clk);

  case(DWIDTH)
    8: //8-bit
    begin
      dst_val  <= 1;
      cfg_en   <= 1;
      @(posedge clk iff dst_rdy && cfg_en && dst_val);
      begin
        for(int i = 0; i < M; i = i+1)
          send_8bit_data(i, M);
          @(negedge dst_rdy);
          dst_val  <= 0;
      end
    end
    16: //16-bit
    begin
      dst_val  <= 1;
      cfg_en   <= 1;
      @(posedge clk iff dst_rdy && cfg_en && dst_val);
      begin
        for(int i = 0; i < M; i = i+2)
          send_16bit_data(i, M);
          @(negedge dst_rdy);
          dst_val  <= 0;
      end
    end
  endcase

end

endmodule