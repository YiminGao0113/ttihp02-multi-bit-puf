/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_multi_bit_puf_wrapper (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

	// Signals mapped from the wrapper input
    wire start_signal = ena;           // Map START signal to ena
    wire reset_signal = ~rst_n;        // Map reset signal (active-low)
    
    // Instantiate puf
    wire [7:0] puf_out;
    puf puf_instance (
	.clk(clk),
        .START(start_signal),
	.addr(ui_in[3:0]),
        .reset(reset_signal),
        .OUT_reg(puf_out)
    );
	
    // Assign the output of multi_bit_puf to uo_out
    assign uo_out = puf_out;

    // Unused output bits are assigned to 0
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;


  // List all unused inputs to prevent warnings such as:
  wire _unused = &{ui_in[7:4], uio_in, 1'b0};

endmodule
