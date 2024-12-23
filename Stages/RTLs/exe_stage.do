add wave -position insertpoint sim:/exe_stage/*
force -freeze sim:/exe_stage/WB_IN 0 0
force -freeze sim:/exe_stage/MEM_IN 0 0
force -freeze sim:/exe_stage/EXE_IN 000 0
force -freeze sim:/exe_stage/PC_IN 0000000000000000 0
force -freeze sim:/exe_stage/operand1 0000000000000010 0
force -freeze sim:/exe_stage/operand2 0000000000000100 0
force -freeze sim:/exe_stage/immediate_IN 0000000000000011 0
force -freeze sim:/exe_stage/Rdst_IN 000 0
force -freeze sim:/exe_stage/ALUSrc 0 0
force -freeze sim:/exe_stage/Inc 0 0
run

force -freeze sim:/exe_stage/EXE_IN 001 0
run

force -freeze sim:/exe_stage/EXE_IN 010 0
run

force -freeze sim:/exe_stage/EXE_IN 011 0
run

force -freeze sim:/exe_stage/EXE_IN 100 0
run

force -freeze sim:/exe_stage/EXE_IN 101 0
run

