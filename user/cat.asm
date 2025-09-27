
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	34c000ef          	jal	36c <read>
  24:	84aa                	mv	s1,a0
  26:	02a05363          	blez	a0,4c <cat+0x4c>
    if (write(1, buf, n) != n) {
  2a:	8626                	mv	a2,s1
  2c:	85ca                	mv	a1,s2
  2e:	4505                	li	a0,1
  30:	344000ef          	jal	374 <write>
  34:	fe9502e3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  38:	00001597          	auipc	a1,0x1
  3c:	8f858593          	addi	a1,a1,-1800 # 930 <malloc+0xf8>
  40:	4509                	li	a0,2
  42:	718000ef          	jal	75a <fprintf>
      exit(1);
  46:	4505                	li	a0,1
  48:	30c000ef          	jal	354 <exit>
    }
  }
  if(n < 0){
  4c:	00054963          	bltz	a0,5e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	addi	sp,sp,48
  5c:	8082                	ret
    fprintf(2, "cat: read error\n");
  5e:	00001597          	auipc	a1,0x1
  62:	8ea58593          	addi	a1,a1,-1814 # 948 <malloc+0x110>
  66:	4509                	li	a0,2
  68:	6f2000ef          	jal	75a <fprintf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	2e6000ef          	jal	354 <exit>

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	7179                	addi	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  7a:	4785                	li	a5,1
  7c:	04a7d263          	bge	a5,a0,c0 <main+0x4e>
  80:	ec26                	sd	s1,24(sp)
  82:	e84a                	sd	s2,16(sp)
  84:	e44e                	sd	s3,8(sp)
  86:	00858913          	addi	s2,a1,8
  8a:	ffe5099b          	addiw	s3,a0,-2
  8e:	02099793          	slli	a5,s3,0x20
  92:	01d7d993          	srli	s3,a5,0x1d
  96:	05c1                	addi	a1,a1,16
  98:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  9a:	4581                	li	a1,0
  9c:	00093503          	ld	a0,0(s2) # 1010 <buf>
  a0:	2f4000ef          	jal	394 <open>
  a4:	84aa                	mv	s1,a0
  a6:	02054663          	bltz	a0,d2 <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  aa:	f57ff0ef          	jal	0 <cat>
    close(fd);
  ae:	8526                	mv	a0,s1
  b0:	2cc000ef          	jal	37c <close>
  for(i = 1; i < argc; i++){
  b4:	0921                	addi	s2,s2,8
  b6:	ff3912e3          	bne	s2,s3,9a <main+0x28>
  }
  exit(0);
  ba:	4501                	li	a0,0
  bc:	298000ef          	jal	354 <exit>
  c0:	ec26                	sd	s1,24(sp)
  c2:	e84a                	sd	s2,16(sp)
  c4:	e44e                	sd	s3,8(sp)
    cat(0);
  c6:	4501                	li	a0,0
  c8:	f39ff0ef          	jal	0 <cat>
    exit(0);
  cc:	4501                	li	a0,0
  ce:	286000ef          	jal	354 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  d2:	00093603          	ld	a2,0(s2)
  d6:	00001597          	auipc	a1,0x1
  da:	88a58593          	addi	a1,a1,-1910 # 960 <malloc+0x128>
  de:	4509                	li	a0,2
  e0:	67a000ef          	jal	75a <fprintf>
      exit(1);
  e4:	4505                	li	a0,1
  e6:	26e000ef          	jal	354 <exit>

00000000000000ea <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e406                	sd	ra,8(sp)
  ee:	e022                	sd	s0,0(sp)
  f0:	0800                	addi	s0,sp,16
  extern int main();
  main();
  f2:	f81ff0ef          	jal	72 <main>
  exit(0);
  f6:	4501                	li	a0,0
  f8:	25c000ef          	jal	354 <exit>

00000000000000fc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 102:	87aa                	mv	a5,a0
 104:	0585                	addi	a1,a1,1
 106:	0785                	addi	a5,a5,1
 108:	fff5c703          	lbu	a4,-1(a1)
 10c:	fee78fa3          	sb	a4,-1(a5)
 110:	fb75                	bnez	a4,104 <strcpy+0x8>
    ;
  return os;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb91                	beqz	a5,136 <strcmp+0x1e>
 124:	0005c703          	lbu	a4,0(a1)
 128:	00f71763          	bne	a4,a5,136 <strcmp+0x1e>
    p++, q++;
 12c:	0505                	addi	a0,a0,1
 12e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	fbe5                	bnez	a5,124 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 136:	0005c503          	lbu	a0,0(a1)
}
 13a:	40a7853b          	subw	a0,a5,a0
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret

0000000000000144 <strlen>:

