`timescale 1ns/100ps
import SystemVerilogCSP::*;

module arbiter2 (interface in0, interface in1, interface out, interface ctr);
	parameter WIDTH = 11;
	parameter FL = 2;
	parameter BL = 2;
	parameter ID = 0;
	logic select=0;
	logic [WIDTH-1:0] data;
	logic [1:0] control = ID;
	always
	begin
		wait((in0.status != idle) || (in1.status != idle)); //wait until 1 of the input ports has a token
		
		if((in0.status != idle) && (in1.status != idle)) //if both ports have tokens
		begin
			if(select == 0)
			begin
				in0.Receive(data);
				#FL;
				fork
				out.Send(data);
				ctr.Send(control);
				join
				#BL;
			end
			else if(select == 1)
			begin
				in1.Receive(data);
				#FL;
				fork
				out.Send(data);
				ctr.Send(control);
				join
				#BL;
			end
			select = ~select;
		end
		else if(in0.status != idle) //if input0 has token ready
		begin
				in0.Receive(data);
				#FL;
				$display("data=%b",data);
				fork
				out.Send(data);
				ctr.Send(control);
				join
				#BL;
		end
		else if(in1.status != idle) //if input1 has token ready
		begin
				in1.Receive(data);
				#FL;
				fork
				out.Send(data);
				ctr.Send(control);
				join
				#BL;
		end
	end
endmodule // arbiter2in

module arbiter2_no_data (interface in0, interface in1, interface ctr);
	parameter FL = 2;
	parameter BL = 2;
	logic select = 0;
	logic [1:0] control;
	always
	begin
		wait((in0.status != idle) || (in1.status != idle)); //wait until 1 of the input ports has a token
		
		if((in0.status != idle) && (in1.status != idle)) //if both ports have tokens
		begin
			if(select == 0)
			begin
				in0.Receive(control);
				#FL;
				ctr.Send(control);
				#BL;
			end
			else if(select == 1)
			begin
				in1.Receive(control);
				#FL;
				ctr.Send(control);
				#BL;
			end
			select = ~select;
		end
		else if(in0.status != idle) //if input0 has token ready
		begin
				in0.Receive(control);
				#FL;
				ctr.Send(control);
				#BL;
		end
		else if(in1.status != idle) //if input1 has token ready
		begin
				in1.Receive(control);
				#FL;
				ctr.Send(control);
				#BL;
		end
	end
endmodule // arbiter2in

module plain_buffer(interface left, interface right);
	parameter FL = 2;
	parameter BL = 2;
	parameter WIDTH = 11;
	logic [WIDTH-1:0] data;
	always
	begin
		left.Receive(data);
		#FL;
		right.Send(data);
		#BL;
	end

endmodule

module input_arbiter_block(interface in1, interface in2, interface in3, interface in4,
							interface data1_to_merge, interface data2_to_merge,
							interface core_control, interface merge_control_out);
	// inputs take 11 bits
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(2)) control_intf[2:0] (); 
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) data_intf[3:0] (); 

	arbiter2 #(.WIDTH(11), .FL(2), .BL(2), .ID(0)) ar1(.in0(in1), .in1(in2), .out(data_intf[0]), .ctr(control_intf[0]));
		// ctr goes to ar2_no_data1's in0
	arbiter2 #(.WIDTH(11), .FL(2), .BL(2), .ID(1)) ar2(.in0(in3), .in1(in4), .out(data_intf[2]), .ctr(control_intf[1]));
		// ctr goes to ar2_no_data1's in1

	plain_buffer #(.FL(2), .BL(2), .WIDTH(11)) plain_buffer11(.left(data_intf[0]), .right(data_intf[1]));
	plain_buffer #(.FL(2), .BL(2), .WIDTH(11)) plain_buffer12(.left(data_intf[1]), .right(data1_to_merge));
	plain_buffer #(.FL(2), .BL(2), .WIDTH(11)) plain_buffer21(.left(data_intf[2]), .right(data_intf[3]));
	plain_buffer #(.FL(2), .BL(2), .WIDTH(11)) plain_buffer22(.left(data_intf[3]), .right(data2_to_merge));

	// Cascadubg two 2-inputs arbiter
	arbiter2_no_data #(.FL(2), .BL(2)) ar2_no_data1(.in0(control_intf[0]), .in1(control_intf[1]), .ctr(control_intf[2]));
		// in0 from ar1's ctr port
		// in1 from ar2's ctr port
		// ctr goes to ar2_no_data2's in0
	arbiter2_no_data #(.FL(2), .BL(2)) ar2_no_data2(.in0(control_intf[2]), .in1(core_control), .ctr(merge_control_out)); 
		// in0 from ctr of 'ar2_no_data1'
		// in1 from core
		// ctr goes to 'merge' control

endmodule


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