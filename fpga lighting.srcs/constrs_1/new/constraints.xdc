set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { CLK_50MHz }]; 
create_clock -add -name sys_clk_pin -period 20.0 [get_ports { CLK_50MHz }]; -- was 20.00

set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { LED }]; 
