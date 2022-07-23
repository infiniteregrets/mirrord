#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <sys/syscall.h>      /* Definition of SYS_* constants */
#include <unistd.h>

int main() {
    int s;
    struct addrinfo hints, *res;
    getaddrinfo("www.example.com", "http", &hints, &res);
    s = syscall(SYS_socket, res->ai_family, res->ai_socktype, res->ai_protocol);

}
