set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { clk }];
 
create_clock -add -name sys_clk_pin -period 8.0 [get_ports { clk }]; 

set_property -dict { PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports { strip_1 }]; 

#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { spi_clk }]; 

#set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { spi_in }]; 

#set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports { LED }]; 

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets spi_clk ];