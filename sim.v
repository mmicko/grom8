`timescale 1ns/1ps 
module sim();
	reg clk = 0;
	reg reset;
	wire [7:0] display_out;
	wire hlt;

	grom_computer computer(.clk(clk),.reset(reset),.hlt(hlt),.display_out(display_out));

	always
		#(5) clk <= !clk;

	initial
	begin
		$dumpfile("grom.vcd");
		$dumpvars(0,sim);
		reset = 1;
		#20
		reset = 0;
		#900
		$finish;
	end
endmodule
