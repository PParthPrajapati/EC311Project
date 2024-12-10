`timescale 1ns / 1ps

module morse_decoder_tb;

    // Inputs
    reg clk;
    reg rst;
    reg dot;
    reg dash;
    reg char_end;

    // Outputs
    wire [7:0] ascii_char;
    wire valid;

    // Instantiate the module
    morse_decoder uut (
        .clk(clk),
        .rst(rst),
        .dot(dot),
        .dash(dash),
        .char_end(char_end),
        .ascii_char(ascii_char),
        .valid(valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 1;
        dot = 0;
        dash = 0;
        char_end = 0;

        // Wait for reset
        #20 rst = 0;

        // Test case 1: Single dot (E)
        #10 dot = 1; #10 dot = 0; // Input a dot
        #10 char_end = 1; #10 char_end = 0; // Signal end of character
        #20; // Wait to observe output

        // Test case 2: Single dash (T)
        #10 dash = 1; #30 dash = 0; // Input a dash
        #10 char_end = 1; #10 char_end = 0; // Signal end of character
        #20;

        // Test case 3: Dot-Dash (A)
        #10 dot = 1; #20 dot = 0; // Input a dot
        #10 dash = 1; #30 dash = 0; // Input a dash
        #10 char_end = 1; #10 char_end = 0; // Signal end of character
        #20;

        // Test case 4: Dash-Dash-Dash (O)
        #10 dash = 1; #10 dash = 0; // Input a dash
        #10 dash = 1; #10 dash = 0; // Input a dash
        #10 dash = 1; #10 dash = 0; // Input a dash
        #10 char_end = 1; #10 char_end = 0; // Signal end of character
        #20;

        // Test case 5: Invalid character (reset mid-sequence)
        #10 dot = 1; #10 dot = 0; // Input a dot
        #10 dash = 1; #10 dash = 0; // Input a dash
        #10 rst = 1; #10 rst = 0; // Reset mid-sequence
        #20;
        
        #10 dash = 1; #10 dash = 0; // Input a dot
        #10 dot = 1; #10 dot = 0; // Input a dash
        #10 dash = 1; #10 dash=0;// Reset mid-sequence
        #10 dot = 1; #10 dot=0;// Reset mid-sequence
        #10 char_end =1; #10 char_end=0;

        #20;

        // Finish simulation
        #50 $stop;
    end

endmodule
