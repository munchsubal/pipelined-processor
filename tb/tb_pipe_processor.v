`timescale 1ns/1ps

module tb_pipe_processor;

reg clk;
reg reset;

integer passed;
integer failed;
integer i;

pipe_processor uut(
    .clk(clk),
    .reset(reset)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

task check;
input [63:0] expected;
input [63:0] actual;
begin
    if(expected == actual) begin
        passed = passed + 1;
        $display("PASS PC=%h", actual);
    end
    else begin
        failed = failed + 1;
        $display("FAIL expected=%h got=%h", expected, actual);
    end
end
endtask

initial begin

passed = 0;
failed = 0;

$display("======================================");
$display("PIPELINE PROCESSOR TEST START");
$display("======================================");

reset = 1;
#20;

check(0, uut.pc_current);

reset = 0;

for(i=1;i<=100;i=i+1) begin

    #10;


    check(i*4, uut.pc_current);

end

$display("======================================");
$display("PASSED: %0d", passed);
$display("FAILED: %0d", failed);
$display("TOTAL : %0d", passed+failed);
$display("======================================");

$finish;

end

endmodule