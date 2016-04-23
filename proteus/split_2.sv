module split_2 (interface inPort, interface controlPort, interface outPort1, interface outPort2);
  parameter FL = 1;
  parameter BL = 1;
  parameter WIDTH = 11;
  logic [WIDTH-1:0] data;
  logic control; 
  always
  begin
    //add a display here to see when this module starts its main loop
    //$display("starting split ***%m at %d",$time);
    fork
      controlPort.Receive(control);
      inPort.Receive(data);
    join
    
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    
    if(control == 0)
    begin 
      outPort1.Send(data);
    end
    else if(control == 1)
    begin 
      outPort2.Send(data);
    end 
  
    #BL;  //Backward Latency: Delay from the time data is delivered to the time next input can be accepted
  end
endmodule