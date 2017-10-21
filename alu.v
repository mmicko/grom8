module alu(
	input [7:0] A,
	input [7:0] B,
	input [4:0] operation,
	output reg [7:0] result,
	output reg C,
	output reg Z,
	output reg S
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

	reg [7:0] tmp;

	always @(*)          
	begin
		case (operation)
			ALU_OP_ADD :
				begin
					{C, result } = A + B;
					Z = result == 0;
					S = result[7];
				end
			ALU_OP_SUB :
				begin
					{C, result } = A - B;
					Z = result == 0;
					S = result[7];
				end
			ALU_OP_ADC :
				begin
					//{C, result } = A + B + C;
					{C, result } = A + B;
					Z = result == 0;
					S = result[7];
				end
			ALU_OP_SBC :
				begin
					//{C, result } = A - B - C;
					{C, result } = A - B;
					Z = result == 0;
					S = result[7];
				end

			ALU_OP_AND :
				begin
					result = A & B;
					C = 0;
					Z = result == 0;
					S = result[7];
				end
			ALU_OP_OR :
				begin
					result = A | B;
					C = 0;
					Z = result == 0;
					S = result[7];
				end
			ALU_OP_NOT :
				begin
					result = ~A;
					C = 0;
					Z = result == 0;
					S = result[7];
				end
			ALU_OP_XOR :
				begin
					result = A ^ B;
					C = 0;
					Z = result == 0;
					S = result[7];
				end

			ALU_OP_INC :
				begin
					{C, result } = B + 1;
					Z = result == 0;
					S = result[7];
				end
			ALU_OP_DEC :
				begin
					{C, result } = B - 1;
					Z = result == 0;
					S = result[7];
				end
			ALU_OP_CMP :
				begin
					{C, tmp } = A - B;
					Z = tmp == 0;
					S = tmp[7];
					result = A; // no result change
				end
			ALU_OP_TST :
				begin
					tmp = A & B;
					C = 0;
					Z = tmp == 0;
					S = tmp[7];
					result = A; // no result change
				end
			default :
				begin
					result = A; // no result change
				end
		endcase
	end
endmodule

