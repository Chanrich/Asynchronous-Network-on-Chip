`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module split_4 (interface inPort, interface controlPort, interface outPort1, interface outPort2, interface outPort3, interface outPort4);
  parameter FL = 1;
  parameter BL = 1;
  parameter WIDTH = 11;
  logic [WIDTH-1:0] data;
  logic [1:0] control; 
  always
  begin
    //add a display here to see when this module starts its main loop
    //$display("starting split ***%m at %d",$time);
    fork
      controlPort.Receive(control);
      inPort.Receive(data);
    join
    
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    
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
    
    #BL;  //Backward Latency: Delay from the time data is delivered to the time next input can be accepted
    //$display("ending split_r***%m at %d",$time);
  end
endmodule

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

module check_position(interface in, interface core_contr, interface router_contr);
  parameter FL = 1;
  parameter BL = 1;
  parameter WIDTH = 4;
  parameter ADDR = 4'b0000;
  logic [WIDTH-1:0] data;
  logic out_core;
  logic [1:0] out_router;
  logic flag = 0;
  int position; 


  always
  begin
//  $display("starting shiftleft ***%m at %d",$time);
    in.Receive(data); 
    //if data == current address then out_core = 1, else then out_core = 0 

    #FL;
    // if(data == ADDR)
    // if data == 0000, reached destination
    if(data == 4'b0000)
      begin 
         out_core = 1;
         core_contr.Send(out_core);
      end
    else
      begin 
        for(int i =0; i<WIDTH; i++)
        begin
         //position 0 -> 00 , position 1 -> 01, position 2 -> 10 , position 3 -> 11 
          if((data[i]==1'b1)&&(flag ==0))
          begin
            position = i;
            flag =1; 
            out_core =0;
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

        fork
           core_contr.Send(out_core);
           router_contr.Send(out_router);
        join


      end

    #BL;  
  end
endmodule

module two_input_xor (interface in,interface out);
  parameter FL = 1;
  parameter BL = 1;
  parameter ADDR = 4'b0000;
  logic [3:0] data;
  logic [3:0] result; 

  always 
  begin 

    in.Receive(data);
    #FL; 
    for(int i =0; i<4; i++)
    begin 
      result[i] = data[i] ^ ADDR[i];
    end
    out.Send(result);
    #BL;
  end

endmodule 


module concatenate_module (interface addr_in,interface data_in, 
      interface out,  interface control_core, interface control_router);
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

  always 
  begin
    fork 
      data_in.Receive(data);
      addr_in.Receive(addr);
    join   
    #FL; 
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

module path_computation_module (interface d_in, interface addr_in, interface d_out2core, interface d_out2router1, interface d_out2router2, interface d_out2router3, interface d_out2router4);

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
   concatenate_module  #(.ADDR(ADDR)) cm(.addr_in(addr_in),.data_in(d_in), 
             .out(out_intf), .control_core(control_core_intf), .control_router(control_router_intf));

   big_split big_split (.inPort(out_intf), .controlPort(control_router_intf), .core_control(control_core_intf),
               .core_output(d_out2core),
               .outPort1(d_out2router1), .outPort2(d_out2router2), .outPort3(d_out2router3), .outPort4(d_out2router4));
   //split_2 s2core(out_intf[0], control_core_intf[0], out_intf[1], d_out2core);
   //split_4 s2router(out_intf[1], control_router_intf[0], d_out2router1, d_out2router2, d_out2router3, d_out2router4);

endmodule



module computation_module_tb;
  logic [3:0] check; 
  logic core_check; 
  logic [1:0] router_check; 
  logic [10:0] result;

  logic [6:0] data_in;
  logic [3:0] addr;
  logic [3:0] addr_test; 

  int i;

  Channel #(.WIDTH(7), .hsProtocol(P4PhaseBD)) data_intf1  [1:0] (); 
  Channel #(.WIDTH(4), .hsProtocol(P4PhaseBD)) addr_intf1  [1:0] (); 
  Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) out_intf1  [7:0] (); 

  path_computation_module pc(data_intf1[0], addr_intf1[0], out_intf1[0],  out_intf1[1],  out_intf1[2],  out_intf1[3],  out_intf1[4]);

  initial 
    begin
      addr_test = 4'b0000;
      for (i=0; i<5; i++)
      begin 
        case(i)
          1: addr_test = 4'b0001;
          2: addr_test = 4'b0010;
          3: addr_test = 4'b0100;
          4: addr_test = 4'b1000;
        endcase

        fork
          addr_intf1[0].Send({addr_test});
          data_intf1[0].Send(7'b1111000);
        join
        #10
        if(pc.cp.out_core == 1'b1)
          begin
            out_intf1[0].Receive(result);
            $display("address matches, core output is %b",result);
          end 
        else 
          begin
            if(pc.cp.out_router == 2'b00)
            begin 
            out_intf1[1].Receive(result);
            $display("router output %b goes to output 1",result);
            end 
            else if(pc.cp.out_router == 2'b01)
            begin 
            out_intf1[2].Receive(result);
            $display("router output %b goes to output 2",result);
            end 
            else if(pc.cp.out_router == 2'b10)
            begin 
            out_intf1[3].Receive(result);
            $display("router output %b goes to output 3",result);
            end 
            else if(pc.cp.out_router == 2'b11)
            begin 
            out_intf1[4].Receive(result);
            $display("router output %b goes to output 4",result);
            end 
          end
        end 
      end


      /*addr_intf[1].Send(4'b0001);
      fork
      control_core_intf[0].Receive(core_check);
      control_router_intf[0].Receive(router_check);
      join
      $display("when xor result is 0001 then the core control signal is %b and router control signal is %b",core_check,router_check);
      #20
      addr_intf[1].Send(4'b0011);
      fork
      control_core_intf[0].Receive(core_check);
      control_router_intf[0].Receive(router_check);
      join  
      $display("when xor result is 0011 then the core control signal is %b and router control signal is %b",core_check,router_check);
      #20
      addr_intf[1].Send(4'b0111);
      fork
      control_core_intf[0].Receive(core_check);
      control_router_intf[0].Receive(router_check);
      join  
      $display("when xor result is 0111 then the core control signal is %b and router control signal is %b",core_check,router_check);
      #20
      addr_intf[1].Send(4'b1111);
      fork
      control_core_intf[0].Receive(core_check);
      control_router_intf[0].Receive(router_check);
      join  
      $display("when xor result is 1111 then the core control signal is %b and router control signal is %b",core_check,router_check);
      #20
      addr_intf[1].Send(4'b0010);
      fork
      control_core_intf[0].Receive(core_check);
      control_router_intf[0].Receive(router_check);
      join  
      $display("when xor result is 0010 then the core control signal is %b and router control signal is %b",core_check,router_check);
      #20
      addr_intf[1].Send(4'b0100);
      fork
      control_core_intf[0].Receive(core_check);
      control_router_intf[0].Receive(router_check);
      join  
      $display("when xor result is 0100 then the core control signal is %b and router control signal is %b",core_check,router_check);
      #20
      addr_intf[1].Send(4'b1000);
      fork
      control_core_intf[0].Receive(core_check);
      control_router_intf[0].Receive(router_check);
      join  
      $display("when xor result is 1000 then the core control signal is %b and router control signal is %b",core_check,router_check);*/
    // #14400 $stop;
     /* addr_intf[0].Send(4'b0001);
      addr_intf[1].Receive(check);
      $display("xor result when input is 0001 is %b",check);
    #20
      addr_intf[0].Send(4'b0010);
      addr_intf[1].Receive(check);
      $display("xor result when input is 0010 is %b",check);
    #20
      addr_intf[0].Send(4'b0100);
      addr_intf[1].Receive(check);
      $display("xor result when input is 0100 is %b",check);
    #20
      addr_intf[0].Send(4'b1000);
      addr_intf[1].Receive(check);
      $display("xor result when input is 1000 is %b",check);
    #20
      addr_intf[0].Send(4'b0011);
      addr_intf[1].Receive(check);
      $display("xor result when input is 0011 is %b",check);
    #20
      addr_intf[0].Send(4'b0111);
      addr_intf[1].Receive(check);
      $display("xor result when input is 0111 is %b",check);
    #20
      addr_intf[0].Send(4'b1111);
      addr_intf[1].Receive(check);
      $display("xor result when input is 1111 is %b",check);*/

endmodule 