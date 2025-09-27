
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7d063          	bge	a5,a0,74 <main+0x74>
  18:	00858493          	addi	s1,a1,8
  1c:	3579                	addiw	a0,a0,-2
  1e:	02051793          	slli	a5,a0,0x20
  22:	01d7d513          	srli	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	addi	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	890a8a93          	addi	s5,s5,-1904 # 8c0 <malloc+0xf8>
  38:	a809                	j	4a <main+0x4a>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	2c4000ef          	jal	304 <write>
  for(i = 1; i < argc; i++){
  44:	04a1                	addi	s1,s1,8
  46:	03348763          	beq	s1,s3,74 <main+0x74>
    write(1, argv[i], strlen(argv[i]));
  4a:	0004b903          	ld	s2,0(s1)
  4e:	854a                	mv	a0,s2
  50:	084000ef          	jal	d4 <strlen>
  54:	0005061b          	sext.w	a2,a0
  58:	85ca                	mv	a1,s2
  5a:	4505                	li	a0,1
  5c:	2a8000ef          	jal	304 <write>
    if(i + 1 < argc){
  60:	fd449de3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  64:	4605                	li	a2,1
  66:	00001597          	auipc	a1,0x1
  6a:	86258593          	addi	a1,a1,-1950 # 8c8 <malloc+0x100>
  6e:	4505                	li	a0,1
  70:	294000ef          	jal	304 <write>
    }
  }
  exit(0);
  74:	4501                	li	a0,0
  76:	26e000ef          	jal	2e4 <exit>

000000000000007a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  extern int main();
  main();
  82:	f7fff0ef          	jal	0 <main>
  exit(0);
  86:	4501                	li	a0,0
  88:	25c000ef          	jal	2e4 <exit>

000000000000008c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  92:	87aa                	mv	a5,a0
  94:	0585                	addi	a1,a1,1
  96:	0785                	addi	a5,a5,1
  98:	fff5c703          	lbu	a4,-1(a1)
  9c:	fee78fa3          	sb	a4,-1(a5)
  a0:	fb75                	bnez	a4,94 <strcpy+0x8>
    ;
  return os;
}
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cb91                	beqz	a5,c6 <strcmp+0x1e>
  b4:	0005c703          	lbu	a4,0(a1)
  b8:	00f71763          	bne	a4,a5,c6 <strcmp+0x1e>
    p++, q++;
  bc:	0505                	addi	a0,a0,1
  be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	fbe5                	bnez	a5,b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c6:	0005c503          	lbu	a0,0(a1)
}
  ca:	40a7853b          	subw	a0,a5,a0
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strlen>:

uint
strlen(const char *s)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf91                	beqz	a5,fa <strlen+0x26>
  e0:	0505                	addi	a0,a0,1
  e2:	87aa                	mv	a5,a0
  e4:	86be                	mv	a3,a5
  e6:	0785                	addi	a5,a5,1
  e8:	fff7c703          	lbu	a4,-1(a5)
  ec:	ff65                	bnez	a4,e4 <strlen+0x10>
  ee:	40a6853b          	subw	a0,a3,a0
  f2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret
  for(n = 0; s[n]; n++)
  fa:	4501                	li	a0,0
  fc:	bfe5                	j	f4 <strlen+0x20>

00000000000000fe <memset>:

