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
    #DELAY;
    SendValue = $random() % (2**WIDTH);
    #FL;
     
    r.Send(SendValue);
  end
endmodule

//Sample data_bucket module
module data_bucket (interface l);
  parameter WIDTH = 11;
  parameter BL = 0; //ideal environment
  logic [WIDTH-1:0] ReceiveValue = 0;
  
  always
  begin
    l.Receive(ReceiveValue);
    #BL;
  end
endmodule



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
		  if (select == 0)
		    inPort0.Receive(data);
		  else if (select == 1)
		    inPort1.Receive(data);
		  else if (select == 2)
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
		address = inData[3:0];
		data = inData[10:4];

		fork
		dataOut.Send(data);
		addressOut.Send(address);
		join
		#BL;
	end
endmodule

module input_process_block(interface input1_to_merge, interface input2_to_merge, interface core_data,
							interface merge_control,
							interface addr_out, interface hamming_out);
	// inputs take 11 bits
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) data_intf (); 

	merge #(.WIDTH(11), .FL(0), .BL(0)) mg(.inPort0(input1_to_merge), .inPort1(input2_to_merge), .inPort2(core_data), .controlPort(merge_control), .outPort(data_intf));
	bitSlicer #(.FL(0), .BL(0)) bs(.in(data_intf), .dataOut(hamming_out), .addressOut(addr_out));

endmodule

module input_process_block_tb;
	
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(11)) intf[3:0] ();
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(7)) hammingOUT ();
	Channel #(.hsProtocol(P4PhaseBD), .WIDTH(4)) addrOUT ();

	data_generator #(.WIDTH(11), .FL(2), .DELAY(0)) dg0(.r(intf[0]));
	data_generator #(.WIDTH(11), .FL(2), .DELAY(0)) dg1(.r(intf[1]));
	data_generator #(.WIDTH(11), .FL(2), .DELAY(0)) dg2(.r(intf[2]));
	data_generator #(.WIDTH(2), .FL(2), .DELAY(0)) dg_sel(.r(intf[3]));
	input_process_block ipb(.input1_to_merge(intf[0]), .input2_to_merge(intf[1]), .core_data(intf[2]), .merge_control(intf[3]), .addr_out(addrOUT), .hamming_out(hammingOUT));
	data_bucket #(.WIDTH(7), .BL(2)) db_ham(.l(hammingOUT));
	data_bucket #(.WIDTH(4), .BL(2)) db_addr(.l(addrOUT));
endmodule


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
		// ctr goes to ar2_no_data1's in0
	arbiter2 #(.WIDTH(11), .FL(2), .BL(2)) ar2(.in0(intf[2]), .in1(intf[3]), .out(intf[6]), .ctr(intf[7]));
		// ctr goes to ar2_no_data1's in1
	// Cascadubg two 2-inputs arbiter
	arbiter2_no_data #(.WIDTH(11), .FL(2), .BL(2)) ar2_no_data1(.in0(intf[5]), .in1(intf[7]), .ctr(intf[8]));
		// in0 from ar1's ctr port
		// in1 from ar2's ctr port
		// ctr goes to ar2_no_data2's in0
	arbiter2_no_data #(.WIDTH(11), .FL(2), .BL(2)) ar2_no_data2(.in0(intf[8]), .in1(intf[9]), .ctr(intf[13])); 
		// in0 from ctr of 'ar2_no_data1'
		// in1 from core
		// ctr goes to 'merge' control


	merge #(.WIDTH(11), .FL(0), .BL(0)) mg(.inPort0(intf[4]), .inPort1(intf[6]), .inPort2(), .controlPort(intf[13]), .outPort(intf[10]));
	bitSlicer #(.FL(0), .BL(0)) bs(.in(intf[10]), .dataOut(intf[11]), .addressOut(intf[12]));
	data_bucket #(.WIDTH(11), .BL(0)) db1(.l(intf[11]));
	data_bucket #(.WIDTH(11), .BL(0)) db2(.l(intf[12]));
endmodule