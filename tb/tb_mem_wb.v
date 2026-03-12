`timescale 1ns/1ps

module tb_mem_wb;

reg clk;
reg reset;

reg [63:0] mem_data_in;
reg [63:0] alu_result_in;

wire [63:0] mem_data_out;

integer total_tests = 0;
integer failed_tests = 0;


mem_wb_reg uut(
    .clk(clk),
    .reset(reset),

    .mem_data_in(mem_data_in),
    .alu_result_in(alu_result_in),
    .rd_in(5'd1),

    .RegWrite_in(1'b1),
    .MemtoReg_in(1'b1),

    .mem_data_out(mem_data_out),
    .alu_result_out(),
    .rd_out(),
    .RegWrite_out(),
    .MemtoReg_out()
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

mem_data_in = 64'h1;
#10 check(64'h1, mem_data_out);

mem_data_in = 64'h2;
#10 check(64'h2, mem_data_out);

mem_data_in = 64'h3;
#10 check(64'h3, mem_data_out);

mem_data_in = 64'h4;
#10 check(64'h4, mem_data_out);

mem_data_in = 64'h5;
#10 check(64'h5, mem_data_out);

mem_data_in = 64'h6;
#10 check(64'h6, mem_data_out);

mem_data_in = 64'h7;
#10 check(64'h7, mem_data_out);

mem_data_in = 64'h8;
#10 check(64'h8, mem_data_out);

mem_data_in = 64'h9;
#10 check(64'h9, mem_data_out);

mem_data_in = 64'hA;
#10 check(64'hA, mem_data_out);

$display("================================");
$display("PASSED = %0d", total_tests - failed_tests);
$display("FAILED = %0d", failed_tests);
$display("TOTAL  = %0d", total_tests);

$finish;

end

endmodule