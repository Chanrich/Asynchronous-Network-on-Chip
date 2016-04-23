 module merge (interface inPort0, interface inPort1, interface inPort2, interface controlPort, interface outPort);
    parameter WIDTH = 11;
    parameter FL = 2;
	parameter BL = 2;
    logic [WIDTH-1:0] data;
    logic [1:0] select;
    
    always
    begin
		  controlPort.Receive(select);
		  if (select == 0)
		    inPort0.Receive(data);
		  else if (select == 1)
		    inPort1.Receive(data);
		  else if (select == 2)
			inPort2.Receive(data);
		  #FL;
	
		  outPort.Send(data);
		  #BL;
     end
  endmodule