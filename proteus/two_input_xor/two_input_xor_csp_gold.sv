
//import SystemVerilogCSP::*;

`include "svc2rtl.sv"
`E1OFN_M(2,4)


module two_input_xor_csp_gold (interface in, interface addr, interface out);
  logic [3:0] data;
  logic [3:0] result; 
  logic [3:0] addr_4bit;
  always 
  begin 
  	data = 0;
  	result = 0;
  	addr_4bit = 0;
  	addr.Receive(addr_4bit);
  	forever begin
	  	addr.Receive(addr_4bit);
	    in.Receive(data);
		result[0] = data[0] ^ addr_4bit[0];
		result[3] = data[3] ^ addr_4bit[3];
		result[2] = data[2] ^ addr_4bit[2];
		result[1] = data[1] ^ addr_4bit[1];
	    out.Send(result);
	end
  end
endmodule