void*
memset(void *dst, int c, uint n)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 104:	ca19                	beqz	a2,11a <memset+0x1c>
 106:	87aa                	mv	a5,a0
 108:	1602                	slli	a2,a2,0x20
 10a:	9201                	srli	a2,a2,0x20
 10c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 110:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 114:	0785                	addi	a5,a5,1
 116:	fee79de3          	bne	a5,a4,110 <memset+0x12>
  }
  return dst;
}
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	1141                	addi	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	addi	s0,sp,16
  for(; *s; s++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cb99                	beqz	a5,140 <strchr+0x20>
    if(*s == c)
 12c:	00f58763          	beq	a1,a5,13a <strchr+0x1a>
  for(; *s; s++)
 130:	0505                	addi	a0,a0,1
 132:	00054783          	lbu	a5,0(a0)
 136:	fbfd                	bnez	a5,12c <strchr+0xc>
      return (char*)s;
  return 0;
 138:	4501                	li	a0,0
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret
  return 0;
 140:	4501                	li	a0,0
 142:	bfe5                	j	13a <strchr+0x1a>

0000000000000144 <gets>:

char*
gets(char *buf, int max)
{
 144:	711d                	addi	sp,sp,-96
 146:	ec86                	sd	ra,88(sp)
 148:	e8a2                	sd	s0,80(sp)
 14a:	e4a6                	sd	s1,72(sp)
 14c:	e0ca                	sd	s2,64(sp)
 14e:	fc4e                	sd	s3,56(sp)
 150:	f852                	sd	s4,48(sp)
 152:	f456                	sd	s5,40(sp)
 154:	f05a                	sd	s6,32(sp)
 156:	ec5e                	sd	s7,24(sp)
 158:	1080                	addi	s0,sp,96
 15a:	8baa                	mv	s7,a0
 15c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15e:	892a                	mv	s2,a0
 160:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 162:	4aa9                	li	s5,10
 164:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 166:	89a6                	mv	s3,s1
 168:	2485                	addiw	s1,s1,1
 16a:	0344d663          	bge	s1,s4,196 <gets+0x52>
    cc = read(0, &c, 1);
 16e:	4605                	li	a2,1
 170:	faf40593          	addi	a1,s0,-81
 174:	4501                	li	a0,0
 176:	186000ef          	jal	2fc <read>
    if(cc < 1)
 17a:	00a05e63          	blez	a0,196 <gets+0x52>
    buf[i++] = c;
 17e:	faf44783          	lbu	a5,-81(s0)
 182:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 186:	01578763          	beq	a5,s5,194 <gets+0x50>
 18a:	0905                	addi	s2,s2,1
 18c:	fd679de3          	bne	a5,s6,166 <gets+0x22>
    buf[i++] = c;
 190:	89a6                	mv	s3,s1
 192:	a011                	j	196 <gets+0x52>
 194:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 196:	99de                	add	s3,s3,s7
 198:	00098023          	sb	zero,0(s3)
  return buf;
}
 19c:	855e                	mv	a0,s7
 19e:	60e6                	ld	ra,88(sp)
 1a0:	6446                	ld	s0,80(sp)
 1a2:	64a6                	ld	s1,72(sp)
 1a4:	6906                	ld	s2,64(sp)
 1a6:	79e2                	ld	s3,56(sp)
 1a8:	7a42                	ld	s4,48(sp)
 1aa:	7aa2                	ld	s5,40(sp)
 1ac:	7b02                	ld	s6,32(sp)
 1ae:	6be2                	ld	s7,24(sp)
 1b0:	6125                	addi	sp,sp,96
 1b2:	8082                	ret

00000000000001b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b4:	1101                	addi	sp,sp,-32
 1b6:	ec06                	sd	ra,24(sp)
 1b8:	e822                	sd	s0,16(sp)
 1ba:	e04a                	sd	s2,0(sp)
 1bc:	1000                	addi	s0,sp,32
 1be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c0:	4581                	li	a1,0
 1c2:	162000ef          	jal	324 <open>
  if(fd < 0)
 1c6:	02054263          	bltz	a0,1ea <stat+0x36>
 1ca:	e426                	sd	s1,8(sp)
 1cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ce:	85ca                	mv	a1,s2
 1d0:	16c000ef          	jal	33c <fstat>
 1d4:	892a                	mv	s2,a0
  close(fd);
 1d6:	8526                	mv	a0,s1
 1d8:	134000ef          	jal	30c <close>
  return r;
 1dc:	64a2                	ld	s1,8(sp)
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret
    return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfcd                	j	1de <stat+0x2a>

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f4:	00054683          	lbu	a3,0(a0)
 1f8:	fd06879b          	addiw	a5,a3,-48
 1fc:	0ff7f793          	zext.b	a5,a5
 200:	4625                	li	a2,9
 202:	02f66863          	bltu	a2,a5,232 <atoi+0x44>
 206:	872a                	mv	a4,a0
  n = 0;
 208:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20a:	0705                	addi	a4,a4,1
 20c:	0025179b          	slliw	a5,a0,0x2
 210:	9fa9                	addw	a5,a5,a0
 212:	0017979b          	slliw	a5,a5,0x1
 216:	9fb5                	addw	a5,a5,a3
 218:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21c:	00074683          	lbu	a3,0(a4)
 220:	fd06879b          	addiw	a5,a3,-48
 224:	0ff7f793          	zext.b	a5,a5
 228:	fef671e3          	bgeu	a2,a5,20a <atoi+0x1c>
  return n;
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  n = 0;
 232:	4501                	li	a0,0
 234:	bfe5                	j	22c <atoi+0x3e>

0000000000000236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 236:	1141                	addi	sp,sp,-16
 238:	e422                	sd	s0,8(sp)
 23a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23c:	02b57463          	bgeu	a0,a1,264 <memmove+0x2e>
    while(n-- > 0)
 240:	00c05f63          	blez	a2,25e <memmove+0x28>
 244:	1602                	slli	a2,a2,0x20
 246:	9201                	srli	a2,a2,0x20
 248:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24c:	872a                	mv	a4,a0
      *dst++ = *src++;
 24e:	0585                	addi	a1,a1,1
 250:	0705                	addi	a4,a4,1
 252:	fff5c683          	lbu	a3,-1(a1)
 256:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25a:	fef71ae3          	bne	a4,a5,24e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
    dst += n;
 264:	00c50733          	add	a4,a0,a2
    src += n;
 268:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26a:	fec05ae3          	blez	a2,25e <memmove+0x28>
 26e:	fff6079b          	addiw	a5,a2,-1
 272:	1782                	slli	a5,a5,0x20
 274:	9381                	srli	a5,a5,0x20
 276:	fff7c793          	not	a5,a5
 27a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27c:	15fd                	addi	a1,a1,-1
 27e:	177d                	addi	a4,a4,-1
 280:	0005c683          	lbu	a3,0(a1)
 284:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x46>
 28c:	bfc9                	j	25e <memmove+0x28>

000000000000028e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 294:	ca05                	beqz	a2,2c4 <memcmp+0x36>
 296:	fff6069b          	addiw	a3,a2,-1
 29a:	1682                	slli	a3,a3,0x20
 29c:	9281                	srli	a3,a3,0x20
 29e:	0685                	addi	a3,a3,1
 2a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	0005c703          	lbu	a4,0(a1)
 2aa:	00e79863          	bne	a5,a4,2ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ae:	0505                	addi	a0,a0,1
    p2++;
 2b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b2:	fed518e3          	bne	a0,a3,2a2 <memcmp+0x14>
  }
  return 0;
 2b6:	4501                	li	a0,0
 2b8:	a019                	j	2be <memcmp+0x30>
      return *p1 - *p2;
 2ba:	40e7853b          	subw	a0,a5,a4
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <memcmp+0x30>

