module morse_decoder (
    input clk,
    input rst,
    input dot,          // Input signal for dot
    input dash,         // Input signal for dash
    input char_end,     // Signal indicating end of character
    output reg [7:0] ascii_char, // ASCII character output
    output reg valid    // Indicates if the output is valid
);
    // Store Morse code pattern (up to 6 bits)
    reg [2:0] bit_count;      // Number of dots/dashes in the current sequence
    reg dot_prev, dash_prev; // Indicates previous state of dot and dash as to not double count
    reg [5:0] morse_sequence; // Sequence of dots and dashes
    
    // Initializing registers
    initial morse_sequence = 6'b000000;
    initial dot_prev = 0;
    initial dash_prev = 0;
    

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            morse_sequence <= 6'b0;
            bit_count <= 0;
            ascii_char <= 8'b0;
            valid <= 0;
        end else begin
            // Update previous states
            dot_prev <= dot;
            dash_prev <= dash;
            
            if (dot || dash) begin
                // Enter loop only if on posedge dot or dash
                if ((~dot_prev) && (~dash_prev)) begin
                    morse_sequence <= {morse_sequence[4:0], dot ? 1'b0 : 1'b1};
                    bit_count <= bit_count + 1;

                    valid <= 0;          // Clear valid until processed
//                    
                end
//            
             end else if (char_end) begin
                // Decode Morse sequence only if char_end is high
                valid <= 1; // Output is valid
                if (bit_count == 1) begin
                    case(morse_sequence)
                        6'b000000: ascii_char <= 8'h45;//"E";
                        6'b000001: ascii_char <= 8'h54;//"T";
                    endcase
                end else if (bit_count == 2) begin
                    case(morse_sequence)
                        6'b000001: ascii_char<= 8'h41; //"A";
                        6'b000000: ascii_char<=  8'h49; //"I";
                        6'b000011: ascii_char<=  8'h4d; //"M";
                        6'b000010: ascii_char<= 8'h4e;  //"N";
                    endcase
                end else if (bit_count == 3) begin
                    case(morse_sequence) 
                        6'b000100: ascii_char<= 8'h44; //"D";
                        6'b000110: ascii_char<= 8'h47; //"G";
                        6'b000101: ascii_char<=  8'h4b; //"K";
                        6'b000111: ascii_char<= 8'h4f;  //"O";
                        6'b000010: ascii_char<=  8'h52; //"R";
                        6'b000000: ascii_char<= 8'h53;  //"S";
                        6'b000001: ascii_char<= 8'h55;  //"U";
                        6'b000011: ascii_char<= 8'h57;  //"W";
                    endcase
                end else if (bit_count == 4) begin
                    case(morse_sequence) 
                        6'b001000: ascii_char<= 8'h42; //"B";
                        6'b001010: ascii_char<=  8'h43; //"C";
                        6'b000010: ascii_char<= 8'h46; //"F";
                        6'b000000: ascii_char<= 8'h48;  //"H";
                        6'b000111: ascii_char<= 8'h4a;  //"J";
                        6'b000100: ascii_char<= 8'h4c;  //"L";
                        6'b000110: ascii_char<=  8'h50;  //"P";
                        6'b001101: ascii_char<= 8'h51;  //"Q";
                        6'b000001: ascii_char<= 8'h56;  //"V";
                        6'b001001: ascii_char<= 8'h58; //"X";
                        6'b001011: ascii_char<=  8'h59; //"Y";
                        6'b001100: ascii_char<= 8'h5a; //"Z";
                    endcase 
                end else if (bit_count == 5) begin
                    case(morse_sequence) 
                        6'b001111: ascii_char<= 8'h31; //"1";
                        6'b000111: ascii_char<= 8'h32; //"2";
                        6'b000011: ascii_char<= 8'h33; //"3";
                        6'b000001: ascii_char<= 8'h34; //"4";
                        6'b000000: ascii_char<= 8'h35; //"5";
                        6'b010000: ascii_char<= 8'h36; //"6";
                        6'b011000: ascii_char<= 8'h37; //"7";
                        6'b011100: ascii_char<= 8'h38; //"8";
                        6'b011110: ascii_char<= 8'h39; //"9";
                        6'b011111: ascii_char<= 8'h30; //"0";   
                    endcase 
                end

                // Reset after decoding
                morse_sequence <= 6'b0;
                bit_count <= 0;
                dot_prev = 0;
                dash_prev=0;
            end else begin
                valid <= 0; // Clear valid if no char_end
            end
        end
    end
endmodule
