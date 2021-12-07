onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk_25
add wave -noupdate /tb/as_n
add wave -noupdate /tb/rw_n
add wave -noupdate /tb/dben_n
add wave -noupdate -radix hexadecimal /tb/adr_out
add wave -noupdate -radix hexadecimal /tb/data_out
add wave -noupdate -radix hexadecimal /tb/data_in
add wave -noupdate -radix binary /tb/dsack_n
add wave -noupdate -radix hexadecimal /tb/size_n
add wave -noupdate -divider FLAGS
add wave -noupdate -radix binary /tb/i_m68030/I_ALU/XNZVC
add wave -noupdate -divider PC
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_ADDRESSREGISTERS/PC
add wave -noupdate -divider {Data Registers}
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_DATA_REGISTERS/DR(0)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_DATA_REGISTERS/DR(1)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_DATA_REGISTERS/DR(2)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_DATA_REGISTERS/DR(3)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_DATA_REGISTERS/DR(4)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_DATA_REGISTERS/DR(5)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_DATA_REGISTERS/DR(6)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_DATA_REGISTERS/DR(7)
add wave -noupdate -divider {Adress Registers}
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_ADDRESSREGISTERS/AR(0)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_ADDRESSREGISTERS/AR(1)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_ADDRESSREGISTERS/AR(2)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_ADDRESSREGISTERS/AR(3)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_ADDRESSREGISTERS/AR(4)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_ADDRESSREGISTERS/AR(5)
add wave -noupdate -radix hexadecimal /tb/i_m68030/I_ADDRESSREGISTERS/AR(6)
add wave -noupdate -divider SP
add wave -noupdate -radix hexadecimal /tb/sp
add wave -noupdate -label {(sp + 12)} -radix hexadecimal /tb/stack(3)
add wave -noupdate -label {(sp + 8)} -radix hexadecimal /tb/stack(2)
add wave -noupdate -label {(sp + 4)} -radix hexadecimal /tb/stack(1)
add wave -noupdate -label (sp) -radix hexadecimal /tb/stack(0)
add wave -noupdate -label {(sp - 4)} -radix hexadecimal /tb/stack(-1)
add wave -noupdate -label {(sp - 8)} -radix hexadecimal /tb/stack(-2)
add wave -noupdate -label {(sp - 12)} -radix hexadecimal /tb/stack(-3)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28399754995 ps} 0} {{Cursor 2} {28400430034 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 323
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
configure wave -timelineunits ps
update
WaveRestoreZoom {28397165225 ps} {28399373001 ps}
