vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave /top/fifo_if/*
coverage save top.ucdb -onexit
run -all