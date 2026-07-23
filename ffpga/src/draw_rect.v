module draw_rect(
    input [9:0] hcount,
    input [9:0] vcount,

    input [9:0] rect_x,
    input [9:0] rect_y,

    input [9:0] width,
    input [9:0] height,

    output draw_rect
);

assign draw_rect = (hcount >= rect_x) &&
                   (hcount <  rect_x + width) &&
                   (vcount >= rect_y) &&
                   (vcount <  rect_y + height);

endmodule
