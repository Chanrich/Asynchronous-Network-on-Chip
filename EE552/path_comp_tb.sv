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


endmodule