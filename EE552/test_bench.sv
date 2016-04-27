`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;
`define test_count 2000
`define send_count 10
module data_generator (interface data_out);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  parameter MYID = 0;
  logic [3:0] addr;
  //logic [3:0] starting_addr;
  logic [3:0] data;
  logic [16:0] counter;
  logic [WIDTH-1:0] SendValue=0;

  initial begin
    counter = 0;
  end

  always
  begin 
    //add a display here to see when this module starts its main loop
    //$display("Start module data_generator and time is %d", $time);
    if (counter < `send_count) begin
      addr = $random() % (2**4);
      data = $random() % (2**4);

      //starting_addr = $random() % (2**4);
      //starting_addr = addr; 
      while(MYID == addr)
      begin
        //$display("in while loop");
        addr = $random() % (2**4);
      end
      #FL;

      SendValue = {data,addr};
      //$display("data generator is sending %b",SendValue);
       
      //Communication action Send is about to start
     // $display("Starting %m.Send @ %d", $time);
      data_out.Send(SendValue);
      tb_module.original.push_back(SendValue);
      tb_module.total_send += 1;
      $display("Start module data_gen and time is %d, Send count: %d", $time, tb_module.total_send); 
      counter += 1;
    end
    #10;
    //Communication action Send is finished
   // $display("Finished %m.Send @ %d", $time);
  end
endmodule

//Sample data_bucket module
module data_bucket (interface r);
  parameter WIDTH = 8;
  parameter BL = 0; //ideal environment
  parameter MYID = 0;
  logic [WIDTH-1:0] ReceiveValue = 0;
  //Variables added for performance measurements
  /*real cycleCounter=0, //# of cycles = Total number of times a value is received
       timeOfReceive=0, //Simulation time of the latest Receive 
       cycleTime=0; // time difference between the last two receives
  real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;*/

  always
  begin
      //$display("Start module data_bucket and time is %d", $time);	
      //Save the simulation time when Receive starts
      //timeOfReceive = $time;
      r.Receive(ReceiveValue);
      tb_module.result.push_back(ReceiveValue);
      tb_module.receive_count = tb_module.receive_count + 1;
      $display("Data bucket [%d] is receiving %b | Receive count: %d", MYID, ReceiveValue, tb_module.receive_count);
      #BL;
  end
endmodule



module split (interface inPort, interface controlPort, interface outPort[15:0]);
  parameter FL = 0;
  parameter BL = 0;
  parameter WIDTH = 8;
  logic [WIDTH-1:0] data;
  logic [3:0] control; 
  always
  begin
    //add a display here to see when this module starts its main loop
    //$display("starting split ***%m at %d",$time);
    fork
      controlPort.Receive(control);
      inPort.Receive(data);
    join
    
    #FL; //Forward Latency: Delay from recieving inputs to send the results forward
    
    case (control)
      4'b0000: outPort[0].Send(data);
      4'b0001: outPort[1].Send(data);
      4'b0010: outPort[2].Send(data);
      4'b0011: outPort[3].Send(data);
      4'b0100: outPort[4].Send(data);
      4'b0101: outPort[5].Send(data);
      4'b0110: outPort[6].Send(data);
      4'b0111: outPort[7].Send(data);
      4'b1000: outPort[8].Send(data);
      4'b1001: outPort[9].Send(data);
      4'b1010: outPort[10].Send(data);
      4'b1011: outPort[11].Send(data);
      4'b1100: outPort[12].Send(data);
      4'b1101: outPort[13].Send(data);
      4'b1110: outPort[14].Send(data);
      4'b1111: outPort[15].Send(data); 
    endcase

  
    #BL;  //Backward Latency: Delay from the time data is delivered to the time next input can be accepted
  end
endmodule





