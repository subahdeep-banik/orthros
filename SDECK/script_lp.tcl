sh rm -rf WORK/*
remove_design -all


define_design_lib WORK -path ./WORK
analyze -library WORK -format vhdl {./HDL/RTL/subround.vhd
./HDL/RTL/sdeck.vhd
}



elaborate SDECK -architecture RTL -library WORK

 set_max_delay 8 -from InxDI -to OutxDO  
 set_max_delay 8 -from KeyxDI -to OutxDO  

create_clock -name "ClkxCI" -period 100 -waveform { 0 50  }  { ClkxCI  }

set_max_area 0

compile_ultra

change_selection -name global -replace [get_timing_paths -delay_type max -nworst 1 -max_paths 1 -include_hierarchical_pins]

uplevel #0 { report_timing -path full -delay max -nworst 40 -max_paths 40 -significant_digits 2 -sort_by group > timing_lp.txt}

uplevel #0 { report_area -hierarchy > area_lp.txt}
 
write -hierarchy -format verilog -output sd-syn.v 

write_sdf sd-syn.sdf  

write -hierarchy -format ddc -output sd.ddc

write -hierarchy -format vhdl -output sd.vhdl

write_sdc -nosplit sd.sdc



