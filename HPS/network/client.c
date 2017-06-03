#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define PORT 5555
#define SERVERHOST "192.168.1.129"
#define NUM_ADDRS_GEN 512

void write_to_server(int filedes) {
  int count = 0;

  while (count < NUM_ADDRS_GEN) {
    uint32_t val = rand() & 0xff;
    val |= (rand() & 0xff) << 8;
    val |= (rand() & 0xff) << 16;
    val |= (rand() & 0xff) << 24;

    uint32_t snt = htonl(val);

    int nbytes = write(filedes, &snt, sizeof(snt));
    if (nbytes < 0) {
      perror("write");
      exit(EXIT_FAILURE);
    }

    count++;
  }
}

void init_sockaddr(struct sockaddr_in *name, const char *hostname,
                   uint16_t port) {
  struct hostent *hostinfo;

  name->sin_family = AF_INET;
  name->sin_port = htons(port);
  hostinfo = gethostbyname(hostname);
  if (hostinfo == NULL) {
    fprintf(stderr, "Unknown host %s.\n", hostname);
    exit(EXIT_FAILURE);
  }
  name->sin_addr = *(struct in_addr *)hostinfo->h_addr;
}

int main(void) {
  extern void init_sockaddr(struct sockaddr_in * name, const char *hostname,
                            uint16_t port);
  int sock;
  struct sockaddr_in servername;

  /* Create the socket. */
  sock = socket(PF_INET, SOCK_STREAM, 0);
  if (sock < 0) {
    perror("socket (client)");
    exit(EXIT_FAILURE);
  }

  /* Connect to the server. */
  init_sockaddr(&servername, SERVERHOST, PORT);
  if (0 > connect(sock, (struct sockaddr *)&servername, sizeof(servername))) {
    perror("connect (client)");
    exit(EXIT_FAILURE);
  }

  /* Send data to the server. */
  write_to_server(sock);
  close(sock);
  exit(EXIT_SUCCESS);
}
