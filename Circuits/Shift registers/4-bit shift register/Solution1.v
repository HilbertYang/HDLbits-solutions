module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q); 
    always @(posedge clk)begin
        if(areset)begin
        q <= 0;
        end
        else begin
            if(load)begin
                q <= data;
            end
            else if (ena)begin
                q[3]<=1'b0;
                q[2:0]<=q[3:1];
            end
            else begin
                q<=q;
            end
        end
    end
    

endmodule
