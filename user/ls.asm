
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	352000ef          	jal	35e <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	32a000ef          	jal	35e <strlen>
  38:	2501                	sext.w	a0,a0
  3a:	47b5                	li	a5,13
  3c:	00a7f863          	bgeu	a5,a0,4c <fmtname+0x4c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  40:	8526                	mv	a0,s1
  42:	70a2                	ld	ra,40(sp)
  44:	7402                	ld	s0,32(sp)
  46:	64e2                	ld	s1,24(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret
  4c:	e84a                	sd	s2,16(sp)
  4e:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  50:	8526                	mv	a0,s1
  52:	30c000ef          	jal	35e <strlen>
  56:	00001997          	auipc	s3,0x1
  5a:	fba98993          	addi	s3,s3,-70 # 1010 <buf.0>
  5e:	0005061b          	sext.w	a2,a0
  62:	85a6                	mv	a1,s1
  64:	854e                	mv	a0,s3
  66:	45a000ef          	jal	4c0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6a:	8526                	mv	a0,s1
  6c:	2f2000ef          	jal	35e <strlen>
  70:	0005091b          	sext.w	s2,a0
  74:	8526                	mv	a0,s1
  76:	2e8000ef          	jal	35e <strlen>
  7a:	1902                	slli	s2,s2,0x20
  7c:	02095913          	srli	s2,s2,0x20
  80:	4639                	li	a2,14
  82:	9e09                	subw	a2,a2,a0
  84:	02000593          	li	a1,32
  88:	01298533          	add	a0,s3,s2
  8c:	2fc000ef          	jal	388 <memset>
  return buf;
  90:	84ce                	mv	s1,s3
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	b76d                	j	40 <fmtname+0x40>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	d9010113          	addi	sp,sp,-624
  9c:	26113423          	sd	ra,616(sp)
  a0:	26813023          	sd	s0,608(sp)
  a4:	25213823          	sd	s2,592(sp)
  a8:	1c80                	addi	s0,sp,624
  aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  ac:	4581                	li	a1,0
  ae:	500000ef          	jal	5ae <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913c23          	sd	s1,600(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  bc:	d9840593          	addi	a1,s0,-616
  c0:	506000ef          	jal	5c6 <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c8:	da041783          	lh	a5,-608(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	da842703          	lw	a4,-600(s0)
  e8:	d9c42683          	lw	a3,-612(s0)
  ec:	da041603          	lh	a2,-608(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	a9050513          	addi	a0,a0,-1392 # b80 <malloc+0x12e>
  f8:	0a7000ef          	jal	99e <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	498000ef          	jal	596 <close>
 102:	25813483          	ld	s1,600(sp)
}
 106:	26813083          	ld	ra,616(sp)
 10a:	26013403          	ld	s0,608(sp)
 10e:	25013903          	ld	s2,592(sp)
 112:	27010113          	addi	sp,sp,624
 116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	a3658593          	addi	a1,a1,-1482 # b50 <malloc+0xfe>
 122:	4509                	li	a0,2
 124:	051000ef          	jal	974 <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	a3c58593          	addi	a1,a1,-1476 # b68 <malloc+0x116>
 134:	4509                	li	a0,2
 136:	03f000ef          	jal	974 <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	45a000ef          	jal	596 <close>
    return;
 140:	25813483          	ld	s1,600(sp)
 144:	b7c9                	j	106 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 146:	854a                	mv	a0,s2
 148:	216000ef          	jal	35e <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
      printf("ls: path too long\n");
 156:	00001517          	auipc	a0,0x1
 15a:	a3a50513          	addi	a0,a0,-1478 # b90 <malloc+0x13e>
 15e:	041000ef          	jal	99e <printf>
      break;
 162:	bf69                	j	fc <ls+0x64>
 164:	25313423          	sd	s3,584(sp)
 168:	25413023          	sd	s4,576(sp)
 16c:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 170:	85ca                	mv	a1,s2
 172:	dc040513          	addi	a0,s0,-576
 176:	1a0000ef          	jal	316 <strcpy>
    p = buf+strlen(buf);
 17a:	dc040513          	addi	a0,s0,-576
 17e:	1e0000ef          	jal	35e <strlen>
 182:	1502                	slli	a0,a0,0x20
 184:	9101                	srli	a0,a0,0x20
 186:	dc040793          	addi	a5,s0,-576
 18a:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 18e:	00190993          	addi	s3,s2,1
 192:	02f00793          	li	a5,47
 196:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 19a:	00001a17          	auipc	s4,0x1
 19e:	9e6a0a13          	addi	s4,s4,-1562 # b80 <malloc+0x12e>
        printf("ls: cannot stat %s\n", buf);
 1a2:	00001a97          	auipc	s5,0x1
 1a6:	9c6a8a93          	addi	s5,s5,-1594 # b68 <malloc+0x116>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1aa:	a031                	j	1b6 <ls+0x11e>
        printf("ls: cannot stat %s\n", buf);
 1ac:	dc040593          	addi	a1,s0,-576
 1b0:	8556                	mv	a0,s5
 1b2:	7ec000ef          	jal	99e <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b6:	4641                	li	a2,16
 1b8:	db040593          	addi	a1,s0,-592
 1bc:	8526                	mv	a0,s1
 1be:	3c8000ef          	jal	586 <read>
 1c2:	47c1                	li	a5,16
 1c4:	04f51463          	bne	a0,a5,20c <ls+0x174>
      if(de.inum == 0)
 1c8:	db045783          	lhu	a5,-592(s0)
 1cc:	d7ed                	beqz	a5,1b6 <ls+0x11e>
      memmove(p, de.name, DIRSIZ);
 1ce:	4639                	li	a2,14
 1d0:	db240593          	addi	a1,s0,-590
 1d4:	854e                	mv	a0,s3
 1d6:	2ea000ef          	jal	4c0 <memmove>
      p[DIRSIZ] = 0;
 1da:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1de:	d9840593          	addi	a1,s0,-616
 1e2:	dc040513          	addi	a0,s0,-576
 1e6:	258000ef          	jal	43e <stat>
 1ea:	fc0541e3          	bltz	a0,1ac <ls+0x114>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1ee:	dc040513          	addi	a0,s0,-576
 1f2:	e0fff0ef          	jal	0 <fmtname>
 1f6:	85aa                	mv	a1,a0
 1f8:	da842703          	lw	a4,-600(s0)
 1fc:	d9c42683          	lw	a3,-612(s0)
 200:	da041603          	lh	a2,-608(s0)
 204:	8552                	mv	a0,s4
 206:	798000ef          	jal	99e <printf>
 20a:	b775                	j	1b6 <ls+0x11e>
 20c:	24813983          	ld	s3,584(sp)
 210:	24013a03          	ld	s4,576(sp)
 214:	23813a83          	ld	s5,568(sp)
 218:	b5d5                	j	fc <ls+0x64>

000000000000021a <main>:

int
main(int argc, char *argv[])
{
 21a:	7139                	addi	sp,sp,-64
 21c:	fc06                	sd	ra,56(sp)
 21e:	f822                	sd	s0,48(sp)
 220:	f426                	sd	s1,40(sp)
 222:	f04a                	sd	s2,32(sp)
 224:	ec4e                	sd	s3,24(sp)
 226:	e456                	sd	s5,8(sp)
 228:	0080                	addi	s0,sp,64
 22a:	892a                	mv	s2,a0
 22c:	89ae                	mv	s3,a1
  int start = uptime();
 22e:	3d8000ef          	jal	606 <uptime>
 232:	84aa                	mv	s1,a0
  int context_start = get_context_switches();
 234:	3da000ef          	jal	60e <get_context_switches>
 238:	8aaa                	mv	s5,a0
  int tick_avg_start = get_total_ticks();
 23a:	3e4000ef          	jal	61e <get_total_ticks>
  int i;

  if(argc < 2){
 23e:	4785                	li	a5,1
 240:	0327d563          	bge	a5,s2,26a <main+0x50>
 244:	e852                	sd	s4,16(sp)
 246:	00898493          	addi	s1,s3,8
 24a:	3979                	addiw	s2,s2,-2
 24c:	02091793          	slli	a5,s2,0x20
 250:	01d7d913          	srli	s2,a5,0x1d
 254:	09c1                	addi	s3,s3,16
 256:	994e                	add	s2,s2,s3
    printf("Execution Time: %ld.%ld seconds\n", ((uint64)elapsed_time*(uint64)tick_avg)/10000000,(((uint64)elapsed_time*(uint64)tick_avg)%10000000)/(10000000/10));
    printf("Total Context Switches: %d \n", context_end - context_start);
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 258:	6088                	ld	a0,0(s1)
 25a:	e3fff0ef          	jal	98 <ls>
  for(i=1; i<argc; i++)
 25e:	04a1                	addi	s1,s1,8
 260:	ff249ce3          	bne	s1,s2,258 <main+0x3e>
  exit(0);
 264:	4501                	li	a0,0
 266:	308000ef          	jal	56e <exit>
 26a:	e852                	sd	s4,16(sp)
 26c:	8a2a                	mv	s4,a0
    ls(".");
 26e:	00001517          	auipc	a0,0x1
 272:	93a50513          	addi	a0,a0,-1734 # ba8 <malloc+0x156>
 276:	e23ff0ef          	jal	98 <ls>
    int end = uptime();
 27a:	38c000ef          	jal	606 <uptime>
    int elapsed_time = (end - start);
 27e:	409504bb          	subw	s1,a0,s1
 282:	0004891b          	sext.w	s2,s1
    int context_end = get_context_switches();
 286:	388000ef          	jal	60e <get_context_switches>
 28a:	89aa                	mv	s3,a0
    int tick_avg_end = get_total_ticks();
 28c:	392000ef          	jal	61e <get_total_ticks>
    int tick_avg = (tick_avg_end - tick_avg_start) / elapsed_time;
 290:	414505bb          	subw	a1,a0,s4
 294:	0295c4bb          	divw	s1,a1,s1
    printf("\nTick sum: %d \n", tick_avg_end - tick_avg_start);
 298:	2581                	sext.w	a1,a1
 29a:	00001517          	auipc	a0,0x1
 29e:	91650513          	addi	a0,a0,-1770 # bb0 <malloc+0x15e>
 2a2:	6fc000ef          	jal	99e <printf>
    printf("Tick AVG: %d \n", tick_avg);
 2a6:	85a6                	mv	a1,s1
 2a8:	00001517          	auipc	a0,0x1
 2ac:	91850513          	addi	a0,a0,-1768 # bc0 <malloc+0x16e>
 2b0:	6ee000ef          	jal	99e <printf>
    printf("\nTotal Ticks: %d ticks\n", elapsed_time);
 2b4:	85ca                	mv	a1,s2
 2b6:	00001517          	auipc	a0,0x1
 2ba:	91a50513          	addi	a0,a0,-1766 # bd0 <malloc+0x17e>
 2be:	6e0000ef          	jal	99e <printf>
    printf("Execution Time: %ld.%ld seconds\n", ((uint64)elapsed_time*(uint64)tick_avg)/10000000,(((uint64)elapsed_time*(uint64)tick_avg)%10000000)/(10000000/10));
 2c2:	02990933          	mul	s2,s2,s1
 2c6:	009895b7          	lui	a1,0x989
 2ca:	68058593          	addi	a1,a1,1664 # 989680 <base+0x988660>
 2ce:	02b97633          	remu	a2,s2,a1
 2d2:	000f47b7          	lui	a5,0xf4
 2d6:	24078793          	addi	a5,a5,576 # f4240 <base+0xf3220>
 2da:	02f65633          	divu	a2,a2,a5
 2de:	02b955b3          	divu	a1,s2,a1
 2e2:	00001517          	auipc	a0,0x1
 2e6:	90650513          	addi	a0,a0,-1786 # be8 <malloc+0x196>
 2ea:	6b4000ef          	jal	99e <printf>
    printf("Total Context Switches: %d \n", context_end - context_start);
 2ee:	415985bb          	subw	a1,s3,s5
 2f2:	00001517          	auipc	a0,0x1
 2f6:	91e50513          	addi	a0,a0,-1762 # c10 <malloc+0x1be>
 2fa:	6a4000ef          	jal	99e <printf>
    exit(0);
 2fe:	4501                	li	a0,0
 300:	26e000ef          	jal	56e <exit>

0000000000000304 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 30c:	f0fff0ef          	jal	21a <main>
  exit(0);
 310:	4501                	li	a0,0
 312:	25c000ef          	jal	56e <exit>

0000000000000316 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 316:	1141                	addi	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 31c:	87aa                	mv	a5,a0
 31e:	0585                	addi	a1,a1,1
 320:	0785                	addi	a5,a5,1
 322:	fff5c703          	lbu	a4,-1(a1)
 326:	fee78fa3          	sb	a4,-1(a5)
 32a:	fb75                	bnez	a4,31e <strcpy+0x8>
    ;
  return os;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret

0000000000000332 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 338:	00054783          	lbu	a5,0(a0)
 33c:	cb91                	beqz	a5,350 <strcmp+0x1e>
 33e:	0005c703          	lbu	a4,0(a1)
 342:	00f71763          	bne	a4,a5,350 <strcmp+0x1e>
    p++, q++;
 346:	0505                	addi	a0,a0,1
 348:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 34a:	00054783          	lbu	a5,0(a0)
 34e:	fbe5                	bnez	a5,33e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 350:	0005c503          	lbu	a0,0(a1)
}
 354:	40a7853b          	subw	a0,a5,a0
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret

000000000000035e <strlen>:

uint
strlen(const char *s)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e422                	sd	s0,8(sp)
 362:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 364:	00054783          	lbu	a5,0(a0)
 368:	cf91                	beqz	a5,384 <strlen+0x26>
 36a:	0505                	addi	a0,a0,1
 36c:	87aa                	mv	a5,a0
 36e:	86be                	mv	a3,a5
 370:	0785                	addi	a5,a5,1
 372:	fff7c703          	lbu	a4,-1(a5)
 376:	ff65                	bnez	a4,36e <strlen+0x10>
 378:	40a6853b          	subw	a0,a3,a0
 37c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 37e:	6422                	ld	s0,8(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret
  for(n = 0; s[n]; n++)
 384:	4501                	li	a0,0
 386:	bfe5                	j	37e <strlen+0x20>

0000000000000388 <memset>:

void*
memset(void *dst, int c, uint n)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 38e:	ca19                	beqz	a2,3a4 <memset+0x1c>
 390:	87aa                	mv	a5,a0
 392:	1602                	slli	a2,a2,0x20
 394:	9201                	srli	a2,a2,0x20
 396:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 39a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 39e:	0785                	addi	a5,a5,1
 3a0:	fee79de3          	bne	a5,a4,39a <memset+0x12>
  }
  return dst;
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret

00000000000003aa <strchr>:

char*
strchr(const char *s, char c)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e422                	sd	s0,8(sp)
 3ae:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3b0:	00054783          	lbu	a5,0(a0)
 3b4:	cb99                	beqz	a5,3ca <strchr+0x20>
    if(*s == c)
 3b6:	00f58763          	beq	a1,a5,3c4 <strchr+0x1a>
  for(; *s; s++)
 3ba:	0505                	addi	a0,a0,1
 3bc:	00054783          	lbu	a5,0(a0)
 3c0:	fbfd                	bnez	a5,3b6 <strchr+0xc>
      return (char*)s;
  return 0;
 3c2:	4501                	li	a0,0
}
 3c4:	6422                	ld	s0,8(sp)
 3c6:	0141                	addi	sp,sp,16
 3c8:	8082                	ret
  return 0;
 3ca:	4501                	li	a0,0
 3cc:	bfe5                	j	3c4 <strchr+0x1a>

00000000000003ce <gets>:

char*
gets(char *buf, int max)
{
 3ce:	711d                	addi	sp,sp,-96
 3d0:	ec86                	sd	ra,88(sp)
 3d2:	e8a2                	sd	s0,80(sp)
 3d4:	e4a6                	sd	s1,72(sp)
 3d6:	e0ca                	sd	s2,64(sp)
 3d8:	fc4e                	sd	s3,56(sp)
 3da:	f852                	sd	s4,48(sp)
 3dc:	f456                	sd	s5,40(sp)
 3de:	f05a                	sd	s6,32(sp)
 3e0:	ec5e                	sd	s7,24(sp)
 3e2:	1080                	addi	s0,sp,96
 3e4:	8baa                	mv	s7,a0
 3e6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e8:	892a                	mv	s2,a0
 3ea:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3ec:	4aa9                	li	s5,10
 3ee:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3f0:	89a6                	mv	s3,s1
 3f2:	2485                	addiw	s1,s1,1
 3f4:	0344d663          	bge	s1,s4,420 <gets+0x52>
    cc = read(0, &c, 1);
 3f8:	4605                	li	a2,1
 3fa:	faf40593          	addi	a1,s0,-81
 3fe:	4501                	li	a0,0
 400:	186000ef          	jal	586 <read>
    if(cc < 1)
 404:	00a05e63          	blez	a0,420 <gets+0x52>
    buf[i++] = c;
 408:	faf44783          	lbu	a5,-81(s0)
 40c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 410:	01578763          	beq	a5,s5,41e <gets+0x50>
 414:	0905                	addi	s2,s2,1
 416:	fd679de3          	bne	a5,s6,3f0 <gets+0x22>
    buf[i++] = c;
 41a:	89a6                	mv	s3,s1
 41c:	a011                	j	420 <gets+0x52>
 41e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 420:	99de                	add	s3,s3,s7
 422:	00098023          	sb	zero,0(s3)
  return buf;
}
 426:	855e                	mv	a0,s7
 428:	60e6                	ld	ra,88(sp)
 42a:	6446                	ld	s0,80(sp)
 42c:	64a6                	ld	s1,72(sp)
 42e:	6906                	ld	s2,64(sp)
 430:	79e2                	ld	s3,56(sp)
 432:	7a42                	ld	s4,48(sp)
 434:	7aa2                	ld	s5,40(sp)
 436:	7b02                	ld	s6,32(sp)
 438:	6be2                	ld	s7,24(sp)
 43a:	6125                	addi	sp,sp,96
 43c:	8082                	ret

000000000000043e <stat>:

int
stat(const char *n, struct stat *st)
{
 43e:	1101                	addi	sp,sp,-32
 440:	ec06                	sd	ra,24(sp)
 442:	e822                	sd	s0,16(sp)
 444:	e04a                	sd	s2,0(sp)
 446:	1000                	addi	s0,sp,32
 448:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 44a:	4581                	li	a1,0
 44c:	162000ef          	jal	5ae <open>
  if(fd < 0)
 450:	02054263          	bltz	a0,474 <stat+0x36>
 454:	e426                	sd	s1,8(sp)
 456:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 458:	85ca                	mv	a1,s2
 45a:	16c000ef          	jal	5c6 <fstat>
 45e:	892a                	mv	s2,a0
  close(fd);
 460:	8526                	mv	a0,s1
 462:	134000ef          	jal	596 <close>
  return r;
 466:	64a2                	ld	s1,8(sp)
}
 468:	854a                	mv	a0,s2
 46a:	60e2                	ld	ra,24(sp)
 46c:	6442                	ld	s0,16(sp)
 46e:	6902                	ld	s2,0(sp)
 470:	6105                	addi	sp,sp,32
 472:	8082                	ret
    return -1;
 474:	597d                	li	s2,-1
 476:	bfcd                	j	468 <stat+0x2a>

0000000000000478 <atoi>:

int
atoi(const char *s)
{
 478:	1141                	addi	sp,sp,-16
 47a:	e422                	sd	s0,8(sp)
 47c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 47e:	00054683          	lbu	a3,0(a0)
 482:	fd06879b          	addiw	a5,a3,-48
 486:	0ff7f793          	zext.b	a5,a5
 48a:	4625                	li	a2,9
 48c:	02f66863          	bltu	a2,a5,4bc <atoi+0x44>
 490:	872a                	mv	a4,a0
  n = 0;
 492:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 494:	0705                	addi	a4,a4,1
 496:	0025179b          	slliw	a5,a0,0x2
 49a:	9fa9                	addw	a5,a5,a0
 49c:	0017979b          	slliw	a5,a5,0x1
 4a0:	9fb5                	addw	a5,a5,a3
 4a2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4a6:	00074683          	lbu	a3,0(a4)
 4aa:	fd06879b          	addiw	a5,a3,-48
 4ae:	0ff7f793          	zext.b	a5,a5
 4b2:	fef671e3          	bgeu	a2,a5,494 <atoi+0x1c>
  return n;
}
 4b6:	6422                	ld	s0,8(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret
  n = 0;
 4bc:	4501                	li	a0,0
 4be:	bfe5                	j	4b6 <atoi+0x3e>

00000000000004c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c0:	1141                	addi	sp,sp,-16
 4c2:	e422                	sd	s0,8(sp)
 4c4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4c6:	02b57463          	bgeu	a0,a1,4ee <memmove+0x2e>
    while(n-- > 0)
 4ca:	00c05f63          	blez	a2,4e8 <memmove+0x28>
 4ce:	1602                	slli	a2,a2,0x20
 4d0:	9201                	srli	a2,a2,0x20
 4d2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4d6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4d8:	0585                	addi	a1,a1,1
 4da:	0705                	addi	a4,a4,1
 4dc:	fff5c683          	lbu	a3,-1(a1)
 4e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4e4:	fef71ae3          	bne	a4,a5,4d8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4e8:	6422                	ld	s0,8(sp)
 4ea:	0141                	addi	sp,sp,16
 4ec:	8082                	ret
    dst += n;
 4ee:	00c50733          	add	a4,a0,a2
    src += n;
 4f2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4f4:	fec05ae3          	blez	a2,4e8 <memmove+0x28>
 4f8:	fff6079b          	addiw	a5,a2,-1
 4fc:	1782                	slli	a5,a5,0x20
 4fe:	9381                	srli	a5,a5,0x20
 500:	fff7c793          	not	a5,a5
 504:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 506:	15fd                	addi	a1,a1,-1
 508:	177d                	addi	a4,a4,-1
 50a:	0005c683          	lbu	a3,0(a1)
 50e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 512:	fee79ae3          	bne	a5,a4,506 <memmove+0x46>
 516:	bfc9                	j	4e8 <memmove+0x28>

0000000000000518 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 518:	1141                	addi	sp,sp,-16
 51a:	e422                	sd	s0,8(sp)
 51c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 51e:	ca05                	beqz	a2,54e <memcmp+0x36>
 520:	fff6069b          	addiw	a3,a2,-1
 524:	1682                	slli	a3,a3,0x20
 526:	9281                	srli	a3,a3,0x20
 528:	0685                	addi	a3,a3,1
 52a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 52c:	00054783          	lbu	a5,0(a0)
 530:	0005c703          	lbu	a4,0(a1)
 534:	00e79863          	bne	a5,a4,544 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 538:	0505                	addi	a0,a0,1
    p2++;
 53a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 53c:	fed518e3          	bne	a0,a3,52c <memcmp+0x14>
  }
  return 0;
 540:	4501                	li	a0,0
 542:	a019                	j	548 <memcmp+0x30>
      return *p1 - *p2;
 544:	40e7853b          	subw	a0,a5,a4
}
 548:	6422                	ld	s0,8(sp)
 54a:	0141                	addi	sp,sp,16
 54c:	8082                	ret
  return 0;
 54e:	4501                	li	a0,0
 550:	bfe5                	j	548 <memcmp+0x30>

0000000000000552 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 552:	1141                	addi	sp,sp,-16
 554:	e406                	sd	ra,8(sp)
 556:	e022                	sd	s0,0(sp)
 558:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 55a:	f67ff0ef          	jal	4c0 <memmove>
}
 55e:	60a2                	ld	ra,8(sp)
 560:	6402                	ld	s0,0(sp)
 562:	0141                	addi	sp,sp,16
 564:	8082                	ret

0000000000000566 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 566:	4885                	li	a7,1
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <exit>:
.global exit
exit:
 li a7, SYS_exit
 56e:	4889                	li	a7,2
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <wait>:
.global wait
wait:
 li a7, SYS_wait
 576:	488d                	li	a7,3
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57e:	4891                	li	a7,4
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <read>:
.global read
read:
 li a7, SYS_read
 586:	4895                	li	a7,5
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <write>:
.global write
write:
 li a7, SYS_write
 58e:	48c1                	li	a7,16
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <close>:
.global close
close:
 li a7, SYS_close
 596:	48d5                	li	a7,21
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <kill>:
.global kill
kill:
 li a7, SYS_kill
 59e:	4899                	li	a7,6
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a6:	489d                	li	a7,7
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <open>:
.global open
open:
 li a7, SYS_open
 5ae:	48bd                	li	a7,15
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b6:	48c5                	li	a7,17
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5be:	48c9                	li	a7,18
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c6:	48a1                	li	a7,8
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <link>:
.global link
link:
 li a7, SYS_link
 5ce:	48cd                	li	a7,19
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d6:	48d1                	li	a7,20
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5de:	48a5                	li	a7,9
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e6:	48a9                	li	a7,10
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ee:	48ad                	li	a7,11
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f6:	48b1                	li	a7,12
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5fe:	48b5                	li	a7,13
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 606:	48b9                	li	a7,14
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <get_context_switches>:
.global get_context_switches
get_context_switches:
 li a7, SYS_get_context_switches
 60e:	48d9                	li	a7,22
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <get_tick_rate>:
.global get_tick_rate
 get_tick_rate:
 li a7, SYS_get_tick_rate
 616:	48dd                	li	a7,23
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <get_total_ticks>:
 .global get_total_ticks
 get_total_ticks:
 li a7, SYS_get_total_ticks
 61e:	48e1                	li	a7,24
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 626:	1101                	addi	sp,sp,-32
 628:	ec06                	sd	ra,24(sp)
 62a:	e822                	sd	s0,16(sp)
 62c:	1000                	addi	s0,sp,32
 62e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 632:	4605                	li	a2,1
 634:	fef40593          	addi	a1,s0,-17
 638:	f57ff0ef          	jal	58e <write>
}
 63c:	60e2                	ld	ra,24(sp)
 63e:	6442                	ld	s0,16(sp)
 640:	6105                	addi	sp,sp,32
 642:	8082                	ret

