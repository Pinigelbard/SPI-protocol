`timescale 1ns / 1ps
module spi_protocol(
input clk,
input [11:0] din,
input start,
output reg cs,mosi,done,
output sclk
    );
    integer count = 0;
    reg sclkt = 0;
    parameter idle = 0;
    parameter start_tx = 1;
    parameter send     = 2;
    parameter endtx    = 3;
    reg [1:0] state = idle;
    reg [11:0] temp;
    integer bitcount = 0;
    always@(posedge clk) begin
    if(count < 10)
    count <= count + 1;
    else begin
    sclkt <= ~sclkt;
    count <= 0;
    end
    end
    always@(posedge sclkt)
    begin
    case(state)
    
    idle : begin
    mosi <= 1'b0;
    done <= 1'b0;
    cs <= 1'b1;
    if(start) begin
    state <= start_tx;
    end
    else
    state <= idle;
    end
    
    start_tx : begin
    cs   <= 1'b0;
    temp <= din;
    state <= send;
    end
    
    send: begin
    if(bitcount <= 11) begin
    bitcount <= bitcount + 1;
    mosi     <= temp [bitcount];
    state    <= send;
    end
    else begin
    state <= endtx;
    bitcount <= 1'b0;
    mosi  <= 1'b0;
    end
    end
    
    endtx: begin
    cs <= 1'b1;
    state <= idle;
    done <= 1'b1;
    end
    
    default :
    state <= idle;
    endcase
    end
      
    assign sclk = sclkt;
    endmodule
