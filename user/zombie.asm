
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	278000ef          	jal	280 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	276000ef          	jal	288 <exit>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	300000ef          	jal	318 <sleep>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	25c000ef          	jal	288 <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	addi	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	86be                	mv	a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	ff65                	bnez	a4,88 <strlen+0x10>
  92:	40a6853b          	subw	a0,a3,a0
  96:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1c>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x12>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	addi	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addiw	s1,s1,1
 10e:	0344d663          	bge	s1,s4,13a <gets+0x52>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	addi	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	186000ef          	jal	2a0 <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x52>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x50>
 12e:	0905                	addi	s2,s2,1
 130:	fd679de3          	bne	a5,s6,10a <gets+0x22>
    buf[i++] = c;
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x52>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	162000ef          	jal	2c8 <open>
  if(fd < 0)
 16a:	02054263          	bltz	a0,18e <stat+0x36>
 16e:	e426                	sd	s1,8(sp)
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	16c000ef          	jal	2e0 <fstat>
 178:	892a                	mv	s2,a0
  close(fd);
 17a:	8526                	mv	a0,s1
 17c:	134000ef          	jal	2b0 <close>
  return r;
 180:	64a2                	ld	s1,8(sp)
}
 182:	854a                	mv	a0,s2
 184:	60e2                	ld	ra,24(sp)
 186:	6442                	ld	s0,16(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	addi	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfcd                	j	182 <stat+0x2a>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054683          	lbu	a3,0(a0)
 19c:	fd06879b          	addiw	a5,a3,-48
 1a0:	0ff7f793          	zext.b	a5,a5
 1a4:	4625                	li	a2,9
 1a6:	02f66863          	bltu	a2,a5,1d6 <atoi+0x44>
 1aa:	872a                	mv	a4,a0
  n = 0;
 1ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ae:	0705                	addi	a4,a4,1
 1b0:	0025179b          	slliw	a5,a0,0x2
 1b4:	9fa9                	addw	a5,a5,a0
 1b6:	0017979b          	slliw	a5,a5,0x1
 1ba:	9fb5                	addw	a5,a5,a3
 1bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c0:	00074683          	lbu	a3,0(a4)
 1c4:	fd06879b          	addiw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	fef671e3          	bgeu	a2,a5,1ae <atoi+0x1c>
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  n = 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <atoi+0x3e>

00000000000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e0:	02b57463          	bgeu	a0,a1,208 <memmove+0x2e>
    while(n-- > 0)
 1e4:	00c05f63          	blez	a2,202 <memmove+0x28>
 1e8:	1602                	slli	a2,a2,0x20
 1ea:	9201                	srli	a2,a2,0x20
 1ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f2:	0585                	addi	a1,a1,1
 1f4:	0705                	addi	a4,a4,1
 1f6:	fff5c683          	lbu	a3,-1(a1)
 1fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fe:	fef71ae3          	bne	a4,a5,1f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
    dst += n;
 208:	00c50733          	add	a4,a0,a2
    src += n;
 20c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20e:	fec05ae3          	blez	a2,202 <memmove+0x28>
 212:	fff6079b          	addiw	a5,a2,-1
 216:	1782                	slli	a5,a5,0x20
 218:	9381                	srli	a5,a5,0x20
 21a:	fff7c793          	not	a5,a5
 21e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 220:	15fd                	addi	a1,a1,-1
 222:	177d                	addi	a4,a4,-1
 224:	0005c683          	lbu	a3,0(a1)
 228:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x46>
 230:	bfc9                	j	202 <memmove+0x28>

0000000000000232 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 238:	ca05                	beqz	a2,268 <memcmp+0x36>
 23a:	fff6069b          	addiw	a3,a2,-1
 23e:	1682                	slli	a3,a3,0x20
 240:	9281                	srli	a3,a3,0x20
 242:	0685                	addi	a3,a3,1
 244:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 246:	00054783          	lbu	a5,0(a0)
 24a:	0005c703          	lbu	a4,0(a1)
 24e:	00e79863          	bne	a5,a4,25e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 252:	0505                	addi	a0,a0,1
    p2++;
 254:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 256:	fed518e3          	bne	a0,a3,246 <memcmp+0x14>
  }
  return 0;
 25a:	4501                	li	a0,0
 25c:	a019                	j	262 <memcmp+0x30>
      return *p1 - *p2;
 25e:	40e7853b          	subw	a0,a5,a4
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <memcmp+0x30>

