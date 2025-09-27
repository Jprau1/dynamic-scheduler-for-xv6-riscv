
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	89058593          	addi	a1,a1,-1904 # 8a0 <malloc+0x104>
  18:	4509                	li	a0,2
  1a:	6a4000ef          	jal	6be <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	298000ef          	jal	2b8 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	2ec000ef          	jal	318 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	282000ef          	jal	2b8 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	87a58593          	addi	a1,a1,-1926 # 8b8 <malloc+0x11c>
  46:	4509                	li	a0,2
  48:	676000ef          	jal	6be <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  extern int main();
  main();
  56:	fabff0ef          	jal	0 <main>
  exit(0);
  5a:	4501                	li	a0,0
  5c:	25c000ef          	jal	2b8 <exit>

0000000000000060 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0x8>
    ;
  return os;
}
  76:	6422                	ld	s0,8(sp)
  78:	0141                	addi	sp,sp,16
  7a:	8082                	ret

000000000000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	cb91                	beqz	a5,9a <strcmp+0x1e>
  88:	0005c703          	lbu	a4,0(a1)
  8c:	00f71763          	bne	a4,a5,9a <strcmp+0x1e>
    p++, q++;
  90:	0505                	addi	a0,a0,1
  92:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	fbe5                	bnez	a5,88 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9a:	0005c503          	lbu	a0,0(a1)
}
  9e:	40a7853b          	subw	a0,a5,a0
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cf91                	beqz	a5,ce <strlen+0x26>
  b4:	0505                	addi	a0,a0,1
  b6:	87aa                	mv	a5,a0
  b8:	86be                	mv	a3,a5
  ba:	0785                	addi	a5,a5,1
  bc:	fff7c703          	lbu	a4,-1(a5)
  c0:	ff65                	bnez	a4,b8 <strlen+0x10>
  c2:	40a6853b          	subw	a0,a3,a0
  c6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  c8:	6422                	ld	s0,8(sp)
  ca:	0141                	addi	sp,sp,16
  cc:	8082                	ret
  for(n = 0; s[n]; n++)
  ce:	4501                	li	a0,0
  d0:	bfe5                	j	c8 <strlen+0x20>

00000000000000d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d8:	ca19                	beqz	a2,ee <memset+0x1c>
  da:	87aa                	mv	a5,a0
  dc:	1602                	slli	a2,a2,0x20
  de:	9201                	srli	a2,a2,0x20
  e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e8:	0785                	addi	a5,a5,1
  ea:	fee79de3          	bne	a5,a4,e4 <memset+0x12>
  }
  return dst;
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <strchr>:

char*
strchr(const char *s, char c)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb99                	beqz	a5,114 <strchr+0x20>
    if(*s == c)
 100:	00f58763          	beq	a1,a5,10e <strchr+0x1a>
  for(; *s; s++)
 104:	0505                	addi	a0,a0,1
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbfd                	bnez	a5,100 <strchr+0xc>
      return (char*)s;
  return 0;
 10c:	4501                	li	a0,0
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
  return 0;
 114:	4501                	li	a0,0
 116:	bfe5                	j	10e <strchr+0x1a>

