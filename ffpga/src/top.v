// vga.v — top-level module for SLG47910V (ForgeFPGA / Shrike Lite)

(* top *) module top(
  (* iopad_external_pin, clkbuf_inhibit *) input clk,
  (* iopad_external_pin *) input rst,

  (* iopad_external_pin *) output LED,
  (* iopad_external_pin *) output LED_en,
  (* iopad_external_pin *) output clk_en,

  (* iopad_external_pin *) output r,
  (* iopad_external_pin *) output r_en,

  (* iopad_external_pin *) output g,
  (* iopad_external_pin *) output g_en,

  (* iopad_external_pin *) output b,
  (* iopad_external_pin *) output b_en,

  (* iopad_external_pin *) output hsync,
  (* iopad_external_pin *) output hsync_en,

  (* iopad_external_pin *) output vsync,
  (* iopad_external_pin *) output vsync_en

  );

  wire tick_25MHZ;
  wire reset = rst;

  wire [9:0] hcount;
  wire [9:0] vcount;

  wire video_active;
  wire frame_start;
  wire line_start;

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

  vga_renderer u_vga_renderer (
      .clk(clk),
      .rst(reset),
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

  assign LED_en = 1'b1;
  assign clk_en = 1'b1;
  assign r_en = 1'b1;
  assign g_en = 1'b1;
  assign b_en = 1'b1;
  assign vsync_en = 1'b1;
  assign hsync_en = 1'b1;

endmodule 
