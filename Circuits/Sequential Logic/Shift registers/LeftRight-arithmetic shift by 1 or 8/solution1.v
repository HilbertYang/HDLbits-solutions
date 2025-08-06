module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= q << 1;
                2'b01: q <= q << 8;
                2'b10: begin
                    if (q[63])
                        q <= {2'b11, q[62:1]};
                    else
                        q <= q >> 1;
                end
                2'b11: begin
                    if (q[63])
                        q <= {8'hFF, q[63:8]};
                    else
                        q <= q >> 8;
                end
            endcase
        end
    end

endmodule
