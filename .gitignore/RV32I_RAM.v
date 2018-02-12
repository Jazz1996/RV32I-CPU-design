`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_RAM (
    input                    rst,
	input                    clk,
	input                    ram_ce_i,
	input                    ram_we_i,
	input      [3:0]         ram_mode_i,
	input      [`RamAddrBus] ram_addr_i,
	input      [`DataBus]    ram_data_i,
	output reg [`DataBus]    ram_data_o
	);
	
	reg [7:0] dRAM [0:799];
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		     {{dRAM[ 3]}, {dRAM[ 2]}, {dRAM[ 1]}, {dRAM[ 0]}} <= 32'h12345678;
			  {{dRAM[ 7]}, {dRAM[ 6]}, {dRAM[ 5]}, {dRAM[ 4]}} <= 32'h87654321;
			  {{dRAM[11]}, {dRAM[10]}, {dRAM[ 9]}, {dRAM[ 8]}} <= {{16'd16}, {-16'd25}};
			  {{dRAM[15]}, {dRAM[14]}, {dRAM[13]}, {dRAM[12]}} <= {{8'd255}, {8'd2}, {-8'd2}, {-8'd128}};
		end
	end
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    ram_data_o <= `ZeroWord;
		end
		
		else if ( ram_ce_i == `ReadEnable ) begin
		    ram_data_o <= {{dRAM[ram_addr_i+3]}, {dRAM[ram_addr_i+2]}, {dRAM[ram_addr_i+1]}, {dRAM[ram_addr_i]}};
		end
		
		else begin
		    ram_data_o <= `ZeroWord;
		end
	end
	
	always @ ( posedge clk ) begin
	    if ( ram_we_i == `WriteEnable ) begin
		    case ( ram_mode_i )
			    4'b0001: begin dRAM[ram_addr_i  ] <= ram_data_i[ 7: 0]; end
				4'b0010: begin dRAM[ram_addr_i+1] <= ram_data_i[15: 8]; end
				4'b0100: begin dRAM[ram_addr_i+2] <= ram_data_i[23:16]; end
				4'b1000: begin dRAM[ram_addr_i+3] <= ram_data_i[31:24]; end
				4'b0011: begin {{dRAM[ram_addr_i+1]}, {dRAM[ram_addr_i  ]}} <= ram_data_i[15: 0]; end
				4'b1100: begin {{dRAM[ram_addr_i+3]}, {dRAM[ram_addr_i+2]}} <= ram_data_i[31:16]; end
				4'b1111: begin {{dRAM[ram_addr_i+3]}, {dRAM[ram_addr_i+2]}, {dRAM[ram_addr_i+1]}, {dRAM[ram_addr_i]}} <= ram_data_i; end
				default: begin end
			endcase
		end
	end
	
endmodule
