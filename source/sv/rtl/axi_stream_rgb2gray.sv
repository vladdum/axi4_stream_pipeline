`default_nettype none
module axi_stream_rgb2gray
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
  state_type state_reg, next_state;

  logic  [17:0] data_gray;
  logic  [23:0] tdata_reg;
  logic  [23:0] data_next;

  logic  [12:0] xsize;
  logic  [12:0] ysize;

  logic  [ 7:0] R;
  logic  [ 7:0] G;
  logic  [ 7:0] B;

  logic         tvalid_reg;
  logic         tlast_reg;
  logic         tready_reg;
  logic         imagsize;

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
    end else begin
      state_reg <= next_state;
    end
  end

//----------------------------------------------------------------------------------------------------
// Input colors
//----------------------------------------------------------------------------------------------------
  assign R = tdata_i[7:0];
  assign G = tdata_i[15:8];
  assign B = tdata_i[23:16];

//----------------------------------------------------------------------------------------------------
// Output buffer
//----------------------------------------------------------------------------------------------------
  always_ff @(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i) begin
      tvalid_reg <= 0;
      tlast_reg  <= 0;
      tdata_reg  <= 0;
      tready_reg <= 0;
    end else begin
      tvalid_reg <= tvalid_i;
      tlast_reg  <= tlast_i;
      tdata_reg  <= data_next;
      tready_reg <= tready_i;
    end
  end
  // Y = 0.299 R + 0.587 G + 0.114 B
//  assign data_gray = 306 * R + 601 * G + 117 * B;
//  assign data_next = data_gray[17:10] & {8{tvalid_i}};

  assign data_gray = 76 * R + 151 * G + 28 * B;
  //assign data_next = {{16{1'b0}},data_gray[15:8] & {8{tvalid_i}}};

//  assign data_gray = data_rgb[ 7: 2]+data_rgb[ 7: 5]+
//                     data_rgb[15: 9]+data_rgb[15:12]+
//                     data_rgb[23:20]+data_rgb[23:21];
//  assign tdata_o   = data_gray[7:0] & {8{tvalid_i}};

  assign imagsize  = (state_reg == Xsize) | (state_reg == Ysize);
      
  assign data_next = imagsize ? tdata_i:{{16{1'b0}},data_gray[15:8] & {8{tvalid_i}}};

  assign tready_o = tready_reg;
  assign tdata_o  = tdata_reg;
  assign tvalid_o = tvalid_reg;
  assign tlast_o  = tlast_reg;

endmodule // axi_stream_sl2m
`default_nettype wire