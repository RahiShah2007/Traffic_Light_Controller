`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 16:43:02
// Design Name: 
// Module Name: tb_signal_ctrl_sys
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


module tb_signal_ctrl_sys;
reg clk;
reg clr;
reg X;
wire[1:0] hwy;
wire[1:0] cty;
traffic_ctrl_sys uut(
.hwy(hwy),
.cty(cty),
.X(X),
.clk(clk),
.clr(clr)
);
always #10clk=~clk;
initial begin
clk=0;
clr=1;
X=0;

#10 clr=0; //reset

#20 X=0;//no car on cty road

#20 X=1; //Car on cty road

#50 X=1;//car stop for sometime

#30 X=0;//car leaves

#40 X=1;//next car arrives;

#100 $finish; 
end
endmodule
