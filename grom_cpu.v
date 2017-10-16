module grom_cpu(
	input clk,
	input reset,
	output reg [11:0] addr,
	input [7:0] data_in,
	output reg [7:0] data_out,
	output reg we,
	output reg ioreq,
	output reg m1,
	output reg hlt
);

	reg[11:0] PC;    // Program counter
	reg[7:0] IR;     // Instruction register
	reg[7:0] VALUE;   // Temp reg for storing 2nd operand
	reg[3:0] CS;    // Code segment regiser
	reg[3:0] DS;    // Data segment regiser
	reg[7:0] R[0:3]; // General purpose registers
	
	parameter STATE_RESET             = 4'b0000;
	parameter STATE_FETCH_PREP        = 4'b0001;
	parameter STATE_FETCH_WAIT        = 4'b0010;
	parameter STATE_FETCH             = 4'b0011;
	parameter STATE_EXECUTE           = 4'b0100;
	parameter STATE_FETCH_VALUE_PREP  = 4'b0101;
	parameter STATE_FETCH_VALUE       = 4'b0110;
	parameter STATE_EXECUTE_DBL       = 4'b0111;
	parameter STATE_LOAD_VALUE_PREP   = 4'b1000;
	parameter STATE_LOAD_VALUE        = 4'b1001;
	parameter STATE_ALU_RESULT        = 4'b1010;

	reg [3:0] state = STATE_RESET;

	reg [7:0]  alu_a;
	reg [7:0]  alu_b;
	reg [3:0]  alu_op;
	
	reg [1:0]  RESULT_REG;
	
	wire [7:0] alu_res;
	wire alu_C;
	wire alu_Z;
	wire alu_S;
	integer jump;
	
	alu alu(.A(alu_a),.B(alu_b),.operation(alu_op),.result(alu_res),.C(alu_C),.Z(alu_Z),.S(alu_S));
	
	always @(posedge clk)
	begin
		if (reset)
		begin
			state <= STATE_RESET;
			hlt   <= 0;			
		end
		else
		begin
			case (state)
				STATE_RESET :
					begin
						PC    <= 12'h000;
						state <= STATE_FETCH_PREP;
					end

				STATE_FETCH_PREP :
					begin
						addr  <= PC;
						we    <= 0;
						ioreq <= 0;
						
						m1	  <= 1;

						state <= STATE_FETCH_WAIT;
					end

				STATE_FETCH_WAIT :
					begin
						m1	  <= 0;
						// Sync with memory due to CLK
						state <= (hlt) ? STATE_FETCH_PREP : STATE_FETCH;
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
						$display("    R0 %h R1 %h R2 %h R3 %h CS %h DS %h ALU [%d %d %d] ", R[0], R[1], R[2], R[3], CS, DS, alu_C,alu_S,alu_Z);
						//
						if (IR[7])
						begin
							addr  <= PC;
							state <= STATE_FETCH_VALUE_PREP;
							PC    <= PC + 1;
						end
						else
						begin
							state <= STATE_FETCH_PREP;
							case(IR[6:4])
								3'b000 :
									begin
										$display("MOV R%d,R%d",IR[3:2],IR[1:0]);
										// MOV dest,src instruction
										R[IR[3:2]] <= R[IR[1:0]];
									end
								3'b001 :
									begin
										alu_a   <= R[0];      // first input R0
										alu_b   <= R[IR[1:0]];
										RESULT_REG <= 0;         // result in R0
										alu_op  <= { 3'b000, IR[3:2] };
										
										state   <= STATE_ALU_RESULT;
										
										case(IR[3:2])
											2'b00 : begin													
													$display("ADD R%d",IR[1:0]);
													end
											2'b01 : begin
													$display("SUB R%d",IR[1:0]);
													end
											2'b10 : begin
													$display("ADC R%d",IR[1:0]);
													end
											2'b11 : begin
													$display("SBC R%d",IR[1:0]);
													end
										endcase
									end
								3'b010 :
									begin
										alu_a   <= R[0];      // first input R0
										alu_b   <= R[IR[1:0]];
										RESULT_REG <= 0;         // result in R0
										alu_op  <= { 3'b001, IR[3:2] };
										state   <= STATE_ALU_RESULT;
										case(IR[3:2])
											2'b00 : begin													
													$display("AND R%d",IR[1:0]);
													end
											2'b01 : begin
													$display("OR R%d",IR[1:0]);
													end
											2'b10 : begin
													$display("NOT R%d",IR[1:0]);
													end
											2'b11 : begin
													$display("XOR R%d",IR[1:0]);
													end
										endcase										
									end
								3'b011 :
									begin
										alu_a   <= R[0];       // first  input R0
										alu_b   <= R[IR[1:0]]; // second input REG
										RESULT_REG <= IR[1:0];    // result in REG
										alu_op  <= {3'b010, IR[3:2] };
										
										// CMP and TEST are not storing result
										state   <= IR[3] ? STATE_FETCH_PREP : STATE_ALU_RESULT; 										
										case(IR[3:2])
											2'b00 : begin													
													$display("INC R%d",IR[1:0]);
													end
											2'b01 : begin
													$display("DEC R%d",IR[1:0]);
													end
											2'b10 : begin
													$display("CMP R%d",IR[1:0]);
													end
											2'b11 : begin
													$display("TST R%d",IR[1:0]);
													end
										endcase
									end
								3'b100 :
									begin
										if (IR[3]==0)
										begin
											alu_a   <= R[0];      // first input R0
											// no 2nd input
											RESULT_REG <= 0;         // result in R0
											alu_op  <= { 2'b10, IR[3:0] };
											case(IR[2:0])
												3'b000 : begin													
														$display("SHL");
														end
												3'b001 : begin
														$display("SHR");
														end
												3'b010 : begin
														$display("SAL");
														end
												3'b011 : begin
														$display("SAR");
														end
												3'b100 : begin													
														$display("ROL");
														end
												3'b101 : begin
														$display("ROR");
														end
												3'b110 : begin
														$display("RCL");
														end
												3'b111 : begin
														$display("RCR");
														end
											endcase
											state   <= STATE_ALU_RESULT;
										end
										else
										begin
											$display("Unused opcode %h",IR);
											state    <= STATE_FETCH_PREP;
										end									
										
									end
								3'b101 :
									begin
										$display("LOAD R%d,[R%d]", IR[3:2], IR[1:0]);
										addr  <= { DS, R[IR[1:0]] };
										we    <= 0;
										ioreq <= 0;
										RESULT_REG <= IR[3:2];
										
										state <= STATE_LOAD_VALUE_PREP;
									end
								3'b110 :
									begin
										$display("STORE [R%d],R%d", IR[3:2], IR[1:0]);
										addr     <= { DS, R[IR[3:2]] };
										we       <= 1;
										ioreq    <= 0;
										data_out <= R[IR[1:0]];
										
										state    <= STATE_FETCH_PREP;
									end
								3'b111 :
									begin
										// Special instuctions
										case(IR[3:2])
											2'b00 : begin
													CS <= R[IR[1:0]][3:0];
													$display("MOV CS,R%d",IR[1:0]);
													end
											2'b01 : begin
													DS <= R[IR[1:0]][3:0];
													$display("MOV DS,R%d",IR[1:0]);
													end
											2'b10 : begin
													$display("Unused opcode %h",IR);
													end
											2'b11 : begin
													hlt <= 1;
													$display("HALT");
												end
										endcase
									end
							endcase							
						end
					end
				STATE_FETCH_VALUE_PREP :
					begin
						// Sync with memory due to CLK
						state <= STATE_FETCH_VALUE;
					end
				STATE_FETCH_VALUE :
					begin
						VALUE <= data_in;
						state <= STATE_EXECUTE_DBL;
					end
				STATE_EXECUTE_DBL :
					begin
						state <= STATE_FETCH_PREP;
						case(IR[6:4])
							3'b000 :
								begin
									case(IR[3:0])
										3'b000 :
											begin
												$display("JMP %h ",{ CS, VALUE[7:0] });
												jump = 1;
											end
										3'b001 :
											begin
												$display("JC %h ",{CS, VALUE[7:0] });
												jump = (alu_C==1);
											end
										3'b010 :
											begin
												$display("JNC %h ",{CS, VALUE[7:0] });
												jump = (alu_C==0);												
											end
										3'b011 :
											begin
												$display("JM %h ",{CS, VALUE[7:0] });
												jump = (alu_S==1);
											end
										3'b100 :
											begin
												$display("JP %h ",{CS, VALUE[7:0] });
												jump = (alu_S==0);
											end
										3'b101 :
											begin
												$display("JZ %h ",{CS, VALUE[7:0] });
												jump = (alu_Z==1);
											end
										3'b110 :
											begin
												$display("JNZ %h ",{CS, VALUE[7:0] });
												jump = (alu_Z==0);												
											end
										3'b111 :
											begin
												$display("Unused opcode %h",IR);
												jump = 0;
											end
									endcase								
									
									if (jump)
									begin
										PC    <= { CS, VALUE[7:0] };
										addr  <= { CS, VALUE[7:0] };
										we    <= 0;
										ioreq <= 0;											
									end												
								end
							3'b001 :
								begin
									case(IR[3:0])
										3'b000 :
											begin
												$display("JR %h ", PC + {VALUE[7],VALUE[7],VALUE[7],VALUE[7],VALUE[7:0]} );
												jump = 1;
											end
										3'b001 :
											begin
												$display("JRC %h ",{CS, VALUE[7:0] });
												jump = (alu_C==1);
											end
										3'b010 :
											begin
												$display("JRNC %h ",{CS, VALUE[7:0] });
												jump = (alu_C==0);
											end
										3'b011 :
											begin
												$display("JRM %h ",{CS, VALUE[7:0] });
												jump = (alu_S==1);
											end
										3'b100 :
											begin
												$display("JRP %h ",{CS, VALUE[7:0] });
												jump = (alu_S==0);
											end
										3'b101 :
											begin
												$display("JRZ %h ",{CS, VALUE[7:0] });
												jump = (alu_Z==1);
											end
										3'b110 :
											begin
												$display("JRNZ %h ",{CS, VALUE[7:0] });
												jump = (alu_Z==0);
											end
										3'b111 :
											begin
												$display("Unused opcode %h",IR);							
												jump = 0;
											end
									endcase								
									if (jump)
									begin
										PC    <= PC + {VALUE[7],VALUE[7],VALUE[7],VALUE[7],VALUE[7:0]};
										addr  <= PC + {VALUE[7],VALUE[7],VALUE[7],VALUE[7],VALUE[7:0]};
										we    <= 0;
										ioreq <= 0;											
									end
								end
								
							3'b010 :
								begin
									$display("JUMP %h ",{ IR[3:0], VALUE[7:0] });
									PC    <= { IR[3:0], VALUE[7:0] };
									addr  <= { IR[3:0], VALUE[7:0] };
									we    <= 0;
									ioreq <= 0;									
								end
							3'b011 :
								begin
									$display("Unused opcode %h",IR);	 
								end
							3'b100 :
								begin
									$display("IN R%d,[0x%h]",IR[1:0], VALUE);
									ioreq <= 1;
									we    <= 0;
									addr  <= { 4'b0000, VALUE };
									RESULT_REG <= IR[1:0];			
									state    <= STATE_LOAD_VALUE_PREP;									
								end
							3'b101 :
								begin
									$display("OUT [0x%h],R%d",VALUE,IR[1:0]);
									ioreq <= 1;
									we    <= 1;
									addr  <= { 4'b0000, VALUE };
									data_out <= R[IR[1:0]];			
									$display("output value is [0x%h]",R[IR[1:0]]);
									state    <= STATE_FETCH_PREP;									
								end
							3'b110 :
								begin
									// Special instuctions
									case(IR[1:0])
										2'b00 : begin
												$display("MOV CS,0x%h",VALUE);
												CS <= VALUE;
												end
										2'b01 : begin
												$display("MOV DS,0x%h",VALUE);
												DS <= VALUE;
												end
										2'b10 : begin
													$display("Unused opcode %h",IR);
												end
										2'b11 : begin
													$display("Unused opcode %h",IR);
												end								
									endcase
								end
							3'b111 :
								begin
									case(IR[3:2])
										2'b00 : begin												
													$display("MOV R%d,0x%h",IR[1:0],VALUE);
													R[IR[1:0]] <= VALUE;
												end
										2'b01 : begin
													$display("LOAD R%d,[0x%h]",IR[1:0], {DS, VALUE});												
													addr  <= { DS, R[IR[1:0]] };
													we    <= 0;
													ioreq <= 0;
													RESULT_REG <= IR[1:0];
													
													state <= STATE_LOAD_VALUE_PREP;
												end
										2'b10 : begin
													$display("STORE [0x%h],R%d", {DS, VALUE}, IR[1:0]);
													addr     <= { DS, VALUE };
													we       <= 1;
													ioreq    <= 0;
													data_out <= R[IR[1:0]];
													
													state    <= STATE_FETCH_PREP;												
												end
										2'b11 : begin
													$display("Unused opcode %h",IR);
												end
									endcase
								end
						endcase
					end
				STATE_LOAD_VALUE_PREP :
					begin
						// Sync with memory due to CLK
						state <= STATE_LOAD_VALUE;
					end
				STATE_LOAD_VALUE :
					begin
						R[RESULT_REG] <= data_in;
						state <= STATE_FETCH_PREP;
					end	
				
				STATE_ALU_RESULT :
					begin
						R[RESULT_REG] <= alu_res;
						state <= STATE_FETCH_PREP;
					end				
			endcase			
		end
	end
endmodule