000000000000026c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 274:	f67ff0ef          	jal	1da <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 280:	4885                	li	a7,1
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <exit>:
.global exit
exit:
 li a7, SYS_exit
 288:	4889                	li	a7,2
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <wait>:
.global wait
wait:
 li a7, SYS_wait
 290:	488d                	li	a7,3
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 298:	4891                	li	a7,4
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <read>:
.global read
read:
 li a7, SYS_read
 2a0:	4895                	li	a7,5
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <write>:
.global write
write:
 li a7, SYS_write
 2a8:	48c1                	li	a7,16
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <close>:
.global close
close:
 li a7, SYS_close
 2b0:	48d5                	li	a7,21
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b8:	4899                	li	a7,6
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c0:	489d                	li	a7,7
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <open>:
.global open
open:
 li a7, SYS_open
 2c8:	48bd                	li	a7,15
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d0:	48c5                	li	a7,17
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d8:	48c9                	li	a7,18
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e0:	48a1                	li	a7,8
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <link>:
.global link
link:
 li a7, SYS_link
 2e8:	48cd                	li	a7,19
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f0:	48d1                	li	a7,20
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f8:	48a5                	li	a7,9
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <dup>:
.global dup
dup:
 li a7, SYS_dup
 300:	48a9                	li	a7,10
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 308:	48ad                	li	a7,11
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 310:	48b1                	li	a7,12
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 318:	48b5                	li	a7,13
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 320:	48b9                	li	a7,14
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <get_context_switches>:
.global get_context_switches
get_context_switches:
 li a7, SYS_get_context_switches
 328:	48d9                	li	a7,22
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <get_tick_rate>:
.global get_tick_rate
 get_tick_rate:
 li a7, SYS_get_tick_rate
 330:	48dd                	li	a7,23
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <get_total_ticks>:
 .global get_total_ticks
 get_total_ticks:
 li a7, SYS_get_total_ticks
 338:	48e1                	li	a7,24
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 340:	1101                	addi	sp,sp,-32
 342:	ec06                	sd	ra,24(sp)
 344:	e822                	sd	s0,16(sp)
 346:	1000                	addi	s0,sp,32
 348:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 34c:	4605                	li	a2,1
 34e:	fef40593          	addi	a1,s0,-17
 352:	f57ff0ef          	jal	2a8 <write>
}
 356:	60e2                	ld	ra,24(sp)
 358:	6442                	ld	s0,16(sp)
 35a:	6105                	addi	sp,sp,32
 35c:	8082                	ret