uint
strlen(const char *s)
{
 144:	1141                	addi	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 14a:	00054783          	lbu	a5,0(a0)
 14e:	cf91                	beqz	a5,16a <strlen+0x26>
 150:	0505                	addi	a0,a0,1
 152:	87aa                	mv	a5,a0
 154:	86be                	mv	a3,a5
 156:	0785                	addi	a5,a5,1
 158:	fff7c703          	lbu	a4,-1(a5)
 15c:	ff65                	bnez	a4,154 <strlen+0x10>
 15e:	40a6853b          	subw	a0,a3,a0
 162:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret
  for(n = 0; s[n]; n++)
 16a:	4501                	li	a0,0
 16c:	bfe5                	j	164 <strlen+0x20>

000000000000016e <memset>:

void*
memset(void *dst, int c, uint n)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 174:	ca19                	beqz	a2,18a <memset+0x1c>
 176:	87aa                	mv	a5,a0
 178:	1602                	slli	a2,a2,0x20
 17a:	9201                	srli	a2,a2,0x20
 17c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 180:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 184:	0785                	addi	a5,a5,1
 186:	fee79de3          	bne	a5,a4,180 <memset+0x12>
  }
  return dst;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  for(; *s; s++)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb99                	beqz	a5,1b0 <strchr+0x20>
    if(*s == c)
 19c:	00f58763          	beq	a1,a5,1aa <strchr+0x1a>
  for(; *s; s++)
 1a0:	0505                	addi	a0,a0,1
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbfd                	bnez	a5,19c <strchr+0xc>
      return (char*)s;
  return 0;
 1a8:	4501                	li	a0,0
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret
  return 0;
 1b0:	4501                	li	a0,0
 1b2:	bfe5                	j	1aa <strchr+0x1a>

00000000000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	711d                	addi	sp,sp,-96
 1b6:	ec86                	sd	ra,88(sp)
 1b8:	e8a2                	sd	s0,80(sp)
 1ba:	e4a6                	sd	s1,72(sp)
 1bc:	e0ca                	sd	s2,64(sp)
 1be:	fc4e                	sd	s3,56(sp)
 1c0:	f852                	sd	s4,48(sp)
 1c2:	f456                	sd	s5,40(sp)
 1c4:	f05a                	sd	s6,32(sp)
 1c6:	ec5e                	sd	s7,24(sp)
 1c8:	1080                	addi	s0,sp,96
 1ca:	8baa                	mv	s7,a0
 1cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	892a                	mv	s2,a0
 1d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d2:	4aa9                	li	s5,10
 1d4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d6:	89a6                	mv	s3,s1
 1d8:	2485                	addiw	s1,s1,1
 1da:	0344d663          	bge	s1,s4,206 <gets+0x52>
    cc = read(0, &c, 1);
 1de:	4605                	li	a2,1
 1e0:	faf40593          	addi	a1,s0,-81
 1e4:	4501                	li	a0,0
 1e6:	186000ef          	jal	36c <read>
    if(cc < 1)
 1ea:	00a05e63          	blez	a0,206 <gets+0x52>
    buf[i++] = c;
 1ee:	faf44783          	lbu	a5,-81(s0)
 1f2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f6:	01578763          	beq	a5,s5,204 <gets+0x50>
 1fa:	0905                	addi	s2,s2,1
 1fc:	fd679de3          	bne	a5,s6,1d6 <gets+0x22>
    buf[i++] = c;
 200:	89a6                	mv	s3,s1
 202:	a011                	j	206 <gets+0x52>
 204:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 206:	99de                	add	s3,s3,s7
 208:	00098023          	sb	zero,0(s3)
  return buf;
}
 20c:	855e                	mv	a0,s7
 20e:	60e6                	ld	ra,88(sp)
 210:	6446                	ld	s0,80(sp)
 212:	64a6                	ld	s1,72(sp)
 214:	6906                	ld	s2,64(sp)
 216:	79e2                	ld	s3,56(sp)
 218:	7a42                	ld	s4,48(sp)
 21a:	7aa2                	ld	s5,40(sp)
 21c:	7b02                	ld	s6,32(sp)
 21e:	6be2                	ld	s7,24(sp)
 220:	6125                	addi	sp,sp,96
 222:	8082                	ret

0000000000000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	1000                	addi	s0,sp,32
 22e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 230:	4581                	li	a1,0
 232:	162000ef          	jal	394 <open>
  if(fd < 0)
 236:	02054263          	bltz	a0,25a <stat+0x36>
 23a:	e426                	sd	s1,8(sp)
 23c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23e:	85ca                	mv	a1,s2
 240:	16c000ef          	jal	3ac <fstat>
 244:	892a                	mv	s2,a0
  close(fd);
 246:	8526                	mv	a0,s1
 248:	134000ef          	jal	37c <close>
  return r;
 24c:	64a2                	ld	s1,8(sp)
}
 24e:	854a                	mv	a0,s2
 250:	60e2                	ld	ra,24(sp)
 252:	6442                	ld	s0,16(sp)
 254:	6902                	ld	s2,0(sp)
 256:	6105                	addi	sp,sp,32
 258:	8082                	ret
    return -1;
 25a:	597d                	li	s2,-1
 25c:	bfcd                	j	24e <stat+0x2a>

