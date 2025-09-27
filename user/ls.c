#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

void
ls(char *path)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf("ls: cannot stat %s\n", buf);
        continue;
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
}

int
main(int argc, char *argv[])
{
  int start = uptime();
  int context_start = get_context_switches();
  int tick_avg_start = get_total_ticks();
  int i;

  if(argc < 2){
    ls(".");
    int end = uptime();
    int elapsed_time = (end - start);
    int context_end = get_context_switches();
    int tick_avg_end = get_total_ticks();
    int tick_avg = (tick_avg_end - tick_avg_start) / elapsed_time;
    printf("\nTick sum: %d \n", tick_avg_end - tick_avg_start);
    printf("Tick AVG: %d \n", tick_avg);
    printf("\nTotal Ticks: %d ticks\n", elapsed_time);
    printf("Execution Time: %ld.%ld seconds\n", ((uint64)elapsed_time*(uint64)tick_avg)/10000000,(((uint64)elapsed_time*(uint64)tick_avg)%10000000)/(10000000/10));
    printf("Total Context Switches: %d \n", context_end - context_start);
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  exit(0);
}