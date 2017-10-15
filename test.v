module test();
	reg clk = 0;
	wire [11:0] addr;
	wire [7:0] memory_out;
	wire [7:0] memory_in;
	wire mem_enable;
	wire we;
	reg reset;

	grom_cpu cpu(.clk(clk),.reset(reset),.addr(addr),.data_in(memory_out),.data_out(memory_in),.we(we),.ioreq(ioreq));

	assign mem_enable = we & ~ioreq;

	ram_memory memory(.clk(clk),.addr(addr),.data_in(memory_in),.we(mem_enable),.data_out(memory_out));


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
		$finish;
	end
endmodule