0000000000000644 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 644:	7139                	addi	sp,sp,-64
 646:	fc06                	sd	ra,56(sp)
 648:	f822                	sd	s0,48(sp)
 64a:	f426                	sd	s1,40(sp)
 64c:	0080                	addi	s0,sp,64
 64e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 650:	c299                	beqz	a3,656 <printint+0x12>
 652:	0805c963          	bltz	a1,6e4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 656:	2581                	sext.w	a1,a1
  neg = 0;
 658:	4881                	li	a7,0
 65a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 65e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 660:	2601                	sext.w	a2,a2
 662:	00000517          	auipc	a0,0x0
 666:	5d650513          	addi	a0,a0,1494 # c38 <digits>
 66a:	883a                	mv	a6,a4
 66c:	2705                	addiw	a4,a4,1
 66e:	02c5f7bb          	remuw	a5,a1,a2
 672:	1782                	slli	a5,a5,0x20
 674:	9381                	srli	a5,a5,0x20
 676:	97aa                	add	a5,a5,a0
 678:	0007c783          	lbu	a5,0(a5)
 67c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 680:	0005879b          	sext.w	a5,a1
 684:	02c5d5bb          	divuw	a1,a1,a2
 688:	0685                	addi	a3,a3,1
 68a:	fec7f0e3          	bgeu	a5,a2,66a <printint+0x26>
  if(neg)
 68e:	00088c63          	beqz	a7,6a6 <printint+0x62>
    buf[i++] = '-';
 692:	fd070793          	addi	a5,a4,-48
 696:	00878733          	add	a4,a5,s0
 69a:	02d00793          	li	a5,45
 69e:	fef70823          	sb	a5,-16(a4)
 6a2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6a6:	02e05a63          	blez	a4,6da <printint+0x96>
 6aa:	f04a                	sd	s2,32(sp)
 6ac:	ec4e                	sd	s3,24(sp)
 6ae:	fc040793          	addi	a5,s0,-64
 6b2:	00e78933          	add	s2,a5,a4
 6b6:	fff78993          	addi	s3,a5,-1
 6ba:	99ba                	add	s3,s3,a4
 6bc:	377d                	addiw	a4,a4,-1
 6be:	1702                	slli	a4,a4,0x20
 6c0:	9301                	srli	a4,a4,0x20
 6c2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6c6:	fff94583          	lbu	a1,-1(s2)
 6ca:	8526                	mv	a0,s1
 6cc:	f5bff0ef          	jal	626 <putc>
  while(--i >= 0)
 6d0:	197d                	addi	s2,s2,-1
 6d2:	ff391ae3          	bne	s2,s3,6c6 <printint+0x82>
 6d6:	7902                	ld	s2,32(sp)
 6d8:	69e2                	ld	s3,24(sp)
}
 6da:	70e2                	ld	ra,56(sp)
 6dc:	7442                	ld	s0,48(sp)
 6de:	74a2                	ld	s1,40(sp)
 6e0:	6121                	addi	sp,sp,64
 6e2:	8082                	ret
    x = -xx;
 6e4:	40b005bb          	negw	a1,a1
    neg = 1;
 6e8:	4885                	li	a7,1
    x = -xx;
 6ea:	bf85                	j	65a <printint+0x16>

