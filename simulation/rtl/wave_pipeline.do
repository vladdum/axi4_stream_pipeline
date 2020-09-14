onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /testbench/pipeline/clk_i
add wave -noupdate -radix hexadecimal /testbench/pipeline/rst_n_i
add wave -noupdate -divider Input
add wave -noupdate -radix hexadecimal /testbench/pipeline/tvalid_i
add wave -noupdate -radix hexadecimal /testbench/pipeline/tready_o
add wave -noupdate -radix hexadecimal /testbench/pipeline/tlast_i
add wave -noupdate -radix hexadecimal /testbench/pipeline/tdata_i
add wave -noupdate -divider Output
add wave -noupdate -radix hexadecimal /testbench/pipeline/tvalid_o
add wave -noupdate -radix hexadecimal /testbench/pipeline/tready_i
add wave -noupdate -radix hexadecimal /testbench/pipeline/tlast_o
add wave -noupdate -radix hexadecimal /testbench/pipeline/tdata_o
add wave -noupdate -divider Internal
add wave -noupdate -radix hexadecimal /testbench/pipeline/tvalid_r2g
add wave -noupdate -radix hexadecimal /testbench/pipeline/tready_sobel
add wave -noupdate -radix hexadecimal /testbench/pipeline/tlast_r2g
add wave -noupdate -radix hexadecimal /testbench/pipeline/tdata_r2g
add wave -noupdate -radix hexadecimal /testbench/pipeline/sobel/data_next
add wave -noupdate -radix hexadecimal /testbench/pipeline/sobel/state_reg
add wave -noupdate -radix hexadecimal /testbench/pipeline/sobel/next_state
add wave -noupdate -radix hexadecimal -childformat {{{/testbench/pipeline/sobel/sliding[0]} -radix hexadecimal -childformat {{{/testbench/pipeline/sobel/sliding[0][0]} -radix hexadecimal} {{/testbench/pipeline/sobel/sliding[0][1]} -radix hexadecimal} {{/testbench/pipeline/sobel/sliding[0][2]} -radix hexadecimal}}} {{/testbench/pipeline/sobel/sliding[1]} -radix hexadecimal} {{/testbench/pipeline/sobel/sliding[2]} -radix hexadecimal}} -expand -subitemconfig {{/testbench/pipeline/sobel/sliding[0]} {-radix hexadecimal -childformat {{{/testbench/pipeline/sobel/sliding[0][0]} -radix hexadecimal} {{/testbench/pipeline/sobel/sliding[0][1]} -radix hexadecimal} {{/testbench/pipeline/sobel/sliding[0][2]} -radix hexadecimal}} -expand} {/testbench/pipeline/sobel/sliding[0][0]} {-radix hexadecimal} {/testbench/pipeline/sobel/sliding[0][1]} {-radix hexadecimal} {/testbench/pipeline/sobel/sliding[0][2]} {-radix hexadecimal} {/testbench/pipeline/sobel/sliding[1]} {-radix hexadecimal} {/testbench/pipeline/sobel/sliding[2]} {-radix hexadecimal}} /testbench/pipeline/sobel/sliding
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {110 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {5007 ns} {7842 ns}
