`timescale 1ns/1ps

module tb_id_ex;

reg clk;
reg reset;
reg flush;
reg bubble;

reg [63:0] pc4_in;
reg [63:0] rs1_data_in;
reg [63:0] rs2_data_in;
reg [63:0] imm_in;
reg [63:0] branch_target_in;

reg [4:0] rs1_in;
reg [4:0] rs2_in;
reg [4:0] rd_in;

reg [2:0] funct3_in;
reg instr30_in;

reg RegWrite_in;
reg MemRead_in;
reg MemWrite_in;
reg MemtoReg_in;
reg Branch_in;
reg ALUSrc_in;
reg [1:0] ALUOp_in;

wire [63:0] pc4_out;
wire [63:0] rs1_data_out;
wire [63:0] rs2_data_out;
wire [63:0] imm_out;

integer total_tests = 0;
integer failed_tests = 0;

id_ex_reg uut(
    .clk(clk),
    .reset(reset),
    .flush(flush),
    .bubble(bubble),

    .pc4_in(pc4_in),
    .rs1_data_in(rs1_data_in),
    .rs2_data_in(rs2_data_in),
    .imm_in(imm_in),
    .branch_target_in(branch_target_in),

    .rs1_in(rs1_in),
    .rs2_in(rs2_in),
    .rd_in(rd_in),

    .funct3_in(funct3_in),
    .instr30_in(instr30_in),

    .RegWrite_in(RegWrite_in),
    .MemRead_in(MemRead_in),
    .MemWrite_in(MemWrite_in),
    .MemtoReg_in(MemtoReg_in),
    .Branch_in(Branch_in),
    .ALUSrc_in(ALUSrc_in),
    .ALUOp_in(ALUOp_in),

    .pc4_out(pc4_out),
    .rs1_data_out(rs1_data_out),
    .rs2_data_out(rs2_data_out),
    .imm_out(imm_out)
);

always #5 clk = ~clk;

task check;
input [63:0] expected;
input [63:0] got;
begin
    total_tests = total_tests + 1;

    if (expected !== got) begin
        $display("FAIL Expected=%h Got=%h", expected, got);
        failed_tests = failed_tests + 1;
    end
    else begin
        $display("PASS Value=%h", got);
    end
end
endtask

initial begin

clk=0;
reset=1;
flush=0;
bubble=0;

#10
reset=0;

pc4_in = 64'h10;
rs1_data_in = 64'h1;
rs2_data_in = 64'h2;
imm_in = 64'h3;

#10 check(64'h10, pc4_out);
#10 check(64'h1, rs1_data_out);
#10 check(64'h2, rs2_data_out);
#10 check(64'h3, imm_out);

pc4_in = 64'h20;
rs1_data_in = 64'h5;
rs2_data_in = 64'h6;
imm_in = 64'h7;

#10 check(64'h20, pc4_out);
#10 check(64'h5, rs1_data_out);
#10 check(64'h6, rs2_data_out);
#10 check(64'h7, imm_out);

bubble = 1;
#10 check(64'h20, pc4_out);

flush = 1;
#10 check(64'h0, pc4_out);

$display("================================");
$display("PASSED = %0d", total_tests - failed_tests);
$display("FAILED = %0d", failed_tests);
$display("TOTAL  = %0d", total_tests);

$finish;

end

endmodule