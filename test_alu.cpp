#include <iostream>
#include <memory>
#include "Valu.h"
#include "verilated.h"

#define CATCH_CONFIG_RUNNER
#include "catch.hpp"

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
			top->operation = top->alu__DOT__ALU_OP_ADD;
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
				top->A = 0;
				top->B = 0;
				top->operation = top->alu__DOT__ALU_OP_ADD;
				top->clk ^= 1; top->eval();
				top->clk ^= 1; top->eval();
			}
			
			top->A = A;
			top->B = B;
			top->operation = top->alu__DOT__ALU_OP_ADC;
			top->clk ^= 1; top->eval();
			top->clk ^= 1; top->eval();
			uint8_t res = A + B;			
			REQUIRE(res==top->result);
			REQUIRE(((res==0) ? 1:0)==top->ZF);
			REQUIRE((((A + B)>0xff) ? 1 : 0 )==top->CF);
			REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
		}
	}
	
	for(int A=0;A<0x100;A++)
	{		
		for(int B=0;B<0x100;B++)
		{
			// Set CF to 1
			{
				top->A = 0;
				top->B = 1;
				top->operation = top->alu__DOT__ALU_OP_SUB;
				top->clk ^= 1; top->eval();
				top->clk ^= 1; top->eval();
			}
			top->A = A;
			top->B = B;
			top->operation = top->alu__DOT__ALU_OP_ADC;
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
			top->operation = top->alu__DOT__ALU_OP_SUB;
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
				top->A = 0;
				top->B = 1;				
				top->operation = top->alu__DOT__ALU_OP_SUB;
				top->clk ^= 1; top->eval();
				top->clk ^= 1; top->eval();
			}
			REQUIRE(1==top->CF);
			top->A = A;
			top->B = B;
			top->operation = top->alu__DOT__ALU_OP_SBC;
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
			top->operation = top->alu__DOT__ALU_OP_AND;
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
			top->operation = top->alu__DOT__ALU_OP_OR;
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
			top->operation = top->alu__DOT__ALU_OP_XOR;
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
		top->operation = top->alu__DOT__ALU_OP_NOT;
		top->clk ^= 1; top->eval();
		top->clk ^= 1; top->eval();
		uint8_t res = ~B;			
		REQUIRE(res==top->result);			
		REQUIRE(((res==0) ? 1:0)==top->ZF);
		REQUIRE(0==top->CF);
		REQUIRE(((res & 0x80) ? 1 : 0) == top->SF);
	}
}
