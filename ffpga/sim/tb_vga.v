`timescale 1ns/1ps

module tb_vga;

    reg clk = 0;
    reg rst = 0;

    wire tick_25MHZ;

    wire [9:0] hcount;
    wire [9:0] vcount;

    wire hsync;
    wire vsync;
    wire video_active;
    wire frame_start;
    wire line_start;

    initial 
        clk = 1'b0;

    always #10 clk = ~clk; //20 ns period ->    --__--__
    //hence tick_25Mhz occurs every 40ns 

    //number of pixel ticks for one VGA frame -> 800*525 = 420000
                                                      // = 420000 * 40 ns = 16.8 ms  

    freq_div u_div(
        .clk(clk),
        .rst(rst),
        .tick_25MHZ(tick_25MHZ)
    );

    vga_timing uut(
        .clk(clk),
        .rst(rst),
        .tick_25MHZ(tick_25MHZ),

        .hcount(hcount),
        .vcount(vcount),

        .hsync(hsync),
        .vsync(vsync),
        .video_active(video_active),

        .frame_start(frame_start),
        .line_start(line_start)
    );

    initial begin

        rst = 0;

        #100;

        rst = 1;

    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_vga);
    end

    always @(posedge clk) begin

        if (tick_25MHZ) begin

            if (hcount >= 800) begin
                $display("ERROR: hcount overflow (%0d)", hcount);
                $finish;
            end

            if (vcount >= 525) begin
                $display("ERROR: vcount overflow (%0d)", vcount);
                $finish;
            end

        end

    end

    initial begin
        #(800 * 40 * 3)

        $display("-----------------------------");
        $display("Simulation Finished");
        $display("hcount = %0d", hcount);
        $display("vcount = %0d", vcount);
        $display("-----------------------------");

        $finish;
    end

endmodule