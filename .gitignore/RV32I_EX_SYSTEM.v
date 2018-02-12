`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_EX_SYSTEM (
    input                    rst,
	input                    ex_system_csr_we,
	input      [`DataBus]    ex_system_zimm,
	input      [`DataBus]    ex_system_reg_rdata,
	input      [`DataBus]    ex_system_csr_rdata,
	input      [`CSRAddrBus] ex_system_csr_raddr,
	input      [`AluFun3Bus] ex_system_alufun3,
	output reg               csr_we,
	output reg [`DataBus]    csr_wdata,
	output reg [`CSRAddrBus] csr_waddr
	);
	
	reg [`DataBus] ex_csr_result;
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    ex_csr_result <= `ZeroWord;
		end
		
		else begin
		    case ( ex_system_alufun3 )
			    `EXE_RES_CSRRW: begin
				    ex_csr_result <= ex_system_reg_rdata;
				end
				
				`EXE_RES_CSRRS: begin
				    ex_csr_result <= ex_system_csr_rdata | ex_system_reg_rdata;
				end
				
				`EXE_RES_CSRRC: begin
				    ex_csr_result <= ex_system_csr_rdata ^ ( ~ ex_system_reg_rdata );
				end
				
				`EXE_RES_CSRRWI: begin
				    ex_csr_result <= ex_system_zimm;
				end
				
				`EXE_RES_CSRRSI: begin
				    ex_csr_result <= ex_system_csr_rdata | ex_system_zimm;
				end
				
				`EXE_RES_CSRRCI: begin
				    ex_csr_result <= ex_system_csr_rdata ^ ( ~ ex_system_zimm );
				end
				
				default: begin
				    ex_csr_result <= `ZeroWord;
				end
			endcase
		end
	end
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    csr_we    <= `WriteDisable;
			csr_wdata <= `ZeroWord;
			csr_waddr <= 12'h0;
		end
		
		else begin
		    csr_we    <= ex_system_csr_we;
			csr_wdata <= ex_csr_result;
			csr_waddr <= ex_system_csr_raddr;
		end
	end
	
endmodule
