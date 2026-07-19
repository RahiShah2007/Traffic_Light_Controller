`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 15:42:36
// Design Name: 
// Module Name: traffic_ctrl_sys
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define TRUE 1'b1
`define FALSE 1'b0
`define RED 2'd0
`define YELLOW 2'd1
`define GREEN 2'd2


//fsm definition       HWY       CTY
`define S0 3'd0  //    GREEN     RED
`define S1 3'd1  //    YELLOW    RED
`define S2 3'd2  //    RED       RED
`define S3 3'd3  //    RED       GREEN
`define S4 3'd4  //    RED       YELLOW

`define Y2RDELAY 3//delay between yellow and red
`define R2GDELAY 2//delay between red and green

module traffic_ctrl_sys(hwy,cty,X,clk,clr);
output [1:0] hwy,cty; //I/O port
reg[1:0] hwy,cty; //declared output signals are register
input X; //if TRUE then car is on cuty road otherwise False
input clk,clr;
parameter RED=2'd0,YELLOW=2'd1,GREEN=2'd2;
parameter S0=3'd0,S1=3'd1,S2=3'd2,S3=3'd3,S4=3'd4;
reg[2:0] state;
reg[2:0] next_state;
reg[2:0] count;
//initial state S0
initial begin
state=`S0;
next_state=`S0;
hwy=`GREEN;
cty=`RED;
count=0;
end
//state changes only at positive edge of clock so thereby we will declare posedge 
always @(posedge clk)
state<=next_state;
always @(state)
begin
    case(state)
        `S0: begin
                hwy=`GREEN;
                cty=`RED;
             end
        `S1: begin
                hwy=`YELLOW;
                cty=`RED;
             end
        `S2: begin
                hwy=`RED;
                cty=`RED;
             end 
        `S3: begin
                hwy=`RED;
                cty=`GREEN;
             end
        `S4: begin
                hwy=`RED;
                cty=`YELLOW;
             end
    endcase
end
//State machine using case statements
always @(state or clr or X)
begin
    if(clr)
    next_state=`S0;
else
    case(state)
        `S0:if(X)
            next_state=`S1;
          else
            next_state=`S0;
        `S1:begin
             if (count < `Y2RDELAY)
                next_state = `S1;
            else
                next_state = `S2;
             end 
        `S2: begin
            if (count < `R2GDELAY)
                next_state = `S2;
            else
                next_state = `S3;
             end 
        `S3: if(X)
              next_state=`S3;
             else
              next_state=`S4;
         `S4: begin
              if (count < `Y2RDELAY)
                 next_state = `S4;
             else
                 next_state = `S0;
              end
          default:next_state=`S0;
        endcase
    end
    
always @(posedge clk or posedge clr) begin
        if (clr)
            count <= 0;
        else begin
            case(state)
                `S1, `S2, `S4: count <= count + 1;
                default: count <= 0;
            endcase
        end
    end
endmodule
