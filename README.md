> [!CAUTION] 
> - The `.xml`, `.peri.xml`, and `.sdc` files are specific to Vaaman's FPGA (Trion T120F324).  
> - The `spi.c` script for SPI master is specifically for Vaamans's CPU (RK3399).  
> - Other codes can be used independently of the device.  
-----------------------------------------------------------------------------------
### What you need:
- All the wires should be of identical lengths. 
- You will need a dummy SPI device in your Linux kernel (e.g., `/dev/spidev1.0`, here 1 is bus and 0 is device).
- `SPI_Slave.v` is the slave. `spi_lb_top.v` is top module responsible for loopback functionality. `spi.py`/`spi.c` is for CPU, which works as SPI master here.  
#### Pin assignments:

| Pin    | CPU Pin | FPGA Pin |
|---------|-------------|---------------|
|`sclk`  |7              |H13 - 7    |
|`mosi`|29       |E9 - 29|
|`miso`|31|L15 - 31|
|`cs_n`|33|L18 - 33|
--------------------------------------------------------------------------------------------
### How it works:
#### Slave
- Clone the repo, add design files to Efinity, and synthesise with your desired clock frequency.  
- The current code is synthesised in Efinity 2024.1, and the clock is at 100 MHz.
- If you want to increase the shift register size, just change the `DATA_WIDTH` parameter in the slave. Yes, it will become faster with a larger buffer.
- Connect the wires of identical lengths.
- Flash the bitstream.
#### Master
**1. To use the Python script, install the Python dependency**
```
pip install spidev
```  
Configure the Python script for your desired `sclk` frequency, `bus` and `device`, `mode` (by default mode is 0 in both Verilog and Python), and the number of bytes you want to loopback.  


**2. To use the C script**


---------------------------------------------------------------------------------------------------------
### Potential Reasons for Failure ** :
The slave itself will never let you down.  
So if it is not working, the reasons can be:
1. `sclk` is too high, RK3399 is maxed out at 12 MHz.
2. Buffer size is not similar in the master and slave. 
3. Modes are not similar in the master and slave.
4. Wire issue.

** *If it fails.*
