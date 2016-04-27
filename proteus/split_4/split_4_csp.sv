`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,2)

module split_4 (e1of2_11.In inPort, e1of2_2.In controlPort, e1of2_11.Out outPort1, e1of2_11.Out outPort2, e1of2_11.Out outPort3, e1of2_11.Out outPort4);
  logic [10:0] data;
  logic [1:0] control; 
  always
  begin
  	data = 0;
  	control = 0;
  	forever begin
		controlPort.Receive(control);
		inPort.Receive(data);
	    if(control == 2'b00)
	    begin 
	      outPort1.Send(data);
	    end
	    else if(control == 2'b01)
	    begin 
	      outPort2.Send(data);
	    end 
	    else if(control == 2'b10)
	    begin 
	      outPort3.Send(data);
	    end 
	    else if(control == 2'b11)
	    begin 
	      outPort4.Send(data);
	    end 
    end
  end
endmodule