module tb_module; 

  logic [7:0] data; 
  logic [3:0] control; 
  int i;
  int result_size;
  reg [15:0] original [$];
  reg [15:0] result [$];
  reg [7:0] result_data;
  int queue_check[$];
  integer receive_count;
  integer total_send;
  integer check_count;
  integer fp_result;
  integer fp_original;


  Channel #(.WIDTH(8), .hsProtocol(P4PhaseBD)) data_intf  [1:0] (); 
  Channel #(.WIDTH(4), .hsProtocol(P4PhaseBD)) control_intf  [1:0] (); 
  Channel #(.WIDTH(8), .hsProtocol(P4PhaseBD)) intf2core  [15:0] (); 
  Channel #(.WIDTH(8), .hsProtocol(P4PhaseBD)) db_intf[15:0]  (); 



  data_generator #(.MYID(0)) dg0(intf2core[0]);
  data_generator #(.MYID(1)) dg1(intf2core[1]);
  data_generator #(.MYID(2)) dg2(intf2core[2]);
  data_generator #(.MYID(3)) dg3(intf2core[3]);
  data_generator #(.MYID(4)) dg4(intf2core[4]);
  data_generator #(.MYID(5)) dg5(intf2core[5]);
  data_generator #(.MYID(6)) dg6(intf2core[6]);
  data_generator #(.MYID(7)) dg7(intf2core[7]);
  data_generator #(.MYID(8)) dg8(intf2core[8]);
  data_generator #(.MYID(9)) dg9(intf2core[9]);
  data_generator #(.MYID(10)) dg10(intf2core[10]);
  data_generator #(.MYID(11)) dg11(intf2core[11]);
  data_generator #(.MYID(12)) dg12(intf2core[12]);
  data_generator #(.MYID(13)) dg13(intf2core[13]);
  data_generator #(.MYID(14)) dg14(intf2core[14]);
  data_generator #(.MYID(15)) dg15(intf2core[15]);


  top top1 (.dg_in(intf2core[15:0]), .db_out(db_intf[15:0]));
  data_bucket #(.MYID(0)) db0000(db_intf[0]);
  data_bucket #(.MYID(1)) db0001(db_intf[1]);
  data_bucket #(.MYID(2)) db0010(db_intf[2]);
  data_bucket #(.MYID(3)) db0011(db_intf[3]);
  data_bucket #(.MYID(4)) db0100(db_intf[4]);
  data_bucket #(.MYID(5)) db0101(db_intf[5]);
  data_bucket #(.MYID(6)) db0110(db_intf[6]);
  data_bucket #(.MYID(7)) db0111(db_intf[7]);

  data_bucket #(.MYID(8)) db1000(db_intf[8]);
  data_bucket #(.MYID(9)) db1001(db_intf[9]);
  data_bucket #(.MYID(10)) db1010(db_intf[10]);
  data_bucket #(.MYID(11)) db1011(db_intf[11]);
  data_bucket #(.MYID(12)) db1100(db_intf[12]);
  data_bucket #(.MYID(13)) db1101(db_intf[13]);
  data_bucket #(.MYID(14)) db1110(db_intf[14]);
  data_bucket #(.MYID(15)) db1111(db_intf[15]);


initial 
  begin 
    receive_count = 0;
    check_count = 0;
    total_send = 0;
    #10;
    $display("Waiting for receivers");
    wait (receive_count == total_send);
    $display("Received: %d",receive_count);
    // for(i = 0; i<10; i++)
    // begin 
    //   case (spdg.control)
    //   4'b0000: intf2core[0].Receive(data); 
    //   4'b0001: intf2core[1].Receive(data); 
    //   4'b0010: intf2core[2].Receive(data); 
    //   4'b0011: intf2core[3].Receive(data); 
    //   4'b0100: intf2core[4].Receive(data); 
    //   4'b0101: intf2core[5].Receive(data); 
    //   4'b0110: intf2core[6].Receive(data); 
    //   4'b0111: intf2core[7].Receive(data); 
    //   4'b1000: intf2core[8].Receive(data); 
    //   4'b1001: intf2core[9].Receive(data); 
    //   4'b1010: intf2core[10].Receive(data); 
    //   4'b1011: intf2core[11].Receive(data); 
    //   4'b1100: intf2core[12].Receive(data); 
    //   4'b1101: intf2core[13].Receive(data); 
    //   4'b1110: intf2core[14].Receive(data); 
    //   4'b1111: intf2core[15].Receive(data); 
    //   endcase

    //   $display("data is %b and control is %b",data,spdg.control);

    //   //#20;
    // end

    fp_result = $fopen("result_output.txt","w");

    result_size = result.size();
    while(result.size()!=0)
    begin 
      check_count = check_count + 1;
      $display("Checking %d in the queue", check_count);
      result_data = result.pop_front();
      queue_check = original.find_first_index(x) with ( x == result_data);
      $display("at index %d\n\tOriginal: %b, Result: %b", queue_check[0], original[queue_check[0]], result_data);
      if (original[queue_check[0]] == result_data) begin
        $display("matched, remove the item from original");
        original.delete(queue_check[0]);
      end
      $fwrite(fp_result,"%b\n",result_data);
    end
    $fclose(fp_result); 
    $display("Original queue has %d elements left", original.size() );
    if (original.size() != 0) begin
      $display("Not matched");
    end else begin
      $display("############  Matched  ###########");
    end

  end 

endmodule 