0000000000000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	711d                	addi	sp,sp,-96
 11a:	ec86                	sd	ra,88(sp)
 11c:	e8a2                	sd	s0,80(sp)
 11e:	e4a6                	sd	s1,72(sp)
 120:	e0ca                	sd	s2,64(sp)
 122:	fc4e                	sd	s3,56(sp)
 124:	f852                	sd	s4,48(sp)
 126:	f456                	sd	s5,40(sp)
 128:	f05a                	sd	s6,32(sp)
 12a:	ec5e                	sd	s7,24(sp)
 12c:	1080                	addi	s0,sp,96
 12e:	8baa                	mv	s7,a0
 130:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	892a                	mv	s2,a0
 134:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 136:	4aa9                	li	s5,10
 138:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13a:	89a6                	mv	s3,s1
 13c:	2485                	addiw	s1,s1,1
 13e:	0344d663          	bge	s1,s4,16a <gets+0x52>
    cc = read(0, &c, 1);
 142:	4605                	li	a2,1
 144:	faf40593          	addi	a1,s0,-81
 148:	4501                	li	a0,0
 14a:	186000ef          	jal	2d0 <read>
    if(cc < 1)
 14e:	00a05e63          	blez	a0,16a <gets+0x52>
    buf[i++] = c;
 152:	faf44783          	lbu	a5,-81(s0)
 156:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15a:	01578763          	beq	a5,s5,168 <gets+0x50>
 15e:	0905                	addi	s2,s2,1
 160:	fd679de3          	bne	a5,s6,13a <gets+0x22>
    buf[i++] = c;
 164:	89a6                	mv	s3,s1
 166:	a011                	j	16a <gets+0x52>
 168:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16a:	99de                	add	s3,s3,s7
 16c:	00098023          	sb	zero,0(s3)
  return buf;
}
 170:	855e                	mv	a0,s7
 172:	60e6                	ld	ra,88(sp)
 174:	6446                	ld	s0,80(sp)
 176:	64a6                	ld	s1,72(sp)
 178:	6906                	ld	s2,64(sp)
 17a:	79e2                	ld	s3,56(sp)
 17c:	7a42                	ld	s4,48(sp)
 17e:	7aa2                	ld	s5,40(sp)
 180:	7b02                	ld	s6,32(sp)
 182:	6be2                	ld	s7,24(sp)
 184:	6125                	addi	sp,sp,96
 186:	8082                	ret

0000000000000188 <stat>:

int
stat(const char *n, struct stat *st)
{
 188:	1101                	addi	sp,sp,-32
 18a:	ec06                	sd	ra,24(sp)
 18c:	e822                	sd	s0,16(sp)
 18e:	e04a                	sd	s2,0(sp)
 190:	1000                	addi	s0,sp,32
 192:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	4581                	li	a1,0
 196:	162000ef          	jal	2f8 <open>
  if(fd < 0)
 19a:	02054263          	bltz	a0,1be <stat+0x36>
 19e:	e426                	sd	s1,8(sp)
 1a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a2:	85ca                	mv	a1,s2
 1a4:	16c000ef          	jal	310 <fstat>
 1a8:	892a                	mv	s2,a0
  close(fd);
 1aa:	8526                	mv	a0,s1
 1ac:	134000ef          	jal	2e0 <close>
  return r;
 1b0:	64a2                	ld	s1,8(sp)
}
 1b2:	854a                	mv	a0,s2
 1b4:	60e2                	ld	ra,24(sp)
 1b6:	6442                	ld	s0,16(sp)
 1b8:	6902                	ld	s2,0(sp)
 1ba:	6105                	addi	sp,sp,32
 1bc:	8082                	ret
    return -1;
 1be:	597d                	li	s2,-1
 1c0:	bfcd                	j	1b2 <stat+0x2a>

00000000000001c2 <atoi>:

int
atoi(const char *s)
{
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c8:	00054683          	lbu	a3,0(a0)
 1cc:	fd06879b          	addiw	a5,a3,-48
 1d0:	0ff7f793          	zext.b	a5,a5
 1d4:	4625                	li	a2,9
 1d6:	02f66863          	bltu	a2,a5,206 <atoi+0x44>
 1da:	872a                	mv	a4,a0
  n = 0;
 1dc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1de:	0705                	addi	a4,a4,1
 1e0:	0025179b          	slliw	a5,a0,0x2
 1e4:	9fa9                	addw	a5,a5,a0
 1e6:	0017979b          	slliw	a5,a5,0x1
 1ea:	9fb5                	addw	a5,a5,a3
 1ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f0:	00074683          	lbu	a3,0(a4)
 1f4:	fd06879b          	addiw	a5,a3,-48
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	fef671e3          	bgeu	a2,a5,1de <atoi+0x1c>
  return n;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret
  n = 0;
 206:	4501                	li	a0,0
 208:	bfe5                	j	200 <atoi+0x3e>

000000000000020a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 210:	02b57463          	bgeu	a0,a1,238 <memmove+0x2e>
    while(n-- > 0)
 214:	00c05f63          	blez	a2,232 <memmove+0x28>
 218:	1602                	slli	a2,a2,0x20
 21a:	9201                	srli	a2,a2,0x20
 21c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 220:	872a                	mv	a4,a0
      *dst++ = *src++;
 222:	0585                	addi	a1,a1,1
 224:	0705                	addi	a4,a4,1
 226:	fff5c683          	lbu	a3,-1(a1)
 22a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22e:	fef71ae3          	bne	a4,a5,222 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23e:	fec05ae3          	blez	a2,232 <memmove+0x28>
 242:	fff6079b          	addiw	a5,a2,-1
 246:	1782                	slli	a5,a5,0x20
 248:	9381                	srli	a5,a5,0x20
 24a:	fff7c793          	not	a5,a5
 24e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 250:	15fd                	addi	a1,a1,-1
 252:	177d                	addi	a4,a4,-1
 254:	0005c683          	lbu	a3,0(a1)
 258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x46>
 260:	bfc9                	j	232 <memmove+0x28>

0000000000000262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 268:	ca05                	beqz	a2,298 <memcmp+0x36>
 26a:	fff6069b          	addiw	a3,a2,-1
 26e:	1682                	slli	a3,a3,0x20
 270:	9281                	srli	a3,a3,0x20
 272:	0685                	addi	a3,a3,1
 274:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 276:	00054783          	lbu	a5,0(a0)
 27a:	0005c703          	lbu	a4,0(a1)
 27e:	00e79863          	bne	a5,a4,28e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 282:	0505                	addi	a0,a0,1
    p2++;
 284:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 286:	fed518e3          	bne	a0,a3,276 <memcmp+0x14>
  }
  return 0;
 28a:	4501                	li	a0,0
 28c:	a019                	j	292 <memcmp+0x30>
      return *p1 - *p2;
 28e:	40e7853b          	subw	a0,a5,a4
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret
  return 0;
 298:	4501                	li	a0,0
 29a:	bfe5                	j	292 <memcmp+0x30>

