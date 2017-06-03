#include <arpa/inet.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#define PORT 5555
#define RING_SIZE 1024
#define INIT_ADDR 0x20000000

#define COUNT_MEASURE_INTERVAL (1024 * 5) // match the message sent by client

uint32_t g_current_addr = INIT_ADDR;
struct timespec g_start, g_end;
int g_measure_curr_count = 0;

int check_addr_available(uint32_t addr) {
  char command[33];
  sprintf(command, "../local/memtool -32 0x%08X 1", addr);

  FILE *output = popen(command, "r");
  if (!output) {
    perror("check_addr");
    exit(EXIT_FAILURE);
  }

  int available = 0;
  const int kLen = 80;

  char *str = (char *)malloc(kLen);
  fread(str, 1, kLen, output);
  if (strstr(str, "00000000") != NULL) {
    available = 1;
  }

  if (pclose(output) != 0) {
    perror("close command");
    exit(EXIT_FAILURE);
  }

  return available;
}

void write_mem(uint32_t val) {
  while (check_addr_available(g_current_addr) == 0) {
  }

  char command[42];
  sprintf(command, "../local/memtool -32 0x%08X=0x%08X", g_current_addr, val);
  int status = system(command);

  if (status == -1) {
    perror("write_mem");
    exit(EXIT_FAILURE);
  }

  g_measure_curr_count++;
  if (g_measure_curr_count % COUNT_MEASURE_INTERVAL == 0) {
    clock_gettime(CLOCK_MONOTONIC_RAW, &g_end);
    uint64_t delta_us = (g_end.tv_sec - g_start.tv_sec) * 1000000 +
                        (g_end.tv_nsec - g_start.tv_nsec) / 1000;
    printf("\nHandle %d addresses used %" PRIu64 " milliseconds.\n\n",
           COUNT_MEASURE_INTERVAL, delta_us);

    clock_gettime(CLOCK_MONOTONIC_RAW, &g_start);
  }

  g_current_addr += sizeof(val);
  if (g_current_addr >= INIT_ADDR + RING_SIZE * sizeof(val)) {
    g_current_addr = INIT_ADDR;
  }
}

int read_from_client(int filedes) {
  int32_t ret;
  int nbytes;

  if (g_measure_curr_count == 0) {
    clock_gettime(CLOCK_MONOTONIC_RAW, &g_start);
  }

  nbytes = read(filedes, &ret, sizeof(ret));
  if (nbytes < 0) {
    /* Read error. */
    perror("read");
    exit(EXIT_FAILURE);
  } else if (nbytes == 0)
    /* End-of-file. */
    return -1;
  else {
    /* Data read. */
    uint32_t val = ntohl(ret);
    write_mem(val);

    return 0;
  }
}

int make_socket(uint16_t port) {
  int sock;
  struct sockaddr_in name;

  /* Create the socket. */
  sock = socket(PF_INET, SOCK_STREAM, 0);
  if (sock < 0) {
    perror("socket");
    exit(EXIT_FAILURE);
  }

  /* Give the socket a name. */
  name.sin_family = AF_INET;
  name.sin_port = htons(port);
  name.sin_addr.s_addr = htonl(INADDR_ANY);
  if (bind(sock, (struct sockaddr *)&name, sizeof(name)) < 0) {
    perror("bind");
    exit(EXIT_FAILURE);
  }

  return sock;
}

int main(void) {
  extern int make_socket(uint16_t port);
  int sock;
  fd_set active_fd_set, read_fd_set;
  int i;
  struct sockaddr_in clientname;
  size_t size;

  /* Create the socket and set it up to accept connections. */
  sock = make_socket(PORT);
  if (listen(sock, 1) < 0) {
    perror("listen");
    exit(EXIT_FAILURE);
  }

  /* Initialize the set of active sockets. */
  FD_ZERO(&active_fd_set);
  FD_SET(sock, &active_fd_set);

  while (1) {
    /* Block until input arrives on one or more active sockets. */
    read_fd_set = active_fd_set;
    if (select(FD_SETSIZE, &read_fd_set, NULL, NULL, NULL) < 0) {
      perror("select");
      exit(EXIT_FAILURE);
    }

    /* Service all the sockets with input pending. */
    for (i = 0; i < FD_SETSIZE; ++i)
      if (FD_ISSET(i, &read_fd_set)) {
        if (i == sock) {
          /* Connection request on original socket. */
          int new;
          size = sizeof(clientname);
          new = accept(sock, (struct sockaddr *)&clientname, &size);
          if (new < 0) {
            perror("accept");
            exit(EXIT_FAILURE);
          }
          fprintf(stderr, "Server: connect from host %s, port %hd.\n",
                  inet_ntoa(clientname.sin_addr), ntohs(clientname.sin_port));
          FD_SET(new, &active_fd_set);
        } else {
          /* Data arriving on an already-connected socket. */
          if (read_from_client(i) < 0) {
            close(i);
            FD_CLR(i, &active_fd_set);
          }
        }
      }
  }
}
