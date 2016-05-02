`include "svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,2)
`E1OFN_M(2,1)

module big_split_csp_gold (interface inPort, interface controlPort, interface core_control, interface core_output, interface outPort1, interface outPort2, interface outPort3, interface outPort4);
  parameter WIDTH = 11;
  logic [WIDTH-1:0] data;
  logic [1:0] control; 
  logic core_control_select; 
  always
  begin
    forever
    begin
      //add a display here to see when this module starts its main loop
      //$display("starting split ***%m at %d",$time);
        controlPort.Receive(control);
        inPort.Receive(data);
        core_control.Receive(core_control_select);
      
      
      if(control == 2'b00 && core_control_select == 0)
      begin 
        outPort1.Send(data);
      end
      else if(control == 2'b01 && core_control_select == 0)
      begin 
        outPort2.Send(data);
      end 
      else if(control == 2'b10 && core_control_select == 0)
      begin 
        outPort3.Send(data);
      end 
      else if(control == 2'b11 && core_control_select == 0)
      begin 
        outPort4.Send(data);
      end 
      else(core_control_select == 1)
      begin
        core_output.Send(data);
      end
      
      //$display("ending split_r***%m at %d",$time);
    end
  end
endmodule