`timescale 1ns/1ps

module tb_if_id;

reg clk;
reg reset;
reg stall;
reg flush;

reg [31:0] instr_in;
reg [63:0] pc_in;
reg [63:0] pc4_in;

wire [31:0] instr_out;
wire [63:0] pc_out;
wire [63:0] pc4_out;

integer total_tests = 0;
integer failed_tests = 0;

if_id_reg uut(
    .clk(clk),
    .reset(reset),
    .stall(stall),
    .flush(flush),

    .instr_in(instr_in),
    .pc_in(pc_in),
    .pc4_in(pc4_in),

    .instr_out(instr_out),
    .pc_out(pc_out),
    .pc4_out(pc4_out)
);

always #5 clk = ~clk;

task check;
input [63:0] expected;
input [63:0] actual;
input [127:0] name;
begin
    total_tests = total_tests + 1;

    if(expected !== actual) begin
        $display("FAIL: %s | Expected=%h Got=%h", name, expected, actual);
        failed_tests = failed_tests + 1;
    end
    else begin
        $display("PASS: %s | Value=%h", name, actual);
    end
end
endtask

initial begin

clk = 0;
reset = 1;
stall = 0;
flush = 0;

instr_in = 32'h00000013;
pc_in = 0;
pc4_in = 0;

#10
reset = 0;

/////////////////////////////////////////////////
// Test 1
/////////////////////////////////////////////////

instr_in = 32'hAAAA1111;
pc_in = 64'h10;
pc4_in = 64'h14;

#10
check(64'h10, pc_out, "PC update");
check(64'h14, pc4_out, "PC+4 update");

/////////////////////////////////////////////////
// Test 2
/////////////////////////////////////////////////

instr_in = 32'hBBBB2222;
pc_in = 64'h20;
pc4_in = 64'h24;

#10
check(64'h20, pc_out, "PC update 2");

/////////////////////////////////////////////////
// Test 3 (stall)
/////////////////////////////////////////////////

stall = 1;

instr_in = 32'hCCCC3333;
pc_in = 64'h30;
pc4_in = 64'h34;

#10
check(64'h20, pc_out, "stall keeps old PC");

/////////////////////////////////////////////////
// Test 4
/////////////////////////////////////////////////

stall = 0;

instr_in = 32'hDDDD4444;
pc_in = 64'h40;
pc4_in = 64'h44;

#10
check(64'h40, pc_out, "stall released");

/////////////////////////////////////////////////
// Test 5 (flush)
/////////////////////////////////////////////////

flush = 1;

#10
check(64'h0, pc_out, "flush clears PC");

/////////////////////////////////////////////////
// Test 6
/////////////////////////////////////////////////

flush = 0;

instr_in = 32'hEEEE5555;
pc_in = 64'h50;
pc4_in = 64'h54;

#10
check(64'h50, pc_out, "PC update after flush");

/////////////////////////////////////////////////
// Test 7
/////////////////////////////////////////////////

instr_in = 32'hFFFF6666;
pc_in = 64'h60;
pc4_in = 64'h64;

#10
check(64'h60, pc_out, "PC update 7");

/////////////////////////////////////////////////
// Test 8
/////////////////////////////////////////////////

instr_in = 32'hAAAA7777;
pc_in = 64'h70;
pc4_in = 64'h74;

#10
check(64'h70, pc_out, "PC update 8");

/////////////////////////////////////////////////
// Test 9
/////////////////////////////////////////////////

instr_in = 32'hBBBB8888;
pc_in = 64'h80;
pc4_in = 64'h84;

#10
check(64'h80, pc_out, "PC update 9");

/////////////////////////////////////////////////
// Test 10
/////////////////////////////////////////////////

instr_in = 32'hCCCC9999;
pc_in = 64'h90;
pc4_in = 64'h94;

#10
check(64'h90, pc_out, "PC update 10");

/////////////////////////////////////////////////

$display("=================================");
$display("PASSED: %0d", total_tests - failed_tests);
$display("FAILED: %0d", failed_tests);
$display("TOTAL : %0d", total_tests);

$finish;

end

endmodule