`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_ID_EX_SYSTEM (
    input                    rst,
	input                    clk,
	input                    csr_we,
	input      [`DataBus]    zimm,
	input      [`DataBus]    reg_rdata,
	input      [`DataBus]    csr_rdata,
	input      [`CSRAddrBus] csr_raddr,
	input      [`AluFun3Bus] id_alufun3,
	output reg               ex_system_csr_we,
	output reg [`DataBus]    ex_system_zimm,
	output reg [`DataBus]    ex_system_reg_rdata,
	output reg [`DataBus]    ex_system_csr_rdata,
	output reg [`CSRAddrBus] ex_system_csr_raddr,
	output reg [`AluFun3Bus] ex_system_alufun3
	);
	
	always @ ( posedge clk ) begin
	    if ( rst == `ResetEnable ) begin
		    ex_system_csr_we    <= `WriteDisable;
			ex_system_zimm      <= `ZeroWord;
			ex_system_reg_rdata <= `ZeroWord;
			ex_system_csr_rdata <= `ZeroWord;
			ex_system_csr_raddr <= 12'h0;
			ex_system_alufun3   <= 3'b000;
		end
		
		else begin
		    ex_system_csr_we    <= csr_we;
			ex_system_zimm      <= zimm;
			ex_system_reg_rdata <= reg_rdata;
			ex_system_csr_rdata <= csr_rdata;
			ex_system_csr_raddr <= csr_raddr;
			ex_system_alufun3   <= id_alufun3;
		end
	end
	
endmodule
