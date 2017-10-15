module grom_cpu(
	input clk,
	input reset,
	output reg [11:0] addr,
	input [7:0] data_in,
	output reg [7:0] data_out,
	output reg we,
	output reg ioreq
);

	reg[11:0] PC;    // Program counter
	reg[7:0] IR;     // Instruction register
	reg[3:0] SEG;    // Segment regiser
	reg[7:0] R[0:3]; // General purpose registers
  
  
	parameter STATE_RESET   	 = 3'b000;
	parameter STATE_RESET_WAIT	 = 3'b001;
	parameter STATE_FETCH_PREP   = 3'b010;
	parameter STATE_FETCH        = 3'b011;
	parameter STATE_EXECUTE      = 3'b100;

	reg [2:0] state = STATE_RESET;
	reg		  HLT = 0;    // Halt state

	
    always @(posedge clk)
	begin
		if (reset)
		begin
			state <= STATE_RESET;
			HLT   <= 0;
		end      
		else
		begin
			case (state)
				STATE_RESET :
					begin
						PC  <= 12'h000;
						SEG <= 4'h0;
						addr  <= 0;
						we    <= 0;
						ioreq <= 0;

						state <= STATE_RESET_WAIT;
					end
				STATE_RESET_WAIT :
					begin
						// Sync with memory due to CLK
						state <= STATE_FETCH_PREP;
					end
				STATE_FETCH_PREP :
					begin
						addr  <= PC;
						we    <= 0;
						ioreq <= 0;

						state <= (HLT) ? STATE_FETCH_PREP : STATE_FETCH;						
					end
				STATE_FETCH :
					begin
						IR    <= data_in;
						PC    <= PC + 1;
						
						state <= STATE_EXECUTE;
					end
				STATE_EXECUTE :
					begin
						$display("fetch %h", IR);
						$display("    R0 %h R1 %h R2 %h R3 %h", R[0], R[1], R[2], R[3]);
					    if (IR[7])
						begin
							$display("2nd fetch needed");
						end
						else
						begin
							case(IR[6:4]) 
								3'b000 :
									begin
										$display("MOV instruction");
										// MOV dest,src instruction
										R[IR[3:2]] <= R[IR[1:0]];
									end
								3'b001 :
									begin
										$display("Register %h",IR[3:2]);
									    // Register instuctions
										case(IR[3:2])
											2'b00 : R[IR[1:0]] <= 0;
											2'b01 : R[IR[1:0]] <= R[IR[1:0]] + 1;
											2'b10 : R[IR[1:0]] <= R[IR[1:0]] - 1;
											2'b11 : R[IR[1:0]] <= ~R[IR[1:0]];
										endcase
									end
								3'b010 :
									begin
										$display("ALU instruction");
									end
								3'b011 :
									begin
										$display("ALU instruction");
									end
								3'b100 :
									begin
										$display("ALU instruction");
									end
								3'b101 :
									begin
										$display("LOAD instruction");
									end
								3'b110 :
									begin
										$display("STORE instruction");
									end
								3'b111 :
									begin
										$display("Special instruction");
									    // Register instuctions
										case(IR[3:2])
											2'b00 : SEG <= R[IR[1:0]][3:0];
											2'b01 : R[IR[1:0]] <= {4'b0000, SEG };
											2'b10 : SEG <= 4'b0000;
											2'b11 : begin
													HLT <= 1;
													$display("HALT");
												end
										endcase									
									end									
							endcase
						end
												
						state <= STATE_FETCH_PREP;
					end
				
			endcase
		end
	end
endmodule