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