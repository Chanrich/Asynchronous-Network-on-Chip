`timescale 1ns/100ps
import SystemVerilogCSP::*;

module data_generator (interface r);
  parameter WIDTH = 11;
  parameter FL = 0; //ideal environment
  parameter DELAY = 0;
  logic [WIDTH-1:0] SendValue=0;
  always
  begin 
    #DELAY;
    SendValue = $random() % (2**WIDTH);
    #FL;
    r.Send(SendValue);
  end
endmodule

module data_bucket (interface l);
  parameter WIDTH = 11;
  parameter BL = 0; //ideal environment
  logic [WIDTH-1:0] ReceiveValue = 0;
  always
  begin
    l.Receive(ReceiveValue);
    #BL;
    $display("########## Value result is %d", ReceiveValue);
  end
endmodule


module node_tb;
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) data_inputs[3:0] (); 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) data_outputs[3:0] (); 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(8)) data_generator_intf (); 
  Channel #(.hsProtocol(P4PhaseBD), .WIDTH(8)) data_bucket_intf (); 

  // data_generator #(.WIDTH(8), .FL(0), .DELAY(5)) dg1(.r(intf[0]));

  data_bucket #(.WIDTH(8), .BL(0)) db1(.l(data_bucket_intf));

  // Set node to IP 2
  node #(.MyIP(4'b0010)) node1 (.in1(data_inputs[0]), .in2(data_inputs[1]), .in3(data_inputs[2]), .in4(data_inputs[3]), 
   .out1(data_outputs[0]), .out2(data_outputs[1]), .out3(data_outputs[2]), .out4(data_outputs[3]),
   .db(data_bucket_intf), .dg(data_generator_intf));

  initial 
  begin
    data_generator_intf.Send(8'b11110010);
    #40;
    data_generator_intf.Send(8'b10100010);
    #40;
    data_generator_intf.Send(8'b10101110);
    #100;
    data_generator_intf.Send(8'b10100100);

  end
endmodule