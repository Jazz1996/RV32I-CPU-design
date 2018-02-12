`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_CSR (
    input                    rst,
	input                    clk,
	input                    csr_we,
	input                    csr_re,
	input      [`CSRAddrBus] csr_waddr,
	input      [`CSRAddrBus] csr_raddr,
	input      [`DataBus]    csr_wdata,
	output reg [`DataBus]    csr_rdata
	);
	
	reg [`DataBus] CSRs[0:`CSRNum-1];
	
	// ----- Writing Data to CSR
	always @ ( posedge clk ) begin
	    if ( rst == `ResetDisable ) begin
		    if ( csr_we == `WriteEnable ) begin
			    CSRs[csr_waddr] <= csr_wdata;
			end
		end
	end
	
	always @ ( posedge clk ) begin
	    if ( rst == `ResetEnable ) begin
		    csr_rdata <= `ZeroWord;
		end
		
		else if ( csr_re == `ReadEnable ) begin
		    csr_rdata <= CSRs[csr_raddr];
		end
	end
	
endmodule
