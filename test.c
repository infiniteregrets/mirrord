#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

__attribute__((constructor))
static void customConstructor(int argc, const char **argv)
{
  const char* name = getprogname();
  const char* wanted_name = "___67go_build_main_go";
  printf("hello from %s\n", name);
  if (strcmp(wanted_name, name) == 0) {
   dlopen("/Users/aviramhassan/Code/mirrord/target/debug/libmirrord_layer.dylib", RTLD_NOW);
    printf("will load I swear\n");
  }
}
