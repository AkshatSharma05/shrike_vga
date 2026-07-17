`timescale 1ns / 1ps // one simulation time unit is 1 ns with 1 ps precision in simulator

module tb_vga;

reg clk = 0; //reg because tb is driving it
reg rst = 1;

wire LED;  //wire because dut will drive it 
wire LED_en;
wire clk_en;

vga dut (
    .clk(clk),
    .rst(rst),
    .LED(LED),
    .LED_en(LED_en),
    .clk_en(clk_en)
);

always #5 clk = ~clk; // this defines a 10 ns period with 50% duty cycle periodic clock signal

initial begin
    $display("Simulation started");
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_vga);

    // nRST is active-low: press reset, then release it.
    rst = 1'b0;
    #20;
    rst = 1'b1;

    #500;

    $display("Simulation ended");

    $finish;
end

endmodule
