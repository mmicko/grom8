#include <iostream>
#include <memory>
#include "Valu.h"
#include "verilated.h"

#define CATCH_CONFIG_RUNNER
#include "catch.hpp"

static const int ALU_OP_ADD = 0b00000;
static const int ALU_OP_SUB = 0b00001;
static const int ALU_OP_ADC = 0b00010;
static const int ALU_OP_SBC = 0b00011;
static const int ALU_OP_AND = 0b00100;
static const int ALU_OP_OR  = 0b00101;
static const int ALU_OP_NOT = 0b00110;
static const int ALU_OP_XOR = 0b00111;
static const int ALU_OP_INC = 0b01000;
static const int ALU_OP_DEC = 0b01001;
static const int ALU_OP_CMP = 0b01010;
static const int ALU_OP_TST = 0b01011;
static const int ALU_OP_SHL = 0b10000;
static const int ALU_OP_SHR = 0b10001;
static const int ALU_OP_SAL = 0b10010;
static const int ALU_OP_SAR = 0b10011;
static const int ALU_OP_ROL = 0b10100;
static const int ALU_OP_ROR = 0b10101;
static const int ALU_OP_RCL = 0b10110;
static const int ALU_OP_RCR = 0b10111;

int main( int argc, char* argv[] )
{
  Verilated::commandArgs(argc, argv);
  int result = Catch::Session().run( argc, argv );
  return ( result < 0xff ? result : 0xff );  
}

TEST_CASE("Test ALU_OP_ADD", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	uint8_t A = 0x00;	
	while(true)
	{		
		uint8_t B = 0;
		{
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_ADD;
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			uint8_t res = A + B;			
			REQUIRE(res==top->result);

			if (B==0xff) break;
			B=B+1;						
		}
		if (A==0xff) break;
		A=A+1;
	}
}

TEST_CASE("Test ALU_OP_INC", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	uint8_t B = 0x00;	
	while(true)
	{		
		top->B = B;
		top->operation = ALU_OP_INC;
		top->clk ^= 1; top->eval();
		top->clk ^= 1; top->eval();
		uint8_t res = B + 1;			
		REQUIRE(res==top->result);
		if (B==0xff) break;
		B=B+1;						
	}
}
