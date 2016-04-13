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

module core_tb;
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(8)) intf[1:0] (); 
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) intf_11b[1:0] (); 
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(2)) intf_2b (); 

	data_generator #(.WIDTH(8), .FL(0), .DELAY(5)) dg1(.r(intf[0]));
	data_generator #(.WIDTH(11), .FL(0), .DELAY(5)) dg2(.r(intf_11b[1]));

	core core (.dg_8b(intf[0]), .db_8b(intf[1]), .data_out_11b(intf_11b[0]), .data_control_out(intf_2b), .data_in_11b(intf_11b[1]));

	data_bucket #(.WIDTH(2), .BL(0)) db1(.l(intf_2b));
	data_bucket #(.WIDTH(11), .BL(0)) db2(.l(intf_11b[0]));
	data_bucket #(.WIDTH(8), .BL(0)) db3(.l(intf[1]));
endmodule