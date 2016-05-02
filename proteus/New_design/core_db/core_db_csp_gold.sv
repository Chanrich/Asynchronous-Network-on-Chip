`include "svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,8)

module core_db_csp_gold (interface db_8b, interface data_in_11b);
	logic [10:0] router_data;
	logic [7:0] db_data;
	logic [6:0] raw_data;
	logic p1;
	logic p2;
	logic p4;
	logic [2:0] parity_bit;
	always
		begin
			router_data = 0;
			db_data = 0;
			raw_data = 0;
			p1 = 0;
			p2 = 0;
			p4 = 0;
			parity_bit = 0;
			forever begin
				// Select bit is 1, get 11-bit data from router
				data_in_11b.Receive(router_data);
				raw_data = router_data[10:4];
				p1 = raw_data[0] ^ raw_data[2] ^ raw_data[4] ^ raw_data[6];
				p2 = raw_data[1] ^ raw_data[2] ^ raw_data[5] ^ raw_data[6];
				p4 = raw_data[3] ^ raw_data[4] ^ raw_data[5] ^ raw_data[6];
				if (p1 == 1)
				begin
					parity_bit = parity_bit + 1;
				end
				if (p2 == 1) 
				begin
					parity_bit = parity_bit + 2;
				end
				if (p4 == 1) 
				begin
					parity_bit = parity_bit + 4;
				end
				if (parity_bit != 0) 
				begin
					raw_data[parity_bit-1] = ~raw_data[parity_bit-1];
				end
				// Put fixed data into data bucket with 8-bits format: | 4-bit IP | 4-bit Data |
				db_data[3:0] = router_data[3:0];
				db_data[7:4] = {raw_data[6], raw_data[5], raw_data[4], raw_data[2]};
				db_8b.Send(db_data);
			end
		end
endmodule