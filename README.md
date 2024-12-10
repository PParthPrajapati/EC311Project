# Morse Decoder

## Team Members
- Parth Prajapati  
- Arav Tyagi  
- Karim Elzokm  
- Ksenia Suglobuva  

*Link to Project Video*  

---

## **Overview of the Project**

Our *Morse Code Decoder* project is designed to decode Morse code signals into ASCII characters in real time. The system utilizes four input buttons:
- One for dots (*dot*),
- One for dashes (*dash*),
- One to mark the end of a character sequence (*char_end*), and
- One for resetting the input (*reset*).

The decoded characters are displayed on a VGA screen, ensuring clear and concise output. The decoder module processes button inputs using a state-based approach, appending bits for dots and dashes to build the Morse code sequence, and triggers decoding when the *end-of-sequence* button is pressed. 

The design incorporates mechanisms to avoid duplicate signal counts and accurately detect input transitions. The VGA display is integrated to show the decoded ASCII characters, with the current implementation displaying one character at a time in the center of the screen—similar to decoding Morse code manually.

---

## **How to Run Your Project**

1. Set `top.v` as the top module of the hierarchy.
2. Run synthesis, implementation, and generate the bitstream for this file.
3. Upload the bitstream onto the FPGA.
4. Use the buttons on the FPGA to control the characters you want to display. The button assignments are defined in the constraints file (included in the project files):
   - `dot`: Button Up  
   - `dash`: Button Right  
   - `char_end`: Button Left  
   - `reset`: Switch 1  

Once uploaded to the FPGA, you can input your Morse sequences followed by `char_end` to decode your message!

---

## **Overview of the Code Structure**

The code structure is simple and modular. The top module, `top.v`, connects all the sub-modules together. It consists of three sub-modules:
- **`morse_decoder`**: Receives dot and dash sequences (followed by `char_end`) and outputs the corresponding ASCII hex code.
- **`vga_controller`**: Generates the VGA signals (`h-sync`, `v-sync`, `video_on`, `x`, and `y`).
- **`ascii_test`**: Generates the 12-bit RGB output based on the ASCII hex code and VGA signals.

### Inputs and Outputs of the Top Module:
**Inputs**:
- `dot`
- `dash`
- `reset`
- `clk`
- `char_end`

**Outputs**:
- `RGB`
- `h-sync`
- `v-sync`

---

## **Operation of `morse_decoder` Module**

The `morse_decoder` module processes the sequence of dots and dashes based on transitions from low to high (detected using previous states `dot_prev` and `dash_prev`). Dots are assigned a value of `0` and dashes are assigned a value of `1`. These values are appended to an intermediate variable, `morse_sequence`.

A counter, `bit_count`, differentiates patterns (e.g., 2 dots vs. 4 dots) based on the number of inputs. When `char_end` goes high, the following sequence occurs:
1. `bit_count` is used to filter the sequence.
2. A case statement matches `morse_sequence` to the corresponding ASCII character.

The ASCII hex code is assigned to the output register `ascii_char`, which is passed to the top module for display through the VGA.

This design allows for easy expansion by adding more Morse sequences to the decoding library in the case statement.

---
