
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
   8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
   c:	4605                	li	a2,1
   e:	fef40593          	addi	a1,s0,-17
  12:	79e000ef          	jal	7b0 <write>
}
  16:	60e2                	ld	ra,24(sp)
  18:	6442                	ld	s0,16(sp)
  1a:	6105                	addi	sp,sp,32
  1c:	8082                	ret

000000000000001e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
  1e:	7139                	addi	sp,sp,-64
  20:	fc06                	sd	ra,56(sp)
  22:	f822                	sd	s0,48(sp)
  24:	f426                	sd	s1,40(sp)
  26:	0080                	addi	s0,sp,64
  28:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
  2a:	c299                	beqz	a3,30 <printint+0x12>
  2c:	0805c963          	bltz	a1,be <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
  30:	2581                	sext.w	a1,a1
  neg = 0;
  32:	4881                	li	a7,0
  34:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
  38:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
  3a:	2601                	sext.w	a2,a2
  3c:	00001517          	auipc	a0,0x1
  40:	90450513          	addi	a0,a0,-1788 # 940 <digits>
  44:	883a                	mv	a6,a4
  46:	2705                	addiw	a4,a4,1
  48:	02c5f7bb          	remuw	a5,a1,a2
  4c:	1782                	slli	a5,a5,0x20
  4e:	9381                	srli	a5,a5,0x20
  50:	97aa                	add	a5,a5,a0
  52:	0007c783          	lbu	a5,0(a5)
  56:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
  5a:	0005879b          	sext.w	a5,a1
  5e:	02c5d5bb          	divuw	a1,a1,a2
  62:	0685                	addi	a3,a3,1
  64:	fec7f0e3          	bgeu	a5,a2,44 <printint+0x26>
  if(neg)
  68:	00088c63          	beqz	a7,80 <printint+0x62>
    buf[i++] = '-';
  6c:	fd070793          	addi	a5,a4,-48
  70:	00878733          	add	a4,a5,s0
  74:	02d00793          	li	a5,45
  78:	fef70823          	sb	a5,-16(a4)
  7c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
  80:	02e05a63          	blez	a4,b4 <printint+0x96>
  84:	f04a                	sd	s2,32(sp)
  86:	ec4e                	sd	s3,24(sp)
  88:	fc040793          	addi	a5,s0,-64
  8c:	00e78933          	add	s2,a5,a4
  90:	fff78993          	addi	s3,a5,-1
  94:	99ba                	add	s3,s3,a4
  96:	377d                	addiw	a4,a4,-1
  98:	1702                	slli	a4,a4,0x20
  9a:	9301                	srli	a4,a4,0x20
  9c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
  a0:	fff94583          	lbu	a1,-1(s2)
  a4:	8526                	mv	a0,s1
  a6:	f5bff0ef          	jal	0 <putc>
  while(--i >= 0)
  aa:	197d                	addi	s2,s2,-1
  ac:	ff391ae3          	bne	s2,s3,a0 <printint+0x82>
  b0:	7902                	ld	s2,32(sp)
  b2:	69e2                	ld	s3,24(sp)
}
  b4:	70e2                	ld	ra,56(sp)
  b6:	7442                	ld	s0,48(sp)
  b8:	74a2                	ld	s1,40(sp)
  ba:	6121                	addi	sp,sp,64
  bc:	8082                	ret
    x = -xx;
  be:	40b005bb          	negw	a1,a1
    neg = 1;
  c2:	4885                	li	a7,1
    x = -xx;
  c4:	bf85                	j	34 <printint+0x16>

00000000000000c6 <print>:
{
  c6:	1101                	addi	sp,sp,-32
  c8:	ec06                	sd	ra,24(sp)
  ca:	e822                	sd	s0,16(sp)
  cc:	e426                	sd	s1,8(sp)
  ce:	1000                	addi	s0,sp,32
  d0:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
  d2:	4ae000ef          	jal	580 <strlen>
  d6:	0005061b          	sext.w	a2,a0
  da:	85a6                	mv	a1,s1
  dc:	4505                	li	a0,1
  de:	6d2000ef          	jal	7b0 <write>
}
  e2:	60e2                	ld	ra,24(sp)
  e4:	6442                	ld	s0,16(sp)
  e6:	64a2                	ld	s1,8(sp)
  e8:	6105                	addi	sp,sp,32
  ea:	8082                	ret

