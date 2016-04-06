`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module data_generator (interface data_out, interface control);
  parameter WIDTH = 8;
  parameter FL = 0; //ideal environment
  logic [3:0] addr;
  logic [3:0] starting_addr;
  logic [3:0] data;
  logic [WIDTH-1:0] SendValue=0;

  always
  begin 
    //add a display here to see when this module starts its main loop
    //$display("Start module data_generator and time is %d", $time);
    
    addr = $random() % (2**4);
    data = $random() % (2**4);
    SendValue = {data,addr};

    //starting_addr = $random() % (2**4);
    starting_addr = addr; 
    while(starting_addr == addr)
    begin
      $display("in while loop");
      starting_addr = $random() % (2**4);
    end

    #FL;
    
    //$display("data generator is sending %b",SendValue);
     
    //Communication action Send is about to start
   // $display("Starting %m.Send @ %d", $time);
    fork 
    tb_module.original.push_back(SendValue);
    data_out.Send(SendValue);
    control.Send(starting_addr);
    join
    //Communication action Send is finished
   // $display("Finished %m.Send @ %d", $time);
  end
endmodule

//Sample data_bucket module
module data_bucket (interface r);
  parameter WIDTH = 8;
  parameter BL = 0; //ideal environment
  logic [WIDTH-1:0] ReceiveValue = 0;
  
  //Variables added for performance measurements
  /*real cycleCounter=0, //# of cycles = Total number of times a value is received
       timeOfReceive=0, //Simulation time of the latest Receive 
       cycleTime=0; // time difference between the last two receives
  real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;*/
  always
  begin
	$display("Start module data_bucket and time is %d", $time);	
    //Save the simulation time when Receive starts
    //timeOfReceive = $time;
    r.Receive(ReceiveValue);
    tb_module.result.push_back(ReceiveValue);
    
    $display("data bucket is receiving %b",ReceiveValue);
    #BL;
   /* cycleCounter += 1;		
    //Measuring throughput: calculate the number of Receives per unit of time  
    //CycleTime stores the time it takes from the begining to the end of the always block
    cycleTime = $time - timeOfReceive;
    averageThroughput = cycleCounter/$time;
    sumOfCycleTimes += cycleTime;
    averageCycleTime = sumOfCycleTimes / cycleCounter;*/
    //$display("Execution cycle= %d, Cycle Time= %d, 
   // Average CycleTime=%f, Average Throughput=%f", cycleCounter, cycleTime, 
   // averageCycleTime, averageThroughput);
	// $display("End module data_bucket and time is %d", $time);
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
  reg [7:0] original [$];
  reg [7:0] result [$];
  reg [7:0] original_data;
  reg [7:0] result_data;
  integer fp_result;
  integer fp_original;


  Channel #(.WIDTH(8), .hsProtocol(P4PhaseBD)) data_intf  [1:0] (); 
  Channel #(.WIDTH(4), .hsProtocol(P4PhaseBD)) control_intf  [1:0] (); 
  Channel #(.WIDTH(8), .hsProtocol(P4PhaseBD)) intf2core  [15:0] (); 
  Channel #(.WIDTH(8), .hsProtocol(P4PhaseBD)) db_intf[15:0]  (); 

  data_generator dg(data_intf[0], control_intf[0]);
  split spdg(data_intf[0], control_intf[0], intf2core[15:0]);

  data_bucket db0000(db_intf[0]);
  data_bucket db0001(db_intf[1]);
  data_bucket db0010(db_intf[2]);
  data_bucket db0011(db_intf[3]);
  data_bucket db0100(db_intf[4]);
  data_bucket db0101(db_intf[5]);
  data_bucket db0110(db_intf[6]);
  data_bucket db0111(db_intf[7]);

  data_bucket db1000(db_intf[8]);
  data_bucket db1001(db_intf[9]);
  data_bucket db1010(db_intf[10]);
  data_bucket db1011(db_intf[11]);
  data_bucket db1100(db_intf[12]);
  data_bucket db1101(db_intf[13]);
  data_bucket db1110(db_intf[14]);
  data_bucket db1111(db_intf[15]);


initial 
  begin 
    #10

    for(i = 0; i<10; i++)
    begin 

      case (spdg.control)
      4'b0000: intf2core[0].Receive(data); 
      4'b0001: intf2core[1].Receive(data); 
      4'b0010: intf2core[2].Receive(data); 
      4'b0011: intf2core[3].Receive(data); 
      4'b0100: intf2core[4].Receive(data); 
      4'b0101: intf2core[5].Receive(data); 
      4'b0110: intf2core[6].Receive(data); 
      4'b0111: intf2core[7].Receive(data); 
      4'b1000: intf2core[8].Receive(data); 
      4'b1001: intf2core[9].Receive(data); 
      4'b1010: intf2core[10].Receive(data); 
      4'b1011: intf2core[11].Receive(data); 
      4'b1100: intf2core[12].Receive(data); 
      4'b1101: intf2core[13].Receive(data); 
      4'b1110: intf2core[14].Receive(data); 
      4'b1111: intf2core[15].Receive(data); 
      endcase

      $display("data is %b and control is %b",data,spdg.control);

      //#20;
    end

    fp_original = $fopen("original_output.txt","a");
    fp_result = $fopen("result_output.txt","a");


    result_size = result.size();
    while(result.size()!=0)
    begin 
      result_data = result.pop_front();
      $fwrite(fp_result,"%b\n",result_data);
      $display("result data = %b",result_data);
    end
    $fclose(fp_result); 

    while(result_size!=0)
    begin 
      original_data = original.pop_front();
      $fwrite(fp_original,"%b\n",original_data);
      $display("original data = %b",original_data);
      result_size--;
    end
    $fclose(fp_original); 

  end 

endmodule 