00000000000002c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d0:	f67ff0ef          	jal	236 <memmove>
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2dc:	4885                	li	a7,1
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e4:	4889                	li	a7,2
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ec:	488d                	li	a7,3
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f4:	4891                	li	a7,4
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <read>:
.global read
read:
 li a7, SYS_read
 2fc:	4895                	li	a7,5
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <write>:
.global write
write:
 li a7, SYS_write
 304:	48c1                	li	a7,16
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <close>:
.global close
close:
 li a7, SYS_close
 30c:	48d5                	li	a7,21
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <kill>:
.global kill
kill:
 li a7, SYS_kill
 314:	4899                	li	a7,6
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exec>:
.global exec
exec:
 li a7, SYS_exec
 31c:	489d                	li	a7,7
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <open>:
.global open
open:
 li a7, SYS_open
 324:	48bd                	li	a7,15
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32c:	48c5                	li	a7,17
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 334:	48c9                	li	a7,18
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33c:	48a1                	li	a7,8
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <link>:
.global link
link:
 li a7, SYS_link
 344:	48cd                	li	a7,19
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34c:	48d1                	li	a7,20
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 354:	48a5                	li	a7,9
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <dup>:
.global dup
dup:
 li a7, SYS_dup
 35c:	48a9                	li	a7,10
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 364:	48ad                	li	a7,11
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 36c:	48b1                	li	a7,12
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 374:	48b5                	li	a7,13
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37c:	48b9                	li	a7,14
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <get_context_switches>:
.global get_context_switches
get_context_switches:
 li a7, SYS_get_context_switches
 384:	48d9                	li	a7,22
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <get_tick_rate>:
.global get_tick_rate
 get_tick_rate:
 li a7, SYS_get_tick_rate
 38c:	48dd                	li	a7,23
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <get_total_ticks>:
 .global get_total_ticks
 get_total_ticks:
 li a7, SYS_get_total_ticks
 394:	48e1                	li	a7,24
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39c:	1101                	addi	sp,sp,-32
 39e:	ec06                	sd	ra,24(sp)
 3a0:	e822                	sd	s0,16(sp)
 3a2:	1000                	addi	s0,sp,32
 3a4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a8:	4605                	li	a2,1
 3aa:	fef40593          	addi	a1,s0,-17
 3ae:	f57ff0ef          	jal	304 <write>
}
 3b2:	60e2                	ld	ra,24(sp)
 3b4:	6442                	ld	s0,16(sp)
 3b6:	6105                	addi	sp,sp,32
 3b8:	8082                	ret