00000000000000ec <forktest>:
{
  ec:	1101                	addi	sp,sp,-32
  ee:	ec06                	sd	ra,24(sp)
  f0:	e822                	sd	s0,16(sp)
  f2:	e426                	sd	s1,8(sp)
  f4:	e04a                	sd	s2,0(sp)
  f6:	1000                	addi	s0,sp,32
  print("fork test\n");
  f8:	00000517          	auipc	a0,0x0
  fc:	75050513          	addi	a0,a0,1872 # 848 <get_total_ticks+0x8>
 100:	fc7ff0ef          	jal	c6 <print>
  for(n=0; n<N; n++){
 104:	4481                	li	s1,0
 106:	3e800913          	li	s2,1000
    pid = fork();
 10a:	67e000ef          	jal	788 <fork>
    if(pid < 0)
 10e:	04054363          	bltz	a0,154 <forktest+0x68>
    if(pid == 0)
 112:	cd09                	beqz	a0,12c <forktest+0x40>
  for(n=0; n<N; n++){
 114:	2485                	addiw	s1,s1,1
 116:	ff249ae3          	bne	s1,s2,10a <forktest+0x1e>
    print("fork claimed to work N times!\n");
 11a:	00000517          	auipc	a0,0x0
 11e:	77e50513          	addi	a0,a0,1918 # 898 <get_total_ticks+0x58>
 122:	fa5ff0ef          	jal	c6 <print>
    exit(1);
 126:	4505                	li	a0,1
 128:	668000ef          	jal	790 <exit>
      exit(0);
 12c:	664000ef          	jal	790 <exit>
      print("wait stopped early\n");
 130:	00000517          	auipc	a0,0x0
 134:	72850513          	addi	a0,a0,1832 # 858 <get_total_ticks+0x18>
 138:	f8fff0ef          	jal	c6 <print>
      exit(1);
 13c:	4505                	li	a0,1
 13e:	652000ef          	jal	790 <exit>
    print("wait got too many\n");
 142:	00000517          	auipc	a0,0x0
 146:	72e50513          	addi	a0,a0,1838 # 870 <get_total_ticks+0x30>
 14a:	f7dff0ef          	jal	c6 <print>
    exit(1);
 14e:	4505                	li	a0,1
 150:	640000ef          	jal	790 <exit>
  for(; n > 0; n--){
 154:	00905963          	blez	s1,166 <forktest+0x7a>
    if(wait(0) < 0){
 158:	4501                	li	a0,0
 15a:	63e000ef          	jal	798 <wait>
 15e:	fc0549e3          	bltz	a0,130 <forktest+0x44>
  for(; n > 0; n--){
 162:	34fd                	addiw	s1,s1,-1
 164:	f8f5                	bnez	s1,158 <forktest+0x6c>
  if(wait(0) != -1){
 166:	4501                	li	a0,0
 168:	630000ef          	jal	798 <wait>
 16c:	57fd                	li	a5,-1
 16e:	fcf51ae3          	bne	a0,a5,142 <forktest+0x56>
  print("fork test OK\n");
 172:	00000517          	auipc	a0,0x0
 176:	71650513          	addi	a0,a0,1814 # 888 <get_total_ticks+0x48>
 17a:	f4dff0ef          	jal	c6 <print>
}
 17e:	60e2                	ld	ra,24(sp)
 180:	6442                	ld	s0,16(sp)
 182:	64a2                	ld	s1,8(sp)
 184:	6902                	ld	s2,0(sp)
 186:	6105                	addi	sp,sp,32
 188:	8082                	ret

000000000000018a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 18a:	711d                	addi	sp,sp,-96
 18c:	ec86                	sd	ra,88(sp)
 18e:	e8a2                	sd	s0,80(sp)
 190:	e0ca                	sd	s2,64(sp)
 192:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 194:	0005c903          	lbu	s2,0(a1)
 198:	26090863          	beqz	s2,408 <vprintf+0x27e>
 19c:	e4a6                	sd	s1,72(sp)
 19e:	fc4e                	sd	s3,56(sp)
 1a0:	f852                	sd	s4,48(sp)
 1a2:	f456                	sd	s5,40(sp)
 1a4:	f05a                	sd	s6,32(sp)
 1a6:	ec5e                	sd	s7,24(sp)
 1a8:	e862                	sd	s8,16(sp)
 1aa:	e466                	sd	s9,8(sp)
 1ac:	8b2a                	mv	s6,a0
 1ae:	8a2e                	mv	s4,a1
 1b0:	8bb2                	mv	s7,a2
  state = 0;
 1b2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 1b4:	4481                	li	s1,0
 1b6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 1b8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 1bc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 1c0:	06c00c93          	li	s9,108
 1c4:	a005                	j	1e4 <vprintf+0x5a>
        putc(fd, c0);
 1c6:	85ca                	mv	a1,s2
 1c8:	855a                	mv	a0,s6
 1ca:	e37ff0ef          	jal	0 <putc>
 1ce:	a019                	j	1d4 <vprintf+0x4a>
    } else if(state == '%'){
 1d0:	03598263          	beq	s3,s5,1f4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 1d4:	2485                	addiw	s1,s1,1
 1d6:	8726                	mv	a4,s1
 1d8:	009a07b3          	add	a5,s4,s1
 1dc:	0007c903          	lbu	s2,0(a5)
 1e0:	20090c63          	beqz	s2,3f8 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 1e4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 1e8:	fe0994e3          	bnez	s3,1d0 <vprintf+0x46>
      if(c0 == '%'){
 1ec:	fd579de3          	bne	a5,s5,1c6 <vprintf+0x3c>
        state = '%';
 1f0:	89be                	mv	s3,a5
 1f2:	b7cd                	j	1d4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 1f4:	00ea06b3          	add	a3,s4,a4
 1f8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 1fc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 1fe:	c681                	beqz	a3,206 <vprintf+0x7c>
 200:	9752                	add	a4,a4,s4
 202:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 206:	03878f63          	beq	a5,s8,244 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 20a:	05978963          	beq	a5,s9,25c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 20e:	07500713          	li	a4,117
 212:	0ee78363          	beq	a5,a4,2f8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 216:	07800713          	li	a4,120
 21a:	12e78563          	beq	a5,a4,344 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 21e:	07000713          	li	a4,112
 222:	14e78a63          	beq	a5,a4,376 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 226:	07300713          	li	a4,115
 22a:	18e78a63          	beq	a5,a4,3be <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 22e:	02500713          	li	a4,37
 232:	04e79563          	bne	a5,a4,27c <vprintf+0xf2>
        putc(fd, '%');
 236:	02500593          	li	a1,37
 23a:	855a                	mv	a0,s6
 23c:	dc5ff0ef          	jal	0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 240:	4981                	li	s3,0
 242:	bf49                	j	1d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 244:	008b8913          	addi	s2,s7,8
 248:	4685                	li	a3,1
 24a:	4629                	li	a2,10
 24c:	000ba583          	lw	a1,0(s7)
 250:	855a                	mv	a0,s6
 252:	dcdff0ef          	jal	1e <printint>
 256:	8bca                	mv	s7,s2
      state = 0;
 258:	4981                	li	s3,0
 25a:	bfad                	j	1d4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 25c:	06400793          	li	a5,100
 260:	02f68963          	beq	a3,a5,292 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 264:	06c00793          	li	a5,108
 268:	04f68263          	beq	a3,a5,2ac <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 26c:	07500793          	li	a5,117
 270:	0af68063          	beq	a3,a5,310 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 274:	07800793          	li	a5,120
 278:	0ef68263          	beq	a3,a5,35c <vprintf+0x1d2>
        putc(fd, '%');
 27c:	02500593          	li	a1,37
 280:	855a                	mv	a0,s6
 282:	d7fff0ef          	jal	0 <putc>
        putc(fd, c0);
 286:	85ca                	mv	a1,s2
 288:	855a                	mv	a0,s6
 28a:	d77ff0ef          	jal	0 <putc>
      state = 0;
 28e:	4981                	li	s3,0
 290:	b791                	j	1d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 292:	008b8913          	addi	s2,s7,8
 296:	4685                	li	a3,1
 298:	4629                	li	a2,10
 29a:	000ba583          	lw	a1,0(s7)
 29e:	855a                	mv	a0,s6
 2a0:	d7fff0ef          	jal	1e <printint>
        i += 1;
 2a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 2a6:	8bca                	mv	s7,s2
      state = 0;
 2a8:	4981                	li	s3,0
        i += 1;
 2aa:	b72d                	j	1d4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 2ac:	06400793          	li	a5,100
 2b0:	02f60763          	beq	a2,a5,2de <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 2b4:	07500793          	li	a5,117
 2b8:	06f60963          	beq	a2,a5,32a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 2bc:	07800793          	li	a5,120
 2c0:	faf61ee3          	bne	a2,a5,27c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 2c4:	008b8913          	addi	s2,s7,8
 2c8:	4681                	li	a3,0
 2ca:	4641                	li	a2,16
 2cc:	000ba583          	lw	a1,0(s7)
 2d0:	855a                	mv	a0,s6
 2d2:	d4dff0ef          	jal	1e <printint>
        i += 2;
 2d6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 2d8:	8bca                	mv	s7,s2
      state = 0;
 2da:	4981                	li	s3,0
        i += 2;
 2dc:	bde5                	j	1d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 2de:	008b8913          	addi	s2,s7,8
 2e2:	4685                	li	a3,1
 2e4:	4629                	li	a2,10
 2e6:	000ba583          	lw	a1,0(s7)
 2ea:	855a                	mv	a0,s6
 2ec:	d33ff0ef          	jal	1e <printint>
        i += 2;
 2f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 2f2:	8bca                	mv	s7,s2
      state = 0;
 2f4:	4981                	li	s3,0
        i += 2;
 2f6:	bdf9                	j	1d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 2f8:	008b8913          	addi	s2,s7,8
 2fc:	4681                	li	a3,0
 2fe:	4629                	li	a2,10
 300:	000ba583          	lw	a1,0(s7)
 304:	855a                	mv	a0,s6
 306:	d19ff0ef          	jal	1e <printint>
 30a:	8bca                	mv	s7,s2
      state = 0;
 30c:	4981                	li	s3,0
 30e:	b5d9                	j	1d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 310:	008b8913          	addi	s2,s7,8
 314:	4681                	li	a3,0
 316:	4629                	li	a2,10
 318:	000ba583          	lw	a1,0(s7)
 31c:	855a                	mv	a0,s6
 31e:	d01ff0ef          	jal	1e <printint>
        i += 1;
 322:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 324:	8bca                	mv	s7,s2
      state = 0;
 326:	4981                	li	s3,0
        i += 1;
 328:	b575                	j	1d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 32a:	008b8913          	addi	s2,s7,8
 32e:	4681                	li	a3,0
 330:	4629                	li	a2,10
 332:	000ba583          	lw	a1,0(s7)
 336:	855a                	mv	a0,s6
 338:	ce7ff0ef          	jal	1e <printint>
        i += 2;
 33c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 33e:	8bca                	mv	s7,s2
      state = 0;
 340:	4981                	li	s3,0
        i += 2;
 342:	bd49                	j	1d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 344:	008b8913          	addi	s2,s7,8
 348:	4681                	li	a3,0
 34a:	4641                	li	a2,16
 34c:	000ba583          	lw	a1,0(s7)
 350:	855a                	mv	a0,s6
 352:	ccdff0ef          	jal	1e <printint>
 356:	8bca                	mv	s7,s2
      state = 0;
 358:	4981                	li	s3,0
 35a:	bdad                	j	1d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 35c:	008b8913          	addi	s2,s7,8
 360:	4681                	li	a3,0
 362:	4641                	li	a2,16
 364:	000ba583          	lw	a1,0(s7)
 368:	855a                	mv	a0,s6
 36a:	cb5ff0ef          	jal	1e <printint>
        i += 1;
 36e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 370:	8bca                	mv	s7,s2
      state = 0;
 372:	4981                	li	s3,0
        i += 1;
 374:	b585                	j	1d4 <vprintf+0x4a>
 376:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 378:	008b8d13          	addi	s10,s7,8
 37c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 380:	03000593          	li	a1,48
 384:	855a                	mv	a0,s6
 386:	c7bff0ef          	jal	0 <putc>
  putc(fd, 'x');
 38a:	07800593          	li	a1,120
 38e:	855a                	mv	a0,s6
 390:	c71ff0ef          	jal	0 <putc>
 394:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 396:	00000b97          	auipc	s7,0x0
 39a:	5aab8b93          	addi	s7,s7,1450 # 940 <digits>
 39e:	03c9d793          	srli	a5,s3,0x3c
 3a2:	97de                	add	a5,a5,s7
 3a4:	0007c583          	lbu	a1,0(a5)
 3a8:	855a                	mv	a0,s6
 3aa:	c57ff0ef          	jal	0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 3ae:	0992                	slli	s3,s3,0x4
 3b0:	397d                	addiw	s2,s2,-1
 3b2:	fe0916e3          	bnez	s2,39e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 3b6:	8bea                	mv	s7,s10
      state = 0;
 3b8:	4981                	li	s3,0
 3ba:	6d02                	ld	s10,0(sp)
 3bc:	bd21                	j	1d4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 3be:	008b8993          	addi	s3,s7,8
 3c2:	000bb903          	ld	s2,0(s7)
 3c6:	00090f63          	beqz	s2,3e4 <vprintf+0x25a>
        for(; *s; s++)
 3ca:	00094583          	lbu	a1,0(s2)
 3ce:	c195                	beqz	a1,3f2 <vprintf+0x268>
          putc(fd, *s);
 3d0:	855a                	mv	a0,s6
 3d2:	c2fff0ef          	jal	0 <putc>
        for(; *s; s++)
 3d6:	0905                	addi	s2,s2,1
 3d8:	00094583          	lbu	a1,0(s2)
 3dc:	f9f5                	bnez	a1,3d0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 3de:	8bce                	mv	s7,s3
      state = 0;
 3e0:	4981                	li	s3,0
 3e2:	bbcd                	j	1d4 <vprintf+0x4a>
          s = "(null)";
 3e4:	00000917          	auipc	s2,0x0
 3e8:	4d490913          	addi	s2,s2,1236 # 8b8 <get_total_ticks+0x78>
        for(; *s; s++)
 3ec:	02800593          	li	a1,40
 3f0:	b7c5                	j	3d0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 3f2:	8bce                	mv	s7,s3
      state = 0;
 3f4:	4981                	li	s3,0
 3f6:	bbf9                	j	1d4 <vprintf+0x4a>
 3f8:	64a6                	ld	s1,72(sp)
 3fa:	79e2                	ld	s3,56(sp)
 3fc:	7a42                	ld	s4,48(sp)
 3fe:	7aa2                	ld	s5,40(sp)
 400:	7b02                	ld	s6,32(sp)
 402:	6be2                	ld	s7,24(sp)
 404:	6c42                	ld	s8,16(sp)
 406:	6ca2                	ld	s9,8(sp)
    }
  }
}
 408:	60e6                	ld	ra,88(sp)
 40a:	6446                	ld	s0,80(sp)
 40c:	6906                	ld	s2,64(sp)
 40e:	6125                	addi	sp,sp,96
 410:	8082                	ret

0000000000000412 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 412:	715d                	addi	sp,sp,-80
 414:	ec06                	sd	ra,24(sp)
 416:	e822                	sd	s0,16(sp)
 418:	1000                	addi	s0,sp,32
 41a:	e010                	sd	a2,0(s0)
 41c:	e414                	sd	a3,8(s0)
 41e:	e818                	sd	a4,16(s0)
 420:	ec1c                	sd	a5,24(s0)
 422:	03043023          	sd	a6,32(s0)
 426:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 42a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 42e:	8622                	mv	a2,s0
 430:	d5bff0ef          	jal	18a <vprintf>
}
 434:	60e2                	ld	ra,24(sp)
 436:	6442                	ld	s0,16(sp)
 438:	6161                	addi	sp,sp,80
 43a:	8082                	ret

000000000000043c <printf>:

void
printf(const char *fmt, ...)
{
 43c:	711d                	addi	sp,sp,-96
 43e:	ec06                	sd	ra,24(sp)
 440:	e822                	sd	s0,16(sp)
 442:	1000                	addi	s0,sp,32
 444:	e40c                	sd	a1,8(s0)
 446:	e810                	sd	a2,16(s0)
 448:	ec14                	sd	a3,24(s0)
 44a:	f018                	sd	a4,32(s0)
 44c:	f41c                	sd	a5,40(s0)
 44e:	03043823          	sd	a6,48(s0)
 452:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 456:	00840613          	addi	a2,s0,8
 45a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 45e:	85aa                	mv	a1,a0
 460:	4505                	li	a0,1
 462:	d29ff0ef          	jal	18a <vprintf>
}
 466:	60e2                	ld	ra,24(sp)
 468:	6442                	ld	s0,16(sp)
 46a:	6125                	addi	sp,sp,96
 46c:	8082                	ret

000000000000046e <main>:
{
 46e:	7139                	addi	sp,sp,-64
 470:	fc06                	sd	ra,56(sp)
 472:	f822                	sd	s0,48(sp)
 474:	f426                	sd	s1,40(sp)
 476:	f04a                	sd	s2,32(sp)
 478:	ec4e                	sd	s3,24(sp)
 47a:	e852                	sd	s4,16(sp)
 47c:	e456                	sd	s5,8(sp)
 47e:	e05a                	sd	s6,0(sp)
 480:	0080                	addi	s0,sp,64
  int start = uptime();
 482:	3a6000ef          	jal	828 <uptime>
 486:	84aa                	mv	s1,a0
  int context_start = get_context_switches();
 488:	3a8000ef          	jal	830 <get_context_switches>
 48c:	892a                	mv	s2,a0
  int tick_avg_start = get_total_ticks();
 48e:	3b2000ef          	jal	840 <get_total_ticks>
 492:	8a2a                	mv	s4,a0
  forktest();
 494:	c59ff0ef          	jal	ec <forktest>
  int end = uptime();
 498:	390000ef          	jal	828 <uptime>
  int elapsed_time = (end - start);
 49c:	409504bb          	subw	s1,a0,s1
 4a0:	00048a9b          	sext.w	s5,s1
  int context_end = get_context_switches();
 4a4:	38c000ef          	jal	830 <get_context_switches>
 4a8:	89aa                	mv	s3,a0
  int tick_avg_end = get_total_ticks();
 4aa:	396000ef          	jal	840 <get_total_ticks>
  int tick_avg = (tick_avg_end - tick_avg_start) / elapsed_time;
 4ae:	414505bb          	subw	a1,a0,s4
 4b2:	0295ca3b          	divw	s4,a1,s1
 4b6:	000a0b1b          	sext.w	s6,s4
  printf("Tick sum: %d \n", tick_avg_end - tick_avg_start);
 4ba:	2581                	sext.w	a1,a1
 4bc:	00000517          	auipc	a0,0x0
 4c0:	40450513          	addi	a0,a0,1028 # 8c0 <get_total_ticks+0x80>
 4c4:	f79ff0ef          	jal	43c <printf>
  printf("Tick AVG: %d \n", tick_avg);
 4c8:	85da                	mv	a1,s6
 4ca:	00000517          	auipc	a0,0x0
 4ce:	40650513          	addi	a0,a0,1030 # 8d0 <get_total_ticks+0x90>
 4d2:	f6bff0ef          	jal	43c <printf>
  printf("\nExecution Time: %d ticks\n", elapsed_time);
 4d6:	85d6                	mv	a1,s5
 4d8:	00000517          	auipc	a0,0x0
 4dc:	40850513          	addi	a0,a0,1032 # 8e0 <get_total_ticks+0xa0>
 4e0:	f5dff0ef          	jal	43c <printf>
  printf("Execution Time: %d.%d seconds\n", (elapsed_time*tick_avg)/10000000,((elapsed_time*tick_avg)%10000000)/(10000000/10));
 4e4:	034484bb          	mulw	s1,s1,s4
 4e8:	009895b7          	lui	a1,0x989
 4ec:	6805859b          	addiw	a1,a1,1664 # 989680 <__global_pointer$+0x98852f>
 4f0:	02b4e63b          	remw	a2,s1,a1
 4f4:	000f47b7          	lui	a5,0xf4
 4f8:	2407879b          	addiw	a5,a5,576 # f4240 <__global_pointer$+0xf30ef>
 4fc:	02f6463b          	divw	a2,a2,a5
 500:	02b4c5bb          	divw	a1,s1,a1
 504:	00000517          	auipc	a0,0x0
 508:	3fc50513          	addi	a0,a0,1020 # 900 <get_total_ticks+0xc0>
 50c:	f31ff0ef          	jal	43c <printf>
  printf("Total Context Switches: %d \n", context_end - context_start);
 510:	412985bb          	subw	a1,s3,s2
 514:	00000517          	auipc	a0,0x0
 518:	40c50513          	addi	a0,a0,1036 # 920 <get_total_ticks+0xe0>
 51c:	f21ff0ef          	jal	43c <printf>
  exit(0);
 520:	4501                	li	a0,0
 522:	26e000ef          	jal	790 <exit>

0000000000000526 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 526:	1141                	addi	sp,sp,-16
 528:	e406                	sd	ra,8(sp)
 52a:	e022                	sd	s0,0(sp)
 52c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 52e:	f41ff0ef          	jal	46e <main>
  exit(0);
 532:	4501                	li	a0,0
 534:	25c000ef          	jal	790 <exit>

0000000000000538 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 538:	1141                	addi	sp,sp,-16
 53a:	e422                	sd	s0,8(sp)
 53c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 53e:	87aa                	mv	a5,a0
 540:	0585                	addi	a1,a1,1
 542:	0785                	addi	a5,a5,1
 544:	fff5c703          	lbu	a4,-1(a1)
 548:	fee78fa3          	sb	a4,-1(a5)
 54c:	fb75                	bnez	a4,540 <strcpy+0x8>
    ;
  return os;
}
 54e:	6422                	ld	s0,8(sp)
 550:	0141                	addi	sp,sp,16
 552:	8082                	ret

0000000000000554 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 554:	1141                	addi	sp,sp,-16
 556:	e422                	sd	s0,8(sp)
 558:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 55a:	00054783          	lbu	a5,0(a0)
 55e:	cb91                	beqz	a5,572 <strcmp+0x1e>
 560:	0005c703          	lbu	a4,0(a1)
 564:	00f71763          	bne	a4,a5,572 <strcmp+0x1e>
    p++, q++;
 568:	0505                	addi	a0,a0,1
 56a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 56c:	00054783          	lbu	a5,0(a0)
 570:	fbe5                	bnez	a5,560 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 572:	0005c503          	lbu	a0,0(a1)
}
 576:	40a7853b          	subw	a0,a5,a0
 57a:	6422                	ld	s0,8(sp)
 57c:	0141                	addi	sp,sp,16
 57e:	8082                	ret

0000000000000580 <strlen>:

uint
strlen(const char *s)
{
 580:	1141                	addi	sp,sp,-16
 582:	e422                	sd	s0,8(sp)
 584:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 586:	00054783          	lbu	a5,0(a0)
 58a:	cf91                	beqz	a5,5a6 <strlen+0x26>
 58c:	0505                	addi	a0,a0,1
 58e:	87aa                	mv	a5,a0
 590:	86be                	mv	a3,a5
 592:	0785                	addi	a5,a5,1
 594:	fff7c703          	lbu	a4,-1(a5)
 598:	ff65                	bnez	a4,590 <strlen+0x10>
 59a:	40a6853b          	subw	a0,a3,a0
 59e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 5a0:	6422                	ld	s0,8(sp)
 5a2:	0141                	addi	sp,sp,16
 5a4:	8082                	ret
  for(n = 0; s[n]; n++)
 5a6:	4501                	li	a0,0
 5a8:	bfe5                	j	5a0 <strlen+0x20>

00000000000005aa <memset>:

void*
memset(void *dst, int c, uint n)
{
 5aa:	1141                	addi	sp,sp,-16
 5ac:	e422                	sd	s0,8(sp)
 5ae:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5b0:	ca19                	beqz	a2,5c6 <memset+0x1c>
 5b2:	87aa                	mv	a5,a0
 5b4:	1602                	slli	a2,a2,0x20
 5b6:	9201                	srli	a2,a2,0x20
 5b8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5c0:	0785                	addi	a5,a5,1
 5c2:	fee79de3          	bne	a5,a4,5bc <memset+0x12>
  }
  return dst;
}
 5c6:	6422                	ld	s0,8(sp)
 5c8:	0141                	addi	sp,sp,16
 5ca:	8082                	ret

00000000000005cc <strchr>:

char*
strchr(const char *s, char c)
{
 5cc:	1141                	addi	sp,sp,-16
 5ce:	e422                	sd	s0,8(sp)
 5d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 5d2:	00054783          	lbu	a5,0(a0)
 5d6:	cb99                	beqz	a5,5ec <strchr+0x20>
    if(*s == c)
 5d8:	00f58763          	beq	a1,a5,5e6 <strchr+0x1a>
  for(; *s; s++)
 5dc:	0505                	addi	a0,a0,1
 5de:	00054783          	lbu	a5,0(a0)
 5e2:	fbfd                	bnez	a5,5d8 <strchr+0xc>
      return (char*)s;
  return 0;
 5e4:	4501                	li	a0,0
}
 5e6:	6422                	ld	s0,8(sp)
 5e8:	0141                	addi	sp,sp,16
 5ea:	8082                	ret
  return 0;
 5ec:	4501                	li	a0,0
 5ee:	bfe5                	j	5e6 <strchr+0x1a>

00000000000005f0 <gets>:

char*
gets(char *buf, int max)
{
 5f0:	711d                	addi	sp,sp,-96
 5f2:	ec86                	sd	ra,88(sp)
 5f4:	e8a2                	sd	s0,80(sp)
 5f6:	e4a6                	sd	s1,72(sp)
 5f8:	e0ca                	sd	s2,64(sp)
 5fa:	fc4e                	sd	s3,56(sp)
 5fc:	f852                	sd	s4,48(sp)
 5fe:	f456                	sd	s5,40(sp)
 600:	f05a                	sd	s6,32(sp)
 602:	ec5e                	sd	s7,24(sp)
 604:	1080                	addi	s0,sp,96
 606:	8baa                	mv	s7,a0
 608:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 60a:	892a                	mv	s2,a0
 60c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 60e:	4aa9                	li	s5,10
 610:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 612:	89a6                	mv	s3,s1
 614:	2485                	addiw	s1,s1,1
 616:	0344d663          	bge	s1,s4,642 <gets+0x52>
    cc = read(0, &c, 1);
 61a:	4605                	li	a2,1
 61c:	faf40593          	addi	a1,s0,-81
 620:	4501                	li	a0,0
 622:	186000ef          	jal	7a8 <read>
    if(cc < 1)
 626:	00a05e63          	blez	a0,642 <gets+0x52>
    buf[i++] = c;
 62a:	faf44783          	lbu	a5,-81(s0)
 62e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 632:	01578763          	beq	a5,s5,640 <gets+0x50>
 636:	0905                	addi	s2,s2,1
 638:	fd679de3          	bne	a5,s6,612 <gets+0x22>
    buf[i++] = c;
 63c:	89a6                	mv	s3,s1
 63e:	a011                	j	642 <gets+0x52>
 640:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 642:	99de                	add	s3,s3,s7
 644:	00098023          	sb	zero,0(s3)
  return buf;
}
 648:	855e                	mv	a0,s7
 64a:	60e6                	ld	ra,88(sp)
 64c:	6446                	ld	s0,80(sp)
 64e:	64a6                	ld	s1,72(sp)
 650:	6906                	ld	s2,64(sp)
 652:	79e2                	ld	s3,56(sp)
 654:	7a42                	ld	s4,48(sp)
 656:	7aa2                	ld	s5,40(sp)
 658:	7b02                	ld	s6,32(sp)
 65a:	6be2                	ld	s7,24(sp)
 65c:	6125                	addi	sp,sp,96
 65e:	8082                	ret

0000000000000660 <stat>:

int
stat(const char *n, struct stat *st)
{
 660:	1101                	addi	sp,sp,-32
 662:	ec06                	sd	ra,24(sp)
 664:	e822                	sd	s0,16(sp)
 666:	e04a                	sd	s2,0(sp)
 668:	1000                	addi	s0,sp,32
 66a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 66c:	4581                	li	a1,0
 66e:	162000ef          	jal	7d0 <open>
  if(fd < 0)
 672:	02054263          	bltz	a0,696 <stat+0x36>
 676:	e426                	sd	s1,8(sp)
 678:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 67a:	85ca                	mv	a1,s2
 67c:	16c000ef          	jal	7e8 <fstat>
 680:	892a                	mv	s2,a0
  close(fd);
 682:	8526                	mv	a0,s1
 684:	134000ef          	jal	7b8 <close>
  return r;
 688:	64a2                	ld	s1,8(sp)
}
 68a:	854a                	mv	a0,s2
 68c:	60e2                	ld	ra,24(sp)
 68e:	6442                	ld	s0,16(sp)
 690:	6902                	ld	s2,0(sp)
 692:	6105                	addi	sp,sp,32
 694:	8082                	ret
    return -1;
 696:	597d                	li	s2,-1
 698:	bfcd                	j	68a <stat+0x2a>

000000000000069a <atoi>:

int
atoi(const char *s)
{
 69a:	1141                	addi	sp,sp,-16
 69c:	e422                	sd	s0,8(sp)
 69e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6a0:	00054683          	lbu	a3,0(a0)
 6a4:	fd06879b          	addiw	a5,a3,-48
 6a8:	0ff7f793          	zext.b	a5,a5
 6ac:	4625                	li	a2,9
 6ae:	02f66863          	bltu	a2,a5,6de <atoi+0x44>
 6b2:	872a                	mv	a4,a0
  n = 0;
 6b4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6b6:	0705                	addi	a4,a4,1
 6b8:	0025179b          	slliw	a5,a0,0x2
 6bc:	9fa9                	addw	a5,a5,a0
 6be:	0017979b          	slliw	a5,a5,0x1
 6c2:	9fb5                	addw	a5,a5,a3
 6c4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6c8:	00074683          	lbu	a3,0(a4)
 6cc:	fd06879b          	addiw	a5,a3,-48
 6d0:	0ff7f793          	zext.b	a5,a5
 6d4:	fef671e3          	bgeu	a2,a5,6b6 <atoi+0x1c>
  return n;
}
 6d8:	6422                	ld	s0,8(sp)
 6da:	0141                	addi	sp,sp,16
 6dc:	8082                	ret
  n = 0;
 6de:	4501                	li	a0,0
 6e0:	bfe5                	j	6d8 <atoi+0x3e>

00000000000006e2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6e2:	1141                	addi	sp,sp,-16
 6e4:	e422                	sd	s0,8(sp)
 6e6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6e8:	02b57463          	bgeu	a0,a1,710 <memmove+0x2e>
    while(n-- > 0)
 6ec:	00c05f63          	blez	a2,70a <memmove+0x28>
 6f0:	1602                	slli	a2,a2,0x20
 6f2:	9201                	srli	a2,a2,0x20
 6f4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 6fa:	0585                	addi	a1,a1,1
 6fc:	0705                	addi	a4,a4,1
 6fe:	fff5c683          	lbu	a3,-1(a1)
 702:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 706:	fef71ae3          	bne	a4,a5,6fa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 70a:	6422                	ld	s0,8(sp)
 70c:	0141                	addi	sp,sp,16
 70e:	8082                	ret
    dst += n;
 710:	00c50733          	add	a4,a0,a2
    src += n;
 714:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 716:	fec05ae3          	blez	a2,70a <memmove+0x28>
 71a:	fff6079b          	addiw	a5,a2,-1
 71e:	1782                	slli	a5,a5,0x20
 720:	9381                	srli	a5,a5,0x20
 722:	fff7c793          	not	a5,a5
 726:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 728:	15fd                	addi	a1,a1,-1
 72a:	177d                	addi	a4,a4,-1
 72c:	0005c683          	lbu	a3,0(a1)
 730:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 734:	fee79ae3          	bne	a5,a4,728 <memmove+0x46>
 738:	bfc9                	j	70a <memmove+0x28>

000000000000073a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 73a:	1141                	addi	sp,sp,-16
 73c:	e422                	sd	s0,8(sp)
 73e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 740:	ca05                	beqz	a2,770 <memcmp+0x36>
 742:	fff6069b          	addiw	a3,a2,-1
 746:	1682                	slli	a3,a3,0x20
 748:	9281                	srli	a3,a3,0x20
 74a:	0685                	addi	a3,a3,1
 74c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 74e:	00054783          	lbu	a5,0(a0)
 752:	0005c703          	lbu	a4,0(a1)
 756:	00e79863          	bne	a5,a4,766 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 75a:	0505                	addi	a0,a0,1
    p2++;
 75c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 75e:	fed518e3          	bne	a0,a3,74e <memcmp+0x14>
  }
  return 0;
 762:	4501                	li	a0,0
 764:	a019                	j	76a <memcmp+0x30>
      return *p1 - *p2;
 766:	40e7853b          	subw	a0,a5,a4
}
 76a:	6422                	ld	s0,8(sp)
 76c:	0141                	addi	sp,sp,16
 76e:	8082                	ret
  return 0;
 770:	4501                	li	a0,0
 772:	bfe5                	j	76a <memcmp+0x30>

