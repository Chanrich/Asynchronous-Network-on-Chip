`include "svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,2)

 module merge_csp_gold (interface inPort0, interface inPort1, interface inPort2, interface controlPort, interface outPort);
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