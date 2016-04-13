`timescale 1ns/100ps
import SystemVerilogCSP::*;


module top (interface dg_in [15:0], interface db_out [15:0]);

	Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_intf_1  [22:0] (); 
	Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_intf_2  [22:0] (); 
	Channel #(.WIDTH(11), .hsProtocol(P4PhaseBD)) data_intf_3  [15:0] (); 


	node #(.MyIP(4'b0000)) n1  (.in1(data_intf_1[1]), .in2(data_intf_1[3]), .in3(data_intf_1[5]), .in4(data_intf_3[1]), 
	 .out1(data_intf_1[0]), .out2(data_intf_1[2]), .out3(data_intf_1[4]), .out4(data_intf_3[0]),
	 .db(db_out[0]), .dg(dg_in[0]));

	node #(.MyIP(4'b0001)) n2  (.in1(data_intf_1[0]), .in2(data_intf_1[7]), .in3(data_intf_1[9]), .in4(data_intf_3[3]), 
	 .out1(data_intf_1[1]), .out2(data_intf_1[6]), .out3(data_intf_1[8]), .out4(data_intf_3[2]),
	 .db(db_out[1]), .dg(dg_in[1]));

	node #(.MyIP(4'b0010)) n3  (.in1(data_intf_1[2]), .in2(data_intf_1[10]), .in3(data_intf_1[12]), .in4(data_intf_3[5]), 
	 .out1(data_intf_1[9]), .out2(data_intf_1[3]), .out3(data_intf_1[11]), .out4(data_intf_3[4]),
	 .db(db_out[2]), .dg(dg_in[2]));

	node #(.MyIP(4'b0011)) n4  (.in1(data_intf_1[6]), .in2(data_intf_1[9]), .in3(data_intf_1[14]), .in4(data_intf_3[7]), 
	 .out1(data_intf_1[10]), .out2(data_intf_1[7]), .out3(data_intf_1[13]), .out4(data_intf_3[6]),
	 .db(db_out[3]), .dg(dg_in[3]));

	node #(.MyIP(4'b0100)) n5  (.in1(data_intf_1[4]), .in2(data_intf_1[16]), .in3(data_intf_1[18]), .in4(data_intf_3[9]), 
	 .out1(data_intf_1[15]), .out2(data_intf_1[17]), .out3(data_intf_1[5]), .out4(data_intf_3[8]),
	 .db(db_out[4]), .dg(dg_in[4]));

	node #(.MyIP(4'b0101)) n6  (.in1(data_intf_1[8]), .in2(data_intf_1[15]), .in3(data_intf_1[20]), .in4(data_intf_3[11]), 
	 .out1(data_intf_1[16]), .out2(data_intf_1[19]), .out3(data_intf_1[9]), .out4(data_intf_3[10]),
	 .db(db_out[5]), .dg(dg_in[5]));

	node #(.MyIP(4'b0110)) n7  (.in1(data_intf_1[11]), .in2(data_intf_1[17]), .in3(data_intf_1[22]), .in4(data_intf_3[13]), 
	 .out1(data_intf_1[21]), .out2(data_intf_1[18]), .out3(data_intf_1[12]), .out4(data_intf_3[12]),
	 .db(db_out[6]), .dg(dg_in[6]));

	node #(.MyIP(4'b0111)) n8  (.in1(data_intf_1[13]), .in2(data_intf_1[19]), .in3(data_intf_1[21]), .in4(data_intf_3[15]), 
	 .out1(data_intf_1[22]), .out2(data_intf_1[20]), .out3(data_intf_1[14]), .out4(data_intf_3[14]),
	 .db(db_out[7]), .dg(dg_in[7]));

	node #(.MyIP(4'b1000)) n9  (.in1(data_intf_2[1]), .in2(data_intf_2[3]), .in3(data_intf_2[5]), .in4(data_intf_3[0]), 
	 .out1(data_intf_2[0]), .out2(data_intf_2[2]), .out3(data_intf_2[4]), .out4(data_intf_3[1]),
	 .db(db_out[8]), .dg(dg_in[8]));

	node #(.MyIP(4'b1001)) n10  (.in1(data_intf_2[0]), .in2(data_intf_2[7]), .in3(data_intf_2[9]), .in4(data_intf_3[2]), 
	 .out1(data_intf_2[1]), .out2(data_intf_2[6]), .out3(data_intf_2[8]), .out4(data_intf_3[3]),
	 .db(db_out[9]), .dg(dg_in[9]));

	node #(.MyIP(4'b1010)) n11  (.in1(data_intf_2[2]), .in2(data_intf_2[10]), .in3(data_intf_2[12]), .in4(data_intf_3[4]), 
	 .out1(data_intf_2[9]), .out2(data_intf_2[3]), .out3(data_intf_2[11]), .out4(data_intf_3[5]),
	 .db(db_out[10]), .dg(dg_in[10]));

	node #(.MyIP(4'b1011)) n12  (.in1(data_intf_2[6]), .in2(data_intf_2[9]), .in3(data_intf_2[14]), .in4(data_intf_3[6]), 
	 .out1(data_intf_2[10]), .out2(data_intf_2[7]), .out3(data_intf_2[13]), .out4(data_intf_3[7]),
	 .db(db_out[11]), .dg(dg_in[11]));

	node #(.MyIP(4'b1100)) n13  (.in1(data_intf_2[4]), .in2(data_intf_2[16]), .in3(data_intf_2[18]), .in4(data_intf_3[8]), 
	 .out1(data_intf_2[15]), .out2(data_intf_2[17]), .out3(data_intf_2[5]), .out4(data_intf_3[9]),
	 .db(db_out[12]), .dg(dg_in[12]));

	node #(.MyIP(4'b1101)) n14  (.in1(data_intf_2[8]), .in2(data_intf_2[15]), .in3(data_intf_2[20]), .in4(data_intf_3[10]), 
	 .out1(data_intf_2[16]), .out2(data_intf_2[19]), .out3(data_intf_2[9]), .out4(data_intf_3[11]),
	 .db(db_out[13]), .dg(dg_in[13]));

	node #(.MyIP(4'b1110)) n15  (.in1(data_intf_2[11]), .in2(data_intf_2[17]), .in3(data_intf_2[22]), .in4(data_intf_3[12]), 
	 .out1(data_intf_2[21]), .out2(data_intf_2[18]), .out3(data_intf_2[12]), .out4(data_intf_3[13]),
	 .db(db_out[14]), .dg(dg_in[14]));

	node #(.MyIP(4'b1111)) n16 (.in1(data_intf_2[13]), .in2(data_intf_2[19]), .in3(data_intf_2[21]), .in4(data_intf_3[14]), 
	 .out1(data_intf_2[22]), .out2(data_intf_2[20]), .out3(data_intf_2[14]), .out4(data_intf_3[15]),
	 .db(db_out[15]), .dg(dg_in[15]));


endmodule


module data_bucket_top_tb (interface r);
  parameter WIDTH = 8;
  parameter BL = 0; //ideal environment
  logic [WIDTH-1:0] ReceiveValue = 0;
  always
  begin
    r.Receive(ReceiveValue);
  end
endmodule

module top_tb;
	Channel #(.WIDTH(8), .hsProtocol(P4PhaseBD)) dg_intf  [15:0] (); 
	Channel #(.WIDTH(8), .hsProtocol(P4PhaseBD)) db_intf  [15:0] (); 
	top t1 (.dg_in(dg_intf[15:0]), .db_out(db_intf[15:0]));

	data_bucket_top_tb data_bucket_top_tb1(.r(db_intf[0]));
	data_bucket_top_tb data_bucket_top_tb2(.r(db_intf[1]));
	data_bucket_top_tb data_bucket_top_tb3(.r(db_intf[2]));
	data_bucket_top_tb data_bucket_top_tb4(.r(db_intf[3]));
	data_bucket_top_tb data_bucket_top_tb5(.r(db_intf[4]));
	data_bucket_top_tb data_bucket_top_tb6(.r(db_intf[5]));
	data_bucket_top_tb data_bucket_top_tb7(.r(db_intf[6]));
	data_bucket_top_tb data_bucket_top_tb8(.r(db_intf[7]));	
	data_bucket_top_tb data_bucket_top_tb9(.r(db_intf[8]));
	data_bucket_top_tb data_bucket_top_tb10(.r(db_intf[9]));
	data_bucket_top_tb data_bucket_top_tb11(.r(db_intf[10]));
	data_bucket_top_tb data_bucket_top_tb12(.r(db_intf[11]));
	data_bucket_top_tb data_bucket_top_tb13(.r(db_intf[12]));
	data_bucket_top_tb data_bucket_top_tb14(.r(db_intf[13]));
	data_bucket_top_tb data_bucket_top_tb15(.r(db_intf[14]));
	data_bucket_top_tb data_bucket_top_tb16(.r(db_intf[15]));

	initial begin
		dg_intf[0].Send(8'b00010001);
		#20;
		dg_intf[0].Send(8'b00100011);
		#20;
		dg_intf[0].Send(8'b00110111);
		#20;
		dg_intf[0].Send(8'b01001111);
		#20;
		dg_intf[0].Send(8'b01011111);
		#20;
		dg_intf[1].Send(8'b01100000);
		#20;
		dg_intf[1].Send(8'b01110011);
		#20;
		dg_intf[1].Send(8'b10000111);
		#20;
		dg_intf[1].Send(8'b10011111);
		#20;
		dg_intf[15].Send(8'b10100000);
		#20;
		dg_intf[14].Send(8'b10110000);
		#20;
		dg_intf[13].Send(8'b11000000);
	end
endmodule