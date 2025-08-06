module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 

    wire carry_minutes, carry_seconds, carry_seconds2;
    bcd_counter_2digit counter_seconds (
        .clk(clk),
        .reset(reset),
        .enable(ena),
        .tens(ss[7:4]),
        .ones(ss[3:0]),
        .carry_out(carry_seconds)
    );
    bcd_counter_2digit_formm counter_minutes (
        .clk(clk),
        .reset(reset),
        .enable(carry_seconds),
        .tens(mm[7:4]),
        .ones(mm[3:0]),
        .carry_out(carry_minutes)
    );
    bcd_counter_2digit_forhh counter_hours (
        .clk(clk),
        .reset(reset),
        .enable(carry_minutes),
        .tens(hh[7:4]),
        .ones(hh[3:0]),
        .carry_out(pm)
    );

endmodule

module bcd_counter_2digit (
    input wire clk,          // 时钟输入
    input wire reset,        // 同步复位
    input wire enable,       // 计数使能
    output reg [3:0] tens,   // 十位BCD输出
    output reg [3:0] ones,   // 个位BCD输出
    output reg carry_out     // 进位输出，用于驱动下一个计数器
);

    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'b0000;      // 复位时清零
            ones <= 4'b0000;
            carry_out <= 1'b0;    // 复位时进位清零
        end
        else if (enable) begin
            // 提前在58时产生carry_out信号
            carry_out <= (tens == 4'b0101 && ones == 4'b1000) ? 1'b1 : 1'b0;

            if (tens == 4'b0101 && ones == 4'b1001) begin  // 到达59
                tens <= 4'b0000;  // 清零十位
                ones <= 4'b0000;  // 清零个位
            end
            else if (ones == 4'b1001) begin  // 个位达到9
                ones <= 4'b0000;    // 个位清零
                tens <= tens + 1;   // 十位加1
            end
            else
                ones <= ones + 1;   // 个位加1
        end
        else begin
            carry_out <= 1'b0;      // 未使能时进位为0
        end
    end

endmodule

module bcd_counter_2digit_formm (
    input wire clk,          // 时钟输入
    input wire reset,        // 同步复位
    input wire enable,       // 计数使能
    output reg [3:0] tens,   // 十位BCD输出
    output reg [3:0] ones,   // 个位BCD输出
    output carry_out     // 进位输出，用于驱动下一个计数器
);

    assign carry_out = (tens == 4'b0101 && ones == 4'b1001) && enable; // 当到达59时，提前产生进位信号

    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'b0000;      // 复位时清零
            ones <= 4'b0000;
        end
        else begin
            if (enable) begin
                if (tens == 4'b0101 && ones == 4'b1001) begin  // 到达59
                    tens <= 4'b0000;  // 清零十位
                    ones <= 4'b0000;  // 清零个位
                end
                else if (ones == 4'b1001) begin  // 个位达到9
                    ones <= 4'b0000;    // 个位清零
                    tens <= tens + 1;   // 十位加1
                end
                else
                    ones <= ones + 1;   // 个位加1
            end

        end
    end

endmodule

module bcd_counter_2digit_forhh (
    input wire clk,          // 时钟输入
    input wire reset,        // 同步复位
    input wire enable,       // 计数使能
    output reg [3:0] tens,   // 十位BCD输出
    output reg [3:0] ones,   // 个位BCD输出
    output reg carry_out     // 进位输出，用于驱动下一个计数器
);

    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'b0001;      // 复位时置十二
            ones <= 4'b0010;
            carry_out <= 1'b0;    // 复位时进位清零
        end
        else if (enable) begin
            if(tens == 4'b0001 && ones == 4'b0001)begin
                carry_out <= ~carry_out; // 进位信号翻转
            end
            if (tens == 4'b0001 && ones == 4'b0010) begin  // 到达12
                tens <= 4'b0000;  // 清零十位
                ones <= 4'b0001;  // 置一个位
            end
            else if (ones == 4'b1001) begin  // 个位达到9
                ones <= 4'b0000;    // 个位清零
                tens <= tens + 1;   // 十位加1
            end
            else
                ones <= ones + 1;   // 个位加1
        end
        else begin
            carry_out <= carry_out; // 未使能时保持进位状态
        end
    end

endmodule

