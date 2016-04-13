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

module data2_generator (interface r);
  parameter WIDTH = 11;
  parameter FL = 0; //ideal environment
  parameter DELAY = 0;
  logic [WIDTH-1:0] SendValue=0;
  always
  begin 
    #DELAY;
    SendValue =2;
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

module arbiter_tb;
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) data_intf[3:0] (); 
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) db_intf[3:0] (); 
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(2)) ctrl_intf [1:0] (); 
	data_generator #(.WIDTH(11), .FL(0), .DELAY(5)) dg1(.r(data_intf[0]));
	data_generator #(.WIDTH(11), .FL(0), .DELAY(15)) dg2(.r(data_intf[1]));
	data_generator #(.WIDTH(11), .FL(0), .DELAY(7)) dg3(.r(data_intf[2]));
	data_generator #(.WIDTH(11), .FL(0), .DELAY(15)) dg4(.r(data_intf[3]));
	data2_generator #(.WIDTH(2), .FL(0), .DELAY(45)) dg5(.r(ctrl_intf[0]));

	input_arbiter_block input_arbiter_block1(.in1(data_intf[0]), .in2(data_intf[1]), .in3(data_intf[2]), .in4(data_intf[3]),
							.data1_to_merge(db_intf[0]), .data2_to_merge(db_intf[1]),
							.core_control(ctrl_intf[0]), .merge_control_out(ctrl_intf[1]));

	data_bucket #(.WIDTH(11), .BL(0)) db1(.l(db_intf[0]));
	data_bucket #(.WIDTH(11), .BL(0)) db2(.l(db_intf[1]));
	data_bucket #(.WIDTH(2), .BL(0)) db3(.l(ctrl_intf[1]));

endmodule