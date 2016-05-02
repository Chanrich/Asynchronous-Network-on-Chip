`timescale 1ns/100ps
//NOTE: you need to compile SystemVerilogCSP.sv as well
module big_split (interface inPort, interface controlPort, interface core_output, interface core_control_out,
               interface outPort1, interface outPort2, interface outPort3, interface outPort4,
                interface control_out1, interface control_out2, interface control_out3, interface control_out4);
  parameter FL = 0;
  parameter BL = 0;
  parameter WIDTH = 11;
  parameter ID = 3'b000;
  logic [WIDTH-1:0] data;
  logic [2:0] control;
  logic [2:0] mydata_id; 
  logic core_control_select; 
  logic [2:0] output_control; 
  always
  begin
    //add a display here to see when this module starts its main loop
    //$display("starting split ***%m at %d",$time);
    fork
      controlPort.Receive(control);
      inPort.Receive(data);
    join
    
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    mydata_id = ID;
    if(control == 3'b000 )
    begin 
      fork
      control_out1.Send(mydata_id);
      outPort1.Send(data);
      join
    end
    else if(control == 3'b001)
    begin 
      fork
      control_out2.Send(mydata_id);
      outPort2.Send(data);
      join    end 
    else if(control == 3'b010)
    begin 
      fork
      control_out3.Send(mydata_id);
      outPort3.Send(data);
      join    end 
    else if(control == 3'b011)
    begin 
      fork
      control_out4.Send(mydata_id);
      outPort4.Send(data);
      join    end 
    else if(control == 3'b100)
    begin
      fork
      core_output.Send(data);
      core_control_out.Send(mydata_id);
      join
    end
    
    #BL;  //Backward Latency: Delay from the time data is delivered to the time next input can be accepted
    //$display("ending split_r***%m at %d",$time);
  end
endmodule


module big_split_no_core (interface inPort, interface controlPort,
               interface outPort1, interface outPort2, interface outPort3, interface outPort4,
                interface control_out1, interface control_out2, interface control_out3, interface control_out4);
  parameter FL = 0;
  parameter BL = 0;
  parameter WIDTH = 11;
  parameter ID = 3'b000;

  logic [WIDTH-1:0] data;
  logic [2:0] control; 
  logic [2:0] mydata_id; 


  always
  begin
    //add a display here to see when this module starts its main loop
    //$display("starting split ***%m at %d",$time);
    fork
      controlPort.Receive(control);
      inPort.Receive(data);
    join
    
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    mydata_id = ID;

    if(control == 3'b000 )
    begin 
      fork
      control_out1.Send(mydata_id);
      outPort1.Send(data);
      join
    end
    else if(control == 3'b001)
    begin 
      fork
      control_out2.Send(mydata_id);
      outPort2.Send(data);
      join    end 
    else if(control == 3'b010)
    begin 
      fork
      control_out3.Send(mydata_id);
      outPort3.Send(data);
      join    end 
    else if(control == 3'b011)
    begin 
      fork
      control_out4.Send(mydata_id);
      outPort4.Send(data);
      join    
    end 
    
    #BL;  //Backward Latency: Delay from the time data is delivered to the time next input can be accepted
    //$display("ending split_r***%m at %d",$time);
  end
endmodule
module concatenate_module (interface in, interface out, interface control_router);
  parameter FL = 0;
  parameter BL = 0;
  parameter ADDR = 4'b0000;

  logic [6:0] data;
  logic [3:0] addr;
  logic [10:0] result; 
  logic [3:0] xor_result; 
  int position; 
  logic flag = 0;
  logic [2:0] out_router;
  logic [10:0] inData;
  logic [6:0] raw_data;
  logic [2:0] parity_bit;
  logic P1;
  logic P2;
  logic P4;
  initial begin
    raw_data = 0;
    parity_bit = 0;
    P1 = 0;
    P2 = 0;
    P4 = 0;
  end
  always 
  begin
    in.Receive(inData);
    #FL; 
    addr = inData[3:0];
    data = inData[10:4];
    for(int i =0; i<4; i++)
    begin 
      xor_result[i] = addr[i] ^ ADDR[i];
    end

    if(xor_result == 4'b0000)
      begin 
        out_router = 3'b100;
      end
    else
      begin 
        for(int i =0; i<4; i++)
        begin
         //position 0 -> 00 , position 1 -> 01, position 2 -> 10 , position 3 -> 11 
          if((xor_result[i]==1'b1)&&(flag ==0))
          begin
            position = i;
            flag =1; 
          end
        end
        flag = 0;
        if(position == 0)
          out_router = 3'b000;
        else if(position == 1)
          out_router = 3'b001;
        else if(position == 2)
          out_router = 3'b010;
        else if(position == 3)
          out_router = 3'b011;
      end




    result = {data,addr};

    fork
      control_router.Send(out_router);
      out.Send(result);
    join
    #BL;
  end
endmodule 


module full_buffer(interface L, interface R);
  logic[10:0] data;
  always begin
    L.Receive(data);
    R.Send(data);
  end

endmodule

module path_computation_module (interface in, interface d_out2core, interface core_control_out,
             interface d_out2router1, interface d_out2router2, interface d_out2router3, interface d_out2router4,
              interface control_out1, interface control_out2, interface control_out3, interface control_out4);

  parameter ADDR = 4'b0000;
  parameter ID = 3'b000;
  logic [3:0] addr_store;
  reg _RESET;
  assign addr_store = ADDR;
  //Interface Vector instatiation: 4-phase bundled data channel
  e1ofN_M #(.N(2), .M(4)) addr_intf  [1:0] (); 
  e1ofN_M #(.N(2), .M(11)) out_intf (); 
  e1ofN_M #(.N(2), .M(11)) edu_intf (); 
  e1ofN_M #(.N(2), .M(11)) buf_intf [1:0] (); 
  e1ofN_M #(.N(2), .M(3)) control_router_intf  (); 
  e1ofN_M #(.N(2), .M(1)) control_core_intf  (); 
  
  full_buffer full_buffer1(.L(in), .R(buf_intf[0]));
  full_buffer full_buffer2(.L(edu_intf), .R(buf_intf[1]));
    edu_cosim_wrapper u_edu_rtl ( .datain(buf_intf[0]), .dataout(edu_intf), ._RESET(_RESET));
   //concatenate_module  #(.ADDR(ADDR)) cm(addr_in,d_in, out_intf, addr_intf[0] );
   concatenate_module  #(.ADDR(ADDR)) cm(.in(buf_intf[1]), .out(out_intf), .control_router(control_router_intf));

   big_split #(.ID(ID))  big_split (.inPort(out_intf), .controlPort(control_router_intf), .core_output(d_out2core), .core_control_out(core_control_out),
               .outPort1(d_out2router1), .outPort2(d_out2router2), .outPort3(d_out2router3), .outPort4(d_out2router4),
              .control_out1(control_out1), .control_out2(control_out2), .control_out3(control_out3), .control_out4(control_out4)
              );
   initial 
     begin : reset
      _RESET = 0;
    buf_intf[0].d_log = '0;    
    edu_intf.e_log = '0;
    #400;  
    _RESET = 1;
    edu_intf.e_log = '1;
   end
endmodule


module path_computation_module_4out (interface in,
             interface d_out2router1, interface d_out2router2, interface d_out2router3, interface d_out2router4,
              interface control_out1, interface control_out2, interface control_out3, interface control_out4);

  parameter ADDR = 4'b0000;
  parameter ID = 3'b000;

  logic [3:0] addr_store;
  reg _RESET;
  assign addr_store = ADDR;
  //Interface Vector instatiation: 4-phase bundled data channel
  e1ofN_M #(.N(2), .M(4)) addr_intf  [1:0] (); 
  e1ofN_M #(.N(2), .M(11)) out_intf (); 
  e1ofN_M #(.N(2), .M(11)) edu_intf (); 
  e1ofN_M #(.N(2), .M(11)) buf_intf [1:0] (); 
  e1ofN_M #(.N(2), .M(3)) control_router_intf  (); 
  e1ofN_M #(.N(2), .M(1)) control_core_intf  (); 
  
  full_buffer full_buffer1(.L(in), .R(buf_intf[0]));
  full_buffer full_buffer2(.L(edu_intf), .R(buf_intf[1]));
    edu_cosim_wrapper u_edu_rtl ( .datain(buf_intf[0]), .dataout(edu_intf), ._RESET(_RESET));
   //concatenate_module  #(.ADDR(ADDR)) cm(addr_in,d_in, out_intf, addr_intf[0] );
   concatenate_module  #(.ADDR(ADDR)) cm(.in(buf_intf[1]), .out(out_intf), .control_router(control_router_intf));

   big_split_no_core #(.ID(ID))  big_split (.inPort(out_intf), .controlPort(control_router_intf),
               .outPort1(d_out2router1), .outPort2(d_out2router2), .outPort3(d_out2router3), .outPort4(d_out2router4),
              .control_out1(control_out1), .control_out2(control_out2), .control_out3(control_out3), .control_out4(control_out4)
              );
  initial 
     begin : reset
    _RESET = 0;
    buf_intf[0].d_log = '0;    
    edu_intf.e_log = '0;
    #300;  
    _RESET = 1;
    edu_intf.e_log = '1;
   end
endmodule



 