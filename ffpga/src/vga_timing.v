/*
    TARGET: 640x480 @ 60 FPS

    -> HORIZONTAL
        - Visible: 640
        - Front Porch: 16
        - HSYNC: 96         #The Sync signals are pulled low to signal the end of the line (or end of frame for vsync)
        - Back Porch: 48
        - TOTAL: 800 Pixel Clock Cycles

    -> VERTICAL
        - Visible: 480
        - Front Porch: 10
        - VSYNC: 2
        - Back Porch: 33
        - TOTAL: 525 Pixel Clock Cycles

    -> EACH FRAME -> 800 * 525 = 420000 Clocks
    -> For 60 FPS -> 420000 Clocks * 60 = 25 MHz approx

    The horizontal line time is:

        800 pixels ÷ 25 MHz ≈ 32 µs

    The frame time is:

        525 × 32 µs ≈ 16.8 ms

    which corresponds to about 59.5 Hz with a 25 MHz pixel clock (very close to the nominal 60 Hz).
*/

module vga_timing(
    input clk,
    input rst,
    input tick_25MHZ,

    output hcount,
    output vcount,
    output hsync,
    output vsync,
    output video_active,
    output frame_start,
    output line_start
);

    reg [31:0] counter = 32'd0;

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            counter <= 32'd0;
        end else if (tick_25MHZ) begin
            /**/
        end
    end

endmodule 