000000000000035e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35e:	7139                	addi	sp,sp,-64
 360:	fc06                	sd	ra,56(sp)
 362:	f822                	sd	s0,48(sp)
 364:	f426                	sd	s1,40(sp)
 366:	0080                	addi	s0,sp,64
 368:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36a:	c299                	beqz	a3,370 <printint+0x12>
 36c:	0805c963          	bltz	a1,3fe <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 370:	2581                	sext.w	a1,a1
  neg = 0;
 372:	4881                	li	a7,0
 374:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 378:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 37a:	2601                	sext.w	a2,a2
 37c:	00000517          	auipc	a0,0x0
 380:	4fc50513          	addi	a0,a0,1276 # 878 <digits>
 384:	883a                	mv	a6,a4
 386:	2705                	addiw	a4,a4,1
 388:	02c5f7bb          	remuw	a5,a1,a2
 38c:	1782                	slli	a5,a5,0x20
 38e:	9381                	srli	a5,a5,0x20
 390:	97aa                	add	a5,a5,a0
 392:	0007c783          	lbu	a5,0(a5)
 396:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 39a:	0005879b          	sext.w	a5,a1
 39e:	02c5d5bb          	divuw	a1,a1,a2
 3a2:	0685                	addi	a3,a3,1
 3a4:	fec7f0e3          	bgeu	a5,a2,384 <printint+0x26>
  if(neg)
 3a8:	00088c63          	beqz	a7,3c0 <printint+0x62>
    buf[i++] = '-';
 3ac:	fd070793          	addi	a5,a4,-48
 3b0:	00878733          	add	a4,a5,s0
 3b4:	02d00793          	li	a5,45
 3b8:	fef70823          	sb	a5,-16(a4)
 3bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3c0:	02e05a63          	blez	a4,3f4 <printint+0x96>
 3c4:	f04a                	sd	s2,32(sp)
 3c6:	ec4e                	sd	s3,24(sp)
 3c8:	fc040793          	addi	a5,s0,-64
 3cc:	00e78933          	add	s2,a5,a4
 3d0:	fff78993          	addi	s3,a5,-1
 3d4:	99ba                	add	s3,s3,a4
 3d6:	377d                	addiw	a4,a4,-1
 3d8:	1702                	slli	a4,a4,0x20
 3da:	9301                	srli	a4,a4,0x20
 3dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3e0:	fff94583          	lbu	a1,-1(s2)
 3e4:	8526                	mv	a0,s1
 3e6:	f5bff0ef          	jal	340 <putc>
  while(--i >= 0)
 3ea:	197d                	addi	s2,s2,-1
 3ec:	ff391ae3          	bne	s2,s3,3e0 <printint+0x82>
 3f0:	7902                	ld	s2,32(sp)
 3f2:	69e2                	ld	s3,24(sp)
}
 3f4:	70e2                	ld	ra,56(sp)
 3f6:	7442                	ld	s0,48(sp)
 3f8:	74a2                	ld	s1,40(sp)
 3fa:	6121                	addi	sp,sp,64
 3fc:	8082                	ret
    x = -xx;
 3fe:	40b005bb          	negw	a1,a1
    neg = 1;
 402:	4885                	li	a7,1
    x = -xx;
 404:	bf85                	j	374 <printint+0x16>

