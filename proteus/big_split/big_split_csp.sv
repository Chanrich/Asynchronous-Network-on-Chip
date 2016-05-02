`include "/home/scf-12/ee552/proteus/pdk/proteus/svc2rtl.sv"
`E1OFN_M(2,11)
`E1OFN_M(2,2)
`E1OFN_M(2,1)

module big_split (e1of2_11.In inPort, e1of2_2.In controlPort, e1of2_1.In core_control, e1of2_11.Out core_output, e1of2_11.Out outPort1, e1of2_11.Out outPort2, e1of2_11.Out outPort3, e1of2_11.Out outPort4);
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