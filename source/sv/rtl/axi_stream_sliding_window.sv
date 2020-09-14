`default_nettype none
module axi_stream_sliding_window
#(
    parameter row_size_g = 4096
)(
//-------------------------------------------
// System interaface
//-------------------------------------------
  input  wire             clk_i,
  input  wire             rst_n_i,
//-------------------------------------------
// input pixel information
//-------------------------------------------
  input  wire [7:0]       inpPixel_i,
  input  wire             validpixel_i,
  input  wire [12:0]      ysize_i,
//-------------------------------------------
// Sliding 3x3 window
//-------------------------------------------
  output wire [0:2][7:0]  sliding_o [0:2]
);

//----------------------------------------------------------------------------------------------------
// interal signals
//----------------------------------------------------------------------------------------------------
  logic [0:2][7:0]  sliding_reg [0:2];
  logic [15:0]      buffer_reg [row_size_g-1:0];
  logic [ 7:0]      test1,test2;
  logic [12:0]      ptr; //log2(512)-1
//----------------------------------------------------------------------------------------------------
// sliding 3x3 window & buffer
//----------------------------------------------------------------------------------------------------
  always_ff @(posedge clk_i or negedge rst_n_i) begin
    if(~rst_n_i) begin
      for(int i=0;i<3;i=i+1)
        for(int j=0;j<3;j=j+1)
        sliding_reg[i][j] <= 0;
      for(int i=0;i<row_size_g;i=i+1)
        buffer_reg[i] <= 0;
    end
    else if(validpixel_i) begin
      sliding_reg[0][2]   <= sliding_reg[1][2];
      sliding_reg[0][1]   <= sliding_reg[1][1];
      sliding_reg[0][0]   <= sliding_reg[1][0];
      sliding_reg[1][2]   <= sliding_reg[2][2];
      sliding_reg[1][1]   <= sliding_reg[2][1];
      sliding_reg[1][0]   <= sliding_reg[2][0];

      sliding_reg[2][1:2] <= buffer_reg[ptr];
      sliding_reg[2][0]   <= inpPixel_i;
      buffer_reg[ptr]     <= sliding_reg[0][0:1];
    end
  end
  assign test1 = sliding_reg[1][2];
  assign test2 = sliding_reg[2][2];
//----------------------------------------------------------------------------------------------------
// buffer pointer
//----------------------------------------------------------------------------------------------------
  always_ff @(posedge clk_i or negedge rst_n_i) begin
    if(~rst_n_i)
      ptr <=0;
    else if(ptr == 0)
      ptr <= ysize_i;
    else
      ptr <= ptr - 1;
  end
  
assign sliding_o = sliding_reg;
endmodule
`default_nettype wire