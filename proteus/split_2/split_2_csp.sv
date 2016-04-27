`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,1)

module split_2 (e1of2_11.In inPort, e1of2_1.In controlPort, e1of2_11.Out outPort1, e1of2_11.Out outPort2);
  logic [10:0] data;
  logic control; 
  always
  begin
  	data = 0;
  	control = 0;
  	forever begin
		controlPort.Receive(control);
		inPort.Receive(data);
	    if(control == 0)
		    begin 
		      outPort1.Send(data);
		    end
	    else if(control == 1)
		    begin 
		      outPort2.Send(data);
		    end 
  	end
  end
endmodule