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