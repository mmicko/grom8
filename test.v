module test();
	reg clk = 0;
	reg reset;
	wire [7:0] display_out;
	wire hlt;

	grom_computer cpu(.clk(clk),.reset(reset),.hlt(hlt),.display_out(display_out));

	always
		#(5) clk <= !clk;

	initial
	begin
		$dumpfile("grom.vcd");
		$dumpvars(0,test);
		reset = 1;
		#20
		reset = 0;

		#300
		#300
		#300
		reset = 1;
		#20
		reset = 0;
		#300
		#300
		$finish;
	end
endmodule
