`timescale 1ns / 1ns

module top_module_tb;
    // 输入信号
    reg clk;        // 时钟
    reg reset;      // 复位
    reg ena;        // 使能
    
    // 输出信号
    wire pm;        // AM/PM 指示
    wire [7:0] hh;  // 小时 (BCD)
    wire [7:0] mm;  // 分钟 (BCD)
    wire [7:0] ss;  // 秒 (BCD)
    
    // 内部信号，用于监控
    wire carry_seconds; // 秒计数器的进位信号
    wire carry_minutes; // 分钟计数器的进位信号
    wire carry_seconds2; // 秒计数器的额外进位信号
    
    // 实例化被测模块 (UUT)
    top_module uut (
        .clk(clk),
        .reset(reset),
        .ena(ena),
        .pm(pm),
        .hh(hh),
        .mm(mm),
        .ss(ss)
    );
    
    // 连接内部信号以便监控
    assign carry_seconds = uut.carry_seconds; // 从 top_module 获取秒进位
    assign carry_minutes = uut.carry_minutes; // 从 top_module 获取分钟进位
    assign carry_seconds2 = uut.carry_seconds2; // 从 top_module 获取秒额外进位
    
    // 时钟生成：100MHz (周期 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 测试激励
    initial begin
        // 初始化输入
        reset = 1;  // 复位高电平
        ena = 0;    // 使能关闭
        
        // 复位测试
        #20;
        reset = 0;  // 释放复位
        
        #20
        ena = 1;
        #10000000;      
        $stop;
        end
endmodule