000000000000025e <atoi>:

int
atoi(const char *s)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 264:	00054683          	lbu	a3,0(a0)
 268:	fd06879b          	addiw	a5,a3,-48
 26c:	0ff7f793          	zext.b	a5,a5
 270:	4625                	li	a2,9
 272:	02f66863          	bltu	a2,a5,2a2 <atoi+0x44>
 276:	872a                	mv	a4,a0
  n = 0;
 278:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 27a:	0705                	addi	a4,a4,1
 27c:	0025179b          	slliw	a5,a0,0x2
 280:	9fa9                	addw	a5,a5,a0
 282:	0017979b          	slliw	a5,a5,0x1
 286:	9fb5                	addw	a5,a5,a3
 288:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 28c:	00074683          	lbu	a3,0(a4)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	fef671e3          	bgeu	a2,a5,27a <atoi+0x1c>
  return n;
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
  n = 0;
 2a2:	4501                	li	a0,0
 2a4:	bfe5                	j	29c <atoi+0x3e>

00000000000002a6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ac:	02b57463          	bgeu	a0,a1,2d4 <memmove+0x2e>
    while(n-- > 0)
 2b0:	00c05f63          	blez	a2,2ce <memmove+0x28>
 2b4:	1602                	slli	a2,a2,0x20
 2b6:	9201                	srli	a2,a2,0x20
 2b8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2bc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2be:	0585                	addi	a1,a1,1
 2c0:	0705                	addi	a4,a4,1
 2c2:	fff5c683          	lbu	a3,-1(a1)
 2c6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ca:	fef71ae3          	bne	a4,a5,2be <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
    dst += n;
 2d4:	00c50733          	add	a4,a0,a2
    src += n;
 2d8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2da:	fec05ae3          	blez	a2,2ce <memmove+0x28>
 2de:	fff6079b          	addiw	a5,a2,-1
 2e2:	1782                	slli	a5,a5,0x20
 2e4:	9381                	srli	a5,a5,0x20
 2e6:	fff7c793          	not	a5,a5
 2ea:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ec:	15fd                	addi	a1,a1,-1
 2ee:	177d                	addi	a4,a4,-1
 2f0:	0005c683          	lbu	a3,0(a1)
 2f4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f8:	fee79ae3          	bne	a5,a4,2ec <memmove+0x46>
 2fc:	bfc9                	j	2ce <memmove+0x28>

00000000000002fe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 304:	ca05                	beqz	a2,334 <memcmp+0x36>
 306:	fff6069b          	addiw	a3,a2,-1
 30a:	1682                	slli	a3,a3,0x20
 30c:	9281                	srli	a3,a3,0x20
 30e:	0685                	addi	a3,a3,1
 310:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 312:	00054783          	lbu	a5,0(a0)
 316:	0005c703          	lbu	a4,0(a1)
 31a:	00e79863          	bne	a5,a4,32a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 31e:	0505                	addi	a0,a0,1
    p2++;
 320:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 322:	fed518e3          	bne	a0,a3,312 <memcmp+0x14>
  }
  return 0;
 326:	4501                	li	a0,0
 328:	a019                	j	32e <memcmp+0x30>
      return *p1 - *p2;
 32a:	40e7853b          	subw	a0,a5,a4
}
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret
  return 0;
 334:	4501                	li	a0,0
 336:	bfe5                	j	32e <memcmp+0x30>

