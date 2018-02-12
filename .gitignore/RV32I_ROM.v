`timescale 1ns / 1ps
`include "DEFINES.v"

module RV32I_ROM (
	input  wire                rst,
	input  wire [`InstAddrBus] pc,
	output  reg [`InstBus]     inst_o
	);
	
	wire [`InstAddrBus] ROM_Addr;
	reg  [`InstBus]     iROM [0:199];
	
	assign ROM_Addr = pc >> 2'd2;
	
	always @ ( * ) begin
	    if ( rst == `ResetEnable ) begin
		    /*iROM[0 ] <= {12'd12, 5'd0, 3'b000, 5'd1, 7'b0010011};  //reg1=0+12
			iROM[1 ] <= {12'd34, 5'd0, 3'b000, 5'd2, 7'b0010011};  //reg2=0+34
			iROM[2 ] <= `NOP;
			iROM[3 ] <= `NOP;
			iROM[4 ] <= `NOP;
			iROM[5 ] <= {12'hfff, 5'd1, 3'b100, 5'd3, 7'b0010011}; //reg3=reg1 XOR 12'hfff
			iROM[6 ] <= {12'h00f, 5'd2, 3'b111, 5'd4, 7'b0010011}; //reg4=reg2 AND 12'h00f
			iROM[7 ] <= {12'h00f, 5'd2, 3'b110, 5'd5, 7'b0010011}; //reg5=reg2 OR  12'h00f
			iROM[8 ] <= {12'hfff, 5'd1, 3'b010, 5'd6, 7'b0010011}; //reg6=1 if reg1<12'hfff(signed -1)
			iROM[9 ] <= {12'hfff, 5'd1, 3'b011, 5'd7, 7'b0010011}; //reg7=1 if reg1<12'hfff(unsigned)
			iROM[10] <= {7'b0000000, 5'd2, 5'd1, 3'b001, 5'd1, 7'b0010011}; //reg1=reg1 << 2
			iROM[11] <= {7'b0000000, 5'd1, 5'd2, 3'b101, 5'd8, 7'b0010011}; //reg8=reg2 >> 1(logic)
			iROM[12] <= {7'b0100000, 5'd1, 5'd2, 3'b101, 5'd9, 7'b0010011}; //reg9=reg2 >> 1(math)
			
			iROM[13] <= {7'b0000000, 5'd4, 5'd3, 3'b000, 5'd5, 7'b0110011}; //reg5=reg3+reg4
			iROM[14] <= {7'b0100000, 5'd4, 5'd3, 3'b000, 5'd6, 7'b0110011}; //reg6=reg3-reg4
			iROM[15] <= {7'b0000000, 5'd4, 5'd3, 3'b100, 5'd7, 7'b0110011}; //reg7=reg3 XOR reg4
			iROM[16] <= {7'b0000000, 5'd4, 5'd3, 3'b110, 5'd1, 7'b0110011}; //reg1=reg3 OR  reg4
			iROM[17] <= {7'b0000000, 5'd4, 5'd3, 3'b111, 5'd2, 7'b0110011}; //reg2=reg3 AND reg4
			iROM[18] <= {7'b0000000, 5'd8, 5'd5, 3'b001, 5'd5, 7'b0110011}; //reg5=reg5 << reg8
			iROM[19] <= {7'b0000000, 5'd8, 5'd6, 3'b101, 5'd6, 7'b0110011}; //reg6=reg6 >> reg8(logic)
			iROM[20] <= {7'b0100000, 5'd8, 5'd7, 3'b101, 5'd7, 7'b0110011}; //reg7=reg7 >> reg8(math)
			iROM[21] <= {7'b0000000, 5'd2, 5'd1, 3'b010, 5'd10, 7'b0110011};//reg10=1 if reg1 < reg2(signed)
			iROM[22] <= {7'b0000000, 5'd2, 5'd1, 3'b011, 5'd11, 7'b0110011};//reg11=1 if reg1 < reg2(unsigned)*/
			
			/*iROM[ 0] <= {12'd0, 5'd0, `EXE_RES_LW, 5'd1, `EXE_OP_LOAD}; //ram[0]->reg1(word)
			iROM[ 1] <= {12'd4, 5'd0, `EXE_RES_LW, 5'd2, `EXE_OP_LOAD}; //ram[4]->reg2
			iROM[ 2] <= {12'd10, 5'd0, `EXE_RES_ADDI, 5'd21, `EXE_OP_I};//set base addr of halfword
			iROM[ 3] <= {12'd14, 5'd0, `EXE_RES_ADDI, 5'd22, `EXE_OP_I};//set base addr of byte
			iROM[ 4] <= `NOP;
			iROM[ 5] <= {7'd0, 5'd2, 5'd1, `EXE_RES_ADD_SUB, 5'd3, `EXE_OP_R};//reg3=reg1 + reg2
			iROM[ 6] <= {12'd0, 5'd21, `EXE_RES_LH, 5'd4, `EXE_OP_LOAD}; //ram[10]->reg4(signed halfword)
			iROM[ 7] <= {-12'd2, 5'd21, `EXE_RES_LH, 5'd5, `EXE_OP_LOAD};//ram[ 8]->reg5
			iROM[ 8] <= {12'd0, 5'd21, `EXE_RES_LHU, 5'd7, `EXE_OP_LOAD}; //ram[10]->reg7(unsigned halfword)
			iROM[ 9] <= {-12'd2, 5'd21, `EXE_RES_LHU, 5'd8, `EXE_OP_LOAD};//ram[ 8]->reg8
			iROM[10] <= {7'b000_0000, 5'd3, 5'd0, `EXE_RES_SW, 5'd16, `EXE_OP_STORE}; //reg3->ram[16]
			iROM[11] <= {7'b010_0000, 5'd5, 5'd4, `EXE_RES_ADD_SUB, 5'd6, `EXE_OP_R};//reg6=reg4-reg5
			iROM[12] <= {-12'd1, 5'd22, `EXE_RES_LB, 5'd1, `EXE_OP_LOAD};//ram[13]->reg1(signed byte)
			iROM[13] <= {-12'd2, 5'd22, `EXE_RES_LB, 5'd2, `EXE_OP_LOAD};//ram[12]->reg2
			iROM[14] <= {7'd0, 5'd8, 5'd7, `EXE_RES_ADD_SUB, 5'd9, `EXE_OP_R};//reg9=reg7+reg8
			iROM[15] <= {7'b111_1111, 5'd6, 5'd21, `EXE_RES_SH, 5'b11110, `EXE_OP_STORE};//reg6->ram[ 8]
			iROM[16] <= {12'd0, 5'd22, `EXE_RES_LBU, 5'd7, `EXE_OP_LOAD};//ram[14]->reg7
			iROM[17] <= {12'd1, 5'd22, `EXE_RES_LBU, 5'd8, `EXE_OP_LOAD};//ram[15]->reg8
			iROM[18] <= {7'b0100000, 5'd2, 5'd1, `EXE_RES_ADD_SUB, 5'd3, `EXE_OP_R};//reg3=reg1-reg2
			iROM[19] <= {7'd0, 5'd9, 5'd21, `EXE_RES_SH, 5'd0, `EXE_OP_STORE};//reg9->ram[10]
			iROM[20] <= `NOP;
			iROM[21] <= {7'd0, 5'd7, 5'd8, `EXE_RES_ADD_SUB, 5'd9, `EXE_OP_R};//reg9=reg7+reg8
			iROM[22] <= {7'b111_1111, 5'd3, 5'd22, `EXE_RES_SB, 5'b11110, `EXE_OP_STORE};//reg3->ram[12]
			iROM[23] <= `NOP;
			iROM[24] <= `NOP;
			iROM[25] <= {7'b111_1111, 5'd9, 5'd22, `EXE_RES_SB, 5'b11111, `EXE_OP_STORE};//reg9->ram[11]*/
			
			iROM[ 0] <= {-12'd1, 5'd0, `EXE_RES_ADDI, 5'd23, `EXE_OP_I};
            iROM[ 1] <= {12'd2, 5'd0, `EXE_RES_ADDI, 5'd24, `EXE_OP_I};
            iROM[ 2] <= {12'd10, 5'd0, `EXE_RES_ADDI, 5'd21, `EXE_OP_I};//set base addr of halfword
            iROM[ 3] <= {12'd14, 5'd0, `EXE_RES_ADDI, 5'd22, `EXE_OP_I};//set base addr of byte
            iROM[ 4] <= {12'd0, 5'd0, `EXE_RES_LW, 5'd1, `EXE_OP_LOAD}; //ram[0]->reg1(word)
            iROM[ 5] <= {12'd4, 5'd0, `EXE_RES_LW, 5'd2, `EXE_OP_LOAD}; //ram[4]->reg2
            iROM[ 6] <= {7'b000_0000, 5'd0, 5'd0, `EXE_RES_BEQ, 5'b0100_0, `EXE_OP_BRANCH}; //branch to rom9
            iROM[ 7] <= {7'b000_0000, 5'd2, 5'd1, `EXE_RES_ADD_SUB, 5'd3, `EXE_OP_R};//reg3=reg1+reg2
            iROM[ 8] <= {7'b000_0000, 5'd24, 5'd23, `EXE_RES_BLT, 5'b0110_0, `EXE_OP_BRANCH}; //branch to rom12
            iROM[ 9] <= {12'd0, 5'd21, `EXE_RES_LH, 5'd4, `EXE_OP_LOAD}; //ram[10]->reg4(signed halfword)
            iROM[10] <= {-12'd2, 5'd21, `EXE_RES_LH, 5'd5, `EXE_OP_LOAD};//ram[ 8]->reg5
            iROM[11] <= {7'b111_1111, 5'd23, 5'd24, `EXE_RES_BNE, 5'b0110_1, `EXE_OP_BRANCH};//branch to rom7
            iROM[12] <= {7'b010_0000, 5'd5, 5'd4, `EXE_RES_ADD_SUB, 5'd6, `EXE_OP_R};//reg6=reg4-reg5
            iROM[13] <= {7'b000_0000, 5'd23, 5'd24, `EXE_RES_BLTU, 5'b0100_0, `EXE_OP_BRANCH};//branch to rom16
            iROM[14] <= {7'b111_1111, 5'd6, 5'd21, `EXE_RES_SH, 5'b11110, `EXE_OP_STORE};//reg6->ram[ 8]
            iROM[15] <= {7'b000_0000, 5'd24, 5'd23, `EXE_RES_BGEU, 5'b0100_0, `EXE_OP_BRANCH};//branch to rom18
            iROM[16] <= {7'b000_0000, 5'd3, 5'd0, `EXE_RES_SW, 5'd16, `EXE_OP_STORE}; //reg3->ram[16]
            iROM[17] <= {7'b111_1111, 5'd23, 5'd24, `EXE_RES_BGE, 5'b1000_1, `EXE_OP_BRANCH};//branch to rom14
            iROM[18] <= `NOP;
		end
		
		else begin end
	end
	
	always @ ( * ) begin
	    inst_o <= iROM[ROM_Addr];
	end
endmodule
