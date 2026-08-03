vlib work
vlog *.sv
vsim -voptargs=+acc *.tb
add wave *
run _all
quit -sim