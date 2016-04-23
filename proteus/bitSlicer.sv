module bitSlicer(interface in, interface dataOut, interface addressOut);
	parameter FL = 0;
	parameter BL = 0;
	logic [10:0] inData;
	logic [6:0] data;
	logic [3:0] address;

	always
	begin
		in.Receive(inData);
		#FL;
		address = inData[3:0];
		data = inData[10:4];

		fork
		dataOut.Send(data);
		addressOut.Send(address);
		join
		#BL;
	end
endmodule