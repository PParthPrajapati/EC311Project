`timescale 1ns / 1ps

module top(
    input clk,          // 100MHz on Basys 3
    input reset,        // btnC on Basys 3
    output hsync,       // to VGA connector
    output vsync,       // to VGA connector
    input dot,
    input dash,
    input char_end,
    output [11:0] rgb   // to DAC, to VGA connector
    );
    
    // signals
    wire [9:0] w_x, w_y;
    wire w_video_on, w_p_tick, valid;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    wire [7:0] ascii_char;
    
    // VGA Controller
    vga_controller vga(.clk_100MHz(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                       .video_on(w_video_on), .p_tick(w_p_tick), .x(w_x), .y(w_y));
                       
    morse_decoder morse(.clk(clk), .rst(reset), .dot(dot), .dash(dash), .char_end(char_end), .ascii_char(ascii_char), .valid(valid));
    // Text Generation Circuit
    ascii_test at(.clk(clk), .video_on(w_video_on), .x(w_x), .y(w_y), .ascii_add(ascii_char), .rgb(rgb_next));
    
    // rgb buffer
    always @(posedge clk)
        if(w_p_tick)
            rgb_reg <= rgb_next;
            
    // output
    assign rgb = rgb_reg;
      
endmodule
