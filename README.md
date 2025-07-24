# spi_slave
SPI slave for Vaaman 
- All the wires should be of identical lengths. 
- You will need a dummy SPI device in your Linux kernel (e.g., `/dev/spidev1.0`, here 1 is bus and 0 is device).
- `SPI_Slave.v` is the slave. `spi_lb_top.v` is top module responsible for loopback functionality. `spi.py` is for CPU.
### Pin assignments:

| Pin    | CPU Pin | FPGA Pin |
|---------|-------------|---------------|
|`sclk`  |7              |H13 - 7    |
|`mosi`|29       |E9 - 29|
|`miso`|31|L15 - 31|
|`cs_n`|33|L18 - 33|

### How it works:
Clone the repo, add design files to Efinity, and synthesise with your desired clock frequency. 

Install Python dependency:
```
pip install spidev
```

Connect the wires of identical lengths.

Flash the bitstream.

Configure the Python script for your desired `sclk` frequency, `bus` and `device`, `mode` (by default mode is 0 in both Verilog and Python), and the number of bytes you want to loopback.

### Potential Reasons for Failure ** :
1. `sclk` is too high. (Checked at 12 MHz, doesn't work for higher frequencies than that, for now).
2. Wire Issue (hardware).
3. Modes are not similar in Python and Verilog. 

** *If it fails.*
