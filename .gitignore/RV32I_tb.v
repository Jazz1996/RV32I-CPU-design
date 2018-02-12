`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_tb;

	// Inputs
	reg rst;
	reg clk;

	// Outputs
	wire [31:0] reg_wdata;

	// Instantiate the Unit Under Test (UUT)
	RV32I_TOP uut (
		.rst(rst), 
		.clk(clk), 
		.reg_wdata(reg_wdata)
	);

	always #25 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 0;
		$display("pc  :reg1:reg2:reg3:reg4:reg5:reg6:reg7:reg8:reg9:rega:regb:inst:ram19:ram18:ram17:ram16:ram11:ram10:ram9:ram8:ram13:ram12");
		$monitor("%d:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%b:%b:%h",
		          uut.RV32I_PC0.pc, uut.RV32I_REGFILES0.regs[1], uut.RV32I_REGFILES0.regs[2], uut.RV32I_REGFILES0.regs[3],
					 uut.RV32I_REGFILES0.regs[4], uut.RV32I_REGFILES0.regs[5], uut.RV32I_REGFILES0.regs[6], uut.RV32I_REGFILES0.regs[7],
					 uut.RV32I_REGFILES0.regs[8], uut.RV32I_REGFILES0.regs[9], uut.RV32I_REGFILES0.regs[21], uut.RV32I_REGFILES0.regs[22],
					 uut.RV32I_RAM0.dRAM[19], uut.RV32I_RAM0.dRAM[18], uut.RV32I_RAM0.dRAM[17], uut.RV32I_RAM0.dRAM[16],
					 uut.RV32I_RAM0.dRAM[11], uut.RV32I_RAM0.dRAM[10], uut.RV32I_RAM0.dRAM[ 9], uut.RV32I_RAM0.dRAM[ 8],
					 uut.RV32I_RAM0.dRAM[13], uut.RV32I_RAM0.dRAM[12],
					 uut.RV32I_ID0.id_inst_i, uut.RV32I_ID0.id_memdata_o, uut.RV32I_PC0.ex_ctrl_flag, uut.RV32I_PC0.id_ctrl_flag,
					 uut.RV32I_EX0.ex_offset_i);
	end
      
endmodule
