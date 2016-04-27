
//import SystemVerilogCSP::*;

`include "svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,1)

module split_2_csp_gold (interface inPort, interface controlPort, interface outPort1, interface outPort2);
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