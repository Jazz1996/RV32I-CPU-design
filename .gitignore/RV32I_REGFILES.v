`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_REGFILES (
    input                    rst,
	input                    clk,
	
	input                    csr_reg_flag,
	input      [`RegAddrBus] csr_reg_addr,
	input      [`DataBus]    csr_rdata,
	
	// ----- Writing to REGFILES
	input                    reg_we_i,
	input      [`RegAddrBus] reg_waddr_i,
	input      [`DataBus]    reg_wdata_i,
	
	// ----- Reading Register1
	input                    reg_re1_i,
	input      [`RegAddrBus] reg_raddr1_i,
	output reg [`DataBus]    reg_rdata1_o,
	
	// ----- Reading Register2
	input                    reg_re2_i,
	input      [`RegAddrBus] reg_raddr2_i,
	output reg [`DataBus]    reg_rdata2_o
	);
	
	reg [`DataBus] regs[0:`RegNum-1];
	
	// ----- Writing data to register
	always @ ( posedge clk ) begin
	    if ( rst == `ResetDisable ) begin
		    if ( (csr_reg_flag == `WriteEnable) && (csr_reg_addr != `regAddr0) ) begin
			    regs[csr_reg_addr] <= csr_rdata;
			end
			
			else if ( (reg_we_i == `WriteEnable) && (reg_waddr_i != `regAddr0) ) begin
			    regs[reg_waddr_i] <= reg_wdata_i;
			end
		end
	end
	
	// ----- Reading data from register1
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    reg_rdata1_o <= `ZeroWord;
		end
		
		else if ( reg_re1_i == `ReadEnable ) begin
		    if ( reg_raddr1_i == `regAddr0 ) begin
			    reg_rdata1_o <= `ZeroWord;
			end
			
			else begin
			    reg_rdata1_o <= regs[reg_raddr1_i];
			end
		end
	end
	
	// ----- Reading data from register2
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    reg_rdata2_o <= `ZeroWord;
		end
		
		else if ( reg_re2_i == `ReadEnable ) begin
		    if ( reg_raddr2_i == `regAddr0 ) begin
			    reg_rdata2_o <= `ZeroWord;
			end
			
			else begin
			    reg_rdata2_o <= regs[reg_raddr2_i];
			end
		end
	end
	
endmodule
