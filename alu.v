module alu(
	input clk,
	input [7:0] A,
	input [7:0] B,
	input [4:0] operation,
	output reg [7:0] result,
	output reg CF,
	output reg ZF,
	output reg SF
);

	parameter ALU_OP_ADD = 5'b00000;
	parameter ALU_OP_SUB = 5'b00001;
	parameter ALU_OP_ADC = 5'b00010;
	parameter ALU_OP_SBC = 5'b00011;

	parameter ALU_OP_AND = 5'b00100;
	parameter ALU_OP_OR  = 5'b00101;
	parameter ALU_OP_NOT = 5'b00110;
	parameter ALU_OP_XOR = 5'b00111;

	parameter ALU_OP_INC = 5'b01000;
	parameter ALU_OP_DEC = 5'b01001;
	parameter ALU_OP_CMP = 5'b01010;
	parameter ALU_OP_TST = 5'b01011;

	parameter ALU_OP_SHL = 5'b10000;
	parameter ALU_OP_SHR = 5'b10001;
	parameter ALU_OP_SAL = 5'b10010;
	parameter ALU_OP_SAR = 5'b10011;

	parameter ALU_OP_ROL = 5'b10100;
	parameter ALU_OP_ROR = 5'b10101;
	parameter ALU_OP_RCL = 5'b10110;
	parameter ALU_OP_RCR = 5'b10111;

	reg [8:0] tmp;

	always @(posedge clk)
	begin
		case (operation)
			ALU_OP_ADD :
				begin
					{ CF, result } = A + B;
				end
			ALU_OP_SUB :
				begin
					{ CF, result } = A - B;
				end
			ALU_OP_ADC :
				begin
					{ CF, result } = A + B + { 7'b0000000, CF };
				end
			ALU_OP_SBC :
				begin
					{ CF, result } = A - B - { 7'b0000000, CF };
				end

			ALU_OP_AND :
				begin
					result = A & B;
					CF = 0;
				end
			ALU_OP_OR :
				begin
					result = A | B;
					CF = 0;
				end
			ALU_OP_NOT :
				begin
					result = ~A;
					CF = 0;
				end
			ALU_OP_XOR :
				begin
					result = A ^ B;
					CF = 0;
				end

			ALU_OP_INC :
				begin
					{CF, result } = B + 1;
				end
			ALU_OP_DEC :
				begin
					{CF, result } = B - 1;
				end
			ALU_OP_CMP :
				begin
					result = A; // no result change
					tmp = A - B;
					CF = tmp[8];
				end
			ALU_OP_TST :
				begin
					tmp = {1'b0, A & B};
					result = A; // no result change
					CF = 0;
				end
			ALU_OP_SHL :
				begin
					result = { A[6:0], 1'b0};
					CF = A[7];
				end
			ALU_OP_SHR :
				begin
					result = { 1'b0, A[7:1]};
					CF = A[0];
				end
			ALU_OP_SAL :
				begin
					// Same as SHL
					result = { A[6:0], 1'b0};
					CF = A[7];
				end
			ALU_OP_SAR :
				begin
					result = { A[7], A[7:1]};
					CF = A[0];
				end
			ALU_OP_ROL :
				begin
					result = { A[6:0], A[7]};
					CF = A[7];
				end
			ALU_OP_ROR :
				begin
					result = { A[0], A[7:1]};
					CF = A[0];
				end
			ALU_OP_RCL :
				begin
					result = { A[6:0], CF};
					CF = A[7];
				end
			ALU_OP_RCR :
				begin
					result = { CF, A[7:1]};
					CF = A[0];
				end
			default :
				begin
					result = A; // no result change
				end
		endcase

		case (operation)
			ALU_OP_CMP, ALU_OP_TST :
				begin
					ZF = tmp == 0;
					SF = tmp[7];
				end
			default :
				begin
					ZF = result == 0;
					SF = result[7];
				end
		endcase
	end
endmodule