00000000000003ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ba:	7139                	addi	sp,sp,-64
 3bc:	fc06                	sd	ra,56(sp)
 3be:	f822                	sd	s0,48(sp)
 3c0:	f426                	sd	s1,40(sp)
 3c2:	0080                	addi	s0,sp,64
 3c4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c6:	c299                	beqz	a3,3cc <printint+0x12>
 3c8:	0805c963          	bltz	a1,45a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3cc:	2581                	sext.w	a1,a1
  neg = 0;
 3ce:	4881                	li	a7,0
 3d0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3d4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d6:	2601                	sext.w	a2,a2
 3d8:	00000517          	auipc	a0,0x0
 3dc:	50050513          	addi	a0,a0,1280 # 8d8 <digits>
 3e0:	883a                	mv	a6,a4
 3e2:	2705                	addiw	a4,a4,1
 3e4:	02c5f7bb          	remuw	a5,a1,a2
 3e8:	1782                	slli	a5,a5,0x20
 3ea:	9381                	srli	a5,a5,0x20
 3ec:	97aa                	add	a5,a5,a0
 3ee:	0007c783          	lbu	a5,0(a5)
 3f2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f6:	0005879b          	sext.w	a5,a1
 3fa:	02c5d5bb          	divuw	a1,a1,a2
 3fe:	0685                	addi	a3,a3,1
 400:	fec7f0e3          	bgeu	a5,a2,3e0 <printint+0x26>
  if(neg)
 404:	00088c63          	beqz	a7,41c <printint+0x62>
    buf[i++] = '-';
 408:	fd070793          	addi	a5,a4,-48
 40c:	00878733          	add	a4,a5,s0
 410:	02d00793          	li	a5,45
 414:	fef70823          	sb	a5,-16(a4)
 418:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 41c:	02e05a63          	blez	a4,450 <printint+0x96>
 420:	f04a                	sd	s2,32(sp)
 422:	ec4e                	sd	s3,24(sp)
 424:	fc040793          	addi	a5,s0,-64
 428:	00e78933          	add	s2,a5,a4
 42c:	fff78993          	addi	s3,a5,-1
 430:	99ba                	add	s3,s3,a4
 432:	377d                	addiw	a4,a4,-1
 434:	1702                	slli	a4,a4,0x20
 436:	9301                	srli	a4,a4,0x20
 438:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 43c:	fff94583          	lbu	a1,-1(s2)
 440:	8526                	mv	a0,s1
 442:	f5bff0ef          	jal	39c <putc>
  while(--i >= 0)
 446:	197d                	addi	s2,s2,-1
 448:	ff391ae3          	bne	s2,s3,43c <printint+0x82>
 44c:	7902                	ld	s2,32(sp)
 44e:	69e2                	ld	s3,24(sp)
}
 450:	70e2                	ld	ra,56(sp)
 452:	7442                	ld	s0,48(sp)
 454:	74a2                	ld	s1,40(sp)
 456:	6121                	addi	sp,sp,64
 458:	8082                	ret
    x = -xx;
 45a:	40b005bb          	negw	a1,a1
    neg = 1;
 45e:	4885                	li	a7,1
    x = -xx;
 460:	bf85                	j	3d0 <printint+0x16>

