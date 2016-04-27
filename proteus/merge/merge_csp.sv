`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,2)

 module merge (e1of2_11.In inPort0, e1of2_11.In inPort1, e1of2_11.In inPort2, e1of2_2.In controlPort, e1of2_11.Out outPort);
    logic [10:0] data;
    logic [1:0] select;
    
    always begin
    	forever begin
		  controlPort.Receive(select);
		  if (select == 0)
		    inPort0.Receive(data);
		  else if (select == 1)
		    inPort1.Receive(data);
		  else
			inPort2.Receive(data);
	
		  outPort.Send(data);
		end
     end
  endmodule