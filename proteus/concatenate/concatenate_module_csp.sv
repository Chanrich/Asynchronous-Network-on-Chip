`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,7)
`E1OFN_M(2,4)

module concatenate_module (e1of2_4.In addr_in, e1of2_7.In data_in, e1of2_11.Out out);
  logic [6:0] data;
  logic [3:0] addr;
  logic [10:0] result; 

  always 
  begin
  	data = 0;
  	addr = 0;
  	result = 0;
  	forever begin
	    data_in.Receive(data);
	    addr_in.Receive(addr);
	    result = {data,addr};
	    out.Send(result);
	end
  end
endmodule