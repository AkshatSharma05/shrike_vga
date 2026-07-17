module blink(
    input clk,
    input rst,
    input tick_25MHZ,
    output LED
);

    reg [31:0] counter = 32'd0;
    reg LED_status = 1'b0;

    assign LED = LED_status;

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            counter <= 32'd0;
            LED_status <= 1'b0;
        end else if (tick_25MHZ) begin
            counter <= counter + 1'b1;
            if (counter == 25000000-1) begin
                LED_status <= !LED_status;
                counter <= 32'b0;
            end
        end
    end

endmodule 
