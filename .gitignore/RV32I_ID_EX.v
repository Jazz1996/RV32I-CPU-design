`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_ID_EX (
    input                    rst,
	input                    clk,
	input                    id_we,
	input      [`RegAddrBus] id_waddr,
	input      [`AluOpBus]   id_aluop,
	input      [`AluFun3Bus] id_alufun3,
	input                    id_alufun7,
	input      [`DataBus]    id_alu1,
	input      [`DataBus]    id_alu2,
	input                    id_memce,
	input                    id_memwe,
	input      [`DataBus]    id_memdata,
	input      [`InstAddrBus]id_offset,
	output reg               ex_we,
	output reg [`RegAddrBus] ex_waddr,
	output reg [`AluOpBus]   ex_aluop,
	output reg [`AluFun3Bus] ex_alufun3,
	output reg               ex_alufun7,
	output reg [`DataBus]    ex_alu1,
	output reg [`DataBus]    ex_alu2,
	output reg               ex_memce,
	output reg               ex_memwe,
	output reg [`DataBus]    ex_memdata,
	output reg [`InstAddrBus]ex_offset
	);
	
	always @ ( posedge clk ) begin
	    if ( rst == `ResetEnable ) begin
		    ex_we      <= `WriteDisable;
			ex_waddr   <= `regAddr0;
			ex_aluop   <= `EXE_OP_I;
			ex_alufun3 <= `EXE_RES_ADDI;
			ex_alufun7 <= 1'b0;
			ex_alu1    <= `ZeroWord;
			ex_alu2    <= `ZeroWord;
			ex_memce   <= `ReadDisable;
			ex_memwe   <= `WriteDisable;
			ex_memdata <= `ZeroWord;
			ex_offset  <= 32'h0;
		end
		
		else begin
		    ex_we      <= id_we;
			ex_waddr   <= id_waddr;
			ex_aluop   <= id_aluop;
			ex_alufun3 <= id_alufun3;
			ex_alufun7 <= id_alufun7;
			ex_alu1    <= id_alu1;
			ex_alu2    <= id_alu2;
			ex_memce   <= id_memce;
			ex_memwe   <= id_memwe;
			ex_memdata <= id_memdata;
			ex_offset  <= id_offset;
		end
	end
	
endmodule

