module grom_top
  (input  i_Clk,        // Main Clock
   input  i_Switch_1,   // SW1 button

   output o_LED_1,
   output o_LED_2,
   output o_LED_3,
   output o_LED_4,
 // Segment1 is upper digit, Segment2 is lower digit
   output o_Segment1_A,
   output o_Segment1_B,
   output o_Segment1_C,
   output o_Segment1_D,
   output o_Segment1_E,
   output o_Segment1_F,
   output o_Segment1_G,
   //
   output o_Segment2_A,
   output o_Segment2_B,
   output o_Segment2_C,
   output o_Segment2_D,
   output o_Segment2_E,
   output o_Segment2_F,
   output o_Segment2_G
   );

 wire [7:0] display_out;
 wire hlt;

 grom_computer computer(.clk(i_Clk),.reset(i_Switch_1),.hlt(hlt),.display_out(display_out));

 hex_to_7seg upper_digit
  (.i_Clk(i_Clk),
   .i_Value(display_out[7:4]),
   .o_Segment_A(o_Segment1_A),
   .o_Segment_B(o_Segment1_B),
   .o_Segment_C(o_Segment1_C),
   .o_Segment_D(o_Segment1_D),
   .o_Segment_E(o_Segment1_E),
   .o_Segment_F(o_Segment1_F),
   .o_Segment_G(o_Segment1_G));

  hex_to_7seg lower_digit
  (.i_Clk(i_Clk),
   .i_Value(display_out[3:0]),
   .o_Segment_A(o_Segment2_A),
   .o_Segment_B(o_Segment2_B),
   .o_Segment_C(o_Segment2_C),
   .o_Segment_D(o_Segment2_D),
   .o_Segment_E(o_Segment2_E),
   .o_Segment_F(o_Segment2_F),
   .o_Segment_G(o_Segment2_G));

  assign o_LED_1 = hlt;
  assign o_LED_2 = 1'b0;
  assign o_LED_3 = 1'b1;
  assign o_LED_4 = 1'b0;
endmodule