000000000000029c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a4:	f67ff0ef          	jal	20a <memmove>
}
 2a8:	60a2                	ld	ra,8(sp)
 2aa:	6402                	ld	s0,0(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret

00000000000002b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b0:	4885                	li	a7,1
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b8:	4889                	li	a7,2
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c0:	488d                	li	a7,3
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c8:	4891                	li	a7,4
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <read>:
.global read
read:
 li a7, SYS_read
 2d0:	4895                	li	a7,5
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <write>:
.global write
write:
 li a7, SYS_write
 2d8:	48c1                	li	a7,16
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <close>:
.global close
close:
 li a7, SYS_close
 2e0:	48d5                	li	a7,21
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e8:	4899                	li	a7,6
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f0:	489d                	li	a7,7
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <open>:
.global open
open:
 li a7, SYS_open
 2f8:	48bd                	li	a7,15
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 300:	48c5                	li	a7,17
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 308:	48c9                	li	a7,18
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 310:	48a1                	li	a7,8
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <link>:
.global link
link:
 li a7, SYS_link
 318:	48cd                	li	a7,19
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 320:	48d1                	li	a7,20
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 328:	48a5                	li	a7,9
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <dup>:
.global dup
dup:
 li a7, SYS_dup
 330:	48a9                	li	a7,10
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 338:	48ad                	li	a7,11
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 340:	48b1                	li	a7,12
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 348:	48b5                	li	a7,13
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 350:	48b9                	li	a7,14
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <get_context_switches>:
.global get_context_switches
get_context_switches:
 li a7, SYS_get_context_switches
 358:	48d9                	li	a7,22
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <get_tick_rate>:
.global get_tick_rate
 get_tick_rate:
 li a7, SYS_get_tick_rate
 360:	48dd                	li	a7,23
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <get_total_ticks>:
 .global get_total_ticks
 get_total_ticks:
 li a7, SYS_get_total_ticks
 368:	48e1                	li	a7,24
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 370:	1101                	addi	sp,sp,-32
 372:	ec06                	sd	ra,24(sp)
 374:	e822                	sd	s0,16(sp)
 376:	1000                	addi	s0,sp,32
 378:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 37c:	4605                	li	a2,1
 37e:	fef40593          	addi	a1,s0,-17
 382:	f57ff0ef          	jal	2d8 <write>
}
 386:	60e2                	ld	ra,24(sp)
 388:	6442                	ld	s0,16(sp)
 38a:	6105                	addi	sp,sp,32
 38c:	8082                	ret

