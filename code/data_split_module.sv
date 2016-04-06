`timescale 1ns/100ps
import SystemVerilogCSP::*;

//Sample data_generator module
module data_generator (interface r);
  parameter WIDTH = 11;
  parameter FL = 0; //ideal environment
  parameter DELAY = 0;
  logic [WIDTH-1:0] SendValue=0;
  always
  begin 
    //add a display here to see when this module starts its main loop
    //$display("Start module data_generator at time %d", $time);
    #DELAY;
    SendValue = $random() % (2**WIDTH);
    //$display("########## DG=%m generated Value=%d", SendValue);
    #FL;
     
    //Communication action Send is about to start
    //$display("Starting %m.Send @ %d", $time);
    r.Send(SendValue);
    //Communication action Send is finished
    //$display("Finished %m.Send @ %d", $time);
    //$display("End module data_generator at time %d", $time);
  end
endmodule

//Sample data_bucket module
module data_bucket (interface l);
  parameter WIDTH = 11;
  parameter BL = 0; //ideal environment
  logic [WIDTH-1:0] ReceiveValue = 0;
  
  //Variables added for performance measurements
  //real cycleCounter=0, //# of cycles = Total number of times a value is received
       //timeOfReceive=0, //Simulation time of the latest Receive 
       //cycleTime=0; // time difference between the last two receives
  //real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;
  always
  begin
	//$display("Start module data_bucket at time %d", $time);	
    //Save the simulation time when Receive starts
    //timeOfReceive = $time;
    l.Receive(ReceiveValue);
    #BL;
    $display("########## Value result is %d", ReceiveValue);
    //cycleCounter += 1;		
    //Measuring throughput: calculate the number of Receives per unit of time  
    //CycleTime stores the time it takes from the begining to the end of the always block
    //cycleTime = $time - timeOfReceive;
    //averageThroughput = cycleCounter/$time;
    //sumOfCycleTimes += cycleTime;
    //averageCycleTime = sumOfCycleTimes / cycleCounter;
    //$display("Execution cycle= %d, Cycle Time= %d, 
    //Average CycleTime=%f, Average Throughput=%f", cycleCounter, cycleTime, 
    //averageCycleTime, averageThroughput);
	//$display("End module data_bucket at time %d", $time);
  end
endmodule

module arbiter2 (interface in0, interface in1, interface out, interface ctr);
	parameter WIDTH = 11;
	parameter FL = 2;
	parameter BL = 2;
	logic select=0;
	logic [WIDTH-1:0] data;
	logic control = 1;
	always
	begin
		wait((in0.status != idle) || (in1.status != idle)); //wait until 1 of the input ports has a token
		
		if((in0.status != idle) && (in1.status != idle)) //if both ports have tokens
		begin
			if(select == 0)
			begin
				in0.Receive(data);
				#FL;
				fork
				out.Send(data);
				ctr.Send(control);
				join
				#BL;
			end
			else if(select == 1)
			begin
				in1.Receive(data);
				#FL;
				fork
				out.Send(data);
				ctr.Send(control);
				join
				#BL;
			end
			select = ~select;
		end
		else if(in0.status != idle) //if input0 has token ready
		begin
				in0.Receive(data);
				#FL;
				$display("data=%b",data);
				fork
				out.Send(data);
				ctr.Send(control);
				join
				#BL;
		end
		else if(in1.status != idle) //if input0 has token ready
		begin
				in1.Receive(data);
				#FL;
				fork
				out.Send(data);
				ctr.Send(control);
				join
				#BL;
		end
	end
endmodule // arbiter2in

module arbiter3 (interface in0, interface in1, interface in2, interface out);
	parameter WIDTH = 2;
	parameter FL = 2;
	parameter BL = 2;
	logic [1:0] select=0;
	logic data;
	logic [1:0] selOut;

	always
	begin
		wait((in0.status != idle) || (in1.status != idle) || (in2.status != idle)); //wait until 1 of the input ports has a token
		
		if((in0.status != idle) && (in1.status != idle) && (in2.status != idle)) //if both ports have tokens
		begin
			if(select == 0)
			begin
				in0.Receive(data);
				#FL;
				selOut = 01;
				out.Send(selOut);
				#BL;
			end
			else if(select == 1)
			begin
				in1.Receive(data);
				#FL;
				selOut = 01;
				out.Send(selOut);
				#BL;
			end
			else if(select == 2)
			begin
				in2.Receive(data);
				#FL;
				selOut = 10;
				out.Send(selOut);
				#BL;
			end
			select = select + 1;
		end
		else if(in0.status != idle) //if input0 has token ready
		begin
				in0.Receive(data);
				#FL;
				selOut = 00;
				out.Send(selOut);
				#BL;
		end
		else if(in1.status != idle) //if input0 has token ready
		begin
				in1.Receive(data);
				#FL;
				selOut = 01;
				out.Send(selOut);
				#BL;
		end
		else if(in2.status != idle) //if input0 has token ready
		begin
				in2.Receive(data);
				#FL;
				selOut = 10;
				out.Send(selOut);
				#BL;
		end
	end
endmodule // arbiter3in

  //merge module
  module merge (interface inPort0, interface inPort1, interface inPort2, interface controlPort, interface outPort);
    parameter WIDTH = 11;
    parameter FL = 2;
	  parameter BL = 2;
    logic [WIDTH-1:0] data;
    logic [1:0] select;
    
    always
    begin
		  controlPort.Receive(select);
		  if (select == 00)
		    inPort0.Receive(data);
		  else if (select == 01)
		    inPort1.Receive(data);
		  else if (select == 10)
			inPort2.Receive(data);
		  #FL;
	
		  outPort.Send(data);
		  #BL;
     end
  endmodule

module bitSlicer(interface in, interface dataOut, interface addressOut);
	parameter FL = 0;
	parameter BL = 0;
	logic [10:0] inData;
	logic [6:0] data;
	logic [3:0] address;

	always
	begin
		in.Receive(inData);
		#FL;

		data = inData[10:4];
		address = inData[3:0];

		fork
		dataOut.Send(data);
		addressOut.Send(address);
		join
		#BL;
	end
endmodule

/*module arbiter2_tb;
	logic [10:0] in0=0, in1=0;
	wire [10:0] out;

	//Interface Vector instantiation: 4-phase bundled data channel
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) intf[2:0] (); 
	//assign in0 = intf[0];
	//assign intf[1] = in1;
	//assign intf[2] = out;

	data_generator #(.WIDTH(11), .FL(0), .DELAY(5)) dg1(.r(intf[0]));
	data_generator #(.WIDTH(11), .FL(0), .DELAY(10)) dg2(.r(intf[1]));
	arbiter2 #(.WIDTH(11), .FL(2), .BL(2)) ar1(.in0(intf[0]), .in1(intf[1]), .out(intf[2]));
	data_bucket #(.WIDTH(11), .BL(0)) db(.l(intf[2]));
	//arbiter2 #(.WIDTH(8), .FL(0), .BL(0)) ar1_0(.in0(in0), .in1(in1), .out(out));

	//initial
	//begin
		//#100;
		//intf[0].Send(1);
		//#10;
		//$display("out=%p",intf[2]);
		//intf[1].Send(0);
		//#100;
		//$display("in0=%b, in1=%b, out=%b",in0, in1, out);
		//#100;

		//aData = {$random()} % (2**8);
	//end

	//always
	//begin
		//@outData;
		//aData = {$random()} % (2**8);
		//aReq = ~aReq;
		//#5;
	//end

	//always
	//begin
	//	reset = ~reset;
	//	$display("3 reset=%b",reset);
	//	#500;
		//if(reset == 1)
		//begin
			//aReq <= 0;
			//bAck <= 0;
		//end
	//end
endmodule*/

module data_splitter_tb;
	logic [10:0] in0=0, in1=0;
	wire [10:0] out;

	//Interface Vector instantiation: 4-phase bundled data channel
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) intf[13:0] (); 

	data_generator #(.WIDTH(11), .FL(0), .DELAY(5)) dg1(.r(intf[0]));
	data_generator #(.WIDTH(11), .FL(0), .DELAY(10)) dg2(.r(intf[1]));
	data_generator #(.WIDTH(11), .FL(0), .DELAY(15)) dg3(.r(intf[2]));
	data_generator #(.WIDTH(11), .FL(0), .DELAY(20)) dg4(.r(intf[3]));
	arbiter2 #(.WIDTH(11), .FL(2), .BL(2)) ar1(.in0(intf[0]), .in1(intf[1]), .out(intf[4]), .ctr(intf[5]));
	arbiter2 #(.WIDTH(11), .FL(2), .BL(2)) ar2(.in0(intf[2]), .in1(intf[3]), .out(intf[6]), .ctr(intf[7]));
	arbiter3 #(.WIDTH(11), .FL(2), .BL(2)) ar3(.in0(intf[5]), .in1(intf[7]), .in2(intf[9]), .out(intf[13]));
	merge #(.WIDTH(11), .FL(0), .BL(0)) mg(.inPort0(intf[4]), .inPort1(intf[6]), .inPort2(intf[8]), .controlPort(intf[13]), .outPort(intf[10]));
	bitSlicer #(.FL(0), .BL(0)) bs(.in(intf[10]), .dataOut(intf[11]), .addressOut(intf[12]));
	data_bucket #(.WIDTH(11), .BL(0)) db1(.l(intf[11]));
	data_bucket #(.WIDTH(11), .BL(0)) db2(.l(intf[12]));
endmodule