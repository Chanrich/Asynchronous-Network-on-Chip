`include "svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,3)

 module nodemerge_csp_gold (interface in1, interface in2, interface in3, interface in4, interface control_in, interface out);
	logic [10:0] data;
	logic [2:0] control_in_bit;
	always begin
		data = 0;
		control_in_bit = 0;
		forever begin
		control_in.Receive(control_in_bit);
		if (control_in_bit == 3'b000) 
			begin
				in1.Receive(data);
			end
		else if (control_in_bit == 3'b001)
			begin
				in2.Receive(data);
			end
		else if (control_in_bit == 3'b010)
			begin
				in3.Receive(data);
			end
		else if (control_in_bit == 3'b011)
			begin
				in4.Receive(data);
			end
		out.Send(data);
		end
	end
  endmodule