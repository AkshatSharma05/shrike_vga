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

    wire r,g,b;

    reg [2:0] framebuffer [0:479][0:639];
    integer fd;
    integer x;
    integer y;

    task write_ppm;
    begin

        fd = $fopen("frame.ppm", "w");

        if (fd == 0) begin
            $display("ERROR: Couldn't create frame.ppm");
            $finish;
        end

        // PPM header
        $fdisplay(fd, "P3");   //ASCII PPM
        $fdisplay(fd, "640 480");
        $fdisplay(fd, "255");  // 8 bit (max color val)

        for (y = 0; y < 480; y = y + 1) begin

            for (x = 0; x < 640; x = x + 1) begin

                case (framebuffer[y][x])

                    3'b000: $fwrite(fd, "0 0 0 ");
                    3'b001: $fwrite(fd, "0 0 255 ");
                    3'b010: $fwrite(fd, "0 255 0 ");
                    3'b011: $fwrite(fd, "0 255 255 ");

                    3'b100: $fwrite(fd, "255 0 0 ");
                    3'b101: $fwrite(fd, "255 0 255 ");
                    3'b110: $fwrite(fd, "255 255 0 ");
                    3'b111: $fwrite(fd, "255 255 255 ");

                endcase

            end

            $fwrite(fd, "\n");

        end

        $fclose(fd);

        $display("Frame written to frame.ppm");

    end

    endtask

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

    vga_renderer u_vga_renderer (
      .clk(clk),
      .rst(rst),
      .tick_25MHZ(tick_25MHZ),

      .video_active(video_active),
      .line_start(line_start),
      .frame_start(frame_start),

      .hcount(hcount),
      .vcount(vcount),

      .r(r),
      .g(g),
      .b(b)
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

    always @(posedge clk) begin
        if (tick_25MHZ && video_active) begin
            framebuffer[vcount[8:0]][hcount] <= {r, g, b};
        end
    end

    initial begin

        repeat(2) @(posedge frame_start);

        write_ppm();

        $finish;

    end

    // initial begin
    //     #(800 * 40 * 3)

    //     $display("-----------------------------");
    //     $display("Simulation Finished");
    //     $display("hcount = %0d", hcount);
    //     $display("vcount = %0d", vcount);
    //     $display("-----------------------------");

    //     $finish;
    // end

endmodule