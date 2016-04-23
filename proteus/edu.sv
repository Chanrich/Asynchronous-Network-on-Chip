module edu(interface datain, interface dataout);
	parameter FL = 2;
	parameter BL = 2;
	logic [6:0] raw_data;
	logic [2:0] parity_bit;
	logic P1;
	logic P2;
	logic P4;
	initial begin
		raw_data = 0;
		parity_bit = 0;
		P1 = 0;
		P2 = 0;
		P4 = 0;
	end
	always begin
		datain.Receive(raw_data);
		P1 = raw_data[0] ^ raw_data[2] ^ raw_data[4] ^ raw_data[6];
		P2 = raw_data[1] ^ raw_data[2] ^ raw_data[5] ^ raw_data[6];
		P4 = raw_data[3] ^ raw_data[4] ^ raw_data[5] ^ raw_data[6];
		parity_bit = 0;
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
			raw_data[parity_bit-1] = ~raw_data[parity_bit-1];
		end
		#FL;
		dataout.Send(raw_data);
		#BL;
	end
endmodule