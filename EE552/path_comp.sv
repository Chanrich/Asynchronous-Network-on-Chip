`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module big_split (interface inPort, interface controlPort, interface core_control, interface core_output,
               interface outPort1, interface outPort2, interface outPort3, interface outPort4);
  parameter FL = 1;
  parameter BL = 1;
  parameter WIDTH = 11;
  logic [WIDTH-1:0] data;
  logic [1:0] control; 
  logic core_control_select; 
  always
  begin
    //add a display here to see when this module starts its main loop
    //$display("starting split ***%m at %d",$time);
    fork
      controlPort.Receive(control);
      inPort.Receive(data);
      core_control.Receive(core_control_select);
    join
    
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    
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
    else if(core_control_select == 1)
    begin
      core_output.Send(data);
    end
    
    #BL;  //Backward Latency: Delay from the time data is delivered to the time next input can be accepted
    //$display("ending split_r***%m at %d",$time);
  end
endmodule

module concatenate_module (interface in, interface out,  interface control_core, interface control_router);
  parameter FL = 1;
  parameter BL = 1;
  parameter ADDR = 4'b0000;

  logic [6:0] data;
  logic [3:0] addr;
  logic [10:0] result; 
  logic [3:0] xor_result; 
  int position; 
  logic flag = 0;
  logic [1:0] out_router;
  logic out_core;
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

    // Error detection and correction
    P1 = data[0] ^ data[2] ^ data[4] ^ data[6];
    P2 = data[1] ^ data[2] ^ data[5] ^ data[6];
    P4 = data[3] ^ data[4] ^ data[5] ^ data[6];
    parity_bit = 0;
    if (P1 == 1)
    begin
      parity_bit = parity_bit + 1;
    end
    if (P2 == 1) 
    begin
      parity_bit = parity_bit + 2;
    end
    if (P4 == 1) 
    begin
      parity_bit = parity_bit + 4;
    end
    if (parity_bit != 0) 
    begin
      data[parity_bit-1] = ~data[parity_bit-1];
    end




    for(int i =0; i<4; i++)
    begin 
      xor_result[i] = addr[i] ^ ADDR[i];
    end

    if(xor_result == 4'b0000)
      begin 
        out_core = 1;
      end
    else
      begin 
        out_core =0;
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
          out_router = 2'b00;
        else if(position == 1)
          out_router = 2'b01;
        else if(position == 2)
          out_router = 2'b10;
        else if(position == 3)
          out_router = 2'b11;
      end




    result = {data,addr};

    fork
      control_core.Send(out_core);
      control_router.Send(out_router);
      out.Send(result);
    join
    #BL;
  end
endmodule 

module path_computation_module (interface in, interface d_out2core, interface d_out2router1, interface d_out2router2, interface d_out2router3, interface d_out2router4);

  parameter ADDR = 4'b0000;
  logic [3:0] addr_store;
  assign addr_store = ADDR;
  //Interface Vector instatiation: 4-phase bundled data channel
  Channel #(.WIDTH(7), .hsProtocol(P4PhaseBD)) data_intf  [1:0] (); 
  Channel #(.WIDTH(4), .hsProtocol(P4PhaseBD)) addr_intf  [1:0] (); 
  Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) out_intf (); 
  Channel #(.WIDTH(2), .hsProtocol(P4PhaseBD)) control_router_intf  (); 
  Channel #(.WIDTH(1), .hsProtocol(P4PhaseBD)) control_core_intf  (); 
  
   //concatenate_module  #(.ADDR(ADDR)) cm(addr_in,d_in, out_intf, addr_intf[0] );
   concatenate_module  #(.ADDR(ADDR)) cm(.in(in), .out(out_intf), .control_core(control_core_intf), .control_router(control_router_intf));

   big_split big_split (.inPort(out_intf), .controlPort(control_router_intf), .core_control(control_core_intf),
               .core_output(d_out2core),
               .outPort1(d_out2router1), .outPort2(d_out2router2), .outPort3(d_out2router3), .outPort4(d_out2router4));
   //split_2 s2core(out_intf[0], control_core_intf[0], out_intf[1], d_out2core);
   //split_4 s2router(out_intf[1], control_router_intf[0], d_out2router1, d_out2router2, d_out2router3, d_out2router4);

endmodule



 