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
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_ADD;
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			uint8_t res = A + B;			
			REQUIRE(res==top->result);
			REQUIRE(((res==0) ? 1:0)==top->ZF);
			REQUIRE((((A + B)>0xff) ? 1 : 0 )==top->CF);
			REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
}


TEST_CASE("Test ALU_OP_ADC", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			// Set CF to 0
			{
				top->B = 0;
				top->operation = ALU_OP_INC;
				top->clk ^= 1; top->eval();
				top->clk ^= 1; top->eval();
			}
			
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_ADC;
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			uint8_t res = A + B;			
			CHECK(res==top->result);
			CHECK(((res==0) ? 1:0)==top->ZF);
			CHECK((((A + B)>0xff) ? 1 : 0 )==top->CF);
			CHECK(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
	
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			// Set CF to 1
			{
				top->B = 0;
				top->operation = ALU_OP_DEC;
				top->clk ^= 1; top->eval();
				top->clk ^= 1; top->eval();
			}
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_ADC;
			int res = A + B + 1;	
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			REQUIRE((res&0xff)==top->result);
			REQUIRE((((res&0xff)==0) ? 1:0)==top->ZF);
			REQUIRE((((res)>0xff) ? 1 : 0 )==top->CF);
			REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
}


TEST_CASE("Test ALU_OP_SUB", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_SUB;
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			uint8_t res = A - B;			
			REQUIRE(res==top->result);
			REQUIRE(((res==0) ? 1:0)==top->ZF);
			REQUIRE((((A - B)<0) ? 1 : 0 )==top->CF);
			REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
}

TEST_CASE("Test ALU_OP_SBC", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			// Set CF to 1
			{
				top->B = 0;
				top->operation = ALU_OP_DEC;
				top->clk ^= 1; top->eval();
				top->clk ^= 1; top->eval();
			}
			REQUIRE(1==top->CF);
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_SBC;
			int res = A - B - 1;	
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			REQUIRE((res&0xff)==top->result);
			REQUIRE((((res&0xff)==0) ? 1:0)==top->ZF);
			REQUIRE((((res)<0) ? 1 : 0 )==top->CF);
			REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
}

TEST_CASE("Test ALU_OP_INC", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	top->A = 0;
	for(int B=0;B<0x100;B++)
	{
		top->B = B;
		top->operation = ALU_OP_INC;
		top->clk ^= 1; top->eval();
		top->clk ^= 1; top->eval();
		
		uint8_t res = B + 1;
		
		REQUIRE(res==top->result);
		REQUIRE(((res==0) ? 1:0)==top->ZF);
		REQUIRE(((B==0xff) ? 1 : 0 )==top->CF);
		REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
	}
}

TEST_CASE("Test ALU_OP_DEC", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	top->A = 0;
	for(int B=0;B<0x100;B++)
	{	
		top->B = B;
		top->operation = ALU_OP_DEC;
		top->clk ^= 1; top->eval();
		top->clk ^= 1; top->eval();
		
		uint8_t res = B - 1;
		
		REQUIRE(res==top->result);
		REQUIRE(((res==0) ? 1:0)==top->ZF);
		REQUIRE(((B==0) ? 1 : 0 )==top->CF);
		REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
	}
}

TEST_CASE("Test ALU_OP_AND", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_AND;
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			uint8_t res = A & B;			
			REQUIRE(res==top->result);			
			REQUIRE(((res==0) ? 1:0)==top->ZF);
			REQUIRE(0==top->CF);
			REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
}

TEST_CASE("Test ALU_OP_OR", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_OR;
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			uint8_t res = A | B;			
			REQUIRE(res==top->result);			
			REQUIRE(((res==0) ? 1:0)==top->ZF);
			REQUIRE(0==top->CF);
			REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
}


TEST_CASE("Test ALU_OP_XOR", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_XOR;
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			uint8_t res = A ^ B;			
			REQUIRE(res==top->result);			
			REQUIRE(((res==0) ? 1:0)==top->ZF);
			REQUIRE(0==top->CF);
			REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
}

TEST_CASE("Test ALU_OP_NOT", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	for(int B=0;B<0x100;B++)
	{
		top->A = 0;
		top->B = B;
		top->operation = ALU_OP_NOT;
		top->clk ^= 1; top->eval();
		top->clk ^= 1; top->eval();
		uint8_t res = ~B;			
		REQUIRE(res==top->result);			
		REQUIRE(((res==0) ? 1:0)==top->ZF);
		REQUIRE(0==top->CF);
		REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
	}
}

TEST_CASE("Test ALU_OP_CMP", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_CMP;
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			uint8_t res = A - B;			
			REQUIRE(A==top->result);
			REQUIRE(((res==0) ? 1:0)==top->ZF);
			REQUIRE((((A - B)<0) ? 1 : 0 )==top->CF);
			REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
}

TEST_CASE("Test ALU_OP_TST", "ALU") 
{
	std::unique_ptr<Valu> top = std::make_unique<Valu>();
	top->clk = 0;
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			top->A = A;
			top->B = B;
			top->operation = ALU_OP_TST;
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			uint8_t res = A & B;			
			REQUIRE(A==top->result);			
			REQUIRE(((res==0) ? 1:0)==top->ZF);
			REQUIRE(0==top->CF);
			REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
}
