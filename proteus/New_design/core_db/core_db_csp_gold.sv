
//import SystemVerilogCSP::*;

`include "svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,8)

module core_db_csp_gold (interface db_8b, interface data_in_11b);
	logic [10:0] router_data;
	logic [7:0] db_data;
	logic [6:0] raw_data;

	task automatic hamming_fix(ref [6:0] raw_data_ref);
		logic P1;
		logic P2;
		logic P4;
		logic [2:0] parity_bit;
		// Parse the data from the router. The format is : | 4-bit IP | 7-bit data |
		//		data section has a format of: | P1 P2 D1 P3 D2 D3 D4 |
		// Check parity and fix data bits
		P1 = 0;
		P2 = 0;
		P4 = 0;
		parity_bit = 0;
		P1 = raw_data_ref[0] ^ raw_data_ref[2] ^ raw_data_ref[4] ^ raw_data_ref[6];
		P2 = raw_data_ref[1] ^ raw_data_ref[2] ^ raw_data_ref[5] ^ raw_data_ref[6];
		P4 = raw_data_ref[3] ^ raw_data_ref[4] ^ raw_data_ref[5] ^ raw_data_ref[6];
		if (P1 == 1)
		begin
			parity_bit = parity_bit + 1;
		end
		if (P2 == 1) 
		begin
			parity_bit = parity_bit + 2;
		end
		if (P4 == 1) 
		begin
			parity_bit = parity_bit + 4;
		end
		if (parity_bit != 0) 
		begin
			raw_data_ref[parity_bit-1] = ~raw_data_ref[parity_bit-1];
		end
	endtask


	always
		begin
			router_data = 0;
			db_data = 0;
			raw_data = 0;
			forever begin
				// Select bit is 1, get 11-bit data from router
				data_in_11b.Receive(router_data);
				raw_data = router_data[10:4];
				hamming_fix(raw_data);
				// Put fixed data into data bucket with 8-bits format: | 4-bit IP | 4-bit Data |
				db_data[3:0] = router_data[3:0];
				db_data[7:4] = {raw_data[6], raw_data[5], raw_data[4], raw_data[2]};
				db_8b.Send(db_data);
			end
		end
endmodule