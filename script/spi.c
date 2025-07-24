#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/spi/spidev.h>
#include <stdint.h>
#include <string.h>

#define SPI_DEV     "/dev/spidev1.0"
#define SPI_SPEED   12000000   // 12 MHz
#define BPW         8
#define CHUNK_SIZE  64         // bytes per read

int main() {
    int fd;
    uint8_t tx[CHUNK_SIZE] = {0};  // dummy TX (all zeros)
    uint8_t rx[CHUNK_SIZE] = {0};

    // Open SPI device
    fd = open(SPI_DEV, O_RDWR);
    if (fd < 0) {
        perror("open spidev");
        return 1;
    }

    // Set SPI mode (MODE0)
    int spi_mode = SPI_MODE_0;
    if (ioctl(fd, SPI_IOC_WR_MODE, &spi_mode) < 0) {
        perror("set spi mode");
        close(fd);
        return 1;
    }

    // Set bits per word
    uint8_t bpw = BPW;
    if (ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &bpw) < 0) {
        perror("set bits per word");
        close(fd);
        return 1;
    }

    // Set max speed
    int speed = SPI_SPEED;
    if (ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed) < 0) {
        perror("set max speed");
        close(fd);
        return 1;
    }

    printf("Reading %d bytes continuously from %s...\n", CHUNK_SIZE, SPI_DEV);

    while (1) {
        struct spi_ioc_transfer tr = {
            .tx_buf = (unsigned long) tx, // dummy tx
            .rx_buf = (unsigned long) rx,
            .len = CHUNK_SIZE,
            .speed_hz = SPI_SPEED,
            .bits_per_word = BPW,
        };

        int ret = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
        if (ret < 0) {
            perror("spi_xfer");
            break;
        }

        // Print received data in hex
        for (int i = 0; i < CHUNK_SIZE; i++) {
            printf("%02X ", rx[i]);
        }
        printf("\n");
        fflush(stdout);

        // Optional small delay to avoid flooding terminal
        usleep(10000);  // 10ms
    }

    close(fd);
    return 0;
}
