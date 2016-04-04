`timescale 1ns/100ps
import SystemVerilogCSP::*;

module core (interface dg_8b, interface db_8b, interface data_out_11b, interface data_control_out, interface data_in_11b);
    parameter FL = 2;
	parameter BL = 2;  logic [WIDTH-1:0] SendValue=0;
	logic select=0;
	logic [10:0] router_data;
	logic [7:0] dg_data;
	logic [10:0] output_data;
	logic [1:0] control = 1;
	always begin
		wait((dg_8b.status != idle) || (data_in_11b.status != idle)); //wait until 1 of the input ports has a token
		if((dg_8b.status != idle) && (data_in_11b.status != idle)) //if both ports have tokens
		begin
			if(select == 0)
			begin
				dg_8b.Receive(dg_data);
				output_data[3:0] = dg_data[3:0];
				output_data[6] = dg_data[4];
				output_data[8] = dg_data[5];
				output_data[9] = dg_data[6];
				output_data[10] = dg_data[7];
				output_data[4] = output_data[6] ^ output_data[8] ^ output_data[10];
				output_data[5] = output_data[6] ^ output_data[9] ^ output_data[10];
				output_data[7] = output_data[8] ^ output_data[9] ^ output_data[10];
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
				data_in_11b.Receive(router_data);
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
		else if(dg_8b.status != idle) //if input0 has token ready
		begin
				dg_8b.Receive(data);
				#FL;
				$display("data=%b",data);
				fork
				out.Send(data);
				control = 0;	// Control 0
				ctr.Send(control);
				join
				#BL;
		end
		else if(data_in_11b.status != idle) //if input1 has token ready
		begin
				data_in_11b.Receive(data);
				#FL;
				fork
				out.Send(data);
				control = 1;	// Control 1
				ctr.Send(control);
				join
				#BL;
		end

	end
endmodule