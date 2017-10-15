module alu(
	input [7:0] A,
	input [7:0] B,
	input [3:0] operation,
	output reg [7:0] result,
	output reg C,
	output reg Z,
	output reg S
);

	parameter ALU_OP_SET = 4'b0000;
	parameter ALU_OP_NOT = 4'b0001;
	parameter ALU_OP_ADD = 4'b0010;
	parameter ALU_OP_SUB = 4'b0011;
	
	always @(*)
	begin
		case (operation)
			ALU_OP_SET :
				begin
					result = B;
				end
			ALU_OP_NOT :
				begin
					result = ~A;
				end
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
		endcase
	end
endmodule

