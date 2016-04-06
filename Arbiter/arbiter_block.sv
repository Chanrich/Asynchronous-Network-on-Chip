`timescale 1ns/100ps
import SystemVerilogCSP::*;

module arbiter2 (interface in0, interface in1, interface out, interface ctr);
	parameter WIDTH = 11;
	parameter FL = 2;
	parameter BL = 2;
	logic select=0;
	logic [WIDTH-1:0] data;
	logic [1:0] control = 1;
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
				control = 0;	// Control 0
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
				control = 1;	// Control 1
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
				control = 0;	// Control 0
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
				control = 1;	// Control 1
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
	logic [1:0] control = 1;
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



module input_arbiter_block(interface in1, interface in2, interface in3, interface in4,
							interface data1_to_merge, interface data2_to_merge,
							interface core_control, interface merge_control_out);
	// inputs take 11 bits
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(2)) control_intf[2:0] (); 

	arbiter2 #(.WIDTH(11), .FL(2), .BL(2)) ar1(.in0(in1), .in1(in2), .out(data1_to_merge), .ctr(control_intf[0]));
		// ctr goes to ar2_no_data1's in0
	arbiter2 #(.WIDTH(11), .FL(2), .BL(2)) ar2(.in0(in3), .in1(in4), .out(data2_to_merge), .ctr(control_intf[1]));
		// ctr goes to ar2_no_data1's in1
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