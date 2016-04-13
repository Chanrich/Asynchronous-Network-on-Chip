onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary {/top_tb/db_intf[0]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[1]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[2]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[3]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[4]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[5]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[6]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[7]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[8]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[9]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[10]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[11]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[12]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[13]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[14]/data}
add wave -noupdate -radix binary {/top_tb/db_intf[15]/data}
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix binary {/top_tb/dg_intf[0]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[1]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[2]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[3]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[4]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[5]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[6]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[7]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[8]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[9]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[10]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[11]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[12]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[13]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[14]/data}
add wave -noupdate -radix binary {/top_tb/dg_intf[15]/data}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {276026201 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 226
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 fs} {420 ns}
