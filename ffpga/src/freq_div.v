module freq_div(
    input clk,
    input rst,
    output reg tick_25MHZ
);

    reg div_ff = 1'b0;

    always @ (posedge clk or negedge rst) begin
        if(!rst) begin
            div_ff <= 1'b0;
            tick_25MHZ <= 1'b0;
        end else begin
            div_ff <= ~div_ff;
            tick_25MHZ <= div_ff;
        end
    end

endmodule 