0000000000000462 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 462:	711d                	addi	sp,sp,-96
 464:	ec86                	sd	ra,88(sp)
 466:	e8a2                	sd	s0,80(sp)
 468:	e0ca                	sd	s2,64(sp)
 46a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 46c:	0005c903          	lbu	s2,0(a1)
 470:	26090863          	beqz	s2,6e0 <vprintf+0x27e>
 474:	e4a6                	sd	s1,72(sp)
 476:	fc4e                	sd	s3,56(sp)
 478:	f852                	sd	s4,48(sp)
 47a:	f456                	sd	s5,40(sp)
 47c:	f05a                	sd	s6,32(sp)
 47e:	ec5e                	sd	s7,24(sp)
 480:	e862                	sd	s8,16(sp)
 482:	e466                	sd	s9,8(sp)
 484:	8b2a                	mv	s6,a0
 486:	8a2e                	mv	s4,a1
 488:	8bb2                	mv	s7,a2
  state = 0;
 48a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 48c:	4481                	li	s1,0
 48e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 490:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 494:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 498:	06c00c93          	li	s9,108
 49c:	a005                	j	4bc <vprintf+0x5a>
        putc(fd, c0);
 49e:	85ca                	mv	a1,s2
 4a0:	855a                	mv	a0,s6
 4a2:	efbff0ef          	jal	39c <putc>
 4a6:	a019                	j	4ac <vprintf+0x4a>
    } else if(state == '%'){
 4a8:	03598263          	beq	s3,s5,4cc <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4ac:	2485                	addiw	s1,s1,1
 4ae:	8726                	mv	a4,s1
 4b0:	009a07b3          	add	a5,s4,s1
 4b4:	0007c903          	lbu	s2,0(a5)
 4b8:	20090c63          	beqz	s2,6d0 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4bc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4c0:	fe0994e3          	bnez	s3,4a8 <vprintf+0x46>
      if(c0 == '%'){
 4c4:	fd579de3          	bne	a5,s5,49e <vprintf+0x3c>
        state = '%';
 4c8:	89be                	mv	s3,a5
 4ca:	b7cd                	j	4ac <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4cc:	00ea06b3          	add	a3,s4,a4
 4d0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4d4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4d6:	c681                	beqz	a3,4de <vprintf+0x7c>
 4d8:	9752                	add	a4,a4,s4
 4da:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4de:	03878f63          	beq	a5,s8,51c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4e2:	05978963          	beq	a5,s9,534 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4e6:	07500713          	li	a4,117
 4ea:	0ee78363          	beq	a5,a4,5d0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4ee:	07800713          	li	a4,120
 4f2:	12e78563          	beq	a5,a4,61c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4f6:	07000713          	li	a4,112
 4fa:	14e78a63          	beq	a5,a4,64e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4fe:	07300713          	li	a4,115
 502:	18e78a63          	beq	a5,a4,696 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 506:	02500713          	li	a4,37
 50a:	04e79563          	bne	a5,a4,554 <vprintf+0xf2>
        putc(fd, '%');
 50e:	02500593          	li	a1,37
 512:	855a                	mv	a0,s6
 514:	e89ff0ef          	jal	39c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 518:	4981                	li	s3,0
 51a:	bf49                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 51c:	008b8913          	addi	s2,s7,8
 520:	4685                	li	a3,1
 522:	4629                	li	a2,10
 524:	000ba583          	lw	a1,0(s7)
 528:	855a                	mv	a0,s6
 52a:	e91ff0ef          	jal	3ba <printint>
 52e:	8bca                	mv	s7,s2
      state = 0;
 530:	4981                	li	s3,0
 532:	bfad                	j	4ac <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 534:	06400793          	li	a5,100
 538:	02f68963          	beq	a3,a5,56a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 53c:	06c00793          	li	a5,108
 540:	04f68263          	beq	a3,a5,584 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 544:	07500793          	li	a5,117
 548:	0af68063          	beq	a3,a5,5e8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 54c:	07800793          	li	a5,120
 550:	0ef68263          	beq	a3,a5,634 <vprintf+0x1d2>
        putc(fd, '%');
 554:	02500593          	li	a1,37
 558:	855a                	mv	a0,s6
 55a:	e43ff0ef          	jal	39c <putc>
        putc(fd, c0);
 55e:	85ca                	mv	a1,s2
 560:	855a                	mv	a0,s6
 562:	e3bff0ef          	jal	39c <putc>
      state = 0;
 566:	4981                	li	s3,0
 568:	b791                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	008b8913          	addi	s2,s7,8
 56e:	4685                	li	a3,1
 570:	4629                	li	a2,10
 572:	000ba583          	lw	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	e43ff0ef          	jal	3ba <printint>
        i += 1;
 57c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
        i += 1;
 582:	b72d                	j	4ac <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 584:	06400793          	li	a5,100
 588:	02f60763          	beq	a2,a5,5b6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 58c:	07500793          	li	a5,117
 590:	06f60963          	beq	a2,a5,602 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 594:	07800793          	li	a5,120
 598:	faf61ee3          	bne	a2,a5,554 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 59c:	008b8913          	addi	s2,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4641                	li	a2,16
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e11ff0ef          	jal	3ba <printint>
        i += 2;
 5ae:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
        i += 2;
 5b4:	bde5                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	df7ff0ef          	jal	3ba <printint>
        i += 2;
 5c8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
        i += 2;
 5ce:	bdf9                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	dddff0ef          	jal	3ba <printint>
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b5d9                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	dc5ff0ef          	jal	3ba <printint>
        i += 1;
 5fa:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fc:	8bca                	mv	s7,s2
      state = 0;
 5fe:	4981                	li	s3,0
        i += 1;
 600:	b575                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	008b8913          	addi	s2,s7,8
 606:	4681                	li	a3,0
 608:	4629                	li	a2,10
 60a:	000ba583          	lw	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	dabff0ef          	jal	3ba <printint>
        i += 2;
 614:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
        i += 2;
 61a:	bd49                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 61c:	008b8913          	addi	s2,s7,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000ba583          	lw	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	d91ff0ef          	jal	3ba <printint>
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
 632:	bdad                	j	4ac <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 634:	008b8913          	addi	s2,s7,8
 638:	4681                	li	a3,0
 63a:	4641                	li	a2,16
 63c:	000ba583          	lw	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	d79ff0ef          	jal	3ba <printint>
        i += 1;
 646:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 648:	8bca                	mv	s7,s2
      state = 0;
 64a:	4981                	li	s3,0
        i += 1;
 64c:	b585                	j	4ac <vprintf+0x4a>
 64e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 650:	008b8d13          	addi	s10,s7,8
 654:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 658:	03000593          	li	a1,48
 65c:	855a                	mv	a0,s6
 65e:	d3fff0ef          	jal	39c <putc>
  putc(fd, 'x');
 662:	07800593          	li	a1,120
 666:	855a                	mv	a0,s6
 668:	d35ff0ef          	jal	39c <putc>
 66c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66e:	00000b97          	auipc	s7,0x0
 672:	26ab8b93          	addi	s7,s7,618 # 8d8 <digits>
 676:	03c9d793          	srli	a5,s3,0x3c
 67a:	97de                	add	a5,a5,s7
 67c:	0007c583          	lbu	a1,0(a5)
 680:	855a                	mv	a0,s6
 682:	d1bff0ef          	jal	39c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 686:	0992                	slli	s3,s3,0x4
 688:	397d                	addiw	s2,s2,-1
 68a:	fe0916e3          	bnez	s2,676 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 68e:	8bea                	mv	s7,s10
      state = 0;
 690:	4981                	li	s3,0
 692:	6d02                	ld	s10,0(sp)
 694:	bd21                	j	4ac <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 696:	008b8993          	addi	s3,s7,8
 69a:	000bb903          	ld	s2,0(s7)
 69e:	00090f63          	beqz	s2,6bc <vprintf+0x25a>
        for(; *s; s++)
 6a2:	00094583          	lbu	a1,0(s2)
 6a6:	c195                	beqz	a1,6ca <vprintf+0x268>
          putc(fd, *s);
 6a8:	855a                	mv	a0,s6
 6aa:	cf3ff0ef          	jal	39c <putc>
        for(; *s; s++)
 6ae:	0905                	addi	s2,s2,1
 6b0:	00094583          	lbu	a1,0(s2)
 6b4:	f9f5                	bnez	a1,6a8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bbcd                	j	4ac <vprintf+0x4a>
          s = "(null)";
 6bc:	00000917          	auipc	s2,0x0
 6c0:	21490913          	addi	s2,s2,532 # 8d0 <malloc+0x108>
        for(; *s; s++)
 6c4:	02800593          	li	a1,40
 6c8:	b7c5                	j	6a8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6ca:	8bce                	mv	s7,s3
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bbf9                	j	4ac <vprintf+0x4a>
 6d0:	64a6                	ld	s1,72(sp)
 6d2:	79e2                	ld	s3,56(sp)
 6d4:	7a42                	ld	s4,48(sp)
 6d6:	7aa2                	ld	s5,40(sp)
 6d8:	7b02                	ld	s6,32(sp)
 6da:	6be2                	ld	s7,24(sp)
 6dc:	6c42                	ld	s8,16(sp)
 6de:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6e0:	60e6                	ld	ra,88(sp)
 6e2:	6446                	ld	s0,80(sp)
 6e4:	6906                	ld	s2,64(sp)
 6e6:	6125                	addi	sp,sp,96
 6e8:	8082                	ret

00000000000006ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ea:	715d                	addi	sp,sp,-80
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	addi	s0,sp,32
 6f2:	e010                	sd	a2,0(s0)
 6f4:	e414                	sd	a3,8(s0)
 6f6:	e818                	sd	a4,16(s0)
 6f8:	ec1c                	sd	a5,24(s0)
 6fa:	03043023          	sd	a6,32(s0)
 6fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 706:	8622                	mv	a2,s0
 708:	d5bff0ef          	jal	462 <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6161                	addi	sp,sp,80
 712:	8082                	ret

0000000000000714 <printf>:

void
printf(const char *fmt, ...)
{
 714:	711d                	addi	sp,sp,-96
 716:	ec06                	sd	ra,24(sp)
 718:	e822                	sd	s0,16(sp)
 71a:	1000                	addi	s0,sp,32
 71c:	e40c                	sd	a1,8(s0)
 71e:	e810                	sd	a2,16(s0)
 720:	ec14                	sd	a3,24(s0)
 722:	f018                	sd	a4,32(s0)
 724:	f41c                	sd	a5,40(s0)
 726:	03043823          	sd	a6,48(s0)
 72a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 72e:	00840613          	addi	a2,s0,8
 732:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 736:	85aa                	mv	a1,a0
 738:	4505                	li	a0,1
 73a:	d29ff0ef          	jal	462 <vprintf>
}
 73e:	60e2                	ld	ra,24(sp)
 740:	6442                	ld	s0,16(sp)
 742:	6125                	addi	sp,sp,96
 744:	8082                	ret

0000000000000746 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 746:	1141                	addi	sp,sp,-16
 748:	e422                	sd	s0,8(sp)
 74a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 750:	00001797          	auipc	a5,0x1
 754:	8b07b783          	ld	a5,-1872(a5) # 1000 <freep>
 758:	a02d                	j	782 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 75a:	4618                	lw	a4,8(a2)
 75c:	9f2d                	addw	a4,a4,a1
 75e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 762:	6398                	ld	a4,0(a5)
 764:	6310                	ld	a2,0(a4)
 766:	a83d                	j	7a4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 768:	ff852703          	lw	a4,-8(a0)
 76c:	9f31                	addw	a4,a4,a2
 76e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 770:	ff053683          	ld	a3,-16(a0)
 774:	a091                	j	7b8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 776:	6398                	ld	a4,0(a5)
 778:	00e7e463          	bltu	a5,a4,780 <free+0x3a>
 77c:	00e6ea63          	bltu	a3,a4,790 <free+0x4a>
{
 780:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	fed7fae3          	bgeu	a5,a3,776 <free+0x30>
 786:	6398                	ld	a4,0(a5)
 788:	00e6e463          	bltu	a3,a4,790 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78c:	fee7eae3          	bltu	a5,a4,780 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 790:	ff852583          	lw	a1,-8(a0)
 794:	6390                	ld	a2,0(a5)
 796:	02059813          	slli	a6,a1,0x20
 79a:	01c85713          	srli	a4,a6,0x1c
 79e:	9736                	add	a4,a4,a3
 7a0:	fae60de3          	beq	a2,a4,75a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7a4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a8:	4790                	lw	a2,8(a5)
 7aa:	02061593          	slli	a1,a2,0x20
 7ae:	01c5d713          	srli	a4,a1,0x1c
 7b2:	973e                	add	a4,a4,a5
 7b4:	fae68ae3          	beq	a3,a4,768 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7b8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ba:	00001717          	auipc	a4,0x1
 7be:	84f73323          	sd	a5,-1978(a4) # 1000 <freep>
}
 7c2:	6422                	ld	s0,8(sp)
 7c4:	0141                	addi	sp,sp,16
 7c6:	8082                	ret

00000000000007c8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c8:	7139                	addi	sp,sp,-64
 7ca:	fc06                	sd	ra,56(sp)
 7cc:	f822                	sd	s0,48(sp)
 7ce:	f426                	sd	s1,40(sp)
 7d0:	ec4e                	sd	s3,24(sp)
 7d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d4:	02051493          	slli	s1,a0,0x20
 7d8:	9081                	srli	s1,s1,0x20
 7da:	04bd                	addi	s1,s1,15
 7dc:	8091                	srli	s1,s1,0x4
 7de:	0014899b          	addiw	s3,s1,1
 7e2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7e4:	00001517          	auipc	a0,0x1
 7e8:	81c53503          	ld	a0,-2020(a0) # 1000 <freep>
 7ec:	c915                	beqz	a0,820 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f0:	4798                	lw	a4,8(a5)
 7f2:	08977a63          	bgeu	a4,s1,886 <malloc+0xbe>
 7f6:	f04a                	sd	s2,32(sp)
 7f8:	e852                	sd	s4,16(sp)
 7fa:	e456                	sd	s5,8(sp)
 7fc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7fe:	8a4e                	mv	s4,s3
 800:	0009871b          	sext.w	a4,s3
 804:	6685                	lui	a3,0x1
 806:	00d77363          	bgeu	a4,a3,80c <malloc+0x44>
 80a:	6a05                	lui	s4,0x1
 80c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 810:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 814:	00000917          	auipc	s2,0x0
 818:	7ec90913          	addi	s2,s2,2028 # 1000 <freep>
  if(p == (char*)-1)
 81c:	5afd                	li	s5,-1
 81e:	a081                	j	85e <malloc+0x96>
 820:	f04a                	sd	s2,32(sp)
 822:	e852                	sd	s4,16(sp)
 824:	e456                	sd	s5,8(sp)
 826:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 828:	00000797          	auipc	a5,0x0
 82c:	7e878793          	addi	a5,a5,2024 # 1010 <base>
 830:	00000717          	auipc	a4,0x0
 834:	7cf73823          	sd	a5,2000(a4) # 1000 <freep>
 838:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 83e:	b7c1                	j	7fe <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 840:	6398                	ld	a4,0(a5)
 842:	e118                	sd	a4,0(a0)
 844:	a8a9                	j	89e <malloc+0xd6>
  hp->s.size = nu;
 846:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 84a:	0541                	addi	a0,a0,16
 84c:	efbff0ef          	jal	746 <free>
  return freep;
 850:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 854:	c12d                	beqz	a0,8b6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 856:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 858:	4798                	lw	a4,8(a5)
 85a:	02977263          	bgeu	a4,s1,87e <malloc+0xb6>
    if(p == freep)
 85e:	00093703          	ld	a4,0(s2)
 862:	853e                	mv	a0,a5
 864:	fef719e3          	bne	a4,a5,856 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 868:	8552                	mv	a0,s4
 86a:	b03ff0ef          	jal	36c <sbrk>
  if(p == (char*)-1)
 86e:	fd551ce3          	bne	a0,s5,846 <malloc+0x7e>
        return 0;
 872:	4501                	li	a0,0
 874:	7902                	ld	s2,32(sp)
 876:	6a42                	ld	s4,16(sp)
 878:	6aa2                	ld	s5,8(sp)
 87a:	6b02                	ld	s6,0(sp)
 87c:	a03d                	j	8aa <malloc+0xe2>
 87e:	7902                	ld	s2,32(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 886:	fae48de3          	beq	s1,a4,840 <malloc+0x78>
        p->s.size -= nunits;
 88a:	4137073b          	subw	a4,a4,s3
 88e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 890:	02071693          	slli	a3,a4,0x20
 894:	01c6d713          	srli	a4,a3,0x1c
 898:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 89e:	00000717          	auipc	a4,0x0
 8a2:	76a73123          	sd	a0,1890(a4) # 1000 <freep>
      return (void*)(p + 1);
 8a6:	01078513          	addi	a0,a5,16
  }
}
 8aa:	70e2                	ld	ra,56(sp)
 8ac:	7442                	ld	s0,48(sp)
 8ae:	74a2                	ld	s1,40(sp)
 8b0:	69e2                	ld	s3,24(sp)
 8b2:	6121                	addi	sp,sp,64
 8b4:	8082                	ret
 8b6:	7902                	ld	s2,32(sp)
 8b8:	6a42                	ld	s4,16(sp)
 8ba:	6aa2                	ld	s5,8(sp)
 8bc:	6b02                	ld	s6,0(sp)
 8be:	b7f5                	j	8aa <malloc+0xe2>