00000000000006ec <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ec:	711d                	addi	sp,sp,-96
 6ee:	ec86                	sd	ra,88(sp)
 6f0:	e8a2                	sd	s0,80(sp)
 6f2:	e0ca                	sd	s2,64(sp)
 6f4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f6:	0005c903          	lbu	s2,0(a1)
 6fa:	26090863          	beqz	s2,96a <vprintf+0x27e>
 6fe:	e4a6                	sd	s1,72(sp)
 700:	fc4e                	sd	s3,56(sp)
 702:	f852                	sd	s4,48(sp)
 704:	f456                	sd	s5,40(sp)
 706:	f05a                	sd	s6,32(sp)
 708:	ec5e                	sd	s7,24(sp)
 70a:	e862                	sd	s8,16(sp)
 70c:	e466                	sd	s9,8(sp)
 70e:	8b2a                	mv	s6,a0
 710:	8a2e                	mv	s4,a1
 712:	8bb2                	mv	s7,a2
  state = 0;
 714:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 716:	4481                	li	s1,0
 718:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 71a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 71e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 722:	06c00c93          	li	s9,108
 726:	a005                	j	746 <vprintf+0x5a>
        putc(fd, c0);
 728:	85ca                	mv	a1,s2
 72a:	855a                	mv	a0,s6
 72c:	efbff0ef          	jal	626 <putc>
 730:	a019                	j	736 <vprintf+0x4a>
    } else if(state == '%'){
 732:	03598263          	beq	s3,s5,756 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 736:	2485                	addiw	s1,s1,1
 738:	8726                	mv	a4,s1
 73a:	009a07b3          	add	a5,s4,s1
 73e:	0007c903          	lbu	s2,0(a5)
 742:	20090c63          	beqz	s2,95a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 746:	0009079b          	sext.w	a5,s2
    if(state == 0){
 74a:	fe0994e3          	bnez	s3,732 <vprintf+0x46>
      if(c0 == '%'){
 74e:	fd579de3          	bne	a5,s5,728 <vprintf+0x3c>
        state = '%';
 752:	89be                	mv	s3,a5
 754:	b7cd                	j	736 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 756:	00ea06b3          	add	a3,s4,a4
 75a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 75e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 760:	c681                	beqz	a3,768 <vprintf+0x7c>
 762:	9752                	add	a4,a4,s4
 764:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 768:	03878f63          	beq	a5,s8,7a6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 76c:	05978963          	beq	a5,s9,7be <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 770:	07500713          	li	a4,117
 774:	0ee78363          	beq	a5,a4,85a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 778:	07800713          	li	a4,120
 77c:	12e78563          	beq	a5,a4,8a6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 780:	07000713          	li	a4,112
 784:	14e78a63          	beq	a5,a4,8d8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 788:	07300713          	li	a4,115
 78c:	18e78a63          	beq	a5,a4,920 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 790:	02500713          	li	a4,37
 794:	04e79563          	bne	a5,a4,7de <vprintf+0xf2>
        putc(fd, '%');
 798:	02500593          	li	a1,37
 79c:	855a                	mv	a0,s6
 79e:	e89ff0ef          	jal	626 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	bf49                	j	736 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 7a6:	008b8913          	addi	s2,s7,8
 7aa:	4685                	li	a3,1
 7ac:	4629                	li	a2,10
 7ae:	000ba583          	lw	a1,0(s7)
 7b2:	855a                	mv	a0,s6
 7b4:	e91ff0ef          	jal	644 <printint>
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	bfad                	j	736 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 7be:	06400793          	li	a5,100
 7c2:	02f68963          	beq	a3,a5,7f4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7c6:	06c00793          	li	a5,108
 7ca:	04f68263          	beq	a3,a5,80e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 7ce:	07500793          	li	a5,117
 7d2:	0af68063          	beq	a3,a5,872 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 7d6:	07800793          	li	a5,120
 7da:	0ef68263          	beq	a3,a5,8be <vprintf+0x1d2>
        putc(fd, '%');
 7de:	02500593          	li	a1,37
 7e2:	855a                	mv	a0,s6
 7e4:	e43ff0ef          	jal	626 <putc>
        putc(fd, c0);
 7e8:	85ca                	mv	a1,s2
 7ea:	855a                	mv	a0,s6
 7ec:	e3bff0ef          	jal	626 <putc>
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	b791                	j	736 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f4:	008b8913          	addi	s2,s7,8
 7f8:	4685                	li	a3,1
 7fa:	4629                	li	a2,10
 7fc:	000ba583          	lw	a1,0(s7)
 800:	855a                	mv	a0,s6
 802:	e43ff0ef          	jal	644 <printint>
        i += 1;
 806:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 808:	8bca                	mv	s7,s2
      state = 0;
 80a:	4981                	li	s3,0
        i += 1;
 80c:	b72d                	j	736 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 80e:	06400793          	li	a5,100
 812:	02f60763          	beq	a2,a5,840 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 816:	07500793          	li	a5,117
 81a:	06f60963          	beq	a2,a5,88c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 81e:	07800793          	li	a5,120
 822:	faf61ee3          	bne	a2,a5,7de <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 826:	008b8913          	addi	s2,s7,8
 82a:	4681                	li	a3,0
 82c:	4641                	li	a2,16
 82e:	000ba583          	lw	a1,0(s7)
 832:	855a                	mv	a0,s6
 834:	e11ff0ef          	jal	644 <printint>
        i += 2;
 838:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 83a:	8bca                	mv	s7,s2
      state = 0;
 83c:	4981                	li	s3,0
        i += 2;
 83e:	bde5                	j	736 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 840:	008b8913          	addi	s2,s7,8
 844:	4685                	li	a3,1
 846:	4629                	li	a2,10
 848:	000ba583          	lw	a1,0(s7)
 84c:	855a                	mv	a0,s6
 84e:	df7ff0ef          	jal	644 <printint>
        i += 2;
 852:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 854:	8bca                	mv	s7,s2
      state = 0;
 856:	4981                	li	s3,0
        i += 2;
 858:	bdf9                	j	736 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 85a:	008b8913          	addi	s2,s7,8
 85e:	4681                	li	a3,0
 860:	4629                	li	a2,10
 862:	000ba583          	lw	a1,0(s7)
 866:	855a                	mv	a0,s6
 868:	dddff0ef          	jal	644 <printint>
 86c:	8bca                	mv	s7,s2
      state = 0;
 86e:	4981                	li	s3,0
 870:	b5d9                	j	736 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 872:	008b8913          	addi	s2,s7,8
 876:	4681                	li	a3,0
 878:	4629                	li	a2,10
 87a:	000ba583          	lw	a1,0(s7)
 87e:	855a                	mv	a0,s6
 880:	dc5ff0ef          	jal	644 <printint>
        i += 1;
 884:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 886:	8bca                	mv	s7,s2
      state = 0;
 888:	4981                	li	s3,0
        i += 1;
 88a:	b575                	j	736 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 88c:	008b8913          	addi	s2,s7,8
 890:	4681                	li	a3,0
 892:	4629                	li	a2,10
 894:	000ba583          	lw	a1,0(s7)
 898:	855a                	mv	a0,s6
 89a:	dabff0ef          	jal	644 <printint>
        i += 2;
 89e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a0:	8bca                	mv	s7,s2
      state = 0;
 8a2:	4981                	li	s3,0
        i += 2;
 8a4:	bd49                	j	736 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 8a6:	008b8913          	addi	s2,s7,8
 8aa:	4681                	li	a3,0
 8ac:	4641                	li	a2,16
 8ae:	000ba583          	lw	a1,0(s7)
 8b2:	855a                	mv	a0,s6
 8b4:	d91ff0ef          	jal	644 <printint>
 8b8:	8bca                	mv	s7,s2
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	bdad                	j	736 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8be:	008b8913          	addi	s2,s7,8
 8c2:	4681                	li	a3,0
 8c4:	4641                	li	a2,16
 8c6:	000ba583          	lw	a1,0(s7)
 8ca:	855a                	mv	a0,s6
 8cc:	d79ff0ef          	jal	644 <printint>
        i += 1;
 8d0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8d2:	8bca                	mv	s7,s2
      state = 0;
 8d4:	4981                	li	s3,0
        i += 1;
 8d6:	b585                	j	736 <vprintf+0x4a>
 8d8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8da:	008b8d13          	addi	s10,s7,8
 8de:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8e2:	03000593          	li	a1,48
 8e6:	855a                	mv	a0,s6
 8e8:	d3fff0ef          	jal	626 <putc>
  putc(fd, 'x');
 8ec:	07800593          	li	a1,120
 8f0:	855a                	mv	a0,s6
 8f2:	d35ff0ef          	jal	626 <putc>
 8f6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8f8:	00000b97          	auipc	s7,0x0
 8fc:	340b8b93          	addi	s7,s7,832 # c38 <digits>
 900:	03c9d793          	srli	a5,s3,0x3c
 904:	97de                	add	a5,a5,s7
 906:	0007c583          	lbu	a1,0(a5)
 90a:	855a                	mv	a0,s6
 90c:	d1bff0ef          	jal	626 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 910:	0992                	slli	s3,s3,0x4
 912:	397d                	addiw	s2,s2,-1
 914:	fe0916e3          	bnez	s2,900 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 918:	8bea                	mv	s7,s10
      state = 0;
 91a:	4981                	li	s3,0
 91c:	6d02                	ld	s10,0(sp)
 91e:	bd21                	j	736 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 920:	008b8993          	addi	s3,s7,8
 924:	000bb903          	ld	s2,0(s7)
 928:	00090f63          	beqz	s2,946 <vprintf+0x25a>
        for(; *s; s++)
 92c:	00094583          	lbu	a1,0(s2)
 930:	c195                	beqz	a1,954 <vprintf+0x268>
          putc(fd, *s);
 932:	855a                	mv	a0,s6
 934:	cf3ff0ef          	jal	626 <putc>
        for(; *s; s++)
 938:	0905                	addi	s2,s2,1
 93a:	00094583          	lbu	a1,0(s2)
 93e:	f9f5                	bnez	a1,932 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 940:	8bce                	mv	s7,s3
      state = 0;
 942:	4981                	li	s3,0
 944:	bbcd                	j	736 <vprintf+0x4a>
          s = "(null)";
 946:	00000917          	auipc	s2,0x0
 94a:	2ea90913          	addi	s2,s2,746 # c30 <malloc+0x1de>
        for(; *s; s++)
 94e:	02800593          	li	a1,40
 952:	b7c5                	j	932 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 954:	8bce                	mv	s7,s3
      state = 0;
 956:	4981                	li	s3,0
 958:	bbf9                	j	736 <vprintf+0x4a>
 95a:	64a6                	ld	s1,72(sp)
 95c:	79e2                	ld	s3,56(sp)
 95e:	7a42                	ld	s4,48(sp)
 960:	7aa2                	ld	s5,40(sp)
 962:	7b02                	ld	s6,32(sp)
 964:	6be2                	ld	s7,24(sp)
 966:	6c42                	ld	s8,16(sp)
 968:	6ca2                	ld	s9,8(sp)
    }
  }
}
 96a:	60e6                	ld	ra,88(sp)
 96c:	6446                	ld	s0,80(sp)
 96e:	6906                	ld	s2,64(sp)
 970:	6125                	addi	sp,sp,96
 972:	8082                	ret