0000000000000774 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 774:	1141                	addi	sp,sp,-16
 776:	e406                	sd	ra,8(sp)
 778:	e022                	sd	s0,0(sp)
 77a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 77c:	f67ff0ef          	jal	6e2 <memmove>
}
 780:	60a2                	ld	ra,8(sp)
 782:	6402                	ld	s0,0(sp)
 784:	0141                	addi	sp,sp,16
 786:	8082                	ret

0000000000000788 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 788:	4885                	li	a7,1
 ecall
 78a:	00000073          	ecall
 ret
 78e:	8082                	ret

0000000000000790 <exit>:
.global exit
exit:
 li a7, SYS_exit
 790:	4889                	li	a7,2
 ecall
 792:	00000073          	ecall
 ret
 796:	8082                	ret

0000000000000798 <wait>:
.global wait
wait:
 li a7, SYS_wait
 798:	488d                	li	a7,3
 ecall
 79a:	00000073          	ecall
 ret
 79e:	8082                	ret

00000000000007a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7a0:	4891                	li	a7,4
 ecall
 7a2:	00000073          	ecall
 ret
 7a6:	8082                	ret

00000000000007a8 <read>:
.global read
read:
 li a7, SYS_read
 7a8:	4895                	li	a7,5
 ecall
 7aa:	00000073          	ecall
 ret
 7ae:	8082                	ret