0000000000000406 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 406:	711d                	addi	sp,sp,-96
 408:	ec86                	sd	ra,88(sp)
 40a:	e8a2                	sd	s0,80(sp)
 40c:	e0ca                	sd	s2,64(sp)
 40e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 410:	0005c903          	lbu	s2,0(a1)
 414:	26090863          	beqz	s2,684 <vprintf+0x27e>
 418:	e4a6                	sd	s1,72(sp)
 41a:	fc4e                	sd	s3,56(sp)
 41c:	f852                	sd	s4,48(sp)
 41e:	f456                	sd	s5,40(sp)
 420:	f05a                	sd	s6,32(sp)
 422:	ec5e                	sd	s7,24(sp)
 424:	e862                	sd	s8,16(sp)
 426:	e466                	sd	s9,8(sp)
 428:	8b2a                	mv	s6,a0
 42a:	8a2e                	mv	s4,a1
 42c:	8bb2                	mv	s7,a2
  state = 0;
 42e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 430:	4481                	li	s1,0
 432:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 434:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 438:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 43c:	06c00c93          	li	s9,108
 440:	a005                	j	460 <vprintf+0x5a>
        putc(fd, c0);
 442:	85ca                	mv	a1,s2
 444:	855a                	mv	a0,s6
 446:	efbff0ef          	jal	340 <putc>
 44a:	a019                	j	450 <vprintf+0x4a>
    } else if(state == '%'){
 44c:	03598263          	beq	s3,s5,470 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 450:	2485                	addiw	s1,s1,1
 452:	8726                	mv	a4,s1
 454:	009a07b3          	add	a5,s4,s1
 458:	0007c903          	lbu	s2,0(a5)
 45c:	20090c63          	beqz	s2,674 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 460:	0009079b          	sext.w	a5,s2
    if(state == 0){
 464:	fe0994e3          	bnez	s3,44c <vprintf+0x46>
      if(c0 == '%'){
 468:	fd579de3          	bne	a5,s5,442 <vprintf+0x3c>
        state = '%';
 46c:	89be                	mv	s3,a5
 46e:	b7cd                	j	450 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 470:	00ea06b3          	add	a3,s4,a4
 474:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 478:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 47a:	c681                	beqz	a3,482 <vprintf+0x7c>
 47c:	9752                	add	a4,a4,s4
 47e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 482:	03878f63          	beq	a5,s8,4c0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 486:	05978963          	beq	a5,s9,4d8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 48a:	07500713          	li	a4,117
 48e:	0ee78363          	beq	a5,a4,574 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 492:	07800713          	li	a4,120
 496:	12e78563          	beq	a5,a4,5c0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 49a:	07000713          	li	a4,112
 49e:	14e78a63          	beq	a5,a4,5f2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4a2:	07300713          	li	a4,115
 4a6:	18e78a63          	beq	a5,a4,63a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4aa:	02500713          	li	a4,37
 4ae:	04e79563          	bne	a5,a4,4f8 <vprintf+0xf2>
        putc(fd, '%');
 4b2:	02500593          	li	a1,37
 4b6:	855a                	mv	a0,s6
 4b8:	e89ff0ef          	jal	340 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4bc:	4981                	li	s3,0
 4be:	bf49                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4c0:	008b8913          	addi	s2,s7,8
 4c4:	4685                	li	a3,1
 4c6:	4629                	li	a2,10
 4c8:	000ba583          	lw	a1,0(s7)
 4cc:	855a                	mv	a0,s6
 4ce:	e91ff0ef          	jal	35e <printint>
 4d2:	8bca                	mv	s7,s2
      state = 0;
 4d4:	4981                	li	s3,0
 4d6:	bfad                	j	450 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4d8:	06400793          	li	a5,100
 4dc:	02f68963          	beq	a3,a5,50e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4e0:	06c00793          	li	a5,108
 4e4:	04f68263          	beq	a3,a5,528 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4e8:	07500793          	li	a5,117
 4ec:	0af68063          	beq	a3,a5,58c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4f0:	07800793          	li	a5,120
 4f4:	0ef68263          	beq	a3,a5,5d8 <vprintf+0x1d2>
        putc(fd, '%');
 4f8:	02500593          	li	a1,37
 4fc:	855a                	mv	a0,s6
 4fe:	e43ff0ef          	jal	340 <putc>
        putc(fd, c0);
 502:	85ca                	mv	a1,s2
 504:	855a                	mv	a0,s6
 506:	e3bff0ef          	jal	340 <putc>
      state = 0;
 50a:	4981                	li	s3,0
 50c:	b791                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 50e:	008b8913          	addi	s2,s7,8
 512:	4685                	li	a3,1
 514:	4629                	li	a2,10
 516:	000ba583          	lw	a1,0(s7)
 51a:	855a                	mv	a0,s6
 51c:	e43ff0ef          	jal	35e <printint>
        i += 1;
 520:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 522:	8bca                	mv	s7,s2
      state = 0;
 524:	4981                	li	s3,0
        i += 1;
 526:	b72d                	j	450 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 528:	06400793          	li	a5,100
 52c:	02f60763          	beq	a2,a5,55a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 530:	07500793          	li	a5,117
 534:	06f60963          	beq	a2,a5,5a6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 538:	07800793          	li	a5,120
 53c:	faf61ee3          	bne	a2,a5,4f8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 540:	008b8913          	addi	s2,s7,8
 544:	4681                	li	a3,0
 546:	4641                	li	a2,16
 548:	000ba583          	lw	a1,0(s7)
 54c:	855a                	mv	a0,s6
 54e:	e11ff0ef          	jal	35e <printint>
        i += 2;
 552:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 554:	8bca                	mv	s7,s2
      state = 0;
 556:	4981                	li	s3,0
        i += 2;
 558:	bde5                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55a:	008b8913          	addi	s2,s7,8
 55e:	4685                	li	a3,1
 560:	4629                	li	a2,10
 562:	000ba583          	lw	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	df7ff0ef          	jal	35e <printint>
        i += 2;
 56c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	8bca                	mv	s7,s2
      state = 0;
 570:	4981                	li	s3,0
        i += 2;
 572:	bdf9                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 574:	008b8913          	addi	s2,s7,8
 578:	4681                	li	a3,0
 57a:	4629                	li	a2,10
 57c:	000ba583          	lw	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	dddff0ef          	jal	35e <printint>
 586:	8bca                	mv	s7,s2
      state = 0;
 588:	4981                	li	s3,0
 58a:	b5d9                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	008b8913          	addi	s2,s7,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	dc5ff0ef          	jal	35e <printint>
        i += 1;
 59e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
        i += 1;
 5a4:	b575                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a6:	008b8913          	addi	s2,s7,8
 5aa:	4681                	li	a3,0
 5ac:	4629                	li	a2,10
 5ae:	000ba583          	lw	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	dabff0ef          	jal	35e <printint>
        i += 2;
 5b8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ba:	8bca                	mv	s7,s2
      state = 0;
 5bc:	4981                	li	s3,0
        i += 2;
 5be:	bd49                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5c0:	008b8913          	addi	s2,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4641                	li	a2,16
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	d91ff0ef          	jal	35e <printint>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bdad                	j	450 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	d79ff0ef          	jal	35e <printint>
        i += 1;
 5ea:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ec:	8bca                	mv	s7,s2
      state = 0;
 5ee:	4981                	li	s3,0
        i += 1;
 5f0:	b585                	j	450 <vprintf+0x4a>
 5f2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5f4:	008b8d13          	addi	s10,s7,8
 5f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fc:	03000593          	li	a1,48
 600:	855a                	mv	a0,s6
 602:	d3fff0ef          	jal	340 <putc>
  putc(fd, 'x');
 606:	07800593          	li	a1,120
 60a:	855a                	mv	a0,s6
 60c:	d35ff0ef          	jal	340 <putc>
 610:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 612:	00000b97          	auipc	s7,0x0
 616:	266b8b93          	addi	s7,s7,614 # 878 <digits>
 61a:	03c9d793          	srli	a5,s3,0x3c
 61e:	97de                	add	a5,a5,s7
 620:	0007c583          	lbu	a1,0(a5)
 624:	855a                	mv	a0,s6
 626:	d1bff0ef          	jal	340 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 62a:	0992                	slli	s3,s3,0x4
 62c:	397d                	addiw	s2,s2,-1
 62e:	fe0916e3          	bnez	s2,61a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 632:	8bea                	mv	s7,s10
      state = 0;
 634:	4981                	li	s3,0
 636:	6d02                	ld	s10,0(sp)
 638:	bd21                	j	450 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 63a:	008b8993          	addi	s3,s7,8
 63e:	000bb903          	ld	s2,0(s7)
 642:	00090f63          	beqz	s2,660 <vprintf+0x25a>
        for(; *s; s++)
 646:	00094583          	lbu	a1,0(s2)
 64a:	c195                	beqz	a1,66e <vprintf+0x268>
          putc(fd, *s);
 64c:	855a                	mv	a0,s6
 64e:	cf3ff0ef          	jal	340 <putc>
        for(; *s; s++)
 652:	0905                	addi	s2,s2,1
 654:	00094583          	lbu	a1,0(s2)
 658:	f9f5                	bnez	a1,64c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 65a:	8bce                	mv	s7,s3
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bbcd                	j	450 <vprintf+0x4a>
          s = "(null)";
 660:	00000917          	auipc	s2,0x0
 664:	21090913          	addi	s2,s2,528 # 870 <malloc+0x104>
        for(; *s; s++)
 668:	02800593          	li	a1,40
 66c:	b7c5                	j	64c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 66e:	8bce                	mv	s7,s3
      state = 0;
 670:	4981                	li	s3,0
 672:	bbf9                	j	450 <vprintf+0x4a>
 674:	64a6                	ld	s1,72(sp)
 676:	79e2                	ld	s3,56(sp)
 678:	7a42                	ld	s4,48(sp)
 67a:	7aa2                	ld	s5,40(sp)
 67c:	7b02                	ld	s6,32(sp)
 67e:	6be2                	ld	s7,24(sp)
 680:	6c42                	ld	s8,16(sp)
 682:	6ca2                	ld	s9,8(sp)
    }
  }
}
 684:	60e6                	ld	ra,88(sp)
 686:	6446                	ld	s0,80(sp)
 688:	6906                	ld	s2,64(sp)
 68a:	6125                	addi	sp,sp,96
 68c:	8082                	ret