0000000000000974 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 974:	715d                	addi	sp,sp,-80
 976:	ec06                	sd	ra,24(sp)
 978:	e822                	sd	s0,16(sp)
 97a:	1000                	addi	s0,sp,32
 97c:	e010                	sd	a2,0(s0)
 97e:	e414                	sd	a3,8(s0)
 980:	e818                	sd	a4,16(s0)
 982:	ec1c                	sd	a5,24(s0)
 984:	03043023          	sd	a6,32(s0)
 988:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 98c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 990:	8622                	mv	a2,s0
 992:	d5bff0ef          	jal	6ec <vprintf>
}
 996:	60e2                	ld	ra,24(sp)
 998:	6442                	ld	s0,16(sp)
 99a:	6161                	addi	sp,sp,80
 99c:	8082                	ret

000000000000099e <printf>:

void
printf(const char *fmt, ...)
{
 99e:	711d                	addi	sp,sp,-96
 9a0:	ec06                	sd	ra,24(sp)
 9a2:	e822                	sd	s0,16(sp)
 9a4:	1000                	addi	s0,sp,32
 9a6:	e40c                	sd	a1,8(s0)
 9a8:	e810                	sd	a2,16(s0)
 9aa:	ec14                	sd	a3,24(s0)
 9ac:	f018                	sd	a4,32(s0)
 9ae:	f41c                	sd	a5,40(s0)
 9b0:	03043823          	sd	a6,48(s0)
 9b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9b8:	00840613          	addi	a2,s0,8
 9bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9c0:	85aa                	mv	a1,a0
 9c2:	4505                	li	a0,1
 9c4:	d29ff0ef          	jal	6ec <vprintf>
}
 9c8:	60e2                	ld	ra,24(sp)
 9ca:	6442                	ld	s0,16(sp)
 9cc:	6125                	addi	sp,sp,96
 9ce:	8082                	ret

