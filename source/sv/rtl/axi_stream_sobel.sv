`default_nettype none
module axi_stream_sobel
(
//-------------------------------------------
// System interaface
//-------------------------------------------
  input  wire         clk_i,
  input  wire         rst_n_i,
//-------------------------------------------
// Slave input
//-------------------------------------------
  input  wire         tvalid_i,
  output wire         tready_o,
  input  wire         tlast_i,
  input  wire [23:0]  tdata_i,
//-------------------------------------------
// Master Output
//-------------------------------------------
  output wire         tvalid_o,
  input  wire         tready_i,
  output wire         tlast_o,
  output wire [23:0]  tdata_o
);
//----------------------------------------------------------------------------------------------------
// Signal definition
//----------------------------------------------------------------------------------------------------
  typedef enum logic [1:0] {Xsize, Ysize,IMdat} state_type;
  state_type state_reg, next_state,state_1d_reg,state_2d_reg;

  logic [0:2][7:0] sliding [0:2];
  logic [9:0] gx1, gx2, gy1, gy2;
  logic [9:0] gx, gy;
  logic [10:0] g;

  logic  [12:0] xsize;
  logic  [12:0] ysize;

  logic         tready_1d_reg;
  logic         tready_2d_reg;
  logic         tvalid_1d_reg;
  logic         tvalid_2d_reg;
  logic         tlast_1d_reg;
  logic         tlast_2d_reg;
  logic [23:0]  tdata_2d_reg;
  logic [23:0]  data_next;
  logic [ 7:0]  g_next;

  logic [ 7:0]  tdata_next;
  logic         tvalid_next;

//----------------------------------------------------------------------------------------------------
// FSM
//----------------------------------------------------------------------------------------------------
  always_comb begin
    next_state = state_reg;
    case (state_reg)
      Xsize : if (tvalid_i) next_state = Ysize;
      Ysize : if (tvalid_i) next_state = IMdat;
      IMdat : if (tlast_i ) next_state = Xsize;
      default : next_state = Ysize;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i) begin
      state_reg <= Xsize;
      state_1d_reg <= Xsize;
      state_2d_reg <= Xsize;
    end else begin
      state_reg    <= next_state;
      state_1d_reg <= state_reg;
      state_2d_reg <= state_1d_reg;
    end
  end

//----------------------------------------------------------------------------------------------------
// 
//----------------------------------------------------------------------------------------------------
  always_ff @(posedge clk_i or negedge rst_n_i)
    if (~rst_n_i) begin
      xsize <= 0;
      ysize <= 0;
    end
    else if (tvalid_i) begin
      if(state_reg == Xsize)
        xsize <= tdata_i;
      if(state_reg == Ysize)
        ysize <= tdata_i;
    end

  assign tdata_next  = (state_reg == IMdat) ? tdata_i[7:0] : 0;
  assign tvalid_next = (state_reg == IMdat) ? tvalid_i : 0;

//----------------------------------------------------------------------------------------------------
// Input colors
//----------------------------------------------------------------------------------------------------
axi_stream_sliding_window sliding_window(
  .clk_i        (clk_i      ),
  .rst_n_i      (rst_n_i    ),
  .inpPixel_i   (tdata_next ),
  .validpixel_i (tvalid_next),
  .ysize_i      (xsize      ),
  .sliding_o    (sliding    )
);

//----------------------------------------------------------------------------------------------------
// Output buffer
//----------------------------------------------------------------------------------------------------
  always_ff @(posedge clk_i or negedge rst_n_i)
    if (~rst_n_i) begin
      gx1 <= 0;
      gx2 <= 0;
      gy1 <= 0;
      gy2 <= 0;
    end
    else if (tvalid_1d_reg) begin
      gx1 <= sliding[2][2] + sliding[0][2] + (sliding[1][2]<<1);
      gx2 <= sliding[2][0] + sliding[0][0] + (sliding[1][0]<<1);
      gy1 <= sliding[2][2] + sliding[2][0] + (sliding[0][1]<<1);
      gy2 <= sliding[0][2] + sliding[0][0] + (sliding[2][1]<<1);
    end


  always_ff @(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i) begin
      tvalid_1d_reg <= 0;
      tvalid_2d_reg <= 0;
      tlast_1d_reg  <= 0;
      tlast_2d_reg  <= 0;
      tdata_2d_reg  <= 0;
      tready_1d_reg <= 0;
      tready_2d_reg <= 0;
    end else begin
      tvalid_1d_reg <= tvalid_i;
      tvalid_2d_reg <= tvalid_1d_reg;
      tlast_1d_reg  <= tlast_i;
      tlast_2d_reg  <= tlast_1d_reg;
      tdata_2d_reg  <= data_next;
      tready_1d_reg <= tready_i;
      tready_2d_reg <= tready_1d_reg;
    end
  end

  assign gx = (gx1 > gx2) ? (gx1 - gx2):(gx2 - gx1);
  assign gy = (gy1 > gy2) ? (gy1 - gy2):(gy2 - gy1);

  // To get the gradient intensity the U and V gradient needs to be combined using the Euclidean distance.  
  // The Euclidean distance requires to perform the square of each gradient and then perform a square-root of the addition.
  // Square roots are very expensive to perform on an FPGA, so we can choose to approximate the Euclidean distance by summing the absolute values.  
  // This saves quite a lot of FPGA area and improves the performance of the system.
  assign g = gy+gx;
  assign g_next = g[10] ? {8{1'b1}}:g[9:2];
  assign data_next = (state_1d_reg == Xsize) ?  xsize  : (state_1d_reg == Ysize) ?  ysize : {{16{1'b0}},g_next};

  assign tready_o = tready_2d_reg;
  assign tdata_o  = tdata_2d_reg;
  assign tvalid_o = tvalid_2d_reg;
  assign tlast_o  = tlast_2d_reg;

endmodule // axi_stream_sl2m
`default_nettype wire