set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { CLK_50MHz }];
 
create_clock -add -name sys_clk_pin -period 8.0 [get_ports { CLK_50MHz }]; 

set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { STRIP1 }]; 

set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { SPI_CLK }]; 

set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { SPI_DATA_IN }]; 

set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports { LED }]; 


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets SPI_CLK_IBUF] ;