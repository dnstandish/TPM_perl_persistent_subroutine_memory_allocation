#include <sys/time.h>
#include <sys/resource.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

extern char** environ;

int main (int argc, char** argv) {
  struct rlimit lim;

  if ( argc != 3 ) {
	fprintf( stderr, "usage: setrlimit limit prog\n");
	return 9;
  }
  unsigned long limit;

  limit = strtoul( argv[1], NULL, 0);
  lim.rlim_cur = limit;
  lim.rlim_max = limit;


  
  if ( //setrlimit( RLIMIT_DATA, &lim) < 0 ) { //||
	//	   setrlimit( RLIMIT_STACK, &lim) < 0 ||
		   setrlimit( RLIMIT_AS, &lim) < 0 ) {
	printf("setrlimit failed\n");
	return 1;
  }
  
  printf("setrlimit ok\n");
  fprintf( stderr, "execing %s\n", argv[2]);
  sleep(2);
  if ( execl( argv[2], argv[2], NULL ) < 1 ) {
	//  if ( execl( "/bin/sh", "/bin/sh", "-c", "ulimit -a", NULL ) < 1 ) {
	fprintf( stderr, "exec failed\n");
	return 2;
  }
  return 0;
}
