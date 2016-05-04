`timescale 1ns/100ps
import SystemVerilogCSP::*;


//Sample data_bucket module
module data_bucket (interface r);
  parameter WIDTH = 8;
  parameter BL = 0; //ideal environment
  logic [WIDTH-1:0] ReceiveValue = 0;
  logic [3:0] true_data;

  task automatic hamming_fix(ref [6:0] raw_data_ref);
    logic P1;
    logic P2;
    logic P4;
    logic [2:0] parity_bit;

    // Parse the data from the router. The format is : | 4-bit IP | 7-bit data |
    //    data section has a format of: | P1 P2 D1 P3 D2 D3 D4 |
    // Check parity and fix data bits
    P1 = 0;
    P2 = 0;
    P4 = 0;
    parity_bit = 0;
    P1 = raw_data_ref[0] ^ raw_data_ref[2] ^ raw_data_ref[4] ^ raw_data_ref[6];
    P2 = raw_data_ref[1] ^ raw_data_ref[2] ^ raw_data_ref[5] ^ raw_data_ref[6];
    P4 = raw_data_ref[3] ^ raw_data_ref[4] ^ raw_data_ref[5] ^ raw_data_ref[6];
    if (P1 == 1)
    begin
      parity_bit = parity_bit + 1;
    end
    if (P2 == 1) 
    begin
      parity_bit = parity_bit + 2;
    end
    if (P4 == 1) 
    begin
      parity_bit = parity_bit + 4;
    end
    if (parity_bit != 0) 
    begin
      raw_data_ref[parity_bit-1] = ~raw_data_ref[parity_bit-1];
    end
  endtask

  
  always
  begin
    r.Receive(ReceiveValue);
    $display("Data bucket receiving %b", ReceiveValue);
  
    hamming_fix(ReceiveValue);
  end
  
endmodule

module calc_parity(interface L, interface R);
    logic [3:0] input_data;
    logic [6:0] output_data;
    integer r;
    task automatic calc_parity(input [3:0] data, output [6:0] data_out);
    // Take input 8-bit data, and output 11-bit data including IP, data and parity bits
    // Calculate and combine parity bits in output
    logic [6:0] in_data;
    in_data[2] = data[0];
    in_data[4] = data[1];
    in_data[5] = data[2];
    in_data[6] = data[3];
    in_data[0] = in_data[2] ^ in_data[4] ^ in_data[6];
    in_data[1] = in_data[2] ^ in_data[5] ^ in_data[6];
    in_data[3] = in_data[4] ^ in_data[5] ^ in_data[6];
    //$display("Original data: %b", data);
    $display("Original data with parity: %b", in_data);
    r = $random() % 7;
    in_data[0] = ~in_data[0];
    $display("Modified data wtih parity: %b", in_data);
    data_out = in_data; 
  endtask

  always begin
      L.Receive(input_data);
      // Calculate and combine parity bits in output
      calc_parity(input_data, output_data);
      R.Send(output_data);

  end
endmodule

module edu_tb;
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(7)) intf [1:0]();
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(4)) manual_input();
  calc_parity cp (manual_input, intf[0]);
	edu edu(intf[0], intf[1]);
	data_bucket #(.WIDTH(7)) split_db2(intf[1]);
  initial begin
    manual_input.Send(4'b0000);
    #10;
    manual_input.Send(4'b1001);
    #10;
    manual_input.Send(4'b0101);
    #10;
    manual_input.Send(4'b1111);

  end
endmodule