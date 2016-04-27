`timescale 1ns/100ps
import SystemVerilogCSP::*;


module arbiter2 (interface in0, interface in1, interface out);
	parameter FL = 2;
	parameter BL = 2;
	logic select=0;
	logic [10:0] data;
	always
	begin
		wait((in0.status == 2) || (in1.status == 2)); //wait until 1 of the input ports has a token
		
		if((in0.status == 2) && (in1.status == 2)) //if both ports have tokens
		begin
			if(select == 0)
			begin
				in0.Receive(data);
				#FL;
				out.Send(data);
				#BL;
			end
			else if(select == 1)
			begin
				in1.Receive(data);
				#FL;
				out.Send(data);
				#BL;
			end
			select = ~select;
		end
		else if(in0.status == 2) //if input0 has token ready
		begin
				in0.Receive(data);
				#FL;
				out.Send(data);
				#BL;
		end
		else if(in1.status == 2) //if input1 has token ready
		begin
				in1.Receive(data);
				#FL;
				out.Send(data);
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
		wait((in0.status == 2) || (in1.status == 2)); //wait until 1 of the input ports has a token
		
		if((in0.status == 2) && (in1.status == 2)) //if both ports have tokens
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
		else if(in0.status == 2) //if input0 has token ready
		begin
				in0.Receive(control);
				#FL;
				ctr.Send(control);
				#BL;
		end
		else if(in1.status == 2) //if input1 has token ready
		begin
				in1.Receive(control);
				#FL;
				ctr.Send(control);
				#BL;
		end
	end
endmodule // arbiter2in


module input_arbiter_block(interface in1, interface in2, interface in3, interface in4,
							interface core_data, interface data_out);
	// inputs take 11 bits
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) data_intf[2:0] (); 

	arbiter2 #(.FL(0), .BL(0)) ar1(.in0(in1), .in1(in2), .out(data_intf[0]));
	arbiter2 #(.FL(0), .BL(0)) ar2(.in0(in3), .in1(in4), .out(data_intf[2]));

	arbiter2 #(.FL(0), .BL(0)) ar3(.in0(data_intf[0]), .in1(data_intf[2]), .out(data_intf[1]));
	arbiter2 #(.FL(0), .BL(0)) ar4(.in0(data_intf[1]), .in1(core_data), .out(data_out));

endmodule