000000000000038e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38e:	7139                	addi	sp,sp,-64
 390:	fc06                	sd	ra,56(sp)
 392:	f822                	sd	s0,48(sp)
 394:	f426                	sd	s1,40(sp)
 396:	0080                	addi	s0,sp,64
 398:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39a:	c299                	beqz	a3,3a0 <printint+0x12>
 39c:	0805c963          	bltz	a1,42e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a0:	2581                	sext.w	a1,a1
  neg = 0;
 3a2:	4881                	li	a7,0
 3a4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3aa:	2601                	sext.w	a2,a2
 3ac:	00000517          	auipc	a0,0x0
 3b0:	52c50513          	addi	a0,a0,1324 # 8d8 <digits>
 3b4:	883a                	mv	a6,a4
 3b6:	2705                	addiw	a4,a4,1
 3b8:	02c5f7bb          	remuw	a5,a1,a2
 3bc:	1782                	slli	a5,a5,0x20
 3be:	9381                	srli	a5,a5,0x20
 3c0:	97aa                	add	a5,a5,a0
 3c2:	0007c783          	lbu	a5,0(a5)
 3c6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ca:	0005879b          	sext.w	a5,a1
 3ce:	02c5d5bb          	divuw	a1,a1,a2
 3d2:	0685                	addi	a3,a3,1
 3d4:	fec7f0e3          	bgeu	a5,a2,3b4 <printint+0x26>
  if(neg)
 3d8:	00088c63          	beqz	a7,3f0 <printint+0x62>
    buf[i++] = '-';
 3dc:	fd070793          	addi	a5,a4,-48
 3e0:	00878733          	add	a4,a5,s0
 3e4:	02d00793          	li	a5,45
 3e8:	fef70823          	sb	a5,-16(a4)
 3ec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3f0:	02e05a63          	blez	a4,424 <printint+0x96>
 3f4:	f04a                	sd	s2,32(sp)
 3f6:	ec4e                	sd	s3,24(sp)
 3f8:	fc040793          	addi	a5,s0,-64
 3fc:	00e78933          	add	s2,a5,a4
 400:	fff78993          	addi	s3,a5,-1
 404:	99ba                	add	s3,s3,a4
 406:	377d                	addiw	a4,a4,-1
 408:	1702                	slli	a4,a4,0x20
 40a:	9301                	srli	a4,a4,0x20
 40c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 410:	fff94583          	lbu	a1,-1(s2)
 414:	8526                	mv	a0,s1
 416:	f5bff0ef          	jal	370 <putc>
  while(--i >= 0)
 41a:	197d                	addi	s2,s2,-1
 41c:	ff391ae3          	bne	s2,s3,410 <printint+0x82>
 420:	7902                	ld	s2,32(sp)
 422:	69e2                	ld	s3,24(sp)
}
 424:	70e2                	ld	ra,56(sp)
 426:	7442                	ld	s0,48(sp)
 428:	74a2                	ld	s1,40(sp)
 42a:	6121                	addi	sp,sp,64
 42c:	8082                	ret
    x = -xx;
 42e:	40b005bb          	negw	a1,a1
    neg = 1;
 432:	4885                	li	a7,1
    x = -xx;
 434:	bf85                	j	3a4 <printint+0x16>