00000000000009d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9d0:	1141                	addi	sp,sp,-16
 9d2:	e422                	sd	s0,8(sp)
 9d4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9d6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9da:	00000797          	auipc	a5,0x0
 9de:	6267b783          	ld	a5,1574(a5) # 1000 <freep>
 9e2:	a02d                	j	a0c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9e4:	4618                	lw	a4,8(a2)
 9e6:	9f2d                	addw	a4,a4,a1
 9e8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ec:	6398                	ld	a4,0(a5)
 9ee:	6310                	ld	a2,0(a4)
 9f0:	a83d                	j	a2e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9f2:	ff852703          	lw	a4,-8(a0)
 9f6:	9f31                	addw	a4,a4,a2
 9f8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9fa:	ff053683          	ld	a3,-16(a0)
 9fe:	a091                	j	a42 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a00:	6398                	ld	a4,0(a5)
 a02:	00e7e463          	bltu	a5,a4,a0a <free+0x3a>
 a06:	00e6ea63          	bltu	a3,a4,a1a <free+0x4a>
{
 a0a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a0c:	fed7fae3          	bgeu	a5,a3,a00 <free+0x30>
 a10:	6398                	ld	a4,0(a5)
 a12:	00e6e463          	bltu	a3,a4,a1a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a16:	fee7eae3          	bltu	a5,a4,a0a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a1a:	ff852583          	lw	a1,-8(a0)
 a1e:	6390                	ld	a2,0(a5)
 a20:	02059813          	slli	a6,a1,0x20
 a24:	01c85713          	srli	a4,a6,0x1c
 a28:	9736                	add	a4,a4,a3
 a2a:	fae60de3          	beq	a2,a4,9e4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a2e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a32:	4790                	lw	a2,8(a5)
 a34:	02061593          	slli	a1,a2,0x20
 a38:	01c5d713          	srli	a4,a1,0x1c
 a3c:	973e                	add	a4,a4,a5
 a3e:	fae68ae3          	beq	a3,a4,9f2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a42:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a44:	00000717          	auipc	a4,0x0
 a48:	5af73e23          	sd	a5,1468(a4) # 1000 <freep>
}
 a4c:	6422                	ld	s0,8(sp)
 a4e:	0141                	addi	sp,sp,16
 a50:	8082                	ret

