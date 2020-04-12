# fpga-lighting

First attempt at VHDL, creating a driver for lighting strips

Ran vivado with the following, as I didn't have enough space in /tmp, when running a simulation causing it to crash:

```
TMPDIR=/opt/tmp/ ./vivado 
```

(-tempDir vivado argument, didn't seem to have any effect for me)

# To Do

* Implement SPI
* Implement BRAM correctly
* Make work for multiple LED strips
* Test with PMOD I designed - https://github.com/anfractuosity/lightdriver

# Notes 

* xilinx/Vivado/2018.2/data/boards/board_files/zybo/B.3/board.xml lists the pins