000000000000068e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68e:	715d                	addi	sp,sp,-80
 690:	ec06                	sd	ra,24(sp)
 692:	e822                	sd	s0,16(sp)
 694:	1000                	addi	s0,sp,32
 696:	e010                	sd	a2,0(s0)
 698:	e414                	sd	a3,8(s0)
 69a:	e818                	sd	a4,16(s0)
 69c:	ec1c                	sd	a5,24(s0)
 69e:	03043023          	sd	a6,32(s0)
 6a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6aa:	8622                	mv	a2,s0
 6ac:	d5bff0ef          	jal	406 <vprintf>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6161                	addi	sp,sp,80
 6b6:	8082                	ret

00000000000006b8 <printf>:

void
printf(const char *fmt, ...)
{
 6b8:	711d                	addi	sp,sp,-96
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e40c                	sd	a1,8(s0)
 6c2:	e810                	sd	a2,16(s0)
 6c4:	ec14                	sd	a3,24(s0)
 6c6:	f018                	sd	a4,32(s0)
 6c8:	f41c                	sd	a5,40(s0)
 6ca:	03043823          	sd	a6,48(s0)
 6ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d2:	00840613          	addi	a2,s0,8
 6d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6da:	85aa                	mv	a1,a0
 6dc:	4505                	li	a0,1
 6de:	d29ff0ef          	jal	406 <vprintf>
}
 6e2:	60e2                	ld	ra,24(sp)
 6e4:	6442                	ld	s0,16(sp)
 6e6:	6125                	addi	sp,sp,96
 6e8:	8082                	ret

