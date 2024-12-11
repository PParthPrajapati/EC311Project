# MORSE DECODER

## Team Members:
- Parth Prajapati  
- Arav Tyagi  
- Karim Elzokm  
- Ksenia Suglobuva  

**Link to Project Video**  
https://drive.google.com/file/d/1lnzDcM3gzE4-zakcDTqW_o5qnYpl5gR4/view?usp=sharing 

---

## OVERVIEW OF THE PROJECT

Our *Morse Code Decoder* project is designed to decode Morse code signals into ASCII characters in real time. The system utilizes four input buttons: one for dots (*dot*), one for dashes (*dash*), one to mark the end of a character sequence (*char_end*), and one for resetting the input (*reset*). The decoded characters are displayed on a VGA screen, ensuring clear and concise output.

The decoder module processes button inputs using a state-based approach, appending bits for dots and dashes to build the Morse code sequence, and triggers decoding when the *end-of-sequence* button is pressed. The design incorporates mechanisms to avoid duplicate signal counts and accurately detect input transitions. The VGA display is integrated to show the decoded ASCII characters, with the current implementation displaying one character at a time in the center of the screen, similar to decoding Morse code manually.

---

## HOW TO RUN YOUR PROJECT

1. Set *`top.v`* as the top of the hierarchy.  
2. Run synthesis, implementation, and generate a bitstream for this file.  
3. Upload the bitstream onto the FPGA.  
4. Use the buttons on the FPGA to control the characters you want to display.  

### Button Mapping (set in the constraints file):
- **Dot**: Button Up  
- **Dash**: Button Right  
- **Char_end**: Button Left  
- **Reset**: Switch 1  

Once uploaded to the FPGA, input your sequences followed by *char_end* to decode your message!

---

## OVERVIEW OF THE CODE STRUCTURE

The code structure is fairly simple. The top module, *`top.v`*, connects all the sub-modules together. There are 4 sub-modules called in the top module:  
- *`morse_decoder`*  
- *`vga_controller`*  
- *`ascii_test`*
- *`ascii_rom`*  

### Sub-Module Responsibilities:
1. **`morse_decoder`**:  
   Responsible for receiving *dot* and *dash* sequences (followed by *char_end*) and outputting the ASCII hex number for the corresponding character.  

2. **`vga_controller`**:  
   Generates the VGA signals (*h-sync, v-sync, video_on, x, and y signals*).  

3. **`ascii_test`**:  
   Handles the rendering of ASCII characters on a VGA screen by determining character placement, fetching bitmap data, and outputting appropriate RGB values for text and background.
4. **`ascii_rom`**:  
   Stores the 8x16 pixel patterns for ASCII characters. Using the character’s ASCII code and the row index, it outputs the corresponding row data to render the character’s bitmap.

### Top Module Inputs:
- **dot**  
- **dash**  
- **reset**  
- **clk**  
- **char_end**  

### Top Module Outputs:
- **RGB**  
- **hsync**  
- **vsync**  

---

## OPERATION OF `morse_decoder` MODULE

The *`morse_decoder`* module processes the sequence of dots and dashes based on input transitions from *low to high*. This is managed using the previous states *`dot_prev`* and *`dash_prev`*.  

### Key Components:
1. **`morse_sequence`**:  
   Dots are assigned as 0s, and dashes as 1s, and appended into this variable.  

2. **`bit_count`**:  
   A counter to differentiate similar patterns (e.g., 2 dots vs. 4 dots) based on the number of inputs pressed.  

3. **Decoding Process**:  
   - When *`char_end`* is high, the module filters sequences by *`bit_count`* and assigns ASCII hex numbers to the sequences via an `if` statement and a `case` statement.  
   - This section of the code serves as the Morse sequence-to-ASCII library. Additional characters can be easily added here.  

4. **Output Register**:  
   The ASCII hex number is assigned to the register *`ascii_char`*, which is used by the top module to display the character through VGA.  
