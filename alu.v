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

	parameter ALU_OP_ADD /* verilator public_flat */ = 5'b00000;
	parameter ALU_OP_SUB /* verilator public_flat */ = 5'b00001;
	parameter ALU_OP_ADC /* verilator public_flat */ = 5'b00010;
	parameter ALU_OP_SBC /* verilator public_flat */ = 5'b00011;

	parameter ALU_OP_AND /* verilator public_flat */ = 5'b00100;
	parameter ALU_OP_OR  /* verilator public_flat */ = 5'b00101;
	parameter ALU_OP_NOT /* verilator public_flat */ = 5'b00110;
	parameter ALU_OP_XOR /* verilator public_flat */ = 5'b00111;

	parameter ALU_OP_INC /* verilator public_flat */ = 5'b01000;
	parameter ALU_OP_DEC /* verilator public_flat */ = 5'b01001;
	parameter ALU_OP_CMP /* verilator public_flat */ = 5'b01010;
	parameter ALU_OP_TST /* verilator public_flat */ = 5'b01011;

	parameter ALU_OP_SHL /* verilator public_flat */ = 5'b10000;
	parameter ALU_OP_SHR /* verilator public_flat */ = 5'b10001;
	parameter ALU_OP_SAL /* verilator public_flat */ = 5'b10010;
	parameter ALU_OP_SAR /* verilator public_flat */ = 5'b10011;

	parameter ALU_OP_ROL /* verilator public_flat */ = 5'b10100;
	parameter ALU_OP_ROR /* verilator public_flat */ = 5'b10101;
	parameter ALU_OP_RCL /* verilator public_flat */ = 5'b10110;
	parameter ALU_OP_RCR /* verilator public_flat */ = 5'b10111;

	reg [8:0] tmp;

	always @(posedge clk)
	begin
		case (operation)
			ALU_OP_ADD :
				tmp = A + B;
			ALU_OP_SUB :
				tmp = A - B;
			ALU_OP_ADC :
				tmp = A + B + { 7'b0000000, CF };
			ALU_OP_SBC :
				tmp = A - B - { 7'b0000000, CF };
			ALU_OP_AND :
				tmp = {1'b0, A & B };
			ALU_OP_OR :
				tmp = {1'b0, A | B };
			ALU_OP_NOT :
				tmp = {1'b0, ~B };
			ALU_OP_XOR :
				tmp = {1'b0, A ^ B};
			ALU_OP_INC :
				tmp = B + 1;
			ALU_OP_DEC :
				tmp = B - 1;
			ALU_OP_CMP :
				tmp = A - B;
			ALU_OP_TST :
				tmp = {1'b0, A & B};
			ALU_OP_SHL :
				tmp = { A[7], A[6:0], 1'b0};
			ALU_OP_SHR :
				tmp = { A[0], 1'b0, A[7:1]};
			ALU_OP_SAL :
				// Same as SHL
				tmp = { A[7], A[6:0], 1'b0};
			ALU_OP_SAR :
				tmp = { A[0], A[7], A[7:1]};
			ALU_OP_ROL :
				tmp = { A[7], A[6:0], A[7]};
			ALU_OP_ROR :
				tmp = { A[0], A[0], A[7:1]};
			ALU_OP_RCL :
				tmp = { A[7], A[6:0], CF};
			ALU_OP_RCR :
				tmp = { A[0], CF, A[7:1]};
			default :
				tmp = {CF, A }; // no result change
		endcase

		CF <= tmp[8];
		ZF <= tmp[7:0] == 0;
		SF <= tmp[7];

		if (operation[4:1] == 4'b0101)
			result <= A;
		else
			result <= tmp[7:0];
	end
endmodule