0000000000000338 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 340:	f67ff0ef          	jal	2a6 <memmove>
}
 344:	60a2                	ld	ra,8(sp)
 346:	6402                	ld	s0,0(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 34c:	4885                	li	a7,1
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <exit>:
.global exit
exit:
 li a7, SYS_exit
 354:	4889                	li	a7,2
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <wait>:
.global wait
wait:
 li a7, SYS_wait
 35c:	488d                	li	a7,3
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 364:	4891                	li	a7,4
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <read>:
.global read
read:
 li a7, SYS_read
 36c:	4895                	li	a7,5
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <write>:
.global write
write:
 li a7, SYS_write
 374:	48c1                	li	a7,16
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <close>:
.global close
close:
 li a7, SYS_close
 37c:	48d5                	li	a7,21
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <kill>:
.global kill
kill:
 li a7, SYS_kill
 384:	4899                	li	a7,6
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <exec>:
.global exec
exec:
 li a7, SYS_exec
 38c:	489d                	li	a7,7
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <open>:
.global open
open:
 li a7, SYS_open
 394:	48bd                	li	a7,15
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 39c:	48c5                	li	a7,17
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a4:	48c9                	li	a7,18
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ac:	48a1                	li	a7,8
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <link>:
.global link
link:
 li a7, SYS_link
 3b4:	48cd                	li	a7,19
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3bc:	48d1                	li	a7,20
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c4:	48a5                	li	a7,9
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3cc:	48a9                	li	a7,10
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d4:	48ad                	li	a7,11
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3dc:	48b1                	li	a7,12
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3e4:	48b5                	li	a7,13
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ec:	48b9                	li	a7,14
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <get_context_switches>:
.global get_context_switches
get_context_switches:
 li a7, SYS_get_context_switches
 3f4:	48d9                	li	a7,22
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <get_tick_rate>:
.global get_tick_rate
 get_tick_rate:
 li a7, SYS_get_tick_rate
 3fc:	48dd                	li	a7,23
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <get_total_ticks>:
 .global get_total_ticks
 get_total_ticks:
 li a7, SYS_get_total_ticks
 404:	48e1                	li	a7,24
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40c:	1101                	addi	sp,sp,-32
 40e:	ec06                	sd	ra,24(sp)
 410:	e822                	sd	s0,16(sp)
 412:	1000                	addi	s0,sp,32
 414:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 418:	4605                	li	a2,1
 41a:	fef40593          	addi	a1,s0,-17
 41e:	f57ff0ef          	jal	374 <write>
}
 422:	60e2                	ld	ra,24(sp)
 424:	6442                	ld	s0,16(sp)
 426:	6105                	addi	sp,sp,32
 428:	8082                	ret

000000000000042a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42a:	7139                	addi	sp,sp,-64
 42c:	fc06                	sd	ra,56(sp)
 42e:	f822                	sd	s0,48(sp)
 430:	f426                	sd	s1,40(sp)
 432:	0080                	addi	s0,sp,64
 434:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 436:	c299                	beqz	a3,43c <printint+0x12>
 438:	0805c963          	bltz	a1,4ca <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43c:	2581                	sext.w	a1,a1
  neg = 0;
 43e:	4881                	li	a7,0
 440:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 444:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 446:	2601                	sext.w	a2,a2
 448:	00000517          	auipc	a0,0x0
 44c:	53850513          	addi	a0,a0,1336 # 980 <digits>
 450:	883a                	mv	a6,a4
 452:	2705                	addiw	a4,a4,1
 454:	02c5f7bb          	remuw	a5,a1,a2
 458:	1782                	slli	a5,a5,0x20
 45a:	9381                	srli	a5,a5,0x20
 45c:	97aa                	add	a5,a5,a0
 45e:	0007c783          	lbu	a5,0(a5)
 462:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 466:	0005879b          	sext.w	a5,a1
 46a:	02c5d5bb          	divuw	a1,a1,a2
 46e:	0685                	addi	a3,a3,1
 470:	fec7f0e3          	bgeu	a5,a2,450 <printint+0x26>
  if(neg)
 474:	00088c63          	beqz	a7,48c <printint+0x62>
    buf[i++] = '-';
 478:	fd070793          	addi	a5,a4,-48
 47c:	00878733          	add	a4,a5,s0
 480:	02d00793          	li	a5,45
 484:	fef70823          	sb	a5,-16(a4)
 488:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 48c:	02e05a63          	blez	a4,4c0 <printint+0x96>
 490:	f04a                	sd	s2,32(sp)
 492:	ec4e                	sd	s3,24(sp)
 494:	fc040793          	addi	a5,s0,-64
 498:	00e78933          	add	s2,a5,a4
 49c:	fff78993          	addi	s3,a5,-1
 4a0:	99ba                	add	s3,s3,a4
 4a2:	377d                	addiw	a4,a4,-1
 4a4:	1702                	slli	a4,a4,0x20
 4a6:	9301                	srli	a4,a4,0x20
 4a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ac:	fff94583          	lbu	a1,-1(s2)
 4b0:	8526                	mv	a0,s1
 4b2:	f5bff0ef          	jal	40c <putc>
  while(--i >= 0)
 4b6:	197d                	addi	s2,s2,-1
 4b8:	ff391ae3          	bne	s2,s3,4ac <printint+0x82>
 4bc:	7902                	ld	s2,32(sp)
 4be:	69e2                	ld	s3,24(sp)
}
 4c0:	70e2                	ld	ra,56(sp)
 4c2:	7442                	ld	s0,48(sp)
 4c4:	74a2                	ld	s1,40(sp)
 4c6:	6121                	addi	sp,sp,64
 4c8:	8082                	ret
    x = -xx;
 4ca:	40b005bb          	negw	a1,a1
    neg = 1;
 4ce:	4885                	li	a7,1
    x = -xx;
 4d0:	bf85                	j	440 <printint+0x16>

