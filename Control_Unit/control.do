vsim work.controlunit
add wave -position insertpoint sim:/controlunit/*

# Type 1 Instructions
# INC
force -freeze sim:/controlunit/opCode 0111001 0
run
# ADD
force -freeze sim:/controlunit/opCode 0111000 0
run
# AND
force -freeze sim:/controlunit/opCode 0111010 0
run
# NOT
force -freeze sim:/controlunit/opCode 0111011 0
run
# SUB
force -freeze sim:/controlunit/opCode 0111100 0
run
# MOV
force -freeze sim:/controlunit/opCode 0111101 0
run

# Type 2 Instructions
# OUT
force -freeze sim:/controlunit/opCode 0010001 0
run
# JZ
force -freeze sim:/controlunit/opCode 0010010 0
run
# JN
force -freeze sim:/controlunit/opCode 0010011 0
run
# JC
force -freeze sim:/controlunit/opCode 0010100 0
run
# JMP
force -freeze sim:/controlunit/opCode 0010101 0
run
# CALL
force -freeze sim:/controlunit/opCode 0010110 0
run
# PUSH
force -freeze sim:/controlunit/opCode 0010111 0
run

# Type 3 Instructions
# NOP
force -freeze sim:/controlunit/opCode 0000000 0
run
# HLT
force -freeze sim:/controlunit/opCode 0000001 0
run
# SETC
force -freeze sim:/controlunit/opCode 0000010 0
run
# INT
force -freeze sim:/controlunit/opCode 0000100 0
run
# RTI
force -freeze sim:/controlunit/opCode 0000110 0
run
# RET
force -freeze sim:/controlunit/opCode 0000111 0
run

# Type 4 Instructions
# IADD
force -freeze sim:/controlunit/opCode 1110000 0
run
# LDM
force -freeze sim:/controlunit/opCode 1110001 0
run
# LDD
force -freeze sim:/controlunit/opCode 1110010 0
run

# Type 5 Instructions
# IN
force -freeze sim:/controlunit/opCode 0100000 0
run
# POP
force -freeze sim:/controlunit/opCode 0100001 0
run

# Type 6 Instructions
# STD
force -freeze sim:/controlunit/opCode 1011000 0
run

# Test Undefined opCodes
# Undefined opcode
force -freeze sim:/controlunit/opCode 1111111 0
run
# Undefined opcode
force -freeze sim:/controlunit/opCode 0001001 0
run
# Undefined opcode
force -freeze sim:/controlunit/opCode 1010111 0
run
# Undefined opcode
force -freeze sim:/controlunit/opCode 1100000 0
run
# Reset to valid opcode (NOP)
force -freeze sim:/controlunit/opCode 0000000 0
run
