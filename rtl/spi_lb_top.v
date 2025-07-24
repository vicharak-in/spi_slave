/*module spi_lb_top #(
    parameter DATA_WIDTH = 8
)(
    // System signals
    input  wire clk,           // System clock
    input  wire rst_n,         // Active low reset
    
    // SPI interface
    input  wire spi_sclk,      // SPI clock from master
    input  wire spi_mosi,      // Master Out, Slave In
    output wire spi_miso,      // Master In, Slave Out
    input  wire spi_cs_n       // Chip select (active low)
);

    // Internal signals
    wire [DATA_WIDTH-1:0] spi_tx_data;
    wire [DATA_WIDTH-1:0] spi_rx_data;
    wire spi_tx_req;
    wire spi_rx_valid;
    
    // Loopback register
    reg [DATA_WIDTH-1:0] loopback_data;
    
    // Instantiate SPI Slave
    SPI_Slave #(
        .DATA_WIDTH(DATA_WIDTH)
    ) spi_slave_inst (
        .clk(clk),
        .rst_n(rst_n),
        .sclk(spi_sclk),
        .mosi(spi_mosi),
        .miso(spi_miso),
        .cs_n(spi_cs_n),
        .tx_data(spi_tx_data),
        .rx_data(spi_rx_data),
        .tx_req(spi_tx_req),
        .rx_valid(spi_rx_valid)
    );
    
    // Simple loopback: store received data to send in next transaction
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            loopback_data <= {DATA_WIDTH{1'b0}};
        end else begin
            if (spi_rx_valid) begin
                loopback_data <= spi_rx_data;
            end
        end
    end
    
    // Connect loopback data to TX
    assign spi_tx_data = loopback_data;

endmodule*/

module spi_lb_top #(
    parameter DATA_WIDTH = 8
)(
    input  wire clk,
    input  wire rst_n,

    input  wire spi_sclk,
    input  wire spi_mosi,
    output wire spi_miso,
    input  wire spi_cs_n
);

    wire [DATA_WIDTH-1:0] spi_tx_data;
    wire [DATA_WIDTH-1:0] spi_rx_data;
    wire spi_tx_req;
    wire spi_rx_valid;

    reg [DATA_WIDTH-1:0] loopback_data;

    // Instantiate the modified SPI slave
    SPI_Slave #(
        .DATA_WIDTH(DATA_WIDTH)
    ) spi_slave_inst (
        .clk(clk),
        .rst_n(rst_n),
        .sclk(spi_sclk),
        .mosi(spi_mosi),
        .miso(spi_miso),
        .cs_n(spi_cs_n),
        .tx_data(spi_tx_data),
        .rx_data(spi_rx_data),
        .tx_req(spi_tx_req),
        .rx_valid(spi_rx_valid)
    );

    // Update loopback data after each received byte
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            loopback_data <= 0;
        else if (spi_rx_valid)
            loopback_data <= spi_rx_data;
    end

    assign spi_tx_data = loopback_data;

endmodule
