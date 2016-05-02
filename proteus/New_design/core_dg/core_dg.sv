`timescale 1ns/100ps
import SystemVerilogCSP::*;

module core_dg (interface dg_8b, interface data_out_11b);
    parameter FL = 0;
	parameter BL = 0;  
	logic [7:0] dg_data;
	logic [10:0] output_data;
	
	task automatic calc_parity(input [7:0] data, output [10:0] data_out);
		// Take input 8-bit data, and output 11-bit data including IP, data and parity bits
		// Calculate and combine parity bits in output
		logic [10:0] in_data;
		in_data[3:0] = data[3:0];
		in_data[6] = data[4];
		in_data[8] = data[5];
		in_data[9] = data[6];
		in_data[10] = data[7];
		in_data[4] = in_data[6] ^ in_data[8] ^ in_data[10];
		in_data[5] = in_data[6] ^ in_data[9] ^ in_data[10];
		in_data[7] = in_data[8] ^ in_data[9] ^ in_data[10];
		data_out = in_data;	
	endtask

	always 
		begin
			dg_8b.Receive(dg_data);

			// Calculate and combine parity bits in output
			calc_parity(dg_data, output_data);
			#FL;

			data_out_11b.Send(output_data);

			#BL;
		end
endmodule

