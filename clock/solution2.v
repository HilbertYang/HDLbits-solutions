module decade(
    input clk,
    input reset,
    input [3:0] reset_num,
    input enable,
    input [3:0] max,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= reset_num;
        else if (q == max && enable)
            q <= 0;
        else if (enable)
            q <= q + 1;
    end
endmodule

module adder_60(
    input clk,
    input reset,
    input inable,
    output cout,
    output [7:0] ss,
    output [7:0] mm
);
    wire [2:0] inable_;

    assign inable_[0] = (ss[3:0] == 9) && inable;
    assign inable_[1] = (ss == 8'h59) && inable;
    assign inable_[2] = (ss == 8'h59 && mm[3:0] == 9) && inable;
    assign cout = (ss == 8'h59 && mm == 8'h59) && inable;

    decade adder1(clk, reset, 4'd0, inable,     4'd9, ss[3:0]);
    decade adder2(clk, reset, 4'd0, inable_[0], 4'd5, ss[7:4]);
    decade adder3(clk, reset, 4'd0, inable_[1], 4'd9, mm[3:0]);
    decade adder4(clk, reset, 4'd0, inable_[2], 4'd5, mm[7:4]);
endmodule

module adder_13(
    input clk,
    input reset,
    input inable,
    output reg [7:0] hh,
    output reg pm_turn
);
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12;      // 12点
            pm_turn <= 1'b0;  // AM
        end
        else if (inable) begin
            case (hh)
                8'h09: hh <= 8'h10; // 09 -> 10
                8'h11: begin        // 11 -> 12，PM翻转
                    hh <= 8'h12;
                    pm_turn <= ~pm_turn;
                end
                8'h12: hh <= 8'h01; // 12 -> 01
                default: hh <= hh + 1; // 其它情况正常加1
            endcase
        end
    end
endmodule

module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);
    wire ena_hh;

    adder_60 adder_sm(clk, reset, ena, ena_hh, ss, mm);
    adder_13 adder_hh(clk, reset, ena_hh, hh, pm);
endmodule
