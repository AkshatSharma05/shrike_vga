// vga.v — top-level module for SLG47910V (ForgeFPGA / Shrike Lite)
// Vicharak's Blinky Demo
// Signals must match io_map.pcf assignments.

(* top *) module top(
  (* iopad_external_pin, clkbuf_inhibit *) input clk,
  (* iopad_external_pin *) input rst,

  (* iopad_external_pin *) output LED,
  (* iopad_external_pin *) output LED_en,
  (* iopad_external_pin *) output clk_en
  );

  wire tick_25MHZ;
  wire reset = rst;

  freq_div u_freq_div (
    .clk       (clk),
    .rst       (reset),
    .tick_25MHZ (tick_25MHZ)
  );

  blink u_blink (
    .clk         (clk),
    .tick_25MHZ  (tick_25MHZ),
    .rst         (reset),
    .LED         (LED)
  );

  wire [9:0] hcount;
  wire [9:0] vcount;
  wire hsync;
  wire vsync;
  wire video_active;
  wire frame_start;
  wire line_start;

  vga_timing u_vga_timing (
      .clk(clk),
      .rst(reset),
      .tick_25MHZ(tick_25MHZ),

      .hcount(hcount),
      .vcount(vcount),

      .hsync(hsync),
      .vsync(vsync),
      .video_active(video_active),

      .frame_start(frame_start),
      .line_start(line_start)
  );

  assign LED_en = 1'b1;
  assign clk_en = 1'b1;


endmodule 
