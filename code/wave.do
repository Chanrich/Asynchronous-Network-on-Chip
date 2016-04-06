onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /data_splitter_tb/dg1/SendValue
add wave -noupdate -radix unsigned /data_splitter_tb/dg2/SendValue
add wave -noupdate -radix unsigned /data_splitter_tb/ar1/data
add wave -noupdate -radix unsigned /data_splitter_tb/ar1/select
add wave -noupdate -radix unsigned /data_splitter_tb/dg3/SendValue
add wave -noupdate -radix unsigned /data_splitter_tb/dg4/SendValue
add wave -noupdate -radix unsigned /data_splitter_tb/ar2/data
add wave -noupdate -radix unsigned /data_splitter_tb/ar2/control
add wave -noupdate -radix unsigned /data_splitter_tb/ar3/data
add wave -noupdate -radix binary /data_splitter_tb/ar3/selOut
add wave -noupdate -radix unsigned /data_splitter_tb/ar3/select
add wave -noupdate -radix unsigned /data_splitter_tb/mg/data
add wave -noupdate -radix unsigned /data_splitter_tb/mg/select
add wave -noupdate -radix unsigned /data_splitter_tb/bs/inData
add wave -noupdate -radix unsigned /data_splitter_tb/bs/data
add wave -noupdate -radix unsigned /data_splitter_tb/bs/address
add wave -noupdate -radix unsigned /data_splitter_tb/db1/ReceiveValue
add wave -noupdate -radix unsigned /data_splitter_tb/db2/ReceiveValue
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8957346 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 207
configure wave -valuecolwidth 77
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
configure wave -timelineunits fs
update
WaveRestoreZoom {0 fs} {52500 ps}