00000000000007b0 <write>:
.global write
write:
 li a7, SYS_write
 7b0:	48c1                	li	a7,16
 ecall
 7b2:	00000073          	ecall
 ret
 7b6:	8082                	ret

00000000000007b8 <close>:
.global close
close:
 li a7, SYS_close
 7b8:	48d5                	li	a7,21
 ecall
 7ba:	00000073          	ecall
 ret
 7be:	8082                	ret

00000000000007c0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7c0:	4899                	li	a7,6
 ecall
 7c2:	00000073          	ecall
 ret
 7c6:	8082                	ret

00000000000007c8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7c8:	489d                	li	a7,7
 ecall
 7ca:	00000073          	ecall
 ret
 7ce:	8082                	ret

00000000000007d0 <open>:
.global open
open:
 li a7, SYS_open
 7d0:	48bd                	li	a7,15
 ecall
 7d2:	00000073          	ecall
 ret
 7d6:	8082                	ret

00000000000007d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7d8:	48c5                	li	a7,17
 ecall
 7da:	00000073          	ecall
 ret
 7de:	8082                	ret

00000000000007e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7e0:	48c9                	li	a7,18
 ecall
 7e2:	00000073          	ecall
 ret
 7e6:	8082                	ret

00000000000007e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7e8:	48a1                	li	a7,8
 ecall
 7ea:	00000073          	ecall
 ret
 7ee:	8082                	ret

