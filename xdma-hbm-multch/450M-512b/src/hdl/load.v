`timescale 1ns / 1ns
`define SYNTH
//////////////////////////////////////////////////////////////////////////////////
// Company: 浪潮信息
// Engineer: 邓子为
//////////////////////////////////////////////////////////////////////////////////

module load #(
  parameter ID_GROUP    = 0,
  parameter LENGTH      = 8,
  parameter SIZE_LOOP   = 8,
  parameter DWIDTH_FFT  = 32,
  parameter SIZE_GROUP  = 8,
  parameter AWIDTH_HBM  = 64,
  parameter DWIDTH_LOAD = 32,
  parameter DWIDTH_BRAM = 64,
  parameter AWIDTH_BRAM = 10
  ) (
  input                        sclk,
  input                        rst_n,
  input                        launch,     //外部输入的启动信号
  output reg  [SIZE_GROUP-1:0] wea_load,   //写入fft模块BRAM的使能信号
  output reg [AWIDTH_BRAM-1:0] addra_load, //BRAM A端口地址
  output reg [AWIDTH_BRAM-1:0] addrb_load, //BRAM B端口地址
  output reg                   start_load, //开始进行FFT计算
  input                        upload,     //可以回传数据
  output reg                   done_upload, //计算结果写回BRAM完成

  output     [DWIDTH_BRAM-1:0] dout_load0, //写入BRAM的数据
  output     [DWIDTH_BRAM-1:0] dout_load1,
  output     [DWIDTH_BRAM-1:0] dout_load2,
  output     [DWIDTH_BRAM-1:0] dout_load3,
  output     [DWIDTH_BRAM-1:0] dout_load4,       
  output     [DWIDTH_BRAM-1:0] dout_load5,
  output     [DWIDTH_BRAM-1:0] dout_load6,
  output     [DWIDTH_BRAM-1:0] dout_load7,
  
  input      [DWIDTH_BRAM-1:0] din_load0,  //从BRAM中读出的数据
  input      [DWIDTH_BRAM-1:0] din_load1,
  input      [DWIDTH_BRAM-1:0] din_load2,
  input      [DWIDTH_BRAM-1:0] din_load3,
  input      [DWIDTH_BRAM-1:0] din_load4,  
  input      [DWIDTH_BRAM-1:0] din_load5,
  input      [DWIDTH_BRAM-1:0] din_load6,
  input      [DWIDTH_BRAM-1:0] din_load7,

  input                        axi_awready, //与HBM的接口信号
  output                       axi_awvalid,
  output      [AWIDTH_HBM-1:0] axi_awaddr,
  input                        axi_wready,	
  output                       axi_wvalid,
  output   [DWIDTH_LOAD*8-1:0] axi_wdata,	
  output     [DWIDTH_LOAD-1:0] axi_wstrb,
  output                       axi_wlast,	
  output                       axi_bready,
  input                        axi_bvalid,
  input                  [1:0] axi_bresp,	
  //output                 [3:0] axi_awid,	
  output                 [7:0] axi_awlen,	
  output                 [2:0] axi_awsize,
  output                 [1:0] axi_awburst,
  //output                 [2:0] axi_awprot,
  output                 [3:0] axi_awcache,	
  input                        axi_arready,
  output                       axi_arvalid,
  output      [AWIDTH_HBM-1:0] axi_araddr,
  output                       axi_rready,
  input                        axi_rvalid,
  input    [DWIDTH_LOAD*8-1:0] axi_rdata,
  input                        axi_rlast,	     
  input                  [1:0] axi_rresp,	 
  //output                 [3:0] axi_arid,
  output                 [7:0] axi_arlen,	
  output                 [2:0] axi_arsize,
  output                 [1:0] axi_arburst,	
  //output                 [2:0] axi_arprot,
  output                 [3:0] axi_arcache
);

