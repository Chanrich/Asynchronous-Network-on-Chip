import SystemVerilogCSP::*;
//`include "svc2rtl.sv"
//`E1OFN_M(2,11)

module core_dg_csp_gold (interface dg_8b, interface data_out_11b);
	logic [10:0] dg_data;
	logic [10:0] output_data;
	logic [10:0] in_data;
	always 
		begin
			dg_data = 0;
			output_data = 0;
			in_data = 0;
			forever begin
				dg_8b.Receive(dg_data);
				// Calculate and combine parity bits in output
				in_data[3:0] = dg_data[3:0];
				in_data[6] = dg_data[4];
				in_data[8] = dg_data[5];
				in_data[9] = dg_data[6];
				in_data[10] = dg_data[7];
				in_data[4] = in_data[6] ^ in_data[8] ^ in_data[10];
				in_data[5] = in_data[6] ^ in_data[9] ^ in_data[10];
				in_data[7] = in_data[8] ^ in_data[9] ^ in_data[10];
				output_data = in_data;	
				data_out_11b.Send(output_data);
		end
		end
endmodule

