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

    localparam RED = 3'b100;
    localparam GREEN = 3'b010;
    localparam BLUE = 3'b001;
    localparam WHITE = 3'b111;
    localparam BLACK = 3'b000;

    reg [2:0] rgb;

    assign r = rgb[2];
    assign g = rgb[1];
    assign b = rgb[0];

    reg [9:0] rect_x;
    reg [9:0] rect_y;
    
    wire draw_rect_active;

    draw_rect u_draw_rect (
        .hcount (hcount),
        .vcount (vcount),
        .rect_x (rect_x),
        .rect_y (rect_y),
        .width  (10'd64),
        .height (10'd64),
        .draw_rect (draw_rect_active)
    );

    always @ (*) begin
        if (!rst) begin
            rgb = BLACK;
        end else begin
            if (!video_active)
                rgb = BLACK;
            else begin 
                if (draw_rect_active)
                    rgb = WHITE;

                else
                    rgb = BLACK;
            end
        end
    end

    //UPDATE BLOCK
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            rect_x <= 100;
            rect_y <= 100;
        end
        
        else if (tick_25MHZ && frame_start) begin
            rect_x <= rect_x + 2;
        end
    end

endmodule