00000000000006ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ea:	1141                	addi	sp,sp,-16
 6ec:	e422                	sd	s0,8(sp)
 6ee:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f4:	00001797          	auipc	a5,0x1
 6f8:	90c7b783          	ld	a5,-1780(a5) # 1000 <freep>
 6fc:	a02d                	j	726 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6fe:	4618                	lw	a4,8(a2)
 700:	9f2d                	addw	a4,a4,a1
 702:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 706:	6398                	ld	a4,0(a5)
 708:	6310                	ld	a2,0(a4)
 70a:	a83d                	j	748 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 70c:	ff852703          	lw	a4,-8(a0)
 710:	9f31                	addw	a4,a4,a2
 712:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 714:	ff053683          	ld	a3,-16(a0)
 718:	a091                	j	75c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71a:	6398                	ld	a4,0(a5)
 71c:	00e7e463          	bltu	a5,a4,724 <free+0x3a>
 720:	00e6ea63          	bltu	a3,a4,734 <free+0x4a>
{
 724:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 726:	fed7fae3          	bgeu	a5,a3,71a <free+0x30>
 72a:	6398                	ld	a4,0(a5)
 72c:	00e6e463          	bltu	a3,a4,734 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	fee7eae3          	bltu	a5,a4,724 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 734:	ff852583          	lw	a1,-8(a0)
 738:	6390                	ld	a2,0(a5)
 73a:	02059813          	slli	a6,a1,0x20
 73e:	01c85713          	srli	a4,a6,0x1c
 742:	9736                	add	a4,a4,a3
 744:	fae60de3          	beq	a2,a4,6fe <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 748:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 74c:	4790                	lw	a2,8(a5)
 74e:	02061593          	slli	a1,a2,0x20
 752:	01c5d713          	srli	a4,a1,0x1c
 756:	973e                	add	a4,a4,a5
 758:	fae68ae3          	beq	a3,a4,70c <free+0x22>
    p->s.ptr = bp->s.ptr;
 75c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 75e:	00001717          	auipc	a4,0x1
 762:	8af73123          	sd	a5,-1886(a4) # 1000 <freep>
}
 766:	6422                	ld	s0,8(sp)
 768:	0141                	addi	sp,sp,16
 76a:	8082                	ret