00000000000007f0 <link>:
.global link
link:
 li a7, SYS_link
 7f0:	48cd                	li	a7,19
 ecall
 7f2:	00000073          	ecall
 ret
 7f6:	8082                	ret

00000000000007f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7f8:	48d1                	li	a7,20
 ecall
 7fa:	00000073          	ecall
 ret
 7fe:	8082                	ret

0000000000000800 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 800:	48a5                	li	a7,9
 ecall
 802:	00000073          	ecall
 ret
 806:	8082                	ret

0000000000000808 <dup>:
.global dup
dup:
 li a7, SYS_dup
 808:	48a9                	li	a7,10
 ecall
 80a:	00000073          	ecall
 ret
 80e:	8082                	ret

0000000000000810 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 810:	48ad                	li	a7,11
 ecall
 812:	00000073          	ecall
 ret
 816:	8082                	ret

0000000000000818 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 818:	48b1                	li	a7,12
 ecall
 81a:	00000073          	ecall
 ret
 81e:	8082                	ret

0000000000000820 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 820:	48b5                	li	a7,13
 ecall
 822:	00000073          	ecall
 ret
 826:	8082                	ret

0000000000000828 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 828:	48b9                	li	a7,14
 ecall
 82a:	00000073          	ecall
 ret
 82e:	8082                	ret

0000000000000830 <get_context_switches>:
.global get_context_switches
get_context_switches:
 li a7, SYS_get_context_switches
 830:	48d9                	li	a7,22
 ecall
 832:	00000073          	ecall
 ret
 836:	8082                	ret

0000000000000838 <get_tick_rate>:
.global get_tick_rate
 get_tick_rate:
 li a7, SYS_get_tick_rate
 838:	48dd                	li	a7,23
 ecall
 83a:	00000073          	ecall
 ret
 83e:	8082                	ret

0000000000000840 <get_total_ticks>:
 .global get_total_ticks
 get_total_ticks:
 li a7, SYS_get_total_ticks
 840:	48e1                	li	a7,24
 ecall
 842:	00000073          	ecall
 ret
 846:	8082                	ret