0000000000000a52 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a52:	7139                	addi	sp,sp,-64
 a54:	fc06                	sd	ra,56(sp)
 a56:	f822                	sd	s0,48(sp)
 a58:	f426                	sd	s1,40(sp)
 a5a:	ec4e                	sd	s3,24(sp)
 a5c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a5e:	02051493          	slli	s1,a0,0x20
 a62:	9081                	srli	s1,s1,0x20
 a64:	04bd                	addi	s1,s1,15
 a66:	8091                	srli	s1,s1,0x4
 a68:	0014899b          	addiw	s3,s1,1
 a6c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a6e:	00000517          	auipc	a0,0x0
 a72:	59253503          	ld	a0,1426(a0) # 1000 <freep>
 a76:	c915                	beqz	a0,aaa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a78:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a7a:	4798                	lw	a4,8(a5)
 a7c:	08977a63          	bgeu	a4,s1,b10 <malloc+0xbe>
 a80:	f04a                	sd	s2,32(sp)
 a82:	e852                	sd	s4,16(sp)
 a84:	e456                	sd	s5,8(sp)
 a86:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a88:	8a4e                	mv	s4,s3
 a8a:	0009871b          	sext.w	a4,s3
 a8e:	6685                	lui	a3,0x1
 a90:	00d77363          	bgeu	a4,a3,a96 <malloc+0x44>
 a94:	6a05                	lui	s4,0x1
 a96:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a9a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a9e:	00000917          	auipc	s2,0x0
 aa2:	56290913          	addi	s2,s2,1378 # 1000 <freep>
  if(p == (char*)-1)
 aa6:	5afd                	li	s5,-1
 aa8:	a081                	j	ae8 <malloc+0x96>
 aaa:	f04a                	sd	s2,32(sp)
 aac:	e852                	sd	s4,16(sp)
 aae:	e456                	sd	s5,8(sp)
 ab0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 ab2:	00000797          	auipc	a5,0x0
 ab6:	56e78793          	addi	a5,a5,1390 # 1020 <base>
 aba:	00000717          	auipc	a4,0x0
 abe:	54f73323          	sd	a5,1350(a4) # 1000 <freep>
 ac2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ac4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ac8:	b7c1                	j	a88 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 aca:	6398                	ld	a4,0(a5)
 acc:	e118                	sd	a4,0(a0)
 ace:	a8a9                	j	b28 <malloc+0xd6>
  hp->s.size = nu;
 ad0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ad4:	0541                	addi	a0,a0,16
 ad6:	efbff0ef          	jal	9d0 <free>
  return freep;
 ada:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ade:	c12d                	beqz	a0,b40 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ae2:	4798                	lw	a4,8(a5)
 ae4:	02977263          	bgeu	a4,s1,b08 <malloc+0xb6>
    if(p == freep)
 ae8:	00093703          	ld	a4,0(s2)
 aec:	853e                	mv	a0,a5
 aee:	fef719e3          	bne	a4,a5,ae0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 af2:	8552                	mv	a0,s4
 af4:	b03ff0ef          	jal	5f6 <sbrk>
  if(p == (char*)-1)
 af8:	fd551ce3          	bne	a0,s5,ad0 <malloc+0x7e>
        return 0;
 afc:	4501                	li	a0,0
 afe:	7902                	ld	s2,32(sp)
 b00:	6a42                	ld	s4,16(sp)
 b02:	6aa2                	ld	s5,8(sp)
 b04:	6b02                	ld	s6,0(sp)
 b06:	a03d                	j	b34 <malloc+0xe2>
 b08:	7902                	ld	s2,32(sp)
 b0a:	6a42                	ld	s4,16(sp)
 b0c:	6aa2                	ld	s5,8(sp)
 b0e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b10:	fae48de3          	beq	s1,a4,aca <malloc+0x78>
        p->s.size -= nunits;
 b14:	4137073b          	subw	a4,a4,s3
 b18:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b1a:	02071693          	slli	a3,a4,0x20
 b1e:	01c6d713          	srli	a4,a3,0x1c
 b22:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b24:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b28:	00000717          	auipc	a4,0x0
 b2c:	4ca73c23          	sd	a0,1240(a4) # 1000 <freep>
      return (void*)(p + 1);
 b30:	01078513          	addi	a0,a5,16
  }
}
 b34:	70e2                	ld	ra,56(sp)
 b36:	7442                	ld	s0,48(sp)
 b38:	74a2                	ld	s1,40(sp)
 b3a:	69e2                	ld	s3,24(sp)
 b3c:	6121                	addi	sp,sp,64
 b3e:	8082                	ret
 b40:	7902                	ld	s2,32(sp)
 b42:	6a42                	ld	s4,16(sp)
 b44:	6aa2                	ld	s5,8(sp)
 b46:	6b02                	ld	s6,0(sp)
 b48:	b7f5                	j	b34 <malloc+0xe2>
