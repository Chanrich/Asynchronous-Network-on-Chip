
//import SystemVerilogCSP::*;

`include "svc2rtl.sv"
`E1OFN_M(2,4)
`E1OFN_M(2,2)
`E1OFN_M(2,1)

module check_position_csp_gold (interface in, interface core_contr, interface router_contr);
  parameter ADDR = 4'b0000;
  logic [3:0] data;
  logic out_core;
  logic [1:0] out_router;
  logic flag;
  int position; 
  always
  begin
  	data = 0;
  	out_core = 0;
  	out_router = 0;
  	flag = 0;
  	position = 0;
  	forever begin
	    in.Receive(data); 
	    if(data == 4'b0000)
	      begin 
	         out_core = 1;
	         core_contr.Send(out_core);
	      end
	    else
	      begin 
	        for(int i =0; i<4; i++)
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
	        core_contr.Send(out_core);
	        router_contr.Send(out_router);
	      end
  	end
  end
endmodule