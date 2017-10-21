module ram_memory(
  input clk,
  input [11:0] addr,
  input [7:0] data_in,
  input we,
  output reg [7:0] data_out,
  input memreq
);

  reg [7:0] store[0:4095] /* verilator public_flat */;

  initial
  begin
	$readmemh("boot.mem", store);
	store[0] <= 8'b11100001; // MOV DS,1
	store[1] <= 8'b00000001; // 
	store[2] <= 8'b01010100; // LOAD R1,[R0]	
	store[3] <= 8'b00110001; // INC R1
	store[4] <= 8'b00110001; // INC R1	
	store[5] <= 8'b01100001; // STORE [R0],R1
	store[6] <= 8'b11010001; // OUT [0],R1
	store[7] <= 8'b00000000; // 
	store[8] <= 8'b00110001; // INC R1
	store[9] <= 8'b11010001; // OUT [0],R1
	store[10] <= 8'b00000000; // 
	store[11] <= 8'b01111111; // HLT
  end

  always @(posedge clk)
	if (memreq)
	begin
		if (we)
		begin
		  if (addr[11:8]==4'hf) 
		  begin
			$display("stack write[%h]=%h", addr, data_in);
		  end
		  if (addr[11:8]==4'hd) 
		  begin
			$display("data write [%h]=%h",addr,  data_in);
		  end
		  store[addr] <= data_in;
		end
		else
		begin
		  if (addr[11:8]==4'hf) 
		  begin
			$display("stack read [%h]=%h", addr, store[addr]);
		  end
		  if (addr[11:8]==4'hd) 
		  begin
			$display("data read [%h]=%h", addr, store[addr]);
		  end
		  data_out <= store[addr];
		end
	end
endmodule
