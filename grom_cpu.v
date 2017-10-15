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
	reg[7:0] VALUE;   // Temp reg for storing 2nd operand
	reg[3:0] SEG;    // Segment regiser
	reg[7:0] R[0:3]; // General purpose registers
  
  
	parameter STATE_RESET   	 = 3'b000;
	parameter STATE_FETCH_PREP	 = 3'b001;
	parameter STATE_FETCH_WAIT   = 3'b010;
	parameter STATE_FETCH        = 3'b011;
	parameter STATE_EXECUTE      = 3'b100;
	parameter STATE_FETCH_VALUE  = 3'b101;
	parameter STATE_FETCH_VALUE2 = 3'b110;
	parameter STATE_EXECUTE_DBL  = 3'b111;

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

						state <= STATE_FETCH_PREP;
					end

				STATE_FETCH_PREP :
					begin
						addr  <= PC;
						we    <= 0;
						ioreq <= 0;

						state <= STATE_FETCH_WAIT;
					end

				STATE_FETCH_WAIT :
					begin
						// Sync with memory due to CLK
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
						//$display("PC=%h", PC);
						//$display("IR=%h", IR);
						$display("    R0 %h R1 %h R2 %h R3 %h", R[0], R[1], R[2], R[3]);
						//
					    if (IR[7])
						begin
							//$display("2nd fetch needed %h %h",PC,  IR[7] );							
							addr  <= PC;
							state <= STATE_FETCH_VALUE;
							PC    <= PC + 1;							
						end
						else
						begin
							case(IR[6:4]) 
								3'b000 :
									begin
										$display("MOV R%d,R%d",IR[3:2],IR[1:0]);
										// MOV dest,src instruction
										R[IR[3:2]] <= R[IR[1:0]];
									end
								3'b001 :
									begin
										
									    // Register instuctions
										case(IR[3:2])
											2'b00 : begin 
													R[IR[1:0]] <= 0;
													$display("CLR R%d",IR[1:0]);
													end
											2'b01 : begin
													R[IR[1:0]] <= R[IR[1:0]] + 1;
													$display("INC R%d",IR[1:0]);
													end
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
							state <= STATE_FETCH_PREP;
						end
					end			
				STATE_FETCH_VALUE :
					begin						
						state <= STATE_FETCH_VALUE2;
					end
				STATE_FETCH_VALUE2 :
					begin						
						VALUE <= data_in;
						state <= STATE_EXECUTE_DBL;
					end
				STATE_EXECUTE_DBL :
					begin
						VALUE <= data_in;
						case(IR[6:4]) 
							3'b000 :
								begin
									$display("JMP %h ",{IR[3:0], VALUE[7:0] });
									PC    <= { IR[3:0], VALUE[7:0] };
									addr  <= { IR[3:0], VALUE[7:0] };
									we    <= 0;
									ioreq <= 0;
								end
							3'b001 :
								begin
									$display("JC instruction");
								end
							3'b010 :
								begin
									$display("JNC instruction");
								end
							3'b011 :
								begin
									$display("JM instruction");
								end
							3'b100 :
								begin
									$display("JP instruction");
								end
							3'b101 :
								begin
									$display("JZ instruction");
								end
							3'b110 :
								begin
									$display("JNZ instruction");
								end
							3'b111 :
								begin
									$display("Special instruction");
								end									
						endcase						
						state <= STATE_FETCH_PREP;
					end
			endcase
		end
	end
endmodule