000000000000076c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 76c:	7139                	addi	sp,sp,-64
 76e:	fc06                	sd	ra,56(sp)
 770:	f822                	sd	s0,48(sp)
 772:	f426                	sd	s1,40(sp)
 774:	ec4e                	sd	s3,24(sp)
 776:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 778:	02051493          	slli	s1,a0,0x20
 77c:	9081                	srli	s1,s1,0x20
 77e:	04bd                	addi	s1,s1,15
 780:	8091                	srli	s1,s1,0x4
 782:	0014899b          	addiw	s3,s1,1
 786:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 788:	00001517          	auipc	a0,0x1
 78c:	87853503          	ld	a0,-1928(a0) # 1000 <freep>
 790:	c915                	beqz	a0,7c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 792:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 794:	4798                	lw	a4,8(a5)
 796:	08977a63          	bgeu	a4,s1,82a <malloc+0xbe>
 79a:	f04a                	sd	s2,32(sp)
 79c:	e852                	sd	s4,16(sp)
 79e:	e456                	sd	s5,8(sp)
 7a0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7a2:	8a4e                	mv	s4,s3
 7a4:	0009871b          	sext.w	a4,s3
 7a8:	6685                	lui	a3,0x1
 7aa:	00d77363          	bgeu	a4,a3,7b0 <malloc+0x44>
 7ae:	6a05                	lui	s4,0x1
 7b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b8:	00001917          	auipc	s2,0x1
 7bc:	84890913          	addi	s2,s2,-1976 # 1000 <freep>
  if(p == (char*)-1)
 7c0:	5afd                	li	s5,-1
 7c2:	a081                	j	802 <malloc+0x96>
 7c4:	f04a                	sd	s2,32(sp)
 7c6:	e852                	sd	s4,16(sp)
 7c8:	e456                	sd	s5,8(sp)
 7ca:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7cc:	00001797          	auipc	a5,0x1
 7d0:	84478793          	addi	a5,a5,-1980 # 1010 <base>
 7d4:	00001717          	auipc	a4,0x1
 7d8:	82f73623          	sd	a5,-2004(a4) # 1000 <freep>
 7dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e2:	b7c1                	j	7a2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7e4:	6398                	ld	a4,0(a5)
 7e6:	e118                	sd	a4,0(a0)
 7e8:	a8a9                	j	842 <malloc+0xd6>
  hp->s.size = nu;
 7ea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ee:	0541                	addi	a0,a0,16
 7f0:	efbff0ef          	jal	6ea <free>
  return freep;
 7f4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7f8:	c12d                	beqz	a0,85a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fc:	4798                	lw	a4,8(a5)
 7fe:	02977263          	bgeu	a4,s1,822 <malloc+0xb6>
    if(p == freep)
 802:	00093703          	ld	a4,0(s2)
 806:	853e                	mv	a0,a5
 808:	fef719e3          	bne	a4,a5,7fa <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 80c:	8552                	mv	a0,s4
 80e:	b03ff0ef          	jal	310 <sbrk>
  if(p == (char*)-1)
 812:	fd551ce3          	bne	a0,s5,7ea <malloc+0x7e>
        return 0;
 816:	4501                	li	a0,0
 818:	7902                	ld	s2,32(sp)
 81a:	6a42                	ld	s4,16(sp)
 81c:	6aa2                	ld	s5,8(sp)
 81e:	6b02                	ld	s6,0(sp)
 820:	a03d                	j	84e <malloc+0xe2>
 822:	7902                	ld	s2,32(sp)
 824:	6a42                	ld	s4,16(sp)
 826:	6aa2                	ld	s5,8(sp)
 828:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 82a:	fae48de3          	beq	s1,a4,7e4 <malloc+0x78>
        p->s.size -= nunits;
 82e:	4137073b          	subw	a4,a4,s3
 832:	c798                	sw	a4,8(a5)
        p += p->s.size;
 834:	02071693          	slli	a3,a4,0x20
 838:	01c6d713          	srli	a4,a3,0x1c
 83c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 83e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 842:	00000717          	auipc	a4,0x0
 846:	7aa73f23          	sd	a0,1982(a4) # 1000 <freep>
      return (void*)(p + 1);
 84a:	01078513          	addi	a0,a5,16
  }
}
 84e:	70e2                	ld	ra,56(sp)
 850:	7442                	ld	s0,48(sp)
 852:	74a2                	ld	s1,40(sp)
 854:	69e2                	ld	s3,24(sp)
 856:	6121                	addi	sp,sp,64
 858:	8082                	ret
 85a:	7902                	ld	s2,32(sp)
 85c:	6a42                	ld	s4,16(sp)
 85e:	6aa2                	ld	s5,8(sp)
 860:	6b02                	ld	s6,0(sp)
 862:	b7f5                	j	84e <malloc+0xe2>
