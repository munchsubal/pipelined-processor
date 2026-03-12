`timescale 1ns/1ps

module tb_ex_mem;

reg clk;
reg reset;

reg [63:0] alu_result_in;
reg [63:0] rs2_data_in;

wire [63:0] alu_result_out;

integer total_tests = 0;
integer failed_tests = 0;

ex_mem_reg uut(
    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result_in),
    .rs2_data_in(rs2_data_in),
    .branch_target_in(64'd0),

    .rd_in(5'd1),
    .zero_in(1'b0),

    .RegWrite_in(1'b1),
    .MemRead_in(1'b0),
    .MemWrite_in(1'b0),
    .MemtoReg_in(1'b0),
    .Branch_in(1'b0),

    .alu_result_out(alu_result_out),
    .rs2_data_out(),
    .branch_target_out(),
    .rd_out(),
    .zero_out(),
    .RegWrite_out(),
    .MemRead_out(),
    .MemWrite_out(),
    .MemtoReg_out(),
    .Branch_out()
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
        $display("PASS %h", got);
    end
end
endtask

initial begin

clk=0;
reset=1;

#10 reset=0;

alu_result_in = 64'h10;
#10 check(64'h10, alu_result_out);

alu_result_in = 64'h20;
#10 check(64'h20, alu_result_out);

alu_result_in = 64'h30;
#10 check(64'h30, alu_result_out);

alu_result_in = 64'h40;
#10 check(64'h40, alu_result_out);

alu_result_in = 64'h50;
#10 check(64'h50, alu_result_out);

alu_result_in = 64'h60;
#10 check(64'h60, alu_result_out);

alu_result_in = 64'h70;
#10 check(64'h70, alu_result_out);

alu_result_in = 64'h80;
#10 check(64'h80, alu_result_out);

alu_result_in = 64'h90;
#10 check(64'h90, alu_result_out);

alu_result_in = 64'hA0;
#10 check(64'hA0, alu_result_out);

$display("================================");
$display("PASSED = %0d", total_tests - failed_tests);
$display("FAILED = %0d", failed_tests);
$display("TOTAL  = %0d", total_tests);

$finish;

end

endmodule