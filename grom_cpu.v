module grom_cpu(
	input clk,
	input reset,
	output reg [11:0] addr,
	input [7:0] data_in,
	output reg [7:0] data_out,
	output reg we,
	output reg ioreq,
	output reg hlt
);

	reg[11:0] PC;    // Program counter
	reg[7:0] IR;     // Instruction register
	reg[7:0] VALUE;   // Temp reg for storing 2nd operand
	reg[3:0] CS;    // Code segment regiser
	reg[3:0] DS;    // Data segment regiser
	reg[11:0] SP;    // Stack pointer regiser
	reg[7:0] R[0:3]; // General purpose registers
	reg[11:0] FUTURE_PC;   // PC to jump to

	parameter STATE_RESET             = 5'b00000;
	parameter STATE_FETCH_PREP        = 5'b00001;
	parameter STATE_FETCH_WAIT        = 5'b00010;
	parameter STATE_FETCH             = 5'b00011;
	parameter STATE_EXECUTE           = 5'b00100;
	parameter STATE_FETCH_VALUE_PREP  = 5'b00101;
	parameter STATE_FETCH_VALUE       = 5'b00110;
	parameter STATE_EXECUTE_DBL       = 5'b00111;
	parameter STATE_LOAD_VALUE        = 5'b01000;
	parameter STATE_LOAD_VALUE_WAIT   = 5'b01001;
	parameter STATE_ALU_RESULT_WAIT   = 5'b01010;
	parameter STATE_ALU_RESULT        = 5'b01011;
	parameter STATE_PUSH_PC_LOW       = 5'b01100;
	parameter STATE_JUMP              = 5'b01101;
	parameter STATE_RET_VALUE_WAIT    = 5'b01110;
	parameter STATE_RET_VALUE         = 5'b01111;
	parameter STATE_RET_VALUE_WAIT2   = 5'b10000;
	parameter STATE_RET_VALUE2        = 5'b10001;

	reg [4:0] state = STATE_RESET;

	reg [7:0]  alu_a;
	reg [7:0]  alu_b;
	reg [4:0]  alu_op;

	reg [1:0]  RESULT_REG;

	wire [7:0] alu_res;
	wire alu_CF;
	wire alu_ZF;
	wire alu_SF;
	reg jump;

	alu alu(.clk(clk),.A(alu_a),.B(alu_b),.operation(alu_op),.result(alu_res),.CF(alu_CF),.ZF(alu_ZF),.SF(alu_SF));

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
						CS    <= 4'h0;
						DS    <= 4'h0;
						R[0]  <= 8'h00;
						R[1]  <= 8'h00;
						R[2]  <= 8'h00;
						R[3]  <= 8'h00;
						SP    <= 12'hfff;
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
						`ifdef DISASSEMBLY
						$display("    PC %h R0 %h R1 %h R2 %h R3 %h CS %h DS %h SP %h ALU [%d %d %d]", PC, R[0], R[1], R[2], R[3], CS, DS, SP, alu_CF,alu_SF,alu_ZF);
						`endif
						if (IR[7])
						begin
							addr  <= PC;
							state <= STATE_FETCH_VALUE_PREP;
							PC    <= PC + 1;
						end
						else
						begin
							case(IR[6:4])
								3'b000 :
									begin
										`ifdef DISASSEMBLY
										$display("MOV R%d,R%d",IR[3:2],IR[1:0]);
										`endif
										R[IR[3:2]] <= R[IR[1:0]];
										state <= STATE_FETCH_PREP;
									end
								3'b001 :
									begin
										alu_a   <= R[0];      // first input R0
										alu_b   <= R[IR[1:0]];
										RESULT_REG <= 0;         // result in R0
										alu_op  <= { 3'b000, IR[3:2] };

										state   <= STATE_ALU_RESULT_WAIT;

										`ifdef DISASSEMBLY
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
										`endif
									end
								3'b010 :
									begin
										alu_a   <= R[0];      // first input R0
										alu_b   <= R[IR[1:0]];
										RESULT_REG <= 0;         // result in R0
										alu_op  <= { 3'b001, IR[3:2] };
										state   <= STATE_ALU_RESULT_WAIT;
										`ifdef DISASSEMBLY
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
										`endif
									end
								3'b011 :
									begin
										alu_a   <= R[0];       // first  input R0
										alu_b   <= R[IR[1:0]]; // second input REG
										RESULT_REG <= IR[1:0];    // result in REG
										alu_op  <= {3'b010, IR[3:2] };

										// CMP and TEST are not storing result
										state   <= IR[3] ? STATE_FETCH_PREP : STATE_ALU_RESULT_WAIT;
										`ifdef DISASSEMBLY
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
										`endif
									end
								3'b100 :
									begin
										if (IR[3]==0)
										begin
											alu_a   <= R[0];      // first input R0
											// no 2nd input
											RESULT_REG <= 0;         // result in R0
											alu_op  <= { 2'b10, IR[2:0] };
											`ifdef DISASSEMBLY
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
											`endif
											state   <= STATE_ALU_RESULT_WAIT;
										end
										else
										begin
											if (IR[2]==0)
											begin
												`ifdef DISASSEMBLY
												$display("PUSH R%d",IR[1:0]);
												`endif
												addr     <= SP;
												we       <= 1;
												ioreq    <= 0;
												data_out <= R[IR[1:0]];
												SP       <= SP - 1;
												state    <= STATE_FETCH_PREP;
											end
											else
											begin
												`ifdef DISASSEMBLY
												$display("IR %h POP R%d",IR,IR[1:0]);
												`endif
												addr  <= SP + 1;
												we    <= 0;
												ioreq <= 0;
												RESULT_REG <= IR[1:0];
												SP    <= SP + 1;
												state <= STATE_LOAD_VALUE_WAIT;
											end
										end
									end
								3'b101 :
									begin
										`ifdef DISASSEMBLY
										$display("LOAD R%d,[R%d]", IR[3:2], IR[1:0]);
										`endif
										addr  <= { DS, R[IR[1:0]] };
										we    <= 0;
										ioreq <= 0;
										RESULT_REG <= IR[3:2];

										state <= STATE_LOAD_VALUE_WAIT;
									end
								3'b110 :
									begin
										`ifdef DISASSEMBLY
										$display("STORE [R%d],R%d", IR[3:2], IR[1:0]);
										`endif
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
													state <= STATE_FETCH_PREP;
													`ifdef DISASSEMBLY
													$display("MOV CS,R%d",IR[1:0]);
													`endif
													end
											2'b01 : begin
													DS <= R[IR[1:0]][3:0];
													state <= STATE_FETCH_PREP;
													`ifdef DISASSEMBLY
													$display("MOV DS,R%d",IR[1:0]);
													`endif
													end
											2'b10 : begin
														case(IR[1:0])
															2'b00 : begin
																	`ifdef DISASSEMBLY
																	$display("PUSH CS");
																	`endif
																	addr     <= SP;
																	we       <= 1;
																	ioreq    <= 0;
																	data_out <= { 4'b0000, CS};
																	SP       <= SP - 1;
																	state    <= STATE_FETCH_PREP;
																	end
															2'b01 : begin
																	`ifdef DISASSEMBLY
																	$display("PUSH DS");
																	`endif
																	addr     <= SP;
																	we       <= 1;
																	ioreq    <= 0;
																	data_out <= { 4'b0000, DS};
																	SP       <= SP - 1;
																	state    <= STATE_FETCH_PREP;
																	end
															2'b10 : begin
																	`ifdef DISASSEMBLY
																	$display("Unused opcode");
																	`endif
																	end
															2'b11 : begin
																	`ifdef DISASSEMBLY
																	$display("Unused opcode");
																	`endif
																end
														endcase
														state <= STATE_FETCH_PREP;
													end
											2'b11 : begin
														case(IR[1:0])
															2'b00 : begin
																	`ifdef DISASSEMBLY
																	$display("Unused opcode");
																	`endif
																	state <= STATE_FETCH_PREP;
																	end
															2'b01 : begin
																	`ifdef DISASSEMBLY
																	$display("Unused opcode");
																	`endif
																	state <= STATE_FETCH_PREP;
																	end
															2'b10 : begin
																	`ifdef DISASSEMBLY
																	$display("RET");
																	`endif
																	addr  <= SP + 1;
																	we    <= 0;
																	ioreq <= 0;
																	SP    <= SP + 1;
																	state <= STATE_RET_VALUE_WAIT;
																	end
															2'b11 : begin
																	hlt <= 1;
																	`ifdef DISASSEMBLY
																	$display("HALT");
																	`endif
																	state <= STATE_FETCH_PREP;
																	end
														endcase
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
						case(IR[6:4])
							3'b000 :
								begin
								if (IR[3]==0)
									begin
										case(IR[2:0])
											3'b000 :
												begin
													`ifdef DISASSEMBLY
													$display("JMP %h ",{ CS, VALUE[7:0] });
													`endif
													jump = 1;
												end
											3'b001 :
												begin
													`ifdef DISASSEMBLY
													$display("JC %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_CF==1);
												end
											3'b010 :
												begin
													`ifdef DISASSEMBLY
													$display("JNC %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_CF==0);
												end
											3'b011 :
												begin
													`ifdef DISASSEMBLY
													$display("JM %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_SF==1);
												end
											3'b100 :
												begin
													`ifdef DISASSEMBLY
													$display("JP %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_SF==0);
												end
											3'b101 :
												begin
													`ifdef DISASSEMBLY
													$display("JZ %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_ZF==1);
												end
											3'b110 :
												begin
													`ifdef DISASSEMBLY
													$display("JNZ %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_ZF==0);
												end
											3'b111 :
												begin
													`ifdef DISASSEMBLY
													$display("Unused opcode %h",IR);
													`endif
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
										state <= STATE_FETCH_PREP;
									end
								else
									begin
										case(IR[2:0])
											3'b000 :
												begin
													`ifdef DISASSEMBLY
													$display("JR %h ", PC + {VALUE[7],VALUE[7],VALUE[7],VALUE[7],VALUE[7:0]} );
													`endif
													jump = 1;
												end
											3'b001 :
												begin
													`ifdef DISASSEMBLY
													$display("JRC %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_CF==1);
												end
											3'b010 :
												begin
													`ifdef DISASSEMBLY
													$display("JRNC %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_CF==0);
												end
											3'b011 :
												begin
													`ifdef DISASSEMBLY
													$display("JRM %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_SF==1);
												end
											3'b100 :
												begin
													`ifdef DISASSEMBLY
													$display("JRP %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_SF==0);
												end
											3'b101 :
												begin
													`ifdef DISASSEMBLY
													$display("JRZ %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_ZF==1);
												end
											3'b110 :
												begin
													`ifdef DISASSEMBLY
													$display("JRNZ %h ",{CS, VALUE[7:0] });
													`endif
													jump = (alu_ZF==0);
												end
											3'b111 :
												begin
													`ifdef DISASSEMBLY
													$display("Unused opcode %h",IR);
													`endif
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
										state <= STATE_FETCH_PREP;
									end
								end
							3'b001 :
								begin
									`ifdef DISASSEMBLY
									$display("JUMP %h ",{ IR[3:0], VALUE[7:0] });
									`endif
									PC    <= { IR[3:0], VALUE[7:0] };
									addr  <= { IR[3:0], VALUE[7:0] };
									we    <= 0;
									ioreq <= 0;
									state <= STATE_FETCH_PREP;
								end
							3'b010 :
								begin
									`ifdef DISASSEMBLY
									$display("CALL %h ",{ IR[3:0], VALUE[7:0] });
									`endif
									FUTURE_PC <= { IR[3:0], VALUE[7:0] };
									addr     <= SP;
									we       <= 1;
									ioreq    <= 0;
									data_out <= { 4'b0000, PC[11:8]};
									SP       <= SP - 1;
									state    <= STATE_PUSH_PC_LOW;
								end
							3'b011 :
								begin
									`ifdef DISASSEMBLY
									$display("MOV SP,%h ",{ IR[3:0], VALUE[7:0] });
									`endif
									SP <= { IR[3:0], VALUE[7:0] };
									state <= STATE_FETCH_PREP;
								end
							3'b100 :
								begin
									`ifdef DISASSEMBLY
									$display("IN R%d,[0x%h]",IR[1:0], VALUE);
									`endif
									ioreq <= 1;
									we    <= 0;
									addr  <= { 4'b0000, VALUE };
									RESULT_REG <= IR[1:0];
									state    <= STATE_LOAD_VALUE_WAIT;
								end
							3'b101 :
								begin
									`ifdef DISASSEMBLY
									$display("OUT [0x%h],R%d",VALUE,IR[1:0]);
									`endif
									ioreq <= 1;
									we    <= 1;
									addr  <= { 4'b0000, VALUE };
									data_out <= R[IR[1:0]];
									state    <= STATE_FETCH_PREP;
								end
							3'b110 :
								begin
									// Special instuctions
									case(IR[1:0])
										2'b00 : begin
												`ifdef DISASSEMBLY
												$display("MOV CS,0x%h",VALUE);
												`endif
												CS <= VALUE[3:0];
												state <= STATE_FETCH_PREP;
												end
										2'b01 : begin
												`ifdef DISASSEMBLY
												$display("MOV DS,0x%h",VALUE);
												`endif
												DS <= VALUE[3:0];
												state <= STATE_FETCH_PREP;
												end
										2'b10 : begin
												`ifdef DISASSEMBLY
												$display("Unused opcode %h",IR);
												`endif
												state <= STATE_FETCH_PREP;
												end
										2'b11 : begin
												`ifdef DISASSEMBLY
												$display("Unused opcode %h",IR);
												`endif
												state <= STATE_FETCH_PREP;
												end
									endcase
								end
							3'b111 :
								begin
									case(IR[3:2])
										2'b00 : begin
													`ifdef DISASSEMBLY
													$display("MOV R%d,0x%h",IR[1:0],VALUE);
													`endif
													R[IR[1:0]] <= VALUE;
													state <= STATE_FETCH_PREP;
												end
										2'b01 : begin
													`ifdef DISASSEMBLY
													$display("LOAD R%d,[0x%h]",IR[1:0], {DS, VALUE});
													`endif
													addr  <= { DS, VALUE };
													we    <= 0;
													ioreq <= 0;
													RESULT_REG <= IR[1:0];

													state <= STATE_LOAD_VALUE_WAIT;
												end
										2'b10 : begin
													`ifdef DISASSEMBLY
													$display("STORE [0x%h],R%d", {DS, VALUE}, IR[1:0]);
													`endif
													addr     <= { DS, VALUE };
													we       <= 1;
													ioreq    <= 0;
													data_out <= R[IR[1:0]];

													state    <= STATE_FETCH_PREP;
												end
										2'b11 : begin
													`ifdef DISASSEMBLY
													$display("Unused opcode %h",IR);
													`endif
													state <= STATE_FETCH_PREP;
												end
									endcase
								end
						endcase
					end
				STATE_LOAD_VALUE_WAIT :
					begin
						// Sync with memory due to CLK
						state <= STATE_LOAD_VALUE;
					end
				STATE_LOAD_VALUE :
					begin
						R[RESULT_REG] <= data_in;
						we    <= 0;
						state <= STATE_FETCH_PREP;
					end
				STATE_ALU_RESULT_WAIT :
					begin
						state <= STATE_ALU_RESULT;
					end
				STATE_ALU_RESULT :
					begin
						R[RESULT_REG] <= alu_res;
						state <= STATE_FETCH_PREP;
					end
				STATE_PUSH_PC_LOW :
					begin
						addr     <= SP;
						we       <= 1;
						ioreq    <= 0;
						data_out <= PC[7:0];
						SP       <= SP - 1;
						state    <= STATE_JUMP;
					end
				STATE_JUMP :
					begin
						`ifdef DISASSEMBLY
						$display("Jumping to %h",FUTURE_PC);
						`endif
						PC <= FUTURE_PC;
						state <= STATE_FETCH_PREP;
					end
				STATE_RET_VALUE_WAIT :
					begin
						// Sync with memory due to CLK
						state <= STATE_RET_VALUE;
					end
				STATE_RET_VALUE :
					begin
						FUTURE_PC <= { 4'b0000, data_in };
						we    <= 0;
						state <= STATE_RET_VALUE_WAIT2;

						addr  <= SP + 1;
						we    <= 0;
						ioreq <= 0;
						SP    <= SP + 1;
					end
				STATE_RET_VALUE_WAIT2 :
					begin
						// Sync with memory due to CLK
						state <= STATE_RET_VALUE2;
					end
				STATE_RET_VALUE2 :
					begin
						FUTURE_PC <= FUTURE_PC | ({ 4'b0000, data_in } << 8);
						we    <= 0;
						state <= STATE_JUMP;
					end
				default :
					begin
						state <= STATE_FETCH_PREP;
					end
			endcase
		end
	end
endmodule
