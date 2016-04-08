onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /node_tb/data_generator_intf/data
add wave -noupdate /node_tb/data_bucket_intf/data
add wave -noupdate {/node_tb/data_inputs[3]/data}
add wave -noupdate {/node_tb/data_inputs[2]/data}
add wave -noupdate {/node_tb/data_inputs[1]/data}
add wave -noupdate {/node_tb/data_inputs[0]/data}
add wave -noupdate {/node_tb/data_outputs[3]/data}
add wave -noupdate {/node_tb/data_outputs[2]/data}
add wave -noupdate {/node_tb/data_outputs[1]/data}
add wave -noupdate {/node_tb/data_outputs[0]/data}
add wave -noupdate /node_tb/node1/input_arbiter_block1/merge_control_out/data
add wave -noupdate /node_tb/node1/input_process_block/merge_control/data
add wave -noupdate -radix binary /node_tb/node1/input_process_block/core_data/data
add wave -noupdate -radix binary /node_tb/node1/input_process_block/data_intf/data
add wave -noupdate -radix binary /node_tb/node1/input_process_block/hamming_out/data
add wave -noupdate -radix binary /node_tb/node1/input_process_block/addr_out/data
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix binary /node_tb/node1/edu1/datain/data
add wave -noupdate -radix binary /node_tb/node1/edu1/dataout/data
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix binary /node_tb/node1/pc/d_in/data
add wave -noupdate -radix binary /node_tb/node1/pc/addr_in/data
add wave -noupdate -radix binary /node_tb/node1/pc/d_out2core/data
add wave -noupdate -radix binary /node_tb/node1/pc/d_out2router1/data
add wave -noupdate -radix binary /node_tb/node1/pc/d_out2router2/data
add wave -noupdate -radix binary /node_tb/node1/pc/d_out2router3/data
add wave -noupdate -radix binary /node_tb/node1/pc/d_out2router4/data
add wave -noupdate -radix binary /node_tb/node1/pc/ADDR
add wave -noupdate -radix binary /node_tb/node1/pc/addr_store
add wave -noupdate -radix binary /node_tb/node1/pc/x/data
add wave -noupdate -radix binary /node_tb/node1/pc/x/result
add wave -noupdate -radix binary /node_tb/node1/pc/cp/data
add wave -noupdate -radix binary /node_tb/node1/pc/cp/ADDR
add wave -noupdate -radix binary /node_tb/node1/pc/cp/out_core
add wave -noupdate -radix binary /node_tb/node1/pc/cp/out_router
add wave -noupdate -radix binary /node_tb/node1/pc/cp/router_contr/data
add wave -noupdate /node_tb/node1/pc/cp/position
add wave -noupdate /node_tb/node1/pc/s2core/data
add wave -noupdate /node_tb/node1/pc/s2core/control
add wave -noupdate {/node_tb/node1/pc/out_intf[1]/data}
add wave -noupdate {/node_tb/node1/pc/out_intf[1]/status}
add wave -noupdate {/node_tb/node1/pc/control_router_intf[1]/data}
add wave -noupdate {/node_tb/node1/pc/control_router_intf[1]/status}
add wave -noupdate {/node_tb/node1/pc/control_core_intf[0]/data}
add wave -noupdate {/node_tb/node1/pc/control_core_intf[0]/status}
add wave -noupdate /node_tb/node1/pc/d_out2core/data
add wave -noupdate /node_tb/node1/pc/s2router/data
add wave -noupdate /node_tb/node1/pc/s2router/control
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix binary /node_tb/node1/core1/data_in_11b/data
add wave -noupdate -radix binary /node_tb/node1/core1/dg_8b/data
add wave -noupdate -radix binary /node_tb/node1/core1/db_8b/data
add wave -noupdate -radix binary /node_tb/node1/core1/data_out_11b/data
add wave -noupdate -radix binary /node_tb/node1/core1/data_control_out/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {199624060 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 390
configure wave -valuecolwidth 63
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {525937500 fs} {919687500 fs}
