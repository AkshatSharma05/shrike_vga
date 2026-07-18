module vga_renderer(
    input clk,
    input rst,
    input tick_25MHZ,

    input video_active,
    input frame_start,
    input line_start,

    input [9:0] hcount,
    input [9:0] vcount,

    output r,
    output g,
    output b
);

    reg [2:0] rgb;

    assign r = rgb[0];
    assign g = rgb[1];
    assign b = rgb[2];

    initial begin 
        rgb = 3'b000; 
    end

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            rgb <= 3'b000;
        end else if (tick_25MHZ) begin
            if (!video_active)
                rgb = 3'b000;
            else if (hcount < 213)
                rgb = 3'b100;
            else if (hcount < 426)
                rgb = 3'b010;
            else
                rgb = 3'b001;
        end
    end

endmodule