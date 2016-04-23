module concatenate_module (interface addr_in,interface data_in,interface out);
  parameter FL = 1;
  parameter BL = 1;
  logic [6:0] data;
  logic [3:0] addr;
  logic [10:0] result; 

  always 
  begin
    fork 
      data_in.Receive(data);
      addr_in.Receive(addr);
    join   
    #FL; 
    result = {data,addr};
    out.Send(result);
    #BL;
  end
endmodule 