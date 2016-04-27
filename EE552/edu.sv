`timescale 1ns/100ps
import SystemVerilogCSP::*;

// //Sample data_generator module
// module data_generator (interface r);
//   parameter WIDTH = 8;
//   parameter FL = 0; //ideal environment
//   logic [WIDTH-1:0] SendValue=0;
//   always
//   begin 
//     //add a display here to see when this module starts its main loop
//     $display("---Always Block Start Time: %m %d", $time);
//     SendValue = $random() % (2**WIDTH);
//     #FL;
     
//     //Communication action Send is about to start
//     $display("Starting %m.Send @ %d", $time);
//     r.Send(SendValue);
//     //Communication action Send is finished
//     $display("Finished %m.Send @ %d", $time);
//   end
// endmodule

// //Sample data_bucket module
// module data_bucket (interface r);
//   parameter WIDTH = 8;
//   parameter BL = 0; //ideal environment
//   logic [WIDTH-1:0] ReceiveValue = 0;
  
//   //Variables added for performance measurements
//   real cycleCounter=0, //# of cycles = Total number of times a value is received
//        timeOfReceive=0, //Simulation time of the latest Receive 
//        cycleTime=0; // time difference between the last two receives
//   real averageThroughput=0, averageCycleTime=0, sumOfCycleTimes=0;
//   always
//   begin
// 	$display("---Always Block Start Time: %m %d", $time);
// 	//$display("Start module data_bucket and time is %d", $time);	
//     //Save the simulation time when Receive starts
//     timeOfReceive = $time;
// 	$display("!!!Starting receiving %m.  @ %d", $time);
//     r.Receive(ReceiveValue);
// 	$display("!!!Finishing receiving in %m.  @ %d", $time);
//     #BL;
//     cycleCounter += 1;		
//     //Measuring throughput: calculate the number of Receives per unit of time  
//     //CycleTime stores the time it takes from the begining to the end of the always block
//     cycleTime = $time - timeOfReceive;
//     averageThroughput = cycleCounter/$time;
//     sumOfCycleTimes += cycleTime;
//     averageCycleTime = sumOfCycleTimes / cycleCounter;
//     $display("Execution cycle= %d, Cycle Time= %d, 
//     Average CycleTime=%f, Average Throughput=%f", cycleCounter, cycleTime, 
//     averageCycleTime, averageThroughput);
// 	//$display("End module data_bucket and time is %d", $time);
//   end
  
// endmodule

module edu(interface datain, interface dataout);
	parameter FL = 2;
	parameter BL = 2;
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
	always begin
		datain.Receive(raw_data);
		P1 = raw_data[0] ^ raw_data[2] ^ raw_data[4] ^ raw_data[6];
		P2 = raw_data[1] ^ raw_data[2] ^ raw_data[5] ^ raw_data[6];
		P4 = raw_data[3] ^ raw_data[4] ^ raw_data[5] ^ raw_data[6];
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
			raw_data[parity_bit-1] = ~raw_data[parity_bit-1];
		end
		#FL;
		dataout.Send(raw_data);
		#BL;
	end
endmodule

module edu_tb;
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(7)) intf [1:0]();
	data_generator #(.WIDTH(7)) dg1(intf[0]);
	edu edu(intf[0], intf[1]);
	data_bucket #(.WIDTH(7)) split_db2(intf[1]);
	

endmodule