00000000000004d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d2:	711d                	addi	sp,sp,-96
 4d4:	ec86                	sd	ra,88(sp)
 4d6:	e8a2                	sd	s0,80(sp)
 4d8:	e0ca                	sd	s2,64(sp)
 4da:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4dc:	0005c903          	lbu	s2,0(a1)
 4e0:	26090863          	beqz	s2,750 <vprintf+0x27e>
 4e4:	e4a6                	sd	s1,72(sp)
 4e6:	fc4e                	sd	s3,56(sp)
 4e8:	f852                	sd	s4,48(sp)
 4ea:	f456                	sd	s5,40(sp)
 4ec:	f05a                	sd	s6,32(sp)
 4ee:	ec5e                	sd	s7,24(sp)
 4f0:	e862                	sd	s8,16(sp)
 4f2:	e466                	sd	s9,8(sp)
 4f4:	8b2a                	mv	s6,a0
 4f6:	8a2e                	mv	s4,a1
 4f8:	8bb2                	mv	s7,a2
  state = 0;
 4fa:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4fc:	4481                	li	s1,0
 4fe:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 500:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 504:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 508:	06c00c93          	li	s9,108
 50c:	a005                	j	52c <vprintf+0x5a>
        putc(fd, c0);
 50e:	85ca                	mv	a1,s2
 510:	855a                	mv	a0,s6
 512:	efbff0ef          	jal	40c <putc>
 516:	a019                	j	51c <vprintf+0x4a>
    } else if(state == '%'){
 518:	03598263          	beq	s3,s5,53c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 51c:	2485                	addiw	s1,s1,1
 51e:	8726                	mv	a4,s1
 520:	009a07b3          	add	a5,s4,s1
 524:	0007c903          	lbu	s2,0(a5)
 528:	20090c63          	beqz	s2,740 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 52c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 530:	fe0994e3          	bnez	s3,518 <vprintf+0x46>
      if(c0 == '%'){
 534:	fd579de3          	bne	a5,s5,50e <vprintf+0x3c>
        state = '%';
 538:	89be                	mv	s3,a5
 53a:	b7cd                	j	51c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 53c:	00ea06b3          	add	a3,s4,a4
 540:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 544:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 546:	c681                	beqz	a3,54e <vprintf+0x7c>
 548:	9752                	add	a4,a4,s4
 54a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 54e:	03878f63          	beq	a5,s8,58c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 552:	05978963          	beq	a5,s9,5a4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 556:	07500713          	li	a4,117
 55a:	0ee78363          	beq	a5,a4,640 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 55e:	07800713          	li	a4,120
 562:	12e78563          	beq	a5,a4,68c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 566:	07000713          	li	a4,112
 56a:	14e78a63          	beq	a5,a4,6be <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 56e:	07300713          	li	a4,115
 572:	18e78a63          	beq	a5,a4,706 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 576:	02500713          	li	a4,37
 57a:	04e79563          	bne	a5,a4,5c4 <vprintf+0xf2>
        putc(fd, '%');
 57e:	02500593          	li	a1,37
 582:	855a                	mv	a0,s6
 584:	e89ff0ef          	jal	40c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 588:	4981                	li	s3,0
 58a:	bf49                	j	51c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 58c:	008b8913          	addi	s2,s7,8
 590:	4685                	li	a3,1
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e91ff0ef          	jal	42a <printint>
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	bfad                	j	51c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5a4:	06400793          	li	a5,100
 5a8:	02f68963          	beq	a3,a5,5da <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ac:	06c00793          	li	a5,108
 5b0:	04f68263          	beq	a3,a5,5f4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5b4:	07500793          	li	a5,117
 5b8:	0af68063          	beq	a3,a5,658 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5bc:	07800793          	li	a5,120
 5c0:	0ef68263          	beq	a3,a5,6a4 <vprintf+0x1d2>
        putc(fd, '%');
 5c4:	02500593          	li	a1,37
 5c8:	855a                	mv	a0,s6
 5ca:	e43ff0ef          	jal	40c <putc>
        putc(fd, c0);
 5ce:	85ca                	mv	a1,s2
 5d0:	855a                	mv	a0,s6
 5d2:	e3bff0ef          	jal	40c <putc>
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b791                	j	51c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5da:	008b8913          	addi	s2,s7,8
 5de:	4685                	li	a3,1
 5e0:	4629                	li	a2,10
 5e2:	000ba583          	lw	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	e43ff0ef          	jal	42a <printint>
        i += 1;
 5ec:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
        i += 1;
 5f2:	b72d                	j	51c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f4:	06400793          	li	a5,100
 5f8:	02f60763          	beq	a2,a5,626 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5fc:	07500793          	li	a5,117
 600:	06f60963          	beq	a2,a5,672 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 604:	07800793          	li	a5,120
 608:	faf61ee3          	bne	a2,a5,5c4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 60c:	008b8913          	addi	s2,s7,8
 610:	4681                	li	a3,0
 612:	4641                	li	a2,16
 614:	000ba583          	lw	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	e11ff0ef          	jal	42a <printint>
        i += 2;
 61e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 620:	8bca                	mv	s7,s2
      state = 0;
 622:	4981                	li	s3,0
        i += 2;
 624:	bde5                	j	51c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 626:	008b8913          	addi	s2,s7,8
 62a:	4685                	li	a3,1
 62c:	4629                	li	a2,10
 62e:	000ba583          	lw	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	df7ff0ef          	jal	42a <printint>
        i += 2;
 638:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
        i += 2;
 63e:	bdf9                	j	51c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 640:	008b8913          	addi	s2,s7,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000ba583          	lw	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	dddff0ef          	jal	42a <printint>
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	b5d9                	j	51c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 658:	008b8913          	addi	s2,s7,8
 65c:	4681                	li	a3,0
 65e:	4629                	li	a2,10
 660:	000ba583          	lw	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	dc5ff0ef          	jal	42a <printint>
        i += 1;
 66a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 66c:	8bca                	mv	s7,s2
      state = 0;
 66e:	4981                	li	s3,0
        i += 1;
 670:	b575                	j	51c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 672:	008b8913          	addi	s2,s7,8
 676:	4681                	li	a3,0
 678:	4629                	li	a2,10
 67a:	000ba583          	lw	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	dabff0ef          	jal	42a <printint>
        i += 2;
 684:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
        i += 2;
 68a:	bd49                	j	51c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 68c:	008b8913          	addi	s2,s7,8
 690:	4681                	li	a3,0
 692:	4641                	li	a2,16
 694:	000ba583          	lw	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	d91ff0ef          	jal	42a <printint>
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bdad                	j	51c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4641                	li	a2,16
 6ac:	000ba583          	lw	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	d79ff0ef          	jal	42a <printint>
        i += 1;
 6b6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
        i += 1;
 6bc:	b585                	j	51c <vprintf+0x4a>
 6be:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6c0:	008b8d13          	addi	s10,s7,8
 6c4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6c8:	03000593          	li	a1,48
 6cc:	855a                	mv	a0,s6
 6ce:	d3fff0ef          	jal	40c <putc>
  putc(fd, 'x');
 6d2:	07800593          	li	a1,120
 6d6:	855a                	mv	a0,s6
 6d8:	d35ff0ef          	jal	40c <putc>
 6dc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6de:	00000b97          	auipc	s7,0x0
 6e2:	2a2b8b93          	addi	s7,s7,674 # 980 <digits>
 6e6:	03c9d793          	srli	a5,s3,0x3c
 6ea:	97de                	add	a5,a5,s7
 6ec:	0007c583          	lbu	a1,0(a5)
 6f0:	855a                	mv	a0,s6
 6f2:	d1bff0ef          	jal	40c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f6:	0992                	slli	s3,s3,0x4
 6f8:	397d                	addiw	s2,s2,-1
 6fa:	fe0916e3          	bnez	s2,6e6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6fe:	8bea                	mv	s7,s10
      state = 0;
 700:	4981                	li	s3,0
 702:	6d02                	ld	s10,0(sp)
 704:	bd21                	j	51c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 706:	008b8993          	addi	s3,s7,8
 70a:	000bb903          	ld	s2,0(s7)
 70e:	00090f63          	beqz	s2,72c <vprintf+0x25a>
        for(; *s; s++)
 712:	00094583          	lbu	a1,0(s2)
 716:	c195                	beqz	a1,73a <vprintf+0x268>
          putc(fd, *s);
 718:	855a                	mv	a0,s6
 71a:	cf3ff0ef          	jal	40c <putc>
        for(; *s; s++)
 71e:	0905                	addi	s2,s2,1
 720:	00094583          	lbu	a1,0(s2)
 724:	f9f5                	bnez	a1,718 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 726:	8bce                	mv	s7,s3
      state = 0;
 728:	4981                	li	s3,0
 72a:	bbcd                	j	51c <vprintf+0x4a>
          s = "(null)";
 72c:	00000917          	auipc	s2,0x0
 730:	24c90913          	addi	s2,s2,588 # 978 <malloc+0x140>
        for(; *s; s++)
 734:	02800593          	li	a1,40
 738:	b7c5                	j	718 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 73a:	8bce                	mv	s7,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bbf9                	j	51c <vprintf+0x4a>
 740:	64a6                	ld	s1,72(sp)
 742:	79e2                	ld	s3,56(sp)
 744:	7a42                	ld	s4,48(sp)
 746:	7aa2                	ld	s5,40(sp)
 748:	7b02                	ld	s6,32(sp)
 74a:	6be2                	ld	s7,24(sp)
 74c:	6c42                	ld	s8,16(sp)
 74e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 750:	60e6                	ld	ra,88(sp)
 752:	6446                	ld	s0,80(sp)
 754:	6906                	ld	s2,64(sp)
 756:	6125                	addi	sp,sp,96
 758:	8082                	ret

000000000000075a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75a:	715d                	addi	sp,sp,-80
 75c:	ec06                	sd	ra,24(sp)
 75e:	e822                	sd	s0,16(sp)
 760:	1000                	addi	s0,sp,32
 762:	e010                	sd	a2,0(s0)
 764:	e414                	sd	a3,8(s0)
 766:	e818                	sd	a4,16(s0)
 768:	ec1c                	sd	a5,24(s0)
 76a:	03043023          	sd	a6,32(s0)
 76e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 772:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 776:	8622                	mv	a2,s0
 778:	d5bff0ef          	jal	4d2 <vprintf>
}
 77c:	60e2                	ld	ra,24(sp)
 77e:	6442                	ld	s0,16(sp)
 780:	6161                	addi	sp,sp,80
 782:	8082                	ret

0000000000000784 <printf>:

void
printf(const char *fmt, ...)
{
 784:	711d                	addi	sp,sp,-96
 786:	ec06                	sd	ra,24(sp)
 788:	e822                	sd	s0,16(sp)
 78a:	1000                	addi	s0,sp,32
 78c:	e40c                	sd	a1,8(s0)
 78e:	e810                	sd	a2,16(s0)
 790:	ec14                	sd	a3,24(s0)
 792:	f018                	sd	a4,32(s0)
 794:	f41c                	sd	a5,40(s0)
 796:	03043823          	sd	a6,48(s0)
 79a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 79e:	00840613          	addi	a2,s0,8
 7a2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a6:	85aa                	mv	a1,a0
 7a8:	4505                	li	a0,1
 7aa:	d29ff0ef          	jal	4d2 <vprintf>
}
 7ae:	60e2                	ld	ra,24(sp)
 7b0:	6442                	ld	s0,16(sp)
 7b2:	6125                	addi	sp,sp,96
 7b4:	8082                	ret

00000000000007b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b6:	1141                	addi	sp,sp,-16
 7b8:	e422                	sd	s0,8(sp)
 7ba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7bc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c0:	00001797          	auipc	a5,0x1
 7c4:	8407b783          	ld	a5,-1984(a5) # 1000 <freep>
 7c8:	a02d                	j	7f2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ca:	4618                	lw	a4,8(a2)
 7cc:	9f2d                	addw	a4,a4,a1
 7ce:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d2:	6398                	ld	a4,0(a5)
 7d4:	6310                	ld	a2,0(a4)
 7d6:	a83d                	j	814 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d8:	ff852703          	lw	a4,-8(a0)
 7dc:	9f31                	addw	a4,a4,a2
 7de:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7e0:	ff053683          	ld	a3,-16(a0)
 7e4:	a091                	j	828 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e6:	6398                	ld	a4,0(a5)
 7e8:	00e7e463          	bltu	a5,a4,7f0 <free+0x3a>
 7ec:	00e6ea63          	bltu	a3,a4,800 <free+0x4a>
{
 7f0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f2:	fed7fae3          	bgeu	a5,a3,7e6 <free+0x30>
 7f6:	6398                	ld	a4,0(a5)
 7f8:	00e6e463          	bltu	a3,a4,800 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fc:	fee7eae3          	bltu	a5,a4,7f0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 800:	ff852583          	lw	a1,-8(a0)
 804:	6390                	ld	a2,0(a5)
 806:	02059813          	slli	a6,a1,0x20
 80a:	01c85713          	srli	a4,a6,0x1c
 80e:	9736                	add	a4,a4,a3
 810:	fae60de3          	beq	a2,a4,7ca <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 814:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 818:	4790                	lw	a2,8(a5)
 81a:	02061593          	slli	a1,a2,0x20
 81e:	01c5d713          	srli	a4,a1,0x1c
 822:	973e                	add	a4,a4,a5
 824:	fae68ae3          	beq	a3,a4,7d8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 828:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 82a:	00000717          	auipc	a4,0x0
 82e:	7cf73b23          	sd	a5,2006(a4) # 1000 <freep>
}
 832:	6422                	ld	s0,8(sp)
 834:	0141                	addi	sp,sp,16
 836:	8082                	ret

0000000000000838 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 838:	7139                	addi	sp,sp,-64
 83a:	fc06                	sd	ra,56(sp)
 83c:	f822                	sd	s0,48(sp)
 83e:	f426                	sd	s1,40(sp)
 840:	ec4e                	sd	s3,24(sp)
 842:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 844:	02051493          	slli	s1,a0,0x20
 848:	9081                	srli	s1,s1,0x20
 84a:	04bd                	addi	s1,s1,15
 84c:	8091                	srli	s1,s1,0x4
 84e:	0014899b          	addiw	s3,s1,1
 852:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 854:	00000517          	auipc	a0,0x0
 858:	7ac53503          	ld	a0,1964(a0) # 1000 <freep>
 85c:	c915                	beqz	a0,890 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 860:	4798                	lw	a4,8(a5)
 862:	08977a63          	bgeu	a4,s1,8f6 <malloc+0xbe>
 866:	f04a                	sd	s2,32(sp)
 868:	e852                	sd	s4,16(sp)
 86a:	e456                	sd	s5,8(sp)
 86c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 86e:	8a4e                	mv	s4,s3
 870:	0009871b          	sext.w	a4,s3
 874:	6685                	lui	a3,0x1
 876:	00d77363          	bgeu	a4,a3,87c <malloc+0x44>
 87a:	6a05                	lui	s4,0x1
 87c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 880:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 884:	00000917          	auipc	s2,0x0
 888:	77c90913          	addi	s2,s2,1916 # 1000 <freep>
  if(p == (char*)-1)
 88c:	5afd                	li	s5,-1
 88e:	a081                	j	8ce <malloc+0x96>
 890:	f04a                	sd	s2,32(sp)
 892:	e852                	sd	s4,16(sp)
 894:	e456                	sd	s5,8(sp)
 896:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 898:	00001797          	auipc	a5,0x1
 89c:	97878793          	addi	a5,a5,-1672 # 1210 <base>
 8a0:	00000717          	auipc	a4,0x0
 8a4:	76f73023          	sd	a5,1888(a4) # 1000 <freep>
 8a8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8aa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ae:	b7c1                	j	86e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8b0:	6398                	ld	a4,0(a5)
 8b2:	e118                	sd	a4,0(a0)
 8b4:	a8a9                	j	90e <malloc+0xd6>
  hp->s.size = nu;
 8b6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ba:	0541                	addi	a0,a0,16
 8bc:	efbff0ef          	jal	7b6 <free>
  return freep;
 8c0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c4:	c12d                	beqz	a0,926 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c8:	4798                	lw	a4,8(a5)
 8ca:	02977263          	bgeu	a4,s1,8ee <malloc+0xb6>
    if(p == freep)
 8ce:	00093703          	ld	a4,0(s2)
 8d2:	853e                	mv	a0,a5
 8d4:	fef719e3          	bne	a4,a5,8c6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8d8:	8552                	mv	a0,s4
 8da:	b03ff0ef          	jal	3dc <sbrk>
  if(p == (char*)-1)
 8de:	fd551ce3          	bne	a0,s5,8b6 <malloc+0x7e>
        return 0;
 8e2:	4501                	li	a0,0
 8e4:	7902                	ld	s2,32(sp)
 8e6:	6a42                	ld	s4,16(sp)
 8e8:	6aa2                	ld	s5,8(sp)
 8ea:	6b02                	ld	s6,0(sp)
 8ec:	a03d                	j	91a <malloc+0xe2>
 8ee:	7902                	ld	s2,32(sp)
 8f0:	6a42                	ld	s4,16(sp)
 8f2:	6aa2                	ld	s5,8(sp)
 8f4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f6:	fae48de3          	beq	s1,a4,8b0 <malloc+0x78>
        p->s.size -= nunits;
 8fa:	4137073b          	subw	a4,a4,s3
 8fe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 900:	02071693          	slli	a3,a4,0x20
 904:	01c6d713          	srli	a4,a3,0x1c
 908:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 90e:	00000717          	auipc	a4,0x0
 912:	6ea73923          	sd	a0,1778(a4) # 1000 <freep>
      return (void*)(p + 1);
 916:	01078513          	addi	a0,a5,16
  }
}
 91a:	70e2                	ld	ra,56(sp)
 91c:	7442                	ld	s0,48(sp)
 91e:	74a2                	ld	s1,40(sp)
 920:	69e2                	ld	s3,24(sp)
 922:	6121                	addi	sp,sp,64
 924:	8082                	ret
 926:	7902                	ld	s2,32(sp)
 928:	6a42                	ld	s4,16(sp)
 92a:	6aa2                	ld	s5,8(sp)
 92c:	6b02                	ld	s6,0(sp)
 92e:	b7f5                	j	91a <malloc+0xe2>