localparam BURST_LEN = LENGTH;              //突发传送长度
localparam NUM_AREA  = 8;                   //每个分区存储中核的数量
localparam SIZE_AREA = SIZE_GROUP/NUM_AREA; //每个平面每个分组存储的数量
localparam SIZE_CH   = SIZE_AREA*SIZE_LOOP; //突发传输的次数
localparam ADDR_CORE = LENGTH*NUM_AREA*DWIDTH_FFT*2/8; //每个区域的地址空间大小
localparam ADDR_LOOP = ADDR_CORE*SIZE_AREA; //每个平面每个分组的地址空间大小
`ifdef SYNTH
localparam ADDR_START = ID_GROUP==0  ? 'h0000_0000 : 
                       (ID_GROUP==1  ? 'h1000_0000 : 
                       (ID_GROUP==2  ? 'h2000_0000 : 
                       (ID_GROUP==3  ? 'h3000_0000 : 
                       (ID_GROUP==4  ? 'h4000_0000 : 
                       (ID_GROUP==5  ? 'h5000_0000 : 
                       (ID_GROUP==6  ? 'h6000_0000 : 
                       (ID_GROUP==7  ? 'h7000_0000 : 
                       (ID_GROUP==8  ? 'h8000_0000 : 
                       (ID_GROUP==9  ? 'h9000_0000 : 
                       (ID_GROUP==10 ? 'ha000_0000 : 
                       (ID_GROUP==11 ? 'hb000_0000 : 
                       (ID_GROUP==12 ? 'hc000_0000 : 
                       (ID_GROUP==13 ? 'hd000_0000 : 
                       (ID_GROUP==14 ? 'he000_0000 : 
                       'hf000_0000))))))))))))));
`else
localparam ADDR_START = 0;
`endif

// axi接口
wire                     awready;
reg                      awvalid;
reg     [AWIDTH_HBM-1:0] awaddr;
reg                [1:0] awburst;
reg                [3:0] awcache;
reg                [7:0] awlen;
reg                [2:0] awsize;
wire                     wready;
reg                      wvalid;
reg  [DWIDTH_LOAD*8-1:0] wdata;
reg    [DWIDTH_LOAD-1:0] wstrb;
reg                      wlast;
reg                      bready;
wire                     bvalid;
wire               [1:0] bresp;
wire                     arready;
reg                      arvalid;
reg     [AWIDTH_HBM-1:0] araddr;
reg                [1:0] arburst;
reg                [3:0] arcache;
reg                [7:0] arlen;
reg                [2:0] arsize;
reg                      rready;
wire                     rvalid;
wire [DWIDTH_LOAD*8-1:0] rdata;
wire                     rlast;
wire               [1:0] rresp;

assign awready     = axi_awready;
assign axi_awvalid = awvalid;
assign axi_awaddr  = awaddr;
assign axi_awburst = awburst;
assign axi_awcache = awcache;
assign axi_awlen   = awlen;
assign axi_awsize  = awsize;
assign wready      = axi_wready;
assign axi_wvalid  = wvalid;
assign axi_wdata   = wdata;
assign axi_wstrb   = wstrb;
assign axi_wlast   = wlast;
assign bvalid      = axi_bvalid;
assign bresp       = axi_bresp;
assign axi_bready  = bready;

assign arready      = axi_arready;
assign axi_arvalid  = arvalid;
assign axi_araddr   = araddr;
assign axi_arburst  = arburst;
assign axi_arcache  = arcache;
assign axi_arlen    = arlen;
assign axi_arsize   = arsize;
assign axi_rready   = rready;
assign rvalid       = axi_rvalid;
assign rdata        = axi_rdata;
assign rlast        = axi_rlast;
assign rresp        = axi_rresp;

integer i;
wire [DWIDTH_BRAM-1:0] rdata0 [NUM_AREA-1:0];
generate for (genvar m=0; m<NUM_AREA; m=m+1) begin
  assign rdata0[m] = rdata[DWIDTH_BRAM*(m+1)-1:DWIDTH_BRAM*m];
end
endgenerate

reg rstn;
always @(posedge sclk or negedge rst_n) begin
  if (!rst_n) begin
    rstn <= 0;
  end
  else begin
    rstn <= 1;
  end
end

reg [DWIDTH_BRAM-1:0] dout_load [SIZE_GROUP-1:0];
assign dout_load0 = dout_load[0];
assign dout_load1 = dout_load[1];
assign dout_load2 = dout_load[2];
assign dout_load3 = dout_load[3];
assign dout_load4 = dout_load[4];
assign dout_load5 = dout_load[5];
assign dout_load6 = dout_load[6];
assign dout_load7 = dout_load[7];

wire [DWIDTH_BRAM-1:0] din_load [SIZE_GROUP-1:0];
assign din_load[0]  = din_load0;
assign din_load[1]  = din_load1;
assign din_load[2]  = din_load2;
assign din_load[3]  = din_load3;
assign din_load[4]  = din_load4;
assign din_load[5]  = din_load5;
assign din_load[6]  = din_load6;
assign din_load[7]  = din_load7;

reg [1:0] launch_d;
always @(posedge sclk or negedge rstn) begin
  if (!rstn) begin
    launch_d <= 0;
  end
  else begin
    launch_d <= {launch_d[0], launch};
  end
end
assign launch_rise = ({launch_d[0], launch_d[1]} == 2'b10) ? 1 : 0;

/**************************** 写数据到HBM ****************************/
localparam WCH_IDLE  = 0;
localparam WCH_READY = 1; //写地址
localparam WCH_WAIT  = 2; //等待BRAM数据有效
localparam WCH_WDATA = 3; //写数据
localparam WCH_RESP  = 4; //写响应
localparam WCH_SUSP  = 5; //每次突发传输间隔

reg   [2:0] wch_state;
reg  [15:0] wdata_cnt; //每次突发传输的数据计数
reg  [15:0] wch_cnt;   //突发传输次数计数
reg   [3:0] ready_cnt; //等待bram数据有效
reg   [7:0] loop_cnt_wch; //平面计数
reg   [4:0] core_cnt_wch; //平面内计数
reg [SIZE_GROUP-1:0] rda; //从BRAM中读出数据使能

always @(posedge sclk) begin
  if (!rstn) begin
    wch_state <= WCH_IDLE;
    awvalid   <= 0;
    awaddr    <= 0;
    awburst   <= 1;
    awcache   <= 3;
    awlen     <= BURST_LEN-1;
    awsize    <= 6;
    wvalid    <= 0;
    wdata     <= 0;
    wstrb     <= {DWIDTH_LOAD{1'b0}};
    wlast     <= 0;
    bready    <= 0;
    wch_cnt   <= 0;
    wdata_cnt <= 0;
    ready_cnt <= 0;
    rda       <= 0;
    done_upload <= 0;
    loop_cnt_wch <= 0;
    core_cnt_wch <= 0;
  end
  else begin
    case (wch_state)
      WCH_IDLE: begin
        if (upload) begin
          wch_state <= WCH_READY;
          awvalid   <= 1;
          awaddr    <= ADDR_START;
        end
        else begin
          wch_state <= WCH_IDLE;
          done_upload  <= 0;
          loop_cnt_wch <= 0;
          core_cnt_wch <= 0;
        end
      end
      WCH_READY: begin
        if (awready)begin
          awvalid <= 0;
          wch_state <= WCH_WAIT;
          wdata_cnt <= 0;
        end
        else
          wch_state <= WCH_READY;
      end
      WCH_WAIT: begin
        for (i=0; i<SIZE_GROUP; i=i+1) begin
          if (i<core_cnt_wch*NUM_AREA) begin
            rda[i] <= 0;
          end
          else if (i<(core_cnt_wch+1)*NUM_AREA) begin
            rda[i] <= 1;
          end
          else begin
            rda[i] <= 0;
          end
        end
        if (ready_cnt<4)begin
          wch_state <= WCH_WAIT;
          ready_cnt <= ready_cnt+1;
        end
        else begin
          wch_state <= WCH_WDATA;
          ready_cnt <= 0;
        end
      end
      WCH_WDATA: begin
        wvalid    <= 1;
        wstrb     <= {DWIDTH_LOAD{1'b1}};
        for (i=0; i<SIZE_GROUP; i=i+1) begin
          if (i<core_cnt_wch*NUM_AREA) begin
            rda[i] <= 0;
          end
          else if (i<(core_cnt_wch+1)*NUM_AREA) begin
            rda[i] <= wdata_cnt<BURST_LEN-5 ? 1 : 0;
          end
          else begin
            rda[i] <= 0;
          end
        end
        wdata <= {din_load[core_cnt_wch*NUM_AREA+7],
                  din_load[core_cnt_wch*NUM_AREA+6],
                  din_load[core_cnt_wch*NUM_AREA+5],
                  din_load[core_cnt_wch*NUM_AREA+4],
                  din_load[core_cnt_wch*NUM_AREA+3], 
                  din_load[core_cnt_wch*NUM_AREA+2], 
                  din_load[core_cnt_wch*NUM_AREA+1], 
                  din_load[core_cnt_wch*NUM_AREA]};
        if (wdata_cnt == BURST_LEN-1) begin
          wch_cnt   <= wch_cnt + 1;
          wch_state <= WCH_WDATA;
          wlast     <= 1;
          wdata_cnt <= wdata_cnt + 1;
        end
        else if (wdata_cnt == BURST_LEN) begin
          wch_state <= WCH_RESP;
          wvalid    <= 0;
          wlast     <= 0;
          bready    <= 1;
          wstrb     <= {DWIDTH_LOAD{1'b0}};
        end
        else begin
          wch_state <= WCH_WDATA;
          wdata_cnt <= wdata_cnt + 1;
        end
      end
      WCH_RESP: begin
        if (bvalid) begin
          wch_state <= WCH_SUSP;
          bready    <= 0;
          wlast     <= 0;
          loop_cnt_wch <= wch_cnt / SIZE_AREA;
          core_cnt_wch <= wch_cnt % SIZE_AREA;
        end
        else
          wch_state <= WCH_RESP;
      end
      WCH_SUSP: begin
        if (wch_cnt > SIZE_CH-1) begin
          wch_state <= WCH_IDLE;
          awvalid   <= 0;
          awaddr    <= 0;
          wvalid    <= 0;
          wdata     <= 0;
          bready    <= 0;
          wch_cnt   <= 0;
          done_upload  <= 1;
        end
        else begin
          wch_state <= WCH_READY;
          awvalid   <= 1;
          awaddr    <= ADDR_START + ADDR_LOOP*loop_cnt_wch + ADDR_CORE*core_cnt_wch;
        end
      end
      default: begin
        wch_state <= WCH_IDLE;
        awvalid   <= 0;
        awaddr    <= 0;
        wvalid    <= 0;
        wdata     <= 0;
        bready    <= 0;
        wch_cnt   <= 0;
        wdata_cnt <= 0;
        ready_cnt <= 0;
      end
    endcase
  end
end

/**************************** 从HBM读出数据 ****************************/
localparam RCH_IDLE  = 0;
localparam RCH_READY = 1;
localparam RCH_RDATA = 2;
localparam RCH_SUSP  = 3;

reg  [2:0] rch_state;
reg [15:0] rch_cnt;   //突发传输次数计数
reg [15:0] rdata_cnt; //每次突发传输的数据计数
reg  [7:0] loop_cnt_rch; //平面计数
reg  [4:0] core_cnt_rch; //平面内计数

always @(posedge sclk) begin
  if (!rstn) begin
    rch_state <= RCH_IDLE;
    arvalid   <= 0;
    araddr    <= 0;
    arburst   <= 1;
    arcache   <= 3;
    arlen     <= BURST_LEN-1;
    arsize    <= 6;
    rready    <= 0;
    rch_cnt   <= 0;
    rdata_cnt <= 0;
    wea_load  <= 0;
    start_load   <= 0;
    loop_cnt_rch <= 0;
    core_cnt_rch <= 0;
    for (i=0; i<SIZE_GROUP; i=i+1) begin
      dout_load[i] <= 0;
    end
  end
  else begin
    case (rch_state)
      RCH_IDLE: begin
        if (launch_rise) begin
          rch_state <= RCH_READY;
          arvalid   <= 1;
          araddr <= ADDR_START;
        end
        else begin
          rch_state <= RCH_IDLE;
          wea_load  <= 0;
          start_load   <= 0;
          loop_cnt_rch <= 0;
          core_cnt_rch <= 0;
        end
      end
      RCH_READY: begin
        if (arready) begin
          rch_state <= RCH_RDATA;
          arvalid   <= 0;
          rready    <= 1;
          rdata_cnt <= 0;
        end
        else
          rch_state <= RCH_READY;
      end
      RCH_RDATA: begin
        for (i=0; i<SIZE_GROUP; i=i+1) begin
          if (i<core_cnt_rch*NUM_AREA) begin
            wea_load[i] <= 0;
          end
          else if (i<(core_cnt_rch+1)*NUM_AREA) begin
            wea_load[i] <= rvalid ? 1 : 0;
          end
          else begin
            wea_load[i] <= 0;
          end
        end
        if (rvalid) begin
          for (i=0; i<NUM_AREA; i=i+1) begin
            dout_load[i+core_cnt_rch*NUM_AREA] <= rdata0[i];
          end
          rdata_cnt <= rdata_cnt + 1;
          rch_state <= rlast ? RCH_SUSP : RCH_RDATA;
          rch_cnt   <= (rdata_cnt==BURST_LEN-2) ? rch_cnt + 1 : rch_cnt;
          loop_cnt_rch <= rch_cnt / SIZE_AREA;
          core_cnt_rch <= rch_cnt % SIZE_AREA;
        end
        else begin
          rch_state <= RCH_RDATA;
        end
      end
      RCH_SUSP: begin
        if (rch_cnt>=SIZE_CH)begin
          rch_state <= RCH_IDLE;
          arvalid   <= 0;
          araddr    <= 0;
          rready    <= 0;
          wea_load  <= 0;
          rch_cnt   <= 0;
          start_load<= 1;
        end
        else begin
          rch_state <= RCH_READY;
          arvalid   <= 1;
          araddr    <= ADDR_START + ADDR_LOOP*loop_cnt_rch + ADDR_CORE*core_cnt_rch; 
          rready    <= 0;
          wea_load  <= 0;
        end
      end
      default: begin
        rch_state <= RCH_IDLE;
        arvalid   <= 0;
        araddr    <= 0;
        rready    <= 0;
        rch_cnt   <= 0;
        rdata_cnt <= 0;
        wea_load  <= 0;
      end
    endcase
  end
end

/**************************** BRAM地址 ****************************/
always @(posedge sclk or negedge rstn) begin
  if (!rstn) begin
    addra_load <= 0;
  end
  else if (loop_cnt_rch == SIZE_CH/SIZE_AREA)
    addra_load <= 0;
  else if (rdata_cnt==BURST_LEN)
    addra_load <= BURST_LEN*loop_cnt_rch;
  else if (wea_load)
    addra_load <= addra_load + 1;
end

always @(posedge sclk or negedge rstn) begin
  if (!rstn) begin
    addrb_load <= 0;
  end
  else if (loop_cnt_wch == SIZE_CH/SIZE_AREA)
    addrb_load <= 0;
  else if (wdata_cnt==BURST_LEN)
    addrb_load <= BURST_LEN * loop_cnt_wch;
  else if (rda)
    addrb_load <= addrb_load + 1;
end

/*
generate if (ID_GROUP==0 || ID_GROUP==1)
  ila_load ila_load_i (
    .clk(sclk),
    .probe0(awready),
    .probe1(awvalid),
    .probe2(awaddr),
    .probe3(wready),
    .probe4(wvalid),
    .probe5(wdata),
    .probe6(wstrb),
    .probe7(wlast),
    .probe8(arready),
    .probe9(arvalid),
    .probe10(araddr),
    .probe11(rready),
    .probe12(rvalid),
    .probe13(rdata),
    .probe14(rlast),
    .probe15(wea_load),
    .probe16(addra_load),
    .probe17(dout_load0),
    .probe18(din_load1),
    .probe19(launch_d[0]),
    .probe20(launch_rise),
    .probe21(rch_state),
    .probe22(loop_cnt_rch),
    .probe23(core_cnt_rch),
    .probe24(start_load)
  );
endgenerate
*/
endmodule

