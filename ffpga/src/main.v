// vga.v — top-level module for SLG47910V (ForgeFPGA / Shrike Lite)
// Vicharak's Blinky Demo
// Signals must match io_map.pcf assignments.

(* top *) module vga(
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

  assign LED_en = 1'b1;
  assign clk_en = 1'b1;


endmodule 
