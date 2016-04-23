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