0000000000000436 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 436:	711d                	addi	sp,sp,-96
 438:	ec86                	sd	ra,88(sp)
 43a:	e8a2                	sd	s0,80(sp)
 43c:	e0ca                	sd	s2,64(sp)
 43e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 440:	0005c903          	lbu	s2,0(a1)
 444:	26090863          	beqz	s2,6b4 <vprintf+0x27e>
 448:	e4a6                	sd	s1,72(sp)
 44a:	fc4e                	sd	s3,56(sp)
 44c:	f852                	sd	s4,48(sp)
 44e:	f456                	sd	s5,40(sp)
 450:	f05a                	sd	s6,32(sp)
 452:	ec5e                	sd	s7,24(sp)
 454:	e862                	sd	s8,16(sp)
 456:	e466                	sd	s9,8(sp)
 458:	8b2a                	mv	s6,a0
 45a:	8a2e                	mv	s4,a1
 45c:	8bb2                	mv	s7,a2
  state = 0;
 45e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 460:	4481                	li	s1,0
 462:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 464:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 468:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 46c:	06c00c93          	li	s9,108
 470:	a005                	j	490 <vprintf+0x5a>
        putc(fd, c0);
 472:	85ca                	mv	a1,s2
 474:	855a                	mv	a0,s6
 476:	efbff0ef          	jal	370 <putc>
 47a:	a019                	j	480 <vprintf+0x4a>
    } else if(state == '%'){
 47c:	03598263          	beq	s3,s5,4a0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 480:	2485                	addiw	s1,s1,1
 482:	8726                	mv	a4,s1
 484:	009a07b3          	add	a5,s4,s1
 488:	0007c903          	lbu	s2,0(a5)
 48c:	20090c63          	beqz	s2,6a4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 490:	0009079b          	sext.w	a5,s2
    if(state == 0){
 494:	fe0994e3          	bnez	s3,47c <vprintf+0x46>
      if(c0 == '%'){
 498:	fd579de3          	bne	a5,s5,472 <vprintf+0x3c>
        state = '%';
 49c:	89be                	mv	s3,a5
 49e:	b7cd                	j	480 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4a0:	00ea06b3          	add	a3,s4,a4
 4a4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4a8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4aa:	c681                	beqz	a3,4b2 <vprintf+0x7c>
 4ac:	9752                	add	a4,a4,s4
 4ae:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4b2:	03878f63          	beq	a5,s8,4f0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4b6:	05978963          	beq	a5,s9,508 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ba:	07500713          	li	a4,117
 4be:	0ee78363          	beq	a5,a4,5a4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4c2:	07800713          	li	a4,120
 4c6:	12e78563          	beq	a5,a4,5f0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ca:	07000713          	li	a4,112
 4ce:	14e78a63          	beq	a5,a4,622 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4d2:	07300713          	li	a4,115
 4d6:	18e78a63          	beq	a5,a4,66a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4da:	02500713          	li	a4,37
 4de:	04e79563          	bne	a5,a4,528 <vprintf+0xf2>
        putc(fd, '%');
 4e2:	02500593          	li	a1,37
 4e6:	855a                	mv	a0,s6
 4e8:	e89ff0ef          	jal	370 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	bf49                	j	480 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4f0:	008b8913          	addi	s2,s7,8
 4f4:	4685                	li	a3,1
 4f6:	4629                	li	a2,10
 4f8:	000ba583          	lw	a1,0(s7)
 4fc:	855a                	mv	a0,s6
 4fe:	e91ff0ef          	jal	38e <printint>
 502:	8bca                	mv	s7,s2
      state = 0;
 504:	4981                	li	s3,0
 506:	bfad                	j	480 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 508:	06400793          	li	a5,100
 50c:	02f68963          	beq	a3,a5,53e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 510:	06c00793          	li	a5,108
 514:	04f68263          	beq	a3,a5,558 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 518:	07500793          	li	a5,117
 51c:	0af68063          	beq	a3,a5,5bc <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 520:	07800793          	li	a5,120
 524:	0ef68263          	beq	a3,a5,608 <vprintf+0x1d2>
        putc(fd, '%');
 528:	02500593          	li	a1,37
 52c:	855a                	mv	a0,s6
 52e:	e43ff0ef          	jal	370 <putc>
        putc(fd, c0);
 532:	85ca                	mv	a1,s2
 534:	855a                	mv	a0,s6
 536:	e3bff0ef          	jal	370 <putc>
      state = 0;
 53a:	4981                	li	s3,0
 53c:	b791                	j	480 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53e:	008b8913          	addi	s2,s7,8
 542:	4685                	li	a3,1
 544:	4629                	li	a2,10
 546:	000ba583          	lw	a1,0(s7)
 54a:	855a                	mv	a0,s6
 54c:	e43ff0ef          	jal	38e <printint>
        i += 1;
 550:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 552:	8bca                	mv	s7,s2
      state = 0;
 554:	4981                	li	s3,0
        i += 1;
 556:	b72d                	j	480 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 558:	06400793          	li	a5,100
 55c:	02f60763          	beq	a2,a5,58a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 560:	07500793          	li	a5,117
 564:	06f60963          	beq	a2,a5,5d6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 568:	07800793          	li	a5,120
 56c:	faf61ee3          	bne	a2,a5,528 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 570:	008b8913          	addi	s2,s7,8
 574:	4681                	li	a3,0
 576:	4641                	li	a2,16
 578:	000ba583          	lw	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	e11ff0ef          	jal	38e <printint>
        i += 2;
 582:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 584:	8bca                	mv	s7,s2
      state = 0;
 586:	4981                	li	s3,0
        i += 2;
 588:	bde5                	j	480 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	008b8913          	addi	s2,s7,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000ba583          	lw	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	df7ff0ef          	jal	38e <printint>
        i += 2;
 59c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
        i += 2;
 5a2:	bdf9                	j	480 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	dddff0ef          	jal	38e <printint>
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b5d9                	j	480 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	dc5ff0ef          	jal	38e <printint>
        i += 1;
 5ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
        i += 1;
 5d4:	b575                	j	480 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	008b8913          	addi	s2,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	dabff0ef          	jal	38e <printint>
        i += 2;
 5e8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	bd49                	j	480 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5f0:	008b8913          	addi	s2,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000ba583          	lw	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	d91ff0ef          	jal	38e <printint>
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
 606:	bdad                	j	480 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	008b8913          	addi	s2,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	d79ff0ef          	jal	38e <printint>
        i += 1;
 61a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
        i += 1;
 620:	b585                	j	480 <vprintf+0x4a>
 622:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 624:	008b8d13          	addi	s10,s7,8
 628:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 62c:	03000593          	li	a1,48
 630:	855a                	mv	a0,s6
 632:	d3fff0ef          	jal	370 <putc>
  putc(fd, 'x');
 636:	07800593          	li	a1,120
 63a:	855a                	mv	a0,s6
 63c:	d35ff0ef          	jal	370 <putc>
 640:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 642:	00000b97          	auipc	s7,0x0
 646:	296b8b93          	addi	s7,s7,662 # 8d8 <digits>
 64a:	03c9d793          	srli	a5,s3,0x3c
 64e:	97de                	add	a5,a5,s7
 650:	0007c583          	lbu	a1,0(a5)
 654:	855a                	mv	a0,s6
 656:	d1bff0ef          	jal	370 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65a:	0992                	slli	s3,s3,0x4
 65c:	397d                	addiw	s2,s2,-1
 65e:	fe0916e3          	bnez	s2,64a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 662:	8bea                	mv	s7,s10
      state = 0;
 664:	4981                	li	s3,0
 666:	6d02                	ld	s10,0(sp)
 668:	bd21                	j	480 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 66a:	008b8993          	addi	s3,s7,8
 66e:	000bb903          	ld	s2,0(s7)
 672:	00090f63          	beqz	s2,690 <vprintf+0x25a>
        for(; *s; s++)
 676:	00094583          	lbu	a1,0(s2)
 67a:	c195                	beqz	a1,69e <vprintf+0x268>
          putc(fd, *s);
 67c:	855a                	mv	a0,s6
 67e:	cf3ff0ef          	jal	370 <putc>
        for(; *s; s++)
 682:	0905                	addi	s2,s2,1
 684:	00094583          	lbu	a1,0(s2)
 688:	f9f5                	bnez	a1,67c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 68a:	8bce                	mv	s7,s3
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bbcd                	j	480 <vprintf+0x4a>
          s = "(null)";
 690:	00000917          	auipc	s2,0x0
 694:	24090913          	addi	s2,s2,576 # 8d0 <malloc+0x134>
        for(; *s; s++)
 698:	02800593          	li	a1,40
 69c:	b7c5                	j	67c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 69e:	8bce                	mv	s7,s3
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bbf9                	j	480 <vprintf+0x4a>
 6a4:	64a6                	ld	s1,72(sp)
 6a6:	79e2                	ld	s3,56(sp)
 6a8:	7a42                	ld	s4,48(sp)
 6aa:	7aa2                	ld	s5,40(sp)
 6ac:	7b02                	ld	s6,32(sp)
 6ae:	6be2                	ld	s7,24(sp)
 6b0:	6c42                	ld	s8,16(sp)
 6b2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6b4:	60e6                	ld	ra,88(sp)
 6b6:	6446                	ld	s0,80(sp)
 6b8:	6906                	ld	s2,64(sp)
 6ba:	6125                	addi	sp,sp,96
 6bc:	8082                	ret

00000000000006be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6be:	715d                	addi	sp,sp,-80
 6c0:	ec06                	sd	ra,24(sp)
 6c2:	e822                	sd	s0,16(sp)
 6c4:	1000                	addi	s0,sp,32
 6c6:	e010                	sd	a2,0(s0)
 6c8:	e414                	sd	a3,8(s0)
 6ca:	e818                	sd	a4,16(s0)
 6cc:	ec1c                	sd	a5,24(s0)
 6ce:	03043023          	sd	a6,32(s0)
 6d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6da:	8622                	mv	a2,s0
 6dc:	d5bff0ef          	jal	436 <vprintf>
}
 6e0:	60e2                	ld	ra,24(sp)
 6e2:	6442                	ld	s0,16(sp)
 6e4:	6161                	addi	sp,sp,80
 6e6:	8082                	ret

00000000000006e8 <printf>:

void
printf(const char *fmt, ...)
{
 6e8:	711d                	addi	sp,sp,-96
 6ea:	ec06                	sd	ra,24(sp)
 6ec:	e822                	sd	s0,16(sp)
 6ee:	1000                	addi	s0,sp,32
 6f0:	e40c                	sd	a1,8(s0)
 6f2:	e810                	sd	a2,16(s0)
 6f4:	ec14                	sd	a3,24(s0)
 6f6:	f018                	sd	a4,32(s0)
 6f8:	f41c                	sd	a5,40(s0)
 6fa:	03043823          	sd	a6,48(s0)
 6fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	00840613          	addi	a2,s0,8
 706:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 70a:	85aa                	mv	a1,a0
 70c:	4505                	li	a0,1
 70e:	d29ff0ef          	jal	436 <vprintf>
}
 712:	60e2                	ld	ra,24(sp)
 714:	6442                	ld	s0,16(sp)
 716:	6125                	addi	sp,sp,96
 718:	8082                	ret

000000000000071a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71a:	1141                	addi	sp,sp,-16
 71c:	e422                	sd	s0,8(sp)
 71e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 720:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 724:	00001797          	auipc	a5,0x1
 728:	8dc7b783          	ld	a5,-1828(a5) # 1000 <freep>
 72c:	a02d                	j	756 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 72e:	4618                	lw	a4,8(a2)
 730:	9f2d                	addw	a4,a4,a1
 732:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 736:	6398                	ld	a4,0(a5)
 738:	6310                	ld	a2,0(a4)
 73a:	a83d                	j	778 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 73c:	ff852703          	lw	a4,-8(a0)
 740:	9f31                	addw	a4,a4,a2
 742:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 744:	ff053683          	ld	a3,-16(a0)
 748:	a091                	j	78c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74a:	6398                	ld	a4,0(a5)
 74c:	00e7e463          	bltu	a5,a4,754 <free+0x3a>
 750:	00e6ea63          	bltu	a3,a4,764 <free+0x4a>
{
 754:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 756:	fed7fae3          	bgeu	a5,a3,74a <free+0x30>
 75a:	6398                	ld	a4,0(a5)
 75c:	00e6e463          	bltu	a3,a4,764 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	fee7eae3          	bltu	a5,a4,754 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 764:	ff852583          	lw	a1,-8(a0)
 768:	6390                	ld	a2,0(a5)
 76a:	02059813          	slli	a6,a1,0x20
 76e:	01c85713          	srli	a4,a6,0x1c
 772:	9736                	add	a4,a4,a3
 774:	fae60de3          	beq	a2,a4,72e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 778:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 77c:	4790                	lw	a2,8(a5)
 77e:	02061593          	slli	a1,a2,0x20
 782:	01c5d713          	srli	a4,a1,0x1c
 786:	973e                	add	a4,a4,a5
 788:	fae68ae3          	beq	a3,a4,73c <free+0x22>
    p->s.ptr = bp->s.ptr;
 78c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 78e:	00001717          	auipc	a4,0x1
 792:	86f73923          	sd	a5,-1934(a4) # 1000 <freep>
}
 796:	6422                	ld	s0,8(sp)
 798:	0141                	addi	sp,sp,16
 79a:	8082                	ret

000000000000079c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79c:	7139                	addi	sp,sp,-64
 79e:	fc06                	sd	ra,56(sp)
 7a0:	f822                	sd	s0,48(sp)
 7a2:	f426                	sd	s1,40(sp)
 7a4:	ec4e                	sd	s3,24(sp)
 7a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a8:	02051493          	slli	s1,a0,0x20
 7ac:	9081                	srli	s1,s1,0x20
 7ae:	04bd                	addi	s1,s1,15
 7b0:	8091                	srli	s1,s1,0x4
 7b2:	0014899b          	addiw	s3,s1,1
 7b6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7b8:	00001517          	auipc	a0,0x1
 7bc:	84853503          	ld	a0,-1976(a0) # 1000 <freep>
 7c0:	c915                	beqz	a0,7f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c4:	4798                	lw	a4,8(a5)
 7c6:	08977a63          	bgeu	a4,s1,85a <malloc+0xbe>
 7ca:	f04a                	sd	s2,32(sp)
 7cc:	e852                	sd	s4,16(sp)
 7ce:	e456                	sd	s5,8(sp)
 7d0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7d2:	8a4e                	mv	s4,s3
 7d4:	0009871b          	sext.w	a4,s3
 7d8:	6685                	lui	a3,0x1
 7da:	00d77363          	bgeu	a4,a3,7e0 <malloc+0x44>
 7de:	6a05                	lui	s4,0x1
 7e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e8:	00001917          	auipc	s2,0x1
 7ec:	81890913          	addi	s2,s2,-2024 # 1000 <freep>
  if(p == (char*)-1)
 7f0:	5afd                	li	s5,-1
 7f2:	a081                	j	832 <malloc+0x96>
 7f4:	f04a                	sd	s2,32(sp)
 7f6:	e852                	sd	s4,16(sp)
 7f8:	e456                	sd	s5,8(sp)
 7fa:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7fc:	00001797          	auipc	a5,0x1
 800:	81478793          	addi	a5,a5,-2028 # 1010 <base>
 804:	00000717          	auipc	a4,0x0
 808:	7ef73e23          	sd	a5,2044(a4) # 1000 <freep>
 80c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 80e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 812:	b7c1                	j	7d2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 814:	6398                	ld	a4,0(a5)
 816:	e118                	sd	a4,0(a0)
 818:	a8a9                	j	872 <malloc+0xd6>
  hp->s.size = nu;
 81a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 81e:	0541                	addi	a0,a0,16
 820:	efbff0ef          	jal	71a <free>
  return freep;
 824:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 828:	c12d                	beqz	a0,88a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82c:	4798                	lw	a4,8(a5)
 82e:	02977263          	bgeu	a4,s1,852 <malloc+0xb6>
    if(p == freep)
 832:	00093703          	ld	a4,0(s2)
 836:	853e                	mv	a0,a5
 838:	fef719e3          	bne	a4,a5,82a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 83c:	8552                	mv	a0,s4
 83e:	b03ff0ef          	jal	340 <sbrk>
  if(p == (char*)-1)
 842:	fd551ce3          	bne	a0,s5,81a <malloc+0x7e>
        return 0;
 846:	4501                	li	a0,0
 848:	7902                	ld	s2,32(sp)
 84a:	6a42                	ld	s4,16(sp)
 84c:	6aa2                	ld	s5,8(sp)
 84e:	6b02                	ld	s6,0(sp)
 850:	a03d                	j	87e <malloc+0xe2>
 852:	7902                	ld	s2,32(sp)
 854:	6a42                	ld	s4,16(sp)
 856:	6aa2                	ld	s5,8(sp)
 858:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 85a:	fae48de3          	beq	s1,a4,814 <malloc+0x78>
        p->s.size -= nunits;
 85e:	4137073b          	subw	a4,a4,s3
 862:	c798                	sw	a4,8(a5)
        p += p->s.size;
 864:	02071693          	slli	a3,a4,0x20
 868:	01c6d713          	srli	a4,a3,0x1c
 86c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 872:	00000717          	auipc	a4,0x0
 876:	78a73723          	sd	a0,1934(a4) # 1000 <freep>
      return (void*)(p + 1);
 87a:	01078513          	addi	a0,a5,16
  }
}
 87e:	70e2                	ld	ra,56(sp)
 880:	7442                	ld	s0,48(sp)
 882:	74a2                	ld	s1,40(sp)
 884:	69e2                	ld	s3,24(sp)
 886:	6121                	addi	sp,sp,64
 888:	8082                	ret
 88a:	7902                	ld	s2,32(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
 892:	b7f5                	j	87e <malloc+0xe2>
