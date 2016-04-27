
//import SystemVerilogCSP::*;

`include "svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,2)
`E1OFN_M(2,4)

module split_4_csp_gold (interface inPort, interface controlPort, interface outPort1, interface outPort2, interface outPort3, interface outPort4);
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