
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	94010113          	addi	sp,sp,-1728 # 80007940 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddb8f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de278793          	addi	a5,a5,-542 # 80000e62 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	1e4020ef          	jal	800022de <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	035000ef          	jal	8000093a <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	0000f517          	auipc	a0,0xf
    80000158:	7ec50513          	addi	a0,a0,2028 # 8000f940 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	0000f497          	auipc	s1,0xf
    80000164:	7e048493          	addi	s1,s1,2016 # 8000f940 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00010917          	auipc	s2,0x10
    8000016c:	87090913          	addi	s2,s2,-1936 # 8000f9d8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	760010ef          	jal	800018e0 <myproc>
    80000184:	7ed010ef          	jal	80002170 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	5ab010ef          	jal	80001f38 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	0000f717          	auipc	a4,0xf
    800001a4:	7a070713          	addi	a4,a4,1952 # 8000f940 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	0c2020ef          	jal	80002294 <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	0000f517          	auipc	a0,0xf
    800001ee:	75650513          	addi	a0,a0,1878 # 8000f940 <cons>
    800001f2:	29b000ef          	jal	80000c8c <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	0000f717          	auipc	a4,0xf
    80000218:	7cf72223          	sw	a5,1988(a4) # 8000f9d8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	0000f517          	auipc	a0,0xf
    8000022e:	71650513          	addi	a0,a0,1814 # 8000f940 <cons>
    80000232:	25b000ef          	jal	80000c8c <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	604000ef          	jal	80000854 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	5f6000ef          	jal	80000854 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5ee000ef          	jal	80000854 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5e8000ef          	jal	80000854 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	0000f517          	auipc	a0,0xf
    80000282:	6c250513          	addi	a0,a0,1730 # 8000f940 <cons>
    80000286:	16f000ef          	jal	80000bf4 <acquire>

  switch(c){
    8000028a:	47d5                	li	a5,21
    8000028c:	08f48f63          	beq	s1,a5,8000032a <consoleintr+0xb8>
    80000290:	0297c563          	blt	a5,s1,800002ba <consoleintr+0x48>
    80000294:	47a1                	li	a5,8
    80000296:	0ef48463          	beq	s1,a5,8000037e <consoleintr+0x10c>
    8000029a:	47c1                	li	a5,16
    8000029c:	10f49563          	bne	s1,a5,800003a6 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002a0:	088020ef          	jal	80002328 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	0000f517          	auipc	a0,0xf
    800002a8:	69c50513          	addi	a0,a0,1692 # 8000f940 <cons>
    800002ac:	1e1000ef          	jal	80000c8c <release>
}
    800002b0:	60e2                	ld	ra,24(sp)
    800002b2:	6442                	ld	s0,16(sp)
    800002b4:	64a2                	ld	s1,8(sp)
    800002b6:	6105                	addi	sp,sp,32
    800002b8:	8082                	ret
  switch(c){
    800002ba:	07f00793          	li	a5,127
    800002be:	0cf48063          	beq	s1,a5,8000037e <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002c2:	0000f717          	auipc	a4,0xf
    800002c6:	67e70713          	addi	a4,a4,1662 # 8000f940 <cons>
    800002ca:	0a072783          	lw	a5,160(a4)
    800002ce:	09872703          	lw	a4,152(a4)
    800002d2:	9f99                	subw	a5,a5,a4
    800002d4:	07f00713          	li	a4,127
    800002d8:	fcf766e3          	bltu	a4,a5,800002a4 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002dc:	47b5                	li	a5,13
    800002de:	0cf48763          	beq	s1,a5,800003ac <consoleintr+0x13a>
      consputc(c);
    800002e2:	8526                	mv	a0,s1
    800002e4:	f5dff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002e8:	0000f797          	auipc	a5,0xf
    800002ec:	65878793          	addi	a5,a5,1624 # 8000f940 <cons>
    800002f0:	0a07a683          	lw	a3,160(a5)
    800002f4:	0016871b          	addiw	a4,a3,1
    800002f8:	0007061b          	sext.w	a2,a4
    800002fc:	0ae7a023          	sw	a4,160(a5)
    80000300:	07f6f693          	andi	a3,a3,127
    80000304:	97b6                	add	a5,a5,a3
    80000306:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000030a:	47a9                	li	a5,10
    8000030c:	0cf48563          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000310:	4791                	li	a5,4
    80000312:	0cf48263          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000316:	0000f797          	auipc	a5,0xf
    8000031a:	6c27a783          	lw	a5,1730(a5) # 8000f9d8 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	0000f717          	auipc	a4,0xf
    80000330:	61470713          	addi	a4,a4,1556 # 8000f940 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	0000f497          	auipc	s1,0xf
    80000340:	60448493          	addi	s1,s1,1540 # 8000f940 <cons>
    while(cons.e != cons.w &&
    80000344:	4929                	li	s2,10
    80000346:	02f70863          	beq	a4,a5,80000376 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	37fd                	addiw	a5,a5,-1
    8000034c:	07f7f713          	andi	a4,a5,127
    80000350:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000352:	01874703          	lbu	a4,24(a4)
    80000356:	03270263          	beq	a4,s2,8000037a <consoleintr+0x108>
      cons.e--;
    8000035a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000035e:	10000513          	li	a0,256
    80000362:	edfff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000366:	0a04a783          	lw	a5,160(s1)
    8000036a:	09c4a703          	lw	a4,156(s1)
    8000036e:	fcf71ee3          	bne	a4,a5,8000034a <consoleintr+0xd8>
    80000372:	6902                	ld	s2,0(sp)
    80000374:	bf05                	j	800002a4 <consoleintr+0x32>
    80000376:	6902                	ld	s2,0(sp)
    80000378:	b735                	j	800002a4 <consoleintr+0x32>
    8000037a:	6902                	ld	s2,0(sp)
    8000037c:	b725                	j	800002a4 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000037e:	0000f717          	auipc	a4,0xf
    80000382:	5c270713          	addi	a4,a4,1474 # 8000f940 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	0000f717          	auipc	a4,0xf
    80000398:	64f72623          	sw	a5,1612(a4) # 8000f9e0 <cons+0xa0>
      consputc(BACKSPACE);
    8000039c:	10000513          	li	a0,256
    800003a0:	ea1ff0ef          	jal	80000240 <consputc>
    800003a4:	b701                	j	800002a4 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003a6:	ee048fe3          	beqz	s1,800002a4 <consoleintr+0x32>
    800003aa:	bf21                	j	800002c2 <consoleintr+0x50>
      consputc(c);
    800003ac:	4529                	li	a0,10
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003b2:	0000f797          	auipc	a5,0xf
    800003b6:	58e78793          	addi	a5,a5,1422 # 8000f940 <cons>
    800003ba:	0a07a703          	lw	a4,160(a5)
    800003be:	0017069b          	addiw	a3,a4,1
    800003c2:	0006861b          	sext.w	a2,a3
    800003c6:	0ad7a023          	sw	a3,160(a5)
    800003ca:	07f77713          	andi	a4,a4,127
    800003ce:	97ba                	add	a5,a5,a4
    800003d0:	4729                	li	a4,10
    800003d2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003d6:	0000f797          	auipc	a5,0xf
    800003da:	60c7a323          	sw	a2,1542(a5) # 8000f9dc <cons+0x9c>
        wakeup(&cons.r);
    800003de:	0000f517          	auipc	a0,0xf
    800003e2:	5fa50513          	addi	a0,a0,1530 # 8000f9d8 <cons+0x98>
    800003e6:	39f010ef          	jal	80001f84 <wakeup>
    800003ea:	bd6d                	j	800002a4 <consoleintr+0x32>

00000000800003ec <consoleinit>:

void
consoleinit(void)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e406                	sd	ra,8(sp)
    800003f0:	e022                	sd	s0,0(sp)
    800003f2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003f4:	00007597          	auipc	a1,0x7
    800003f8:	c0c58593          	addi	a1,a1,-1012 # 80007000 <etext>
    800003fc:	0000f517          	auipc	a0,0xf
    80000400:	54450513          	addi	a0,a0,1348 # 8000f940 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	0001f797          	auipc	a5,0x1f
    80000410:	6cc78793          	addi	a5,a5,1740 # 8001fad8 <devsw>
    80000414:	00000717          	auipc	a4,0x0
    80000418:	d2270713          	addi	a4,a4,-734 # 80000136 <consoleread>
    8000041c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	cb270713          	addi	a4,a4,-846 # 800000d0 <consolewrite>
    80000426:	ef98                	sd	a4,24(a5)
}
    80000428:	60a2                	ld	ra,8(sp)
    8000042a:	6402                	ld	s0,0(sp)
    8000042c:	0141                	addi	sp,sp,16
    8000042e:	8082                	ret

0000000080000430 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000430:	7179                	addi	sp,sp,-48
    80000432:	f406                	sd	ra,40(sp)
    80000434:	f022                	sd	s0,32(sp)
    80000436:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000438:	c219                	beqz	a2,8000043e <printint+0xe>
    8000043a:	08054063          	bltz	a0,800004ba <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000043e:	4881                	li	a7,0
    80000440:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000444:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000446:	00007617          	auipc	a2,0x7
    8000044a:	32a60613          	addi	a2,a2,810 # 80007770 <digits>
    8000044e:	883e                	mv	a6,a5
    80000450:	2785                	addiw	a5,a5,1
    80000452:	02b57733          	remu	a4,a0,a1
    80000456:	9732                	add	a4,a4,a2
    80000458:	00074703          	lbu	a4,0(a4)
    8000045c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000460:	872a                	mv	a4,a0
    80000462:	02b55533          	divu	a0,a0,a1
    80000466:	0685                	addi	a3,a3,1
    80000468:	feb773e3          	bgeu	a4,a1,8000044e <printint+0x1e>

  if(sign)
    8000046c:	00088a63          	beqz	a7,80000480 <printint+0x50>
    buf[i++] = '-';
    80000470:	1781                	addi	a5,a5,-32
    80000472:	97a2                	add	a5,a5,s0
    80000474:	02d00713          	li	a4,45
    80000478:	fee78823          	sb	a4,-16(a5)
    8000047c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000480:	02f05963          	blez	a5,800004b2 <printint+0x82>
    80000484:	ec26                	sd	s1,24(sp)
    80000486:	e84a                	sd	s2,16(sp)
    80000488:	fd040713          	addi	a4,s0,-48
    8000048c:	00f704b3          	add	s1,a4,a5
    80000490:	fff70913          	addi	s2,a4,-1
    80000494:	993e                	add	s2,s2,a5
    80000496:	37fd                	addiw	a5,a5,-1
    80000498:	1782                	slli	a5,a5,0x20
    8000049a:	9381                	srli	a5,a5,0x20
    8000049c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004a0:	fff4c503          	lbu	a0,-1(s1)
    800004a4:	d9dff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004a8:	14fd                	addi	s1,s1,-1
    800004aa:	ff249be3          	bne	s1,s2,800004a0 <printint+0x70>
    800004ae:	64e2                	ld	s1,24(sp)
    800004b0:	6942                	ld	s2,16(sp)
}
    800004b2:	70a2                	ld	ra,40(sp)
    800004b4:	7402                	ld	s0,32(sp)
    800004b6:	6145                	addi	sp,sp,48
    800004b8:	8082                	ret
    x = -xx;
    800004ba:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004be:	4885                	li	a7,1
    x = -xx;
    800004c0:	b741                	j	80000440 <printint+0x10>

00000000800004c2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004c2:	7155                	addi	sp,sp,-208
    800004c4:	e506                	sd	ra,136(sp)
    800004c6:	e122                	sd	s0,128(sp)
    800004c8:	f0d2                	sd	s4,96(sp)
    800004ca:	0900                	addi	s0,sp,144
    800004cc:	8a2a                	mv	s4,a0
    800004ce:	e40c                	sd	a1,8(s0)
    800004d0:	e810                	sd	a2,16(s0)
    800004d2:	ec14                	sd	a3,24(s0)
    800004d4:	f018                	sd	a4,32(s0)
    800004d6:	f41c                	sd	a5,40(s0)
    800004d8:	03043823          	sd	a6,48(s0)
    800004dc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004e0:	0000f797          	auipc	a5,0xf
    800004e4:	5207a783          	lw	a5,1312(a5) # 8000fa00 <pr+0x18>
    800004e8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004ec:	e3a1                	bnez	a5,8000052c <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004ee:	00840793          	addi	a5,s0,8
    800004f2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004f6:	00054503          	lbu	a0,0(a0)
    800004fa:	26050763          	beqz	a0,80000768 <printf+0x2a6>
    800004fe:	fca6                	sd	s1,120(sp)
    80000500:	f8ca                	sd	s2,112(sp)
    80000502:	f4ce                	sd	s3,104(sp)
    80000504:	ecd6                	sd	s5,88(sp)
    80000506:	e8da                	sd	s6,80(sp)
    80000508:	e0e2                	sd	s8,64(sp)
    8000050a:	fc66                	sd	s9,56(sp)
    8000050c:	f86a                	sd	s10,48(sp)
    8000050e:	f46e                	sd	s11,40(sp)
    80000510:	4981                	li	s3,0
    if(cx != '%'){
    80000512:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000516:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000051a:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000051e:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000522:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000526:	07000d93          	li	s11,112
    8000052a:	a815                	j	8000055e <printf+0x9c>
    acquire(&pr.lock);
    8000052c:	0000f517          	auipc	a0,0xf
    80000530:	4bc50513          	addi	a0,a0,1212 # 8000f9e8 <pr>
    80000534:	6c0000ef          	jal	80000bf4 <acquire>
  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000540:	000a4503          	lbu	a0,0(s4)
    80000544:	fd4d                	bnez	a0,800004fe <printf+0x3c>
    80000546:	a481                	j	80000786 <printf+0x2c4>
      consputc(cx);
    80000548:	cf9ff0ef          	jal	80000240 <consputc>
      continue;
    8000054c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	0014899b          	addiw	s3,s1,1
    80000552:	013a07b3          	add	a5,s4,s3
    80000556:	0007c503          	lbu	a0,0(a5)
    8000055a:	1e050b63          	beqz	a0,80000750 <printf+0x28e>
    if(cx != '%'){
    8000055e:	ff5515e3          	bne	a0,s5,80000548 <printf+0x86>
    i++;
    80000562:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000566:	009a07b3          	add	a5,s4,s1
    8000056a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056e:	1e090163          	beqz	s2,80000750 <printf+0x28e>
    80000572:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000576:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000578:	c789                	beqz	a5,80000582 <printf+0xc0>
    8000057a:	009a0733          	add	a4,s4,s1
    8000057e:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000582:	03690763          	beq	s2,s6,800005b0 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000586:	05890163          	beq	s2,s8,800005c8 <printf+0x106>
    } else if(c0 == 'u'){
    8000058a:	0d990b63          	beq	s2,s9,80000660 <printf+0x19e>
    } else if(c0 == 'x'){
    8000058e:	13a90163          	beq	s2,s10,800006b0 <printf+0x1ee>
    } else if(c0 == 'p'){
    80000592:	13b90b63          	beq	s2,s11,800006c8 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80000596:	07300793          	li	a5,115
    8000059a:	16f90a63          	beq	s2,a5,8000070e <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000059e:	1b590463          	beq	s2,s5,80000746 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005a2:	8556                	mv	a0,s5
    800005a4:	c9dff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005a8:	854a                	mv	a0,s2
    800005aa:	c97ff0ef          	jal	80000240 <consputc>
    800005ae:	b745                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005b0:	f8843783          	ld	a5,-120(s0)
    800005b4:	00878713          	addi	a4,a5,8
    800005b8:	f8e43423          	sd	a4,-120(s0)
    800005bc:	4605                	li	a2,1
    800005be:	45a9                	li	a1,10
    800005c0:	4388                	lw	a0,0(a5)
    800005c2:	e6fff0ef          	jal	80000430 <printint>
    800005c6:	b761                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005c8:	03678663          	beq	a5,s6,800005f4 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005cc:	05878263          	beq	a5,s8,80000610 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005d0:	0b978463          	beq	a5,s9,80000678 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005d4:	fda797e3          	bne	a5,s10,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005d8:	f8843783          	ld	a5,-120(s0)
    800005dc:	00878713          	addi	a4,a5,8
    800005e0:	f8e43423          	sd	a4,-120(s0)
    800005e4:	4601                	li	a2,0
    800005e6:	45c1                	li	a1,16
    800005e8:	6388                	ld	a0,0(a5)
    800005ea:	e47ff0ef          	jal	80000430 <printint>
      i += 1;
    800005ee:	0029849b          	addiw	s1,s3,2
    800005f2:	bfb1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005f4:	f8843783          	ld	a5,-120(s0)
    800005f8:	00878713          	addi	a4,a5,8
    800005fc:	f8e43423          	sd	a4,-120(s0)
    80000600:	4605                	li	a2,1
    80000602:	45a9                	li	a1,10
    80000604:	6388                	ld	a0,0(a5)
    80000606:	e2bff0ef          	jal	80000430 <printint>
      i += 1;
    8000060a:	0029849b          	addiw	s1,s3,2
    8000060e:	b781                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000610:	06400793          	li	a5,100
    80000614:	02f68863          	beq	a3,a5,80000644 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000618:	07500793          	li	a5,117
    8000061c:	06f68c63          	beq	a3,a5,80000694 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000620:	07800793          	li	a5,120
    80000624:	f6f69fe3          	bne	a3,a5,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000628:	f8843783          	ld	a5,-120(s0)
    8000062c:	00878713          	addi	a4,a5,8
    80000630:	f8e43423          	sd	a4,-120(s0)
    80000634:	4601                	li	a2,0
    80000636:	45c1                	li	a1,16
    80000638:	6388                	ld	a0,0(a5)
    8000063a:	df7ff0ef          	jal	80000430 <printint>
      i += 2;
    8000063e:	0039849b          	addiw	s1,s3,3
    80000642:	b731                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	45a9                	li	a1,10
    80000654:	6388                	ld	a0,0(a5)
    80000656:	ddbff0ef          	jal	80000430 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bdc5                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4601                	li	a2,0
    8000066e:	45a9                	li	a1,10
    80000670:	4388                	lw	a0,0(a5)
    80000672:	dbfff0ef          	jal	80000430 <printint>
    80000676:	bde1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4601                	li	a2,0
    80000686:	45a9                	li	a1,10
    80000688:	6388                	ld	a0,0(a5)
    8000068a:	da7ff0ef          	jal	80000430 <printint>
      i += 1;
    8000068e:	0029849b          	addiw	s1,s3,2
    80000692:	bd75                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	4601                	li	a2,0
    800006a2:	45a9                	li	a1,10
    800006a4:	6388                	ld	a0,0(a5)
    800006a6:	d8bff0ef          	jal	80000430 <printint>
      i += 2;
    800006aa:	0039849b          	addiw	s1,s3,3
    800006ae:	b545                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	4601                	li	a2,0
    800006be:	45c1                	li	a1,16
    800006c0:	4388                	lw	a0,0(a5)
    800006c2:	d6fff0ef          	jal	80000430 <printint>
    800006c6:	b561                	j	8000054e <printf+0x8c>
    800006c8:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006ca:	f8843783          	ld	a5,-120(s0)
    800006ce:	00878713          	addi	a4,a5,8
    800006d2:	f8e43423          	sd	a4,-120(s0)
    800006d6:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006da:	03000513          	li	a0,48
    800006de:	b63ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006e2:	07800513          	li	a0,120
    800006e6:	b5bff0ef          	jal	80000240 <consputc>
    800006ea:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ec:	00007b97          	auipc	s7,0x7
    800006f0:	084b8b93          	addi	s7,s7,132 # 80007770 <digits>
    800006f4:	03c9d793          	srli	a5,s3,0x3c
    800006f8:	97de                	add	a5,a5,s7
    800006fa:	0007c503          	lbu	a0,0(a5)
    800006fe:	b43ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0917e3          	bnez	s2,800006f4 <printf+0x232>
    8000070a:	6ba6                	ld	s7,72(sp)
    8000070c:	b589                	j	8000054e <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000070e:	f8843783          	ld	a5,-120(s0)
    80000712:	00878713          	addi	a4,a5,8
    80000716:	f8e43423          	sd	a4,-120(s0)
    8000071a:	0007b903          	ld	s2,0(a5)
    8000071e:	00090d63          	beqz	s2,80000738 <printf+0x276>
      for(; *s; s++)
    80000722:	00094503          	lbu	a0,0(s2)
    80000726:	e20504e3          	beqz	a0,8000054e <printf+0x8c>
        consputc(*s);
    8000072a:	b17ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000072e:	0905                	addi	s2,s2,1
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	f97d                	bnez	a0,8000072a <printf+0x268>
    80000736:	bd21                	j	8000054e <printf+0x8c>
        s = "(null)";
    80000738:	00007917          	auipc	s2,0x7
    8000073c:	8d090913          	addi	s2,s2,-1840 # 80007008 <etext+0x8>
      for(; *s; s++)
    80000740:	02800513          	li	a0,40
    80000744:	b7dd                	j	8000072a <printf+0x268>
      consputc('%');
    80000746:	02500513          	li	a0,37
    8000074a:	af7ff0ef          	jal	80000240 <consputc>
    8000074e:	b501                	j	8000054e <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000750:	f7843783          	ld	a5,-136(s0)
    80000754:	e385                	bnez	a5,80000774 <printf+0x2b2>
    80000756:	74e6                	ld	s1,120(sp)
    80000758:	7946                	ld	s2,112(sp)
    8000075a:	79a6                	ld	s3,104(sp)
    8000075c:	6ae6                	ld	s5,88(sp)
    8000075e:	6b46                	ld	s6,80(sp)
    80000760:	6c06                	ld	s8,64(sp)
    80000762:	7ce2                	ld	s9,56(sp)
    80000764:	7d42                	ld	s10,48(sp)
    80000766:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000768:	4501                	li	a0,0
    8000076a:	60aa                	ld	ra,136(sp)
    8000076c:	640a                	ld	s0,128(sp)
    8000076e:	7a06                	ld	s4,96(sp)
    80000770:	6169                	addi	sp,sp,208
    80000772:	8082                	ret
    80000774:	74e6                	ld	s1,120(sp)
    80000776:	7946                	ld	s2,112(sp)
    80000778:	79a6                	ld	s3,104(sp)
    8000077a:	6ae6                	ld	s5,88(sp)
    8000077c:	6b46                	ld	s6,80(sp)
    8000077e:	6c06                	ld	s8,64(sp)
    80000780:	7ce2                	ld	s9,56(sp)
    80000782:	7d42                	ld	s10,48(sp)
    80000784:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000786:	0000f517          	auipc	a0,0xf
    8000078a:	26250513          	addi	a0,a0,610 # 8000f9e8 <pr>
    8000078e:	4fe000ef          	jal	80000c8c <release>
    80000792:	bfd9                	j	80000768 <printf+0x2a6>

0000000080000794 <panic>:

void
panic(char *s)
{
    80000794:	1101                	addi	sp,sp,-32
    80000796:	ec06                	sd	ra,24(sp)
    80000798:	e822                	sd	s0,16(sp)
    8000079a:	e426                	sd	s1,8(sp)
    8000079c:	1000                	addi	s0,sp,32
    8000079e:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007a0:	0000f797          	auipc	a5,0xf
    800007a4:	2607a023          	sw	zero,608(a5) # 8000fa00 <pr+0x18>
  printf("panic: ");
    800007a8:	00007517          	auipc	a0,0x7
    800007ac:	87050513          	addi	a0,a0,-1936 # 80007018 <etext+0x18>
    800007b0:	d13ff0ef          	jal	800004c2 <printf>
  printf("%s\n", s);
    800007b4:	85a6                	mv	a1,s1
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86a50513          	addi	a0,a0,-1942 # 80007020 <etext+0x20>
    800007be:	d05ff0ef          	jal	800004c2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007c2:	4785                	li	a5,1
    800007c4:	00007717          	auipc	a4,0x7
    800007c8:	12f72623          	sw	a5,300(a4) # 800078f0 <panicked>
  for(;;)
    800007cc:	a001                	j	800007cc <panic+0x38>

00000000800007ce <printfinit>:
    ;
}

void
printfinit(void)
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007d8:	0000f497          	auipc	s1,0xf
    800007dc:	21048493          	addi	s1,s1,528 # 8000f9e8 <pr>
    800007e0:	00007597          	auipc	a1,0x7
    800007e4:	84858593          	addi	a1,a1,-1976 # 80007028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	38a000ef          	jal	80000b74 <initlock>
  pr.locking = 1;
    800007ee:	4785                	li	a5,1
    800007f0:	cc9c                	sw	a5,24(s1)
}
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000804:	100007b7          	lui	a5,0x10000
    80000808:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080c:	10000737          	lui	a4,0x10000
    80000810:	f8000693          	li	a3,-128
    80000814:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000818:	468d                	li	a3,3
    8000081a:	10000637          	lui	a2,0x10000
    8000081e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000822:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000826:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	461d                	li	a2,7
    80000830:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000834:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000838:	00006597          	auipc	a1,0x6
    8000083c:	7f858593          	addi	a1,a1,2040 # 80007030 <etext+0x30>
    80000840:	0000f517          	auipc	a0,0xf
    80000844:	1c850513          	addi	a0,a0,456 # 8000fa08 <uart_tx_lock>
    80000848:	32c000ef          	jal	80000b74 <initlock>
}
    8000084c:	60a2                	ld	ra,8(sp)
    8000084e:	6402                	ld	s0,0(sp)
    80000850:	0141                	addi	sp,sp,16
    80000852:	8082                	ret

0000000080000854 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
    8000085e:	84aa                	mv	s1,a0
  push_off();
    80000860:	354000ef          	jal	80000bb4 <push_off>

  if(panicked){
    80000864:	00007797          	auipc	a5,0x7
    80000868:	08c7a783          	lw	a5,140(a5) # 800078f0 <panicked>
    8000086c:	e795                	bnez	a5,80000898 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000874:	00074783          	lbu	a5,0(a4)
    80000878:	0207f793          	andi	a5,a5,32
    8000087c:	dfe5                	beqz	a5,80000874 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000087e:	0ff4f513          	zext.b	a0,s1
    80000882:	100007b7          	lui	a5,0x10000
    80000886:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088a:	3ae000ef          	jal	80000c38 <pop_off>
}
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    for(;;)
    80000898:	a001                	j	80000898 <uartputc_sync+0x44>

000000008000089a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089a:	00007797          	auipc	a5,0x7
    8000089e:	05e7b783          	ld	a5,94(a5) # 800078f8 <uart_tx_r>
    800008a2:	00007717          	auipc	a4,0x7
    800008a6:	05e73703          	ld	a4,94(a4) # 80007900 <uart_tx_w>
    800008aa:	08f70263          	beq	a4,a5,8000092e <uartstart+0x94>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c2:	10000937          	lui	s2,0x10000
    800008c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c8:	0000fa97          	auipc	s5,0xf
    800008cc:	140a8a93          	addi	s5,s5,320 # 8000fa08 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	00007497          	auipc	s1,0x7
    800008d4:	02848493          	addi	s1,s1,40 # 800078f8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	00007997          	auipc	s3,0x7
    800008e0:	02498993          	addi	s3,s3,36 # 80007900 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e4:	00094703          	lbu	a4,0(s2)
    800008e8:	02077713          	andi	a4,a4,32
    800008ec:	c71d                	beqz	a4,8000091a <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ee:	01f7f713          	andi	a4,a5,31
    800008f2:	9756                	add	a4,a4,s5
    800008f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008f8:	0785                	addi	a5,a5,1
    800008fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008fc:	8526                	mv	a0,s1
    800008fe:	686010ef          	jal	80001f84 <wakeup>
    WriteReg(THR, c);
    80000902:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000906:	609c                	ld	a5,0(s1)
    80000908:	0009b703          	ld	a4,0(s3)
    8000090c:	fcf71ce3          	bne	a4,a5,800008e4 <uartstart+0x4a>
      ReadReg(ISR);
    80000910:	100007b7          	lui	a5,0x10000
    80000914:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000916:	0007c783          	lbu	a5,0(a5)
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
      ReadReg(ISR);
    8000092e:	100007b7          	lui	a5,0x10000
    80000932:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000934:	0007c783          	lbu	a5,0(a5)
      return;
    80000938:	8082                	ret

000000008000093a <uartputc>:
{
    8000093a:	7179                	addi	sp,sp,-48
    8000093c:	f406                	sd	ra,40(sp)
    8000093e:	f022                	sd	s0,32(sp)
    80000940:	ec26                	sd	s1,24(sp)
    80000942:	e84a                	sd	s2,16(sp)
    80000944:	e44e                	sd	s3,8(sp)
    80000946:	e052                	sd	s4,0(sp)
    80000948:	1800                	addi	s0,sp,48
    8000094a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000094c:	0000f517          	auipc	a0,0xf
    80000950:	0bc50513          	addi	a0,a0,188 # 8000fa08 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	00007797          	auipc	a5,0x7
    8000095c:	f987a783          	lw	a5,-104(a5) # 800078f0 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	00007717          	auipc	a4,0x7
    80000966:	f9e73703          	ld	a4,-98(a4) # 80007900 <uart_tx_w>
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	f8e7b783          	ld	a5,-114(a5) # 800078f8 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	0000f997          	auipc	s3,0xf
    8000097a:	09298993          	addi	s3,s3,146 # 8000fa08 <uart_tx_lock>
    8000097e:	00007497          	auipc	s1,0x7
    80000982:	f7a48493          	addi	s1,s1,-134 # 800078f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00007917          	auipc	s2,0x7
    8000098a:	f7a90913          	addi	s2,s2,-134 # 80007900 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	5a2010ef          	jal	80001f38 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	0000f497          	auipc	s1,0xf
    800009ac:	06048493          	addi	s1,s1,96 # 8000fa08 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	00007797          	auipc	a5,0x7
    800009c0:	f4e7b223          	sd	a4,-188(a5) # 80007900 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	2c2000ef          	jal	80000c8c <release>
}
    800009ce:	70a2                	ld	ra,40(sp)
    800009d0:	7402                	ld	s0,32(sp)
    800009d2:	64e2                	ld	s1,24(sp)
    800009d4:	6942                	ld	s2,16(sp)
    800009d6:	69a2                	ld	s3,8(sp)
    800009d8:	6a02                	ld	s4,0(sp)
    800009da:	6145                	addi	sp,sp,48
    800009dc:	8082                	ret
    for(;;)
    800009de:	a001                	j	800009de <uartputc+0xa4>

00000000800009e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e0:	1141                	addi	sp,sp,-16
    800009e2:	e422                	sd	s0,8(sp)
    800009e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e6:	100007b7          	lui	a5,0x10000
    800009ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009ec:	0007c783          	lbu	a5,0(a5)
    800009f0:	8b85                	andi	a5,a5,1
    800009f2:	cb81                	beqz	a5,80000a02 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009fc:	6422                	ld	s0,8(sp)
    800009fe:	0141                	addi	sp,sp,16
    80000a00:	8082                	ret
    return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	bfe5                	j	800009fc <uartgetc+0x1c>

0000000080000a06 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a06:	1101                	addi	sp,sp,-32
    80000a08:	ec06                	sd	ra,24(sp)
    80000a0a:	e822                	sd	s0,16(sp)
    80000a0c:	e426                	sd	s1,8(sp)
    80000a0e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a10:	54fd                	li	s1,-1
    80000a12:	a019                	j	80000a18 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a14:	85fff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a18:	fc9ff0ef          	jal	800009e0 <uartgetc>
    if(c == -1)
    80000a1c:	fe951ce3          	bne	a0,s1,80000a14 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a20:	0000f497          	auipc	s1,0xf
    80000a24:	fe848493          	addi	s1,s1,-24 # 8000fa08 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	1ca000ef          	jal	80000bf4 <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	258000ef          	jal	80000c8c <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	e7a9                	bnez	a5,80000a9c <kfree+0x5a>
    80000a54:	84aa                	mv	s1,a0
    80000a56:	00020797          	auipc	a5,0x20
    80000a5a:	21a78793          	addi	a5,a5,538 # 80020c70 <end>
    80000a5e:	02f56f63          	bltu	a0,a5,80000a9c <kfree+0x5a>
    80000a62:	47c5                	li	a5,17
    80000a64:	07ee                	slli	a5,a5,0x1b
    80000a66:	02f57b63          	bgeu	a0,a5,80000a9c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	4585                	li	a1,1
    80000a6e:	25a000ef          	jal	80000cc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a72:	0000f917          	auipc	s2,0xf
    80000a76:	fce90913          	addi	s2,s2,-50 # 8000fa40 <kmem>
    80000a7a:	854a                	mv	a0,s2
    80000a7c:	178000ef          	jal	80000bf4 <acquire>
  r->next = kmem.freelist;
    80000a80:	01893783          	ld	a5,24(s2)
    80000a84:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a86:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	200000ef          	jal	80000c8c <release>
}
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6902                	ld	s2,0(sp)
    80000a98:	6105                	addi	sp,sp,32
    80000a9a:	8082                	ret
    panic("kfree");
    80000a9c:	00006517          	auipc	a0,0x6
    80000aa0:	59c50513          	addi	a0,a0,1436 # 80007038 <etext+0x38>
    80000aa4:	cf1ff0ef          	jal	80000794 <panic>

0000000080000aa8 <freerange>:
{
    80000aa8:	7179                	addi	sp,sp,-48
    80000aaa:	f406                	sd	ra,40(sp)
    80000aac:	f022                	sd	s0,32(sp)
    80000aae:	ec26                	sd	s1,24(sp)
    80000ab0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab2:	6785                	lui	a5,0x1
    80000ab4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab8:	00e504b3          	add	s1,a0,a4
    80000abc:	777d                	lui	a4,0xfffff
    80000abe:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	94be                	add	s1,s1,a5
    80000ac2:	0295e263          	bltu	a1,s1,80000ae6 <freerange+0x3e>
    80000ac6:	e84a                	sd	s2,16(sp)
    80000ac8:	e44e                	sd	s3,8(sp)
    80000aca:	e052                	sd	s4,0(sp)
    80000acc:	892e                	mv	s2,a1
    kfree(p);
    80000ace:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad0:	6985                	lui	s3,0x1
    kfree(p);
    80000ad2:	01448533          	add	a0,s1,s4
    80000ad6:	f6dff0ef          	jal	80000a42 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe997be3          	bgeu	s2,s1,80000ad2 <freerange+0x2a>
    80000ae0:	6942                	ld	s2,16(sp)
    80000ae2:	69a2                	ld	s3,8(sp)
    80000ae4:	6a02                	ld	s4,0(sp)
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6145                	addi	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e406                	sd	ra,8(sp)
    80000af4:	e022                	sd	s0,0(sp)
    80000af6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af8:	00006597          	auipc	a1,0x6
    80000afc:	54858593          	addi	a1,a1,1352 # 80007040 <etext+0x40>
    80000b00:	0000f517          	auipc	a0,0xf
    80000b04:	f4050513          	addi	a0,a0,-192 # 8000fa40 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00020517          	auipc	a0,0x20
    80000b14:	16050513          	addi	a0,a0,352 # 80020c70 <end>
    80000b18:	f91ff0ef          	jal	80000aa8 <freerange>
}
    80000b1c:	60a2                	ld	ra,8(sp)
    80000b1e:	6402                	ld	s0,0(sp)
    80000b20:	0141                	addi	sp,sp,16
    80000b22:	8082                	ret

0000000080000b24 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b24:	1101                	addi	sp,sp,-32
    80000b26:	ec06                	sd	ra,24(sp)
    80000b28:	e822                	sd	s0,16(sp)
    80000b2a:	e426                	sd	s1,8(sp)
    80000b2c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2e:	0000f497          	auipc	s1,0xf
    80000b32:	f1248493          	addi	s1,s1,-238 # 8000fa40 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	0000f517          	auipc	a0,0xf
    80000b46:	efe50513          	addi	a0,a0,-258 # 8000fa40 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	140000ef          	jal	80000c8c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b50:	6605                	lui	a2,0x1
    80000b52:	4595                	li	a1,5
    80000b54:	8526                	mv	a0,s1
    80000b56:	172000ef          	jal	80000cc8 <memset>
  return (void*)r;
}
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
  release(&kmem.lock);
    80000b66:	0000f517          	auipc	a0,0xf
    80000b6a:	eda50513          	addi	a0,a0,-294 # 8000fa40 <kmem>
    80000b6e:	11e000ef          	jal	80000c8c <release>
  if(r)
    80000b72:	b7e5                	j	80000b5a <kalloc+0x36>

0000000080000b74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e422                	sd	s0,8(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	6422                	ld	s0,8(sp)
    80000b86:	0141                	addi	sp,sp,16
    80000b88:	8082                	ret

0000000080000b8a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8a:	411c                	lw	a5,0(a0)
    80000b8c:	e399                	bnez	a5,80000b92 <holding+0x8>
    80000b8e:	4501                	li	a0,0
  return r;
}
    80000b90:	8082                	ret
{
    80000b92:	1101                	addi	sp,sp,-32
    80000b94:	ec06                	sd	ra,24(sp)
    80000b96:	e822                	sd	s0,16(sp)
    80000b98:	e426                	sd	s1,8(sp)
    80000b9a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9c:	6904                	ld	s1,16(a0)
    80000b9e:	527000ef          	jal	800018c4 <mycpu>
    80000ba2:	40a48533          	sub	a0,s1,a0
    80000ba6:	00153513          	seqz	a0,a0
}
    80000baa:	60e2                	ld	ra,24(sp)
    80000bac:	6442                	ld	s0,16(sp)
    80000bae:	64a2                	ld	s1,8(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbe:	100024f3          	csrr	s1,sstatus
    80000bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bcc:	4f9000ef          	jal	800018c4 <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	4f1000ef          	jal	800018c4 <mycpu>
    80000bd8:	5d3c                	lw	a5,120(a0)
    80000bda:	2785                	addiw	a5,a5,1
    80000bdc:	dd3c                	sw	a5,120(a0)
}
    80000bde:	60e2                	ld	ra,24(sp)
    80000be0:	6442                	ld	s0,16(sp)
    80000be2:	64a2                	ld	s1,8(sp)
    80000be4:	6105                	addi	sp,sp,32
    80000be6:	8082                	ret
    mycpu()->intena = old;
    80000be8:	4dd000ef          	jal	800018c4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bec:	8085                	srli	s1,s1,0x1
    80000bee:	8885                	andi	s1,s1,1
    80000bf0:	dd64                	sw	s1,124(a0)
    80000bf2:	b7cd                	j	80000bd4 <push_off+0x20>

0000000080000bf4 <acquire>:
{
    80000bf4:	1101                	addi	sp,sp,-32
    80000bf6:	ec06                	sd	ra,24(sp)
    80000bf8:	e822                	sd	s0,16(sp)
    80000bfa:	e426                	sd	s1,8(sp)
    80000bfc:	1000                	addi	s0,sp,32
    80000bfe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c00:	fb5ff0ef          	jal	80000bb4 <push_off>
  if(holding(lk))
    80000c04:	8526                	mv	a0,s1
    80000c06:	f85ff0ef          	jal	80000b8a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0a:	4705                	li	a4,1
  if(holding(lk))
    80000c0c:	e105                	bnez	a0,80000c2c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0e:	87ba                	mv	a5,a4
    80000c10:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c14:	2781                	sext.w	a5,a5
    80000c16:	ffe5                	bnez	a5,80000c0e <acquire+0x1a>
  __sync_synchronize();
    80000c18:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c1c:	4a9000ef          	jal	800018c4 <mycpu>
    80000c20:	e888                	sd	a0,16(s1)
}
    80000c22:	60e2                	ld	ra,24(sp)
    80000c24:	6442                	ld	s0,16(sp)
    80000c26:	64a2                	ld	s1,8(sp)
    80000c28:	6105                	addi	sp,sp,32
    80000c2a:	8082                	ret
    panic("acquire");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	41c50513          	addi	a0,a0,1052 # 80007048 <etext+0x48>
    80000c34:	b61ff0ef          	jal	80000794 <panic>

0000000080000c38 <pop_off>:

void
pop_off(void)
{
    80000c38:	1141                	addi	sp,sp,-16
    80000c3a:	e406                	sd	ra,8(sp)
    80000c3c:	e022                	sd	s0,0(sp)
    80000c3e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c40:	485000ef          	jal	800018c4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4a:	e78d                	bnez	a5,80000c74 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4c:	5d3c                	lw	a5,120(a0)
    80000c4e:	02f05963          	blez	a5,80000c80 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c52:	37fd                	addiw	a5,a5,-1
    80000c54:	0007871b          	sext.w	a4,a5
    80000c58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5a:	eb09                	bnez	a4,80000c6c <pop_off+0x34>
    80000c5c:	5d7c                	lw	a5,124(a0)
    80000c5e:	c799                	beqz	a5,80000c6c <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6c:	60a2                	ld	ra,8(sp)
    80000c6e:	6402                	ld	s0,0(sp)
    80000c70:	0141                	addi	sp,sp,16
    80000c72:	8082                	ret
    panic("pop_off - interruptible");
    80000c74:	00006517          	auipc	a0,0x6
    80000c78:	3dc50513          	addi	a0,a0,988 # 80007050 <etext+0x50>
    80000c7c:	b19ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000c80:	00006517          	auipc	a0,0x6
    80000c84:	3e850513          	addi	a0,a0,1000 # 80007068 <etext+0x68>
    80000c88:	b0dff0ef          	jal	80000794 <panic>

0000000080000c8c <release>:
{
    80000c8c:	1101                	addi	sp,sp,-32
    80000c8e:	ec06                	sd	ra,24(sp)
    80000c90:	e822                	sd	s0,16(sp)
    80000c92:	e426                	sd	s1,8(sp)
    80000c94:	1000                	addi	s0,sp,32
    80000c96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c98:	ef3ff0ef          	jal	80000b8a <holding>
    80000c9c:	c105                	beqz	a0,80000cbc <release+0x30>
  lk->cpu = 0;
    80000c9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca6:	0f50000f          	fence	iorw,ow
    80000caa:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cae:	f8bff0ef          	jal	80000c38 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00006517          	auipc	a0,0x6
    80000cc0:	3b450513          	addi	a0,a0,948 # 80007070 <etext+0x70>
    80000cc4:	ad1ff0ef          	jal	80000794 <panic>

0000000080000cc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1c>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x12>
  }
  return dst;
}
    80000ce4:	6422                	ld	s0,8(sp)
    80000ce6:	0141                	addi	sp,sp,16
    80000ce8:	8082                	ret

0000000080000cea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cea:	1141                	addi	sp,sp,-16
    80000cec:	e422                	sd	s0,8(sp)
    80000cee:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf0:	ca05                	beqz	a2,80000d20 <memcmp+0x36>
    80000cf2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf6:	1682                	slli	a3,a3,0x20
    80000cf8:	9281                	srli	a3,a3,0x20
    80000cfa:	0685                	addi	a3,a3,1
    80000cfc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cfe:	00054783          	lbu	a5,0(a0)
    80000d02:	0005c703          	lbu	a4,0(a1)
    80000d06:	00e79863          	bne	a5,a4,80000d16 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0a:	0505                	addi	a0,a0,1
    80000d0c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d0e:	fed518e3          	bne	a0,a3,80000cfe <memcmp+0x14>
  }

  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	a019                	j	80000d1a <memcmp+0x30>
      return *s1 - *s2;
    80000d16:	40e7853b          	subw	a0,a5,a4
}
    80000d1a:	6422                	ld	s0,8(sp)
    80000d1c:	0141                	addi	sp,sp,16
    80000d1e:	8082                	ret
  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	bfe5                	j	80000d1a <memcmp+0x30>

0000000080000d24 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e422                	sd	s0,8(sp)
    80000d28:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2a:	c205                	beqz	a2,80000d4a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2c:	02a5e263          	bltu	a1,a0,80000d50 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d30:	1602                	slli	a2,a2,0x20
    80000d32:	9201                	srli	a2,a2,0x20
    80000d34:	00c587b3          	add	a5,a1,a2
{
    80000d38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3a:	0585                	addi	a1,a1,1
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde391>
    80000d3e:	fff5c683          	lbu	a3,-1(a1)
    80000d42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d46:	feb79ae3          	bne	a5,a1,80000d3a <memmove+0x16>

  return dst;
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
  if(s < d && s + n > d){
    80000d50:	02061693          	slli	a3,a2,0x20
    80000d54:	9281                	srli	a3,a3,0x20
    80000d56:	00d58733          	add	a4,a1,a3
    80000d5a:	fce57be3          	bgeu	a0,a4,80000d30 <memmove+0xc>
    d += n;
    80000d5e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	fff7c793          	not	a5,a5
    80000d6c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	16fd                	addi	a3,a3,-1
    80000d72:	00074603          	lbu	a2,0(a4)
    80000d76:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7a:	fef71ae3          	bne	a4,a5,80000d6e <memmove+0x4a>
    80000d7e:	b7f1                	j	80000d4a <memmove+0x26>

0000000080000d80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d80:	1141                	addi	sp,sp,-16
    80000d82:	e406                	sd	ra,8(sp)
    80000d84:	e022                	sd	s0,0(sp)
    80000d86:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d88:	f9dff0ef          	jal	80000d24 <memmove>
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret

0000000080000d94 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d94:	1141                	addi	sp,sp,-16
    80000d96:	e422                	sd	s0,8(sp)
    80000d98:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9a:	ce11                	beqz	a2,80000db6 <strncmp+0x22>
    80000d9c:	00054783          	lbu	a5,0(a0)
    80000da0:	cf89                	beqz	a5,80000dba <strncmp+0x26>
    80000da2:	0005c703          	lbu	a4,0(a1)
    80000da6:	00f71a63          	bne	a4,a5,80000dba <strncmp+0x26>
    n--, p++, q++;
    80000daa:	367d                	addiw	a2,a2,-1
    80000dac:	0505                	addi	a0,a0,1
    80000dae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db0:	f675                	bnez	a2,80000d9c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db2:	4501                	li	a0,0
    80000db4:	a801                	j	80000dc4 <strncmp+0x30>
    80000db6:	4501                	li	a0,0
    80000db8:	a031                	j	80000dc4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dba:	00054503          	lbu	a0,0(a0)
    80000dbe:	0005c783          	lbu	a5,0(a1)
    80000dc2:	9d1d                	subw	a0,a0,a5
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd0:	87aa                	mv	a5,a0
    80000dd2:	86b2                	mv	a3,a2
    80000dd4:	367d                	addiw	a2,a2,-1
    80000dd6:	02d05563          	blez	a3,80000e00 <strncpy+0x36>
    80000dda:	0785                	addi	a5,a5,1
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	fee78fa3          	sb	a4,-1(a5)
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	f775                	bnez	a4,80000dd2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000de8:	873e                	mv	a4,a5
    80000dea:	9fb5                	addw	a5,a5,a3
    80000dec:	37fd                	addiw	a5,a5,-1
    80000dee:	00c05963          	blez	a2,80000e00 <strncpy+0x36>
    *s++ = 0;
    80000df2:	0705                	addi	a4,a4,1
    80000df4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000df8:	40e786bb          	subw	a3,a5,a4
    80000dfc:	fed04be3          	bgtz	a3,80000df2 <strncpy+0x28>
  return os;
}
    80000e00:	6422                	ld	s0,8(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e422                	sd	s0,8(sp)
    80000e0a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0c:	02c05363          	blez	a2,80000e32 <safestrcpy+0x2c>
    80000e10:	fff6069b          	addiw	a3,a2,-1
    80000e14:	1682                	slli	a3,a3,0x20
    80000e16:	9281                	srli	a3,a3,0x20
    80000e18:	96ae                	add	a3,a3,a1
    80000e1a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1c:	00d58963          	beq	a1,a3,80000e2e <safestrcpy+0x28>
    80000e20:	0585                	addi	a1,a1,1
    80000e22:	0785                	addi	a5,a5,1
    80000e24:	fff5c703          	lbu	a4,-1(a1)
    80000e28:	fee78fa3          	sb	a4,-1(a5)
    80000e2c:	fb65                	bnez	a4,80000e1c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e2e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <strlen>:

int
strlen(const char *s)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e3e:	00054783          	lbu	a5,0(a0)
    80000e42:	cf91                	beqz	a5,80000e5e <strlen+0x26>
    80000e44:	0505                	addi	a0,a0,1
    80000e46:	87aa                	mv	a5,a0
    80000e48:	86be                	mv	a3,a5
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	fff7c703          	lbu	a4,-1(a5)
    80000e50:	ff65                	bnez	a4,80000e48 <strlen+0x10>
    80000e52:	40a6853b          	subw	a0,a3,a0
    80000e56:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e58:	6422                	ld	s0,8(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e5e:	4501                	li	a0,0
    80000e60:	bfe5                	j	80000e58 <strlen+0x20>

0000000080000e62 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e6a:	24b000ef          	jal	800018b4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6e:	00007717          	auipc	a4,0x7
    80000e72:	a9a70713          	addi	a4,a4,-1382 # 80007908 <started>
  if(cpuid() == 0){
    80000e76:	c51d                	beqz	a0,80000ea4 <main+0x42>
    while(started == 0)
    80000e78:	431c                	lw	a5,0(a4)
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dff5                	beqz	a5,80000e78 <main+0x16>
      ;
    __sync_synchronize();
    80000e7e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e82:	233000ef          	jal	800018b4 <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	21050513          	addi	a0,a0,528 # 80007098 <etext+0x98>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	080000ef          	jal	80000f14 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	5c2010ef          	jal	8000245a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	49c040ef          	jal	80005338 <plicinithart>
  }

  scheduler();        
    80000ea0:	675000ef          	jal	80001d14 <scheduler>
    consoleinit();
    80000ea4:	d48ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000ea8:	927ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000eac:	00006517          	auipc	a0,0x6
    80000eb0:	1cc50513          	addi	a0,a0,460 # 80007078 <etext+0x78>
    80000eb4:	e0eff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000eb8:	00006517          	auipc	a0,0x6
    80000ebc:	1c850513          	addi	a0,a0,456 # 80007080 <etext+0x80>
    80000ec0:	e02ff0ef          	jal	800004c2 <printf>
    printf("\n");
    80000ec4:	00006517          	auipc	a0,0x6
    80000ec8:	1b450513          	addi	a0,a0,436 # 80007078 <etext+0x78>
    80000ecc:	df6ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80000ed0:	c21ff0ef          	jal	80000af0 <kinit>
    kvminit();       // create kernel page table
    80000ed4:	2ca000ef          	jal	8000119e <kvminit>
    kvminithart();   // turn on paging
    80000ed8:	03c000ef          	jal	80000f14 <kvminithart>
    procinit();      // process table
    80000edc:	123000ef          	jal	800017fe <procinit>
    trapinit();      // trap vectors
    80000ee0:	556010ef          	jal	80002436 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	576010ef          	jal	8000245a <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	436040ef          	jal	8000531e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	44c040ef          	jal	80005338 <plicinithart>
    binit();         // buffer cache
    80000ef0:	3ef010ef          	jal	80002ade <binit>
    iinit();         // inode table
    80000ef4:	1e0020ef          	jal	800030d4 <iinit>
    fileinit();      // file table
    80000ef8:	78d020ef          	jal	80003e84 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	52c040ef          	jal	80005428 <virtio_disk_init>
    userinit();      // first user process
    80000f00:	449000ef          	jal	80001b48 <userinit>
    __sync_synchronize();
    80000f04:	0ff0000f          	fence
    started = 1;
    80000f08:	4785                	li	a5,1
    80000f0a:	00007717          	auipc	a4,0x7
    80000f0e:	9ef72f23          	sw	a5,-1538(a4) # 80007908 <started>
    80000f12:	b779                	j	80000ea0 <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e422                	sd	s0,8(sp)
    80000f18:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f1a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1e:	00007797          	auipc	a5,0x7
    80000f22:	9f27b783          	ld	a5,-1550(a5) # 80007910 <kernel_pagetable>
    80000f26:	83b1                	srli	a5,a5,0xc
    80000f28:	577d                	li	a4,-1
    80000f2a:	177e                	slli	a4,a4,0x3f
    80000f2c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f2e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f32:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f36:	6422                	ld	s0,8(sp)
    80000f38:	0141                	addi	sp,sp,16
    80000f3a:	8082                	ret

0000000080000f3c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3c:	7139                	addi	sp,sp,-64
    80000f3e:	fc06                	sd	ra,56(sp)
    80000f40:	f822                	sd	s0,48(sp)
    80000f42:	f426                	sd	s1,40(sp)
    80000f44:	f04a                	sd	s2,32(sp)
    80000f46:	ec4e                	sd	s3,24(sp)
    80000f48:	e852                	sd	s4,16(sp)
    80000f4a:	e456                	sd	s5,8(sp)
    80000f4c:	e05a                	sd	s6,0(sp)
    80000f4e:	0080                	addi	s0,sp,64
    80000f50:	84aa                	mv	s1,a0
    80000f52:	89ae                	mv	s3,a1
    80000f54:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f56:	57fd                	li	a5,-1
    80000f58:	83e9                	srli	a5,a5,0x1a
    80000f5a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f5c:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f5e:	02b7fc63          	bgeu	a5,a1,80000f96 <walk+0x5a>
    panic("walk");
    80000f62:	00006517          	auipc	a0,0x6
    80000f66:	14e50513          	addi	a0,a0,334 # 800070b0 <etext+0xb0>
    80000f6a:	82bff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f6e:	060a8263          	beqz	s5,80000fd2 <walk+0x96>
    80000f72:	bb3ff0ef          	jal	80000b24 <kalloc>
    80000f76:	84aa                	mv	s1,a0
    80000f78:	c139                	beqz	a0,80000fbe <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	4581                	li	a1,0
    80000f7e:	d4bff0ef          	jal	80000cc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f82:	00c4d793          	srli	a5,s1,0xc
    80000f86:	07aa                	slli	a5,a5,0xa
    80000f88:	0017e793          	ori	a5,a5,1
    80000f8c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f90:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde387>
    80000f92:	036a0063          	beq	s4,s6,80000fb2 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f96:	0149d933          	srl	s2,s3,s4
    80000f9a:	1ff97913          	andi	s2,s2,511
    80000f9e:	090e                	slli	s2,s2,0x3
    80000fa0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fa2:	00093483          	ld	s1,0(s2)
    80000fa6:	0014f793          	andi	a5,s1,1
    80000faa:	d3f1                	beqz	a5,80000f6e <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fac:	80a9                	srli	s1,s1,0xa
    80000fae:	04b2                	slli	s1,s1,0xc
    80000fb0:	b7c5                	j	80000f90 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fb2:	00c9d513          	srli	a0,s3,0xc
    80000fb6:	1ff57513          	andi	a0,a0,511
    80000fba:	050e                	slli	a0,a0,0x3
    80000fbc:	9526                	add	a0,a0,s1
}
    80000fbe:	70e2                	ld	ra,56(sp)
    80000fc0:	7442                	ld	s0,48(sp)
    80000fc2:	74a2                	ld	s1,40(sp)
    80000fc4:	7902                	ld	s2,32(sp)
    80000fc6:	69e2                	ld	s3,24(sp)
    80000fc8:	6a42                	ld	s4,16(sp)
    80000fca:	6aa2                	ld	s5,8(sp)
    80000fcc:	6b02                	ld	s6,0(sp)
    80000fce:	6121                	addi	sp,sp,64
    80000fd0:	8082                	ret
        return 0;
    80000fd2:	4501                	li	a0,0
    80000fd4:	b7ed                	j	80000fbe <walk+0x82>

0000000080000fd6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fd6:	57fd                	li	a5,-1
    80000fd8:	83e9                	srli	a5,a5,0x1a
    80000fda:	00b7f463          	bgeu	a5,a1,80000fe2 <walkaddr+0xc>
    return 0;
    80000fde:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe0:	8082                	ret
{
    80000fe2:	1141                	addi	sp,sp,-16
    80000fe4:	e406                	sd	ra,8(sp)
    80000fe6:	e022                	sd	s0,0(sp)
    80000fe8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fea:	4601                	li	a2,0
    80000fec:	f51ff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80000ff0:	c105                	beqz	a0,80001010 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000ff2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000ff4:	0117f693          	andi	a3,a5,17
    80000ff8:	4745                	li	a4,17
    return 0;
    80000ffa:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000ffc:	00e68663          	beq	a3,a4,80001008 <walkaddr+0x32>
}
    80001000:	60a2                	ld	ra,8(sp)
    80001002:	6402                	ld	s0,0(sp)
    80001004:	0141                	addi	sp,sp,16
    80001006:	8082                	ret
  pa = PTE2PA(*pte);
    80001008:	83a9                	srli	a5,a5,0xa
    8000100a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000100e:	bfcd                	j	80001000 <walkaddr+0x2a>
    return 0;
    80001010:	4501                	li	a0,0
    80001012:	b7fd                	j	80001000 <walkaddr+0x2a>

0000000080001014 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001014:	715d                	addi	sp,sp,-80
    80001016:	e486                	sd	ra,72(sp)
    80001018:	e0a2                	sd	s0,64(sp)
    8000101a:	fc26                	sd	s1,56(sp)
    8000101c:	f84a                	sd	s2,48(sp)
    8000101e:	f44e                	sd	s3,40(sp)
    80001020:	f052                	sd	s4,32(sp)
    80001022:	ec56                	sd	s5,24(sp)
    80001024:	e85a                	sd	s6,16(sp)
    80001026:	e45e                	sd	s7,8(sp)
    80001028:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000102a:	03459793          	slli	a5,a1,0x34
    8000102e:	e7a9                	bnez	a5,80001078 <mappages+0x64>
    80001030:	8aaa                	mv	s5,a0
    80001032:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001034:	03461793          	slli	a5,a2,0x34
    80001038:	e7b1                	bnez	a5,80001084 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    8000103a:	ca39                	beqz	a2,80001090 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000103c:	77fd                	lui	a5,0xfffff
    8000103e:	963e                	add	a2,a2,a5
    80001040:	00b609b3          	add	s3,a2,a1
  a = va;
    80001044:	892e                	mv	s2,a1
    80001046:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000104a:	6b85                	lui	s7,0x1
    8000104c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001050:	4605                	li	a2,1
    80001052:	85ca                	mv	a1,s2
    80001054:	8556                	mv	a0,s5
    80001056:	ee7ff0ef          	jal	80000f3c <walk>
    8000105a:	c539                	beqz	a0,800010a8 <mappages+0x94>
    if(*pte & PTE_V)
    8000105c:	611c                	ld	a5,0(a0)
    8000105e:	8b85                	andi	a5,a5,1
    80001060:	ef95                	bnez	a5,8000109c <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001062:	80b1                	srli	s1,s1,0xc
    80001064:	04aa                	slli	s1,s1,0xa
    80001066:	0164e4b3          	or	s1,s1,s6
    8000106a:	0014e493          	ori	s1,s1,1
    8000106e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001070:	05390863          	beq	s2,s3,800010c0 <mappages+0xac>
    a += PGSIZE;
    80001074:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001076:	bfd9                	j	8000104c <mappages+0x38>
    panic("mappages: va not aligned");
    80001078:	00006517          	auipc	a0,0x6
    8000107c:	04050513          	addi	a0,a0,64 # 800070b8 <etext+0xb8>
    80001080:	f14ff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    80001084:	00006517          	auipc	a0,0x6
    80001088:	05450513          	addi	a0,a0,84 # 800070d8 <etext+0xd8>
    8000108c:	f08ff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    80001090:	00006517          	auipc	a0,0x6
    80001094:	06850513          	addi	a0,a0,104 # 800070f8 <etext+0xf8>
    80001098:	efcff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    8000109c:	00006517          	auipc	a0,0x6
    800010a0:	06c50513          	addi	a0,a0,108 # 80007108 <etext+0x108>
    800010a4:	ef0ff0ef          	jal	80000794 <panic>
      return -1;
    800010a8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010aa:	60a6                	ld	ra,72(sp)
    800010ac:	6406                	ld	s0,64(sp)
    800010ae:	74e2                	ld	s1,56(sp)
    800010b0:	7942                	ld	s2,48(sp)
    800010b2:	79a2                	ld	s3,40(sp)
    800010b4:	7a02                	ld	s4,32(sp)
    800010b6:	6ae2                	ld	s5,24(sp)
    800010b8:	6b42                	ld	s6,16(sp)
    800010ba:	6ba2                	ld	s7,8(sp)
    800010bc:	6161                	addi	sp,sp,80
    800010be:	8082                	ret
  return 0;
    800010c0:	4501                	li	a0,0
    800010c2:	b7e5                	j	800010aa <mappages+0x96>

00000000800010c4 <kvmmap>:
{
    800010c4:	1141                	addi	sp,sp,-16
    800010c6:	e406                	sd	ra,8(sp)
    800010c8:	e022                	sd	s0,0(sp)
    800010ca:	0800                	addi	s0,sp,16
    800010cc:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010ce:	86b2                	mv	a3,a2
    800010d0:	863e                	mv	a2,a5
    800010d2:	f43ff0ef          	jal	80001014 <mappages>
    800010d6:	e509                	bnez	a0,800010e0 <kvmmap+0x1c>
}
    800010d8:	60a2                	ld	ra,8(sp)
    800010da:	6402                	ld	s0,0(sp)
    800010dc:	0141                	addi	sp,sp,16
    800010de:	8082                	ret
    panic("kvmmap");
    800010e0:	00006517          	auipc	a0,0x6
    800010e4:	03850513          	addi	a0,a0,56 # 80007118 <etext+0x118>
    800010e8:	eacff0ef          	jal	80000794 <panic>

00000000800010ec <kvmmake>:
{
    800010ec:	1101                	addi	sp,sp,-32
    800010ee:	ec06                	sd	ra,24(sp)
    800010f0:	e822                	sd	s0,16(sp)
    800010f2:	e426                	sd	s1,8(sp)
    800010f4:	e04a                	sd	s2,0(sp)
    800010f6:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010f8:	a2dff0ef          	jal	80000b24 <kalloc>
    800010fc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fe:	6605                	lui	a2,0x1
    80001100:	4581                	li	a1,0
    80001102:	bc7ff0ef          	jal	80000cc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001106:	4719                	li	a4,6
    80001108:	6685                	lui	a3,0x1
    8000110a:	10000637          	lui	a2,0x10000
    8000110e:	100005b7          	lui	a1,0x10000
    80001112:	8526                	mv	a0,s1
    80001114:	fb1ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001118:	4719                	li	a4,6
    8000111a:	6685                	lui	a3,0x1
    8000111c:	10001637          	lui	a2,0x10001
    80001120:	100015b7          	lui	a1,0x10001
    80001124:	8526                	mv	a0,s1
    80001126:	f9fff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000112a:	4719                	li	a4,6
    8000112c:	040006b7          	lui	a3,0x4000
    80001130:	0c000637          	lui	a2,0xc000
    80001134:	0c0005b7          	lui	a1,0xc000
    80001138:	8526                	mv	a0,s1
    8000113a:	f8bff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000113e:	00006917          	auipc	s2,0x6
    80001142:	ec290913          	addi	s2,s2,-318 # 80007000 <etext>
    80001146:	4729                	li	a4,10
    80001148:	80006697          	auipc	a3,0x80006
    8000114c:	eb868693          	addi	a3,a3,-328 # 7000 <_entry-0x7fff9000>
    80001150:	4605                	li	a2,1
    80001152:	067e                	slli	a2,a2,0x1f
    80001154:	85b2                	mv	a1,a2
    80001156:	8526                	mv	a0,s1
    80001158:	f6dff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000115c:	46c5                	li	a3,17
    8000115e:	06ee                	slli	a3,a3,0x1b
    80001160:	4719                	li	a4,6
    80001162:	412686b3          	sub	a3,a3,s2
    80001166:	864a                	mv	a2,s2
    80001168:	85ca                	mv	a1,s2
    8000116a:	8526                	mv	a0,s1
    8000116c:	f59ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001170:	4729                	li	a4,10
    80001172:	6685                	lui	a3,0x1
    80001174:	00005617          	auipc	a2,0x5
    80001178:	e8c60613          	addi	a2,a2,-372 # 80006000 <_trampoline>
    8000117c:	040005b7          	lui	a1,0x4000
    80001180:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001182:	05b2                	slli	a1,a1,0xc
    80001184:	8526                	mv	a0,s1
    80001186:	f3fff0ef          	jal	800010c4 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000118a:	8526                	mv	a0,s1
    8000118c:	5da000ef          	jal	80001766 <proc_mapstacks>
}
    80001190:	8526                	mv	a0,s1
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6902                	ld	s2,0(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <kvminit>:
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e406                	sd	ra,8(sp)
    800011a2:	e022                	sd	s0,0(sp)
    800011a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011a6:	f47ff0ef          	jal	800010ec <kvmmake>
    800011aa:	00006797          	auipc	a5,0x6
    800011ae:	76a7b323          	sd	a0,1894(a5) # 80007910 <kernel_pagetable>
}
    800011b2:	60a2                	ld	ra,8(sp)
    800011b4:	6402                	ld	s0,0(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ba:	715d                	addi	sp,sp,-80
    800011bc:	e486                	sd	ra,72(sp)
    800011be:	e0a2                	sd	s0,64(sp)
    800011c0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011c2:	03459793          	slli	a5,a1,0x34
    800011c6:	e39d                	bnez	a5,800011ec <uvmunmap+0x32>
    800011c8:	f84a                	sd	s2,48(sp)
    800011ca:	f44e                	sd	s3,40(sp)
    800011cc:	f052                	sd	s4,32(sp)
    800011ce:	ec56                	sd	s5,24(sp)
    800011d0:	e85a                	sd	s6,16(sp)
    800011d2:	e45e                	sd	s7,8(sp)
    800011d4:	8a2a                	mv	s4,a0
    800011d6:	892e                	mv	s2,a1
    800011d8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011da:	0632                	slli	a2,a2,0xc
    800011dc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011e0:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e2:	6b05                	lui	s6,0x1
    800011e4:	0735ff63          	bgeu	a1,s3,80001262 <uvmunmap+0xa8>
    800011e8:	fc26                	sd	s1,56(sp)
    800011ea:	a0a9                	j	80001234 <uvmunmap+0x7a>
    800011ec:	fc26                	sd	s1,56(sp)
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800011fa:	00006517          	auipc	a0,0x6
    800011fe:	f2650513          	addi	a0,a0,-218 # 80007120 <etext+0x120>
    80001202:	d92ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    80001206:	00006517          	auipc	a0,0x6
    8000120a:	f3250513          	addi	a0,a0,-206 # 80007138 <etext+0x138>
    8000120e:	d86ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    80001212:	00006517          	auipc	a0,0x6
    80001216:	f3650513          	addi	a0,a0,-202 # 80007148 <etext+0x148>
    8000121a:	d7aff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    8000121e:	00006517          	auipc	a0,0x6
    80001222:	f4250513          	addi	a0,a0,-190 # 80007160 <etext+0x160>
    80001226:	d6eff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000122a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000122e:	995a                	add	s2,s2,s6
    80001230:	03397863          	bgeu	s2,s3,80001260 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001234:	4601                	li	a2,0
    80001236:	85ca                	mv	a1,s2
    80001238:	8552                	mv	a0,s4
    8000123a:	d03ff0ef          	jal	80000f3c <walk>
    8000123e:	84aa                	mv	s1,a0
    80001240:	d179                	beqz	a0,80001206 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001242:	6108                	ld	a0,0(a0)
    80001244:	00157793          	andi	a5,a0,1
    80001248:	d7e9                	beqz	a5,80001212 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000124a:	3ff57793          	andi	a5,a0,1023
    8000124e:	fd7788e3          	beq	a5,s7,8000121e <uvmunmap+0x64>
    if(do_free){
    80001252:	fc0a8ce3          	beqz	s5,8000122a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001256:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001258:	0532                	slli	a0,a0,0xc
    8000125a:	fe8ff0ef          	jal	80000a42 <kfree>
    8000125e:	b7f1                	j	8000122a <uvmunmap+0x70>
    80001260:	74e2                	ld	s1,56(sp)
    80001262:	7942                	ld	s2,48(sp)
    80001264:	79a2                	ld	s3,40(sp)
    80001266:	7a02                	ld	s4,32(sp)
    80001268:	6ae2                	ld	s5,24(sp)
    8000126a:	6b42                	ld	s6,16(sp)
    8000126c:	6ba2                	ld	s7,8(sp)
  }
}
    8000126e:	60a6                	ld	ra,72(sp)
    80001270:	6406                	ld	s0,64(sp)
    80001272:	6161                	addi	sp,sp,80
    80001274:	8082                	ret

0000000080001276 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001276:	1101                	addi	sp,sp,-32
    80001278:	ec06                	sd	ra,24(sp)
    8000127a:	e822                	sd	s0,16(sp)
    8000127c:	e426                	sd	s1,8(sp)
    8000127e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001280:	8a5ff0ef          	jal	80000b24 <kalloc>
    80001284:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001286:	c509                	beqz	a0,80001290 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001288:	6605                	lui	a2,0x1
    8000128a:	4581                	li	a1,0
    8000128c:	a3dff0ef          	jal	80000cc8 <memset>
  return pagetable;
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret

000000008000129c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000129c:	7179                	addi	sp,sp,-48
    8000129e:	f406                	sd	ra,40(sp)
    800012a0:	f022                	sd	s0,32(sp)
    800012a2:	ec26                	sd	s1,24(sp)
    800012a4:	e84a                	sd	s2,16(sp)
    800012a6:	e44e                	sd	s3,8(sp)
    800012a8:	e052                	sd	s4,0(sp)
    800012aa:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012ac:	6785                	lui	a5,0x1
    800012ae:	04f67063          	bgeu	a2,a5,800012ee <uvmfirst+0x52>
    800012b2:	8a2a                	mv	s4,a0
    800012b4:	89ae                	mv	s3,a1
    800012b6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012b8:	86dff0ef          	jal	80000b24 <kalloc>
    800012bc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012be:	6605                	lui	a2,0x1
    800012c0:	4581                	li	a1,0
    800012c2:	a07ff0ef          	jal	80000cc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012c6:	4779                	li	a4,30
    800012c8:	86ca                	mv	a3,s2
    800012ca:	6605                	lui	a2,0x1
    800012cc:	4581                	li	a1,0
    800012ce:	8552                	mv	a0,s4
    800012d0:	d45ff0ef          	jal	80001014 <mappages>
  memmove(mem, src, sz);
    800012d4:	8626                	mv	a2,s1
    800012d6:	85ce                	mv	a1,s3
    800012d8:	854a                	mv	a0,s2
    800012da:	a4bff0ef          	jal	80000d24 <memmove>
}
    800012de:	70a2                	ld	ra,40(sp)
    800012e0:	7402                	ld	s0,32(sp)
    800012e2:	64e2                	ld	s1,24(sp)
    800012e4:	6942                	ld	s2,16(sp)
    800012e6:	69a2                	ld	s3,8(sp)
    800012e8:	6a02                	ld	s4,0(sp)
    800012ea:	6145                	addi	sp,sp,48
    800012ec:	8082                	ret
    panic("uvmfirst: more than a page");
    800012ee:	00006517          	auipc	a0,0x6
    800012f2:	e8a50513          	addi	a0,a0,-374 # 80007178 <etext+0x178>
    800012f6:	c9eff0ef          	jal	80000794 <panic>

00000000800012fa <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001304:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001306:	00b67d63          	bgeu	a2,a1,80001320 <uvmdealloc+0x26>
    8000130a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000130c:	6785                	lui	a5,0x1
    8000130e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001310:	00f60733          	add	a4,a2,a5
    80001314:	76fd                	lui	a3,0xfffff
    80001316:	8f75                	and	a4,a4,a3
    80001318:	97ae                	add	a5,a5,a1
    8000131a:	8ff5                	and	a5,a5,a3
    8000131c:	00f76863          	bltu	a4,a5,8000132c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001320:	8526                	mv	a0,s1
    80001322:	60e2                	ld	ra,24(sp)
    80001324:	6442                	ld	s0,16(sp)
    80001326:	64a2                	ld	s1,8(sp)
    80001328:	6105                	addi	sp,sp,32
    8000132a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000132c:	8f99                	sub	a5,a5,a4
    8000132e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001330:	4685                	li	a3,1
    80001332:	0007861b          	sext.w	a2,a5
    80001336:	85ba                	mv	a1,a4
    80001338:	e83ff0ef          	jal	800011ba <uvmunmap>
    8000133c:	b7d5                	j	80001320 <uvmdealloc+0x26>

000000008000133e <uvmalloc>:
  if(newsz < oldsz)
    8000133e:	08b66f63          	bltu	a2,a1,800013dc <uvmalloc+0x9e>
{
    80001342:	7139                	addi	sp,sp,-64
    80001344:	fc06                	sd	ra,56(sp)
    80001346:	f822                	sd	s0,48(sp)
    80001348:	ec4e                	sd	s3,24(sp)
    8000134a:	e852                	sd	s4,16(sp)
    8000134c:	e456                	sd	s5,8(sp)
    8000134e:	0080                	addi	s0,sp,64
    80001350:	8aaa                	mv	s5,a0
    80001352:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001354:	6785                	lui	a5,0x1
    80001356:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001358:	95be                	add	a1,a1,a5
    8000135a:	77fd                	lui	a5,0xfffff
    8000135c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001360:	08c9f063          	bgeu	s3,a2,800013e0 <uvmalloc+0xa2>
    80001364:	f426                	sd	s1,40(sp)
    80001366:	f04a                	sd	s2,32(sp)
    80001368:	e05a                	sd	s6,0(sp)
    8000136a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000136c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001370:	fb4ff0ef          	jal	80000b24 <kalloc>
    80001374:	84aa                	mv	s1,a0
    if(mem == 0){
    80001376:	c515                	beqz	a0,800013a2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	94dff0ef          	jal	80000cc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001380:	875a                	mv	a4,s6
    80001382:	86a6                	mv	a3,s1
    80001384:	6605                	lui	a2,0x1
    80001386:	85ca                	mv	a1,s2
    80001388:	8556                	mv	a0,s5
    8000138a:	c8bff0ef          	jal	80001014 <mappages>
    8000138e:	e915                	bnez	a0,800013c2 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001390:	6785                	lui	a5,0x1
    80001392:	993e                	add	s2,s2,a5
    80001394:	fd496ee3          	bltu	s2,s4,80001370 <uvmalloc+0x32>
  return newsz;
    80001398:	8552                	mv	a0,s4
    8000139a:	74a2                	ld	s1,40(sp)
    8000139c:	7902                	ld	s2,32(sp)
    8000139e:	6b02                	ld	s6,0(sp)
    800013a0:	a811                	j	800013b4 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013a2:	864e                	mv	a2,s3
    800013a4:	85ca                	mv	a1,s2
    800013a6:	8556                	mv	a0,s5
    800013a8:	f53ff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013ac:	4501                	li	a0,0
    800013ae:	74a2                	ld	s1,40(sp)
    800013b0:	7902                	ld	s2,32(sp)
    800013b2:	6b02                	ld	s6,0(sp)
}
    800013b4:	70e2                	ld	ra,56(sp)
    800013b6:	7442                	ld	s0,48(sp)
    800013b8:	69e2                	ld	s3,24(sp)
    800013ba:	6a42                	ld	s4,16(sp)
    800013bc:	6aa2                	ld	s5,8(sp)
    800013be:	6121                	addi	sp,sp,64
    800013c0:	8082                	ret
      kfree(mem);
    800013c2:	8526                	mv	a0,s1
    800013c4:	e7eff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013c8:	864e                	mv	a2,s3
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8556                	mv	a0,s5
    800013ce:	f2dff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013d2:	4501                	li	a0,0
    800013d4:	74a2                	ld	s1,40(sp)
    800013d6:	7902                	ld	s2,32(sp)
    800013d8:	6b02                	ld	s6,0(sp)
    800013da:	bfe9                	j	800013b4 <uvmalloc+0x76>
    return oldsz;
    800013dc:	852e                	mv	a0,a1
}
    800013de:	8082                	ret
  return newsz;
    800013e0:	8532                	mv	a0,a2
    800013e2:	bfc9                	j	800013b4 <uvmalloc+0x76>

00000000800013e4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013e4:	7179                	addi	sp,sp,-48
    800013e6:	f406                	sd	ra,40(sp)
    800013e8:	f022                	sd	s0,32(sp)
    800013ea:	ec26                	sd	s1,24(sp)
    800013ec:	e84a                	sd	s2,16(sp)
    800013ee:	e44e                	sd	s3,8(sp)
    800013f0:	e052                	sd	s4,0(sp)
    800013f2:	1800                	addi	s0,sp,48
    800013f4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013f6:	84aa                	mv	s1,a0
    800013f8:	6905                	lui	s2,0x1
    800013fa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013fc:	4985                	li	s3,1
    800013fe:	a819                	j	80001414 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001400:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001402:	00c79513          	slli	a0,a5,0xc
    80001406:	fdfff0ef          	jal	800013e4 <freewalk>
      pagetable[i] = 0;
    8000140a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000140e:	04a1                	addi	s1,s1,8
    80001410:	01248f63          	beq	s1,s2,8000142e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001414:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001416:	00f7f713          	andi	a4,a5,15
    8000141a:	ff3703e3          	beq	a4,s3,80001400 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000141e:	8b85                	andi	a5,a5,1
    80001420:	d7fd                	beqz	a5,8000140e <freewalk+0x2a>
      panic("freewalk: leaf");
    80001422:	00006517          	auipc	a0,0x6
    80001426:	d7650513          	addi	a0,a0,-650 # 80007198 <etext+0x198>
    8000142a:	b6aff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    8000142e:	8552                	mv	a0,s4
    80001430:	e12ff0ef          	jal	80000a42 <kfree>
}
    80001434:	70a2                	ld	ra,40(sp)
    80001436:	7402                	ld	s0,32(sp)
    80001438:	64e2                	ld	s1,24(sp)
    8000143a:	6942                	ld	s2,16(sp)
    8000143c:	69a2                	ld	s3,8(sp)
    8000143e:	6a02                	ld	s4,0(sp)
    80001440:	6145                	addi	sp,sp,48
    80001442:	8082                	ret

0000000080001444 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001444:	1101                	addi	sp,sp,-32
    80001446:	ec06                	sd	ra,24(sp)
    80001448:	e822                	sd	s0,16(sp)
    8000144a:	e426                	sd	s1,8(sp)
    8000144c:	1000                	addi	s0,sp,32
    8000144e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001450:	e989                	bnez	a1,80001462 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001452:	8526                	mv	a0,s1
    80001454:	f91ff0ef          	jal	800013e4 <freewalk>
}
    80001458:	60e2                	ld	ra,24(sp)
    8000145a:	6442                	ld	s0,16(sp)
    8000145c:	64a2                	ld	s1,8(sp)
    8000145e:	6105                	addi	sp,sp,32
    80001460:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001462:	6785                	lui	a5,0x1
    80001464:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001466:	95be                	add	a1,a1,a5
    80001468:	4685                	li	a3,1
    8000146a:	00c5d613          	srli	a2,a1,0xc
    8000146e:	4581                	li	a1,0
    80001470:	d4bff0ef          	jal	800011ba <uvmunmap>
    80001474:	bff9                	j	80001452 <uvmfree+0xe>

0000000080001476 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001476:	c65d                	beqz	a2,80001524 <uvmcopy+0xae>
{
    80001478:	715d                	addi	sp,sp,-80
    8000147a:	e486                	sd	ra,72(sp)
    8000147c:	e0a2                	sd	s0,64(sp)
    8000147e:	fc26                	sd	s1,56(sp)
    80001480:	f84a                	sd	s2,48(sp)
    80001482:	f44e                	sd	s3,40(sp)
    80001484:	f052                	sd	s4,32(sp)
    80001486:	ec56                	sd	s5,24(sp)
    80001488:	e85a                	sd	s6,16(sp)
    8000148a:	e45e                	sd	s7,8(sp)
    8000148c:	0880                	addi	s0,sp,80
    8000148e:	8b2a                	mv	s6,a0
    80001490:	8aae                	mv	s5,a1
    80001492:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001494:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001496:	4601                	li	a2,0
    80001498:	85ce                	mv	a1,s3
    8000149a:	855a                	mv	a0,s6
    8000149c:	aa1ff0ef          	jal	80000f3c <walk>
    800014a0:	c121                	beqz	a0,800014e0 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014a2:	6118                	ld	a4,0(a0)
    800014a4:	00177793          	andi	a5,a4,1
    800014a8:	c3b1                	beqz	a5,800014ec <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014aa:	00a75593          	srli	a1,a4,0xa
    800014ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014b2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014b6:	e6eff0ef          	jal	80000b24 <kalloc>
    800014ba:	892a                	mv	s2,a0
    800014bc:	c129                	beqz	a0,800014fe <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014be:	6605                	lui	a2,0x1
    800014c0:	85de                	mv	a1,s7
    800014c2:	863ff0ef          	jal	80000d24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014c6:	8726                	mv	a4,s1
    800014c8:	86ca                	mv	a3,s2
    800014ca:	6605                	lui	a2,0x1
    800014cc:	85ce                	mv	a1,s3
    800014ce:	8556                	mv	a0,s5
    800014d0:	b45ff0ef          	jal	80001014 <mappages>
    800014d4:	e115                	bnez	a0,800014f8 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014d6:	6785                	lui	a5,0x1
    800014d8:	99be                	add	s3,s3,a5
    800014da:	fb49eee3          	bltu	s3,s4,80001496 <uvmcopy+0x20>
    800014de:	a805                	j	8000150e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800014e0:	00006517          	auipc	a0,0x6
    800014e4:	cc850513          	addi	a0,a0,-824 # 800071a8 <etext+0x1a8>
    800014e8:	aacff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    800014ec:	00006517          	auipc	a0,0x6
    800014f0:	cdc50513          	addi	a0,a0,-804 # 800071c8 <etext+0x1c8>
    800014f4:	aa0ff0ef          	jal	80000794 <panic>
      kfree(mem);
    800014f8:	854a                	mv	a0,s2
    800014fa:	d48ff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014fe:	4685                	li	a3,1
    80001500:	00c9d613          	srli	a2,s3,0xc
    80001504:	4581                	li	a1,0
    80001506:	8556                	mv	a0,s5
    80001508:	cb3ff0ef          	jal	800011ba <uvmunmap>
  return -1;
    8000150c:	557d                	li	a0,-1
}
    8000150e:	60a6                	ld	ra,72(sp)
    80001510:	6406                	ld	s0,64(sp)
    80001512:	74e2                	ld	s1,56(sp)
    80001514:	7942                	ld	s2,48(sp)
    80001516:	79a2                	ld	s3,40(sp)
    80001518:	7a02                	ld	s4,32(sp)
    8000151a:	6ae2                	ld	s5,24(sp)
    8000151c:	6b42                	ld	s6,16(sp)
    8000151e:	6ba2                	ld	s7,8(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret
  return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	8082                	ret

0000000080001528 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001528:	1141                	addi	sp,sp,-16
    8000152a:	e406                	sd	ra,8(sp)
    8000152c:	e022                	sd	s0,0(sp)
    8000152e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001530:	4601                	li	a2,0
    80001532:	a0bff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80001536:	c901                	beqz	a0,80001546 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001538:	611c                	ld	a5,0(a0)
    8000153a:	9bbd                	andi	a5,a5,-17
    8000153c:	e11c                	sd	a5,0(a0)
}
    8000153e:	60a2                	ld	ra,8(sp)
    80001540:	6402                	ld	s0,0(sp)
    80001542:	0141                	addi	sp,sp,16
    80001544:	8082                	ret
    panic("uvmclear");
    80001546:	00006517          	auipc	a0,0x6
    8000154a:	ca250513          	addi	a0,a0,-862 # 800071e8 <etext+0x1e8>
    8000154e:	a46ff0ef          	jal	80000794 <panic>

0000000080001552 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001552:	cad1                	beqz	a3,800015e6 <copyout+0x94>
{
    80001554:	711d                	addi	sp,sp,-96
    80001556:	ec86                	sd	ra,88(sp)
    80001558:	e8a2                	sd	s0,80(sp)
    8000155a:	e4a6                	sd	s1,72(sp)
    8000155c:	fc4e                	sd	s3,56(sp)
    8000155e:	f456                	sd	s5,40(sp)
    80001560:	f05a                	sd	s6,32(sp)
    80001562:	ec5e                	sd	s7,24(sp)
    80001564:	1080                	addi	s0,sp,96
    80001566:	8baa                	mv	s7,a0
    80001568:	8aae                	mv	s5,a1
    8000156a:	8b32                	mv	s6,a2
    8000156c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000156e:	74fd                	lui	s1,0xfffff
    80001570:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001572:	57fd                	li	a5,-1
    80001574:	83e9                	srli	a5,a5,0x1a
    80001576:	0697ea63          	bltu	a5,s1,800015ea <copyout+0x98>
    8000157a:	e0ca                	sd	s2,64(sp)
    8000157c:	f852                	sd	s4,48(sp)
    8000157e:	e862                	sd	s8,16(sp)
    80001580:	e466                	sd	s9,8(sp)
    80001582:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001584:	4cd5                	li	s9,21
    80001586:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001588:	8c3e                	mv	s8,a5
    8000158a:	a025                	j	800015b2 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    8000158c:	83a9                	srli	a5,a5,0xa
    8000158e:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001590:	409a8533          	sub	a0,s5,s1
    80001594:	0009061b          	sext.w	a2,s2
    80001598:	85da                	mv	a1,s6
    8000159a:	953e                	add	a0,a0,a5
    8000159c:	f88ff0ef          	jal	80000d24 <memmove>

    len -= n;
    800015a0:	412989b3          	sub	s3,s3,s2
    src += n;
    800015a4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015a6:	02098963          	beqz	s3,800015d8 <copyout+0x86>
    if(va0 >= MAXVA)
    800015aa:	054c6263          	bltu	s8,s4,800015ee <copyout+0x9c>
    800015ae:	84d2                	mv	s1,s4
    800015b0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015b2:	4601                	li	a2,0
    800015b4:	85a6                	mv	a1,s1
    800015b6:	855e                	mv	a0,s7
    800015b8:	985ff0ef          	jal	80000f3c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015bc:	c121                	beqz	a0,800015fc <copyout+0xaa>
    800015be:	611c                	ld	a5,0(a0)
    800015c0:	0157f713          	andi	a4,a5,21
    800015c4:	05971b63          	bne	a4,s9,8000161a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015c8:	01a48a33          	add	s4,s1,s10
    800015cc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015d0:	fb29fee3          	bgeu	s3,s2,8000158c <copyout+0x3a>
    800015d4:	894e                	mv	s2,s3
    800015d6:	bf5d                	j	8000158c <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015d8:	4501                	li	a0,0
    800015da:	6906                	ld	s2,64(sp)
    800015dc:	7a42                	ld	s4,48(sp)
    800015de:	6c42                	ld	s8,16(sp)
    800015e0:	6ca2                	ld	s9,8(sp)
    800015e2:	6d02                	ld	s10,0(sp)
    800015e4:	a015                	j	80001608 <copyout+0xb6>
    800015e6:	4501                	li	a0,0
}
    800015e8:	8082                	ret
      return -1;
    800015ea:	557d                	li	a0,-1
    800015ec:	a831                	j	80001608 <copyout+0xb6>
    800015ee:	557d                	li	a0,-1
    800015f0:	6906                	ld	s2,64(sp)
    800015f2:	7a42                	ld	s4,48(sp)
    800015f4:	6c42                	ld	s8,16(sp)
    800015f6:	6ca2                	ld	s9,8(sp)
    800015f8:	6d02                	ld	s10,0(sp)
    800015fa:	a039                	j	80001608 <copyout+0xb6>
      return -1;
    800015fc:	557d                	li	a0,-1
    800015fe:	6906                	ld	s2,64(sp)
    80001600:	7a42                	ld	s4,48(sp)
    80001602:	6c42                	ld	s8,16(sp)
    80001604:	6ca2                	ld	s9,8(sp)
    80001606:	6d02                	ld	s10,0(sp)
}
    80001608:	60e6                	ld	ra,88(sp)
    8000160a:	6446                	ld	s0,80(sp)
    8000160c:	64a6                	ld	s1,72(sp)
    8000160e:	79e2                	ld	s3,56(sp)
    80001610:	7aa2                	ld	s5,40(sp)
    80001612:	7b02                	ld	s6,32(sp)
    80001614:	6be2                	ld	s7,24(sp)
    80001616:	6125                	addi	sp,sp,96
    80001618:	8082                	ret
      return -1;
    8000161a:	557d                	li	a0,-1
    8000161c:	6906                	ld	s2,64(sp)
    8000161e:	7a42                	ld	s4,48(sp)
    80001620:	6c42                	ld	s8,16(sp)
    80001622:	6ca2                	ld	s9,8(sp)
    80001624:	6d02                	ld	s10,0(sp)
    80001626:	b7cd                	j	80001608 <copyout+0xb6>

0000000080001628 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001628:	c6a5                	beqz	a3,80001690 <copyin+0x68>
{
    8000162a:	715d                	addi	sp,sp,-80
    8000162c:	e486                	sd	ra,72(sp)
    8000162e:	e0a2                	sd	s0,64(sp)
    80001630:	fc26                	sd	s1,56(sp)
    80001632:	f84a                	sd	s2,48(sp)
    80001634:	f44e                	sd	s3,40(sp)
    80001636:	f052                	sd	s4,32(sp)
    80001638:	ec56                	sd	s5,24(sp)
    8000163a:	e85a                	sd	s6,16(sp)
    8000163c:	e45e                	sd	s7,8(sp)
    8000163e:	e062                	sd	s8,0(sp)
    80001640:	0880                	addi	s0,sp,80
    80001642:	8b2a                	mv	s6,a0
    80001644:	8a2e                	mv	s4,a1
    80001646:	8c32                	mv	s8,a2
    80001648:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000164a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000164c:	6a85                	lui	s5,0x1
    8000164e:	a00d                	j	80001670 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001650:	018505b3          	add	a1,a0,s8
    80001654:	0004861b          	sext.w	a2,s1
    80001658:	412585b3          	sub	a1,a1,s2
    8000165c:	8552                	mv	a0,s4
    8000165e:	ec6ff0ef          	jal	80000d24 <memmove>

    len -= n;
    80001662:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001666:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001668:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000166c:	02098063          	beqz	s3,8000168c <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001670:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001674:	85ca                	mv	a1,s2
    80001676:	855a                	mv	a0,s6
    80001678:	95fff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    8000167c:	cd01                	beqz	a0,80001694 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000167e:	418904b3          	sub	s1,s2,s8
    80001682:	94d6                	add	s1,s1,s5
    if(n > len)
    80001684:	fc99f6e3          	bgeu	s3,s1,80001650 <copyin+0x28>
    80001688:	84ce                	mv	s1,s3
    8000168a:	b7d9                	j	80001650 <copyin+0x28>
  }
  return 0;
    8000168c:	4501                	li	a0,0
    8000168e:	a021                	j	80001696 <copyin+0x6e>
    80001690:	4501                	li	a0,0
}
    80001692:	8082                	ret
      return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6c02                	ld	s8,0(sp)
    800016aa:	6161                	addi	sp,sp,80
    800016ac:	8082                	ret

00000000800016ae <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016ae:	c6dd                	beqz	a3,8000175c <copyinstr+0xae>
{
    800016b0:	715d                	addi	sp,sp,-80
    800016b2:	e486                	sd	ra,72(sp)
    800016b4:	e0a2                	sd	s0,64(sp)
    800016b6:	fc26                	sd	s1,56(sp)
    800016b8:	f84a                	sd	s2,48(sp)
    800016ba:	f44e                	sd	s3,40(sp)
    800016bc:	f052                	sd	s4,32(sp)
    800016be:	ec56                	sd	s5,24(sp)
    800016c0:	e85a                	sd	s6,16(sp)
    800016c2:	e45e                	sd	s7,8(sp)
    800016c4:	0880                	addi	s0,sp,80
    800016c6:	8a2a                	mv	s4,a0
    800016c8:	8b2e                	mv	s6,a1
    800016ca:	8bb2                	mv	s7,a2
    800016cc:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016ce:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016d0:	6985                	lui	s3,0x1
    800016d2:	a825                	j	8000170a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016d4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016d8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016da:	37fd                	addiw	a5,a5,-1
    800016dc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016e0:	60a6                	ld	ra,72(sp)
    800016e2:	6406                	ld	s0,64(sp)
    800016e4:	74e2                	ld	s1,56(sp)
    800016e6:	7942                	ld	s2,48(sp)
    800016e8:	79a2                	ld	s3,40(sp)
    800016ea:	7a02                	ld	s4,32(sp)
    800016ec:	6ae2                	ld	s5,24(sp)
    800016ee:	6b42                	ld	s6,16(sp)
    800016f0:	6ba2                	ld	s7,8(sp)
    800016f2:	6161                	addi	sp,sp,80
    800016f4:	8082                	ret
    800016f6:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800016fa:	9742                	add	a4,a4,a6
      --max;
    800016fc:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001700:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001704:	04e58463          	beq	a1,a4,8000174c <copyinstr+0x9e>
{
    80001708:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000170a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000170e:	85a6                	mv	a1,s1
    80001710:	8552                	mv	a0,s4
    80001712:	8c5ff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    80001716:	cd0d                	beqz	a0,80001750 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001718:	417486b3          	sub	a3,s1,s7
    8000171c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000171e:	00d97363          	bgeu	s2,a3,80001724 <copyinstr+0x76>
    80001722:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001724:	955e                	add	a0,a0,s7
    80001726:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001728:	c695                	beqz	a3,80001754 <copyinstr+0xa6>
    8000172a:	87da                	mv	a5,s6
    8000172c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000172e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001732:	96da                	add	a3,a3,s6
    80001734:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001736:	00f60733          	add	a4,a2,a5
    8000173a:	00074703          	lbu	a4,0(a4)
    8000173e:	db59                	beqz	a4,800016d4 <copyinstr+0x26>
        *dst = *p;
    80001740:	00e78023          	sb	a4,0(a5)
      dst++;
    80001744:	0785                	addi	a5,a5,1
    while(n > 0){
    80001746:	fed797e3          	bne	a5,a3,80001734 <copyinstr+0x86>
    8000174a:	b775                	j	800016f6 <copyinstr+0x48>
    8000174c:	4781                	li	a5,0
    8000174e:	b771                	j	800016da <copyinstr+0x2c>
      return -1;
    80001750:	557d                	li	a0,-1
    80001752:	b779                	j	800016e0 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001754:	6b85                	lui	s7,0x1
    80001756:	9ba6                	add	s7,s7,s1
    80001758:	87da                	mv	a5,s6
    8000175a:	b77d                	j	80001708 <copyinstr+0x5a>
  int got_null = 0;
    8000175c:	4781                	li	a5,0
  if(got_null){
    8000175e:	37fd                	addiw	a5,a5,-1
    80001760:	0007851b          	sext.w	a0,a5
}
    80001764:	8082                	ret

0000000080001766 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001766:	7139                	addi	sp,sp,-64
    80001768:	fc06                	sd	ra,56(sp)
    8000176a:	f822                	sd	s0,48(sp)
    8000176c:	f426                	sd	s1,40(sp)
    8000176e:	f04a                	sd	s2,32(sp)
    80001770:	ec4e                	sd	s3,24(sp)
    80001772:	e852                	sd	s4,16(sp)
    80001774:	e456                	sd	s5,8(sp)
    80001776:	e05a                	sd	s6,0(sp)
    80001778:	0080                	addi	s0,sp,64
    8000177a:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000177c:	0000e497          	auipc	s1,0xe
    80001780:	71448493          	addi	s1,s1,1812 # 8000fe90 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001784:	8b26                	mv	s6,s1
    80001786:	04fa5937          	lui	s2,0x4fa5
    8000178a:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    8000178e:	0932                	slli	s2,s2,0xc
    80001790:	fa590913          	addi	s2,s2,-91
    80001794:	0932                	slli	s2,s2,0xc
    80001796:	fa590913          	addi	s2,s2,-91
    8000179a:	0932                	slli	s2,s2,0xc
    8000179c:	fa590913          	addi	s2,s2,-91
    800017a0:	040009b7          	lui	s3,0x4000
    800017a4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017a6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a8:	00014a97          	auipc	s5,0x14
    800017ac:	0e8a8a93          	addi	s5,s5,232 # 80015890 <tickslock>
    char *pa = kalloc();
    800017b0:	b74ff0ef          	jal	80000b24 <kalloc>
    800017b4:	862a                	mv	a2,a0
    if(pa == 0)
    800017b6:	cd15                	beqz	a0,800017f2 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017b8:	416485b3          	sub	a1,s1,s6
    800017bc:	858d                	srai	a1,a1,0x3
    800017be:	032585b3          	mul	a1,a1,s2
    800017c2:	2585                	addiw	a1,a1,1
    800017c4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017c8:	4719                	li	a4,6
    800017ca:	6685                	lui	a3,0x1
    800017cc:	40b985b3          	sub	a1,s3,a1
    800017d0:	8552                	mv	a0,s4
    800017d2:	8f3ff0ef          	jal	800010c4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d6:	16848493          	addi	s1,s1,360
    800017da:	fd549be3          	bne	s1,s5,800017b0 <proc_mapstacks+0x4a>
  }
}
    800017de:	70e2                	ld	ra,56(sp)
    800017e0:	7442                	ld	s0,48(sp)
    800017e2:	74a2                	ld	s1,40(sp)
    800017e4:	7902                	ld	s2,32(sp)
    800017e6:	69e2                	ld	s3,24(sp)
    800017e8:	6a42                	ld	s4,16(sp)
    800017ea:	6aa2                	ld	s5,8(sp)
    800017ec:	6b02                	ld	s6,0(sp)
    800017ee:	6121                	addi	sp,sp,64
    800017f0:	8082                	ret
      panic("kalloc");
    800017f2:	00006517          	auipc	a0,0x6
    800017f6:	a0650513          	addi	a0,a0,-1530 # 800071f8 <etext+0x1f8>
    800017fa:	f9bfe0ef          	jal	80000794 <panic>

00000000800017fe <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017fe:	7139                	addi	sp,sp,-64
    80001800:	fc06                	sd	ra,56(sp)
    80001802:	f822                	sd	s0,48(sp)
    80001804:	f426                	sd	s1,40(sp)
    80001806:	f04a                	sd	s2,32(sp)
    80001808:	ec4e                	sd	s3,24(sp)
    8000180a:	e852                	sd	s4,16(sp)
    8000180c:	e456                	sd	s5,8(sp)
    8000180e:	e05a                	sd	s6,0(sp)
    80001810:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001812:	00006597          	auipc	a1,0x6
    80001816:	9ee58593          	addi	a1,a1,-1554 # 80007200 <etext+0x200>
    8000181a:	0000e517          	auipc	a0,0xe
    8000181e:	24650513          	addi	a0,a0,582 # 8000fa60 <pid_lock>
    80001822:	b52ff0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001826:	00006597          	auipc	a1,0x6
    8000182a:	9e258593          	addi	a1,a1,-1566 # 80007208 <etext+0x208>
    8000182e:	0000e517          	auipc	a0,0xe
    80001832:	24a50513          	addi	a0,a0,586 # 8000fa78 <wait_lock>
    80001836:	b3eff0ef          	jal	80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000183a:	0000e497          	auipc	s1,0xe
    8000183e:	65648493          	addi	s1,s1,1622 # 8000fe90 <proc>
      initlock(&p->lock, "proc");
    80001842:	00006b17          	auipc	s6,0x6
    80001846:	9d6b0b13          	addi	s6,s6,-1578 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000184a:	8aa6                	mv	s5,s1
    8000184c:	04fa5937          	lui	s2,0x4fa5
    80001850:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001854:	0932                	slli	s2,s2,0xc
    80001856:	fa590913          	addi	s2,s2,-91
    8000185a:	0932                	slli	s2,s2,0xc
    8000185c:	fa590913          	addi	s2,s2,-91
    80001860:	0932                	slli	s2,s2,0xc
    80001862:	fa590913          	addi	s2,s2,-91
    80001866:	040009b7          	lui	s3,0x4000
    8000186a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000186c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186e:	00014a17          	auipc	s4,0x14
    80001872:	022a0a13          	addi	s4,s4,34 # 80015890 <tickslock>
      initlock(&p->lock, "proc");
    80001876:	85da                	mv	a1,s6
    80001878:	8526                	mv	a0,s1
    8000187a:	afaff0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    8000187e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001882:	415487b3          	sub	a5,s1,s5
    80001886:	878d                	srai	a5,a5,0x3
    80001888:	032787b3          	mul	a5,a5,s2
    8000188c:	2785                	addiw	a5,a5,1
    8000188e:	00d7979b          	slliw	a5,a5,0xd
    80001892:	40f987b3          	sub	a5,s3,a5
    80001896:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001898:	16848493          	addi	s1,s1,360
    8000189c:	fd449de3          	bne	s1,s4,80001876 <procinit+0x78>
  }
}
    800018a0:	70e2                	ld	ra,56(sp)
    800018a2:	7442                	ld	s0,48(sp)
    800018a4:	74a2                	ld	s1,40(sp)
    800018a6:	7902                	ld	s2,32(sp)
    800018a8:	69e2                	ld	s3,24(sp)
    800018aa:	6a42                	ld	s4,16(sp)
    800018ac:	6aa2                	ld	s5,8(sp)
    800018ae:	6b02                	ld	s6,0(sp)
    800018b0:	6121                	addi	sp,sp,64
    800018b2:	8082                	ret

00000000800018b4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018b4:	1141                	addi	sp,sp,-16
    800018b6:	e422                	sd	s0,8(sp)
    800018b8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018ba:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018bc:	2501                	sext.w	a0,a0
    800018be:	6422                	ld	s0,8(sp)
    800018c0:	0141                	addi	sp,sp,16
    800018c2:	8082                	ret

00000000800018c4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018c4:	1141                	addi	sp,sp,-16
    800018c6:	e422                	sd	s0,8(sp)
    800018c8:	0800                	addi	s0,sp,16
    800018ca:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018cc:	2781                	sext.w	a5,a5
    800018ce:	079e                	slli	a5,a5,0x7
  return c;
}
    800018d0:	0000e517          	auipc	a0,0xe
    800018d4:	1c050513          	addi	a0,a0,448 # 8000fa90 <cpus>
    800018d8:	953e                	add	a0,a0,a5
    800018da:	6422                	ld	s0,8(sp)
    800018dc:	0141                	addi	sp,sp,16
    800018de:	8082                	ret

00000000800018e0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018e0:	1101                	addi	sp,sp,-32
    800018e2:	ec06                	sd	ra,24(sp)
    800018e4:	e822                	sd	s0,16(sp)
    800018e6:	e426                	sd	s1,8(sp)
    800018e8:	1000                	addi	s0,sp,32
  push_off();
    800018ea:	acaff0ef          	jal	80000bb4 <push_off>
    800018ee:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018f0:	2781                	sext.w	a5,a5
    800018f2:	079e                	slli	a5,a5,0x7
    800018f4:	0000e717          	auipc	a4,0xe
    800018f8:	16c70713          	addi	a4,a4,364 # 8000fa60 <pid_lock>
    800018fc:	97ba                	add	a5,a5,a4
    800018fe:	7b84                	ld	s1,48(a5)
  pop_off();
    80001900:	b38ff0ef          	jal	80000c38 <pop_off>
  return p;
}
    80001904:	8526                	mv	a0,s1
    80001906:	60e2                	ld	ra,24(sp)
    80001908:	6442                	ld	s0,16(sp)
    8000190a:	64a2                	ld	s1,8(sp)
    8000190c:	6105                	addi	sp,sp,32
    8000190e:	8082                	ret

0000000080001910 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001910:	1141                	addi	sp,sp,-16
    80001912:	e406                	sd	ra,8(sp)
    80001914:	e022                	sd	s0,0(sp)
    80001916:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001918:	fc9ff0ef          	jal	800018e0 <myproc>
    8000191c:	b70ff0ef          	jal	80000c8c <release>

  if (first) {
    80001920:	00006797          	auipc	a5,0x6
    80001924:	f807a783          	lw	a5,-128(a5) # 800078a0 <first.1>
    80001928:	e799                	bnez	a5,80001936 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000192a:	349000ef          	jal	80002472 <usertrapret>
}
    8000192e:	60a2                	ld	ra,8(sp)
    80001930:	6402                	ld	s0,0(sp)
    80001932:	0141                	addi	sp,sp,16
    80001934:	8082                	ret
    fsinit(ROOTDEV);
    80001936:	4505                	li	a0,1
    80001938:	730010ef          	jal	80003068 <fsinit>
    first = 0;
    8000193c:	00006797          	auipc	a5,0x6
    80001940:	f607a223          	sw	zero,-156(a5) # 800078a0 <first.1>
    __sync_synchronize();
    80001944:	0ff0000f          	fence
    80001948:	b7cd                	j	8000192a <forkret+0x1a>

000000008000194a <allocpid>:
{
    8000194a:	1101                	addi	sp,sp,-32
    8000194c:	ec06                	sd	ra,24(sp)
    8000194e:	e822                	sd	s0,16(sp)
    80001950:	e426                	sd	s1,8(sp)
    80001952:	e04a                	sd	s2,0(sp)
    80001954:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001956:	0000e917          	auipc	s2,0xe
    8000195a:	10a90913          	addi	s2,s2,266 # 8000fa60 <pid_lock>
    8000195e:	854a                	mv	a0,s2
    80001960:	a94ff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    80001964:	00006797          	auipc	a5,0x6
    80001968:	f4078793          	addi	a5,a5,-192 # 800078a4 <nextpid>
    8000196c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000196e:	0014871b          	addiw	a4,s1,1
    80001972:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001974:	854a                	mv	a0,s2
    80001976:	b16ff0ef          	jal	80000c8c <release>
}
    8000197a:	8526                	mv	a0,s1
    8000197c:	60e2                	ld	ra,24(sp)
    8000197e:	6442                	ld	s0,16(sp)
    80001980:	64a2                	ld	s1,8(sp)
    80001982:	6902                	ld	s2,0(sp)
    80001984:	6105                	addi	sp,sp,32
    80001986:	8082                	ret

0000000080001988 <proc_pagetable>:
{
    80001988:	1101                	addi	sp,sp,-32
    8000198a:	ec06                	sd	ra,24(sp)
    8000198c:	e822                	sd	s0,16(sp)
    8000198e:	e426                	sd	s1,8(sp)
    80001990:	e04a                	sd	s2,0(sp)
    80001992:	1000                	addi	s0,sp,32
    80001994:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001996:	8e1ff0ef          	jal	80001276 <uvmcreate>
    8000199a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000199c:	cd05                	beqz	a0,800019d4 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000199e:	4729                	li	a4,10
    800019a0:	00004697          	auipc	a3,0x4
    800019a4:	66068693          	addi	a3,a3,1632 # 80006000 <_trampoline>
    800019a8:	6605                	lui	a2,0x1
    800019aa:	040005b7          	lui	a1,0x4000
    800019ae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019b0:	05b2                	slli	a1,a1,0xc
    800019b2:	e62ff0ef          	jal	80001014 <mappages>
    800019b6:	02054663          	bltz	a0,800019e2 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019ba:	4719                	li	a4,6
    800019bc:	05893683          	ld	a3,88(s2)
    800019c0:	6605                	lui	a2,0x1
    800019c2:	020005b7          	lui	a1,0x2000
    800019c6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019c8:	05b6                	slli	a1,a1,0xd
    800019ca:	8526                	mv	a0,s1
    800019cc:	e48ff0ef          	jal	80001014 <mappages>
    800019d0:	00054f63          	bltz	a0,800019ee <proc_pagetable+0x66>
}
    800019d4:	8526                	mv	a0,s1
    800019d6:	60e2                	ld	ra,24(sp)
    800019d8:	6442                	ld	s0,16(sp)
    800019da:	64a2                	ld	s1,8(sp)
    800019dc:	6902                	ld	s2,0(sp)
    800019de:	6105                	addi	sp,sp,32
    800019e0:	8082                	ret
    uvmfree(pagetable, 0);
    800019e2:	4581                	li	a1,0
    800019e4:	8526                	mv	a0,s1
    800019e6:	a5fff0ef          	jal	80001444 <uvmfree>
    return 0;
    800019ea:	4481                	li	s1,0
    800019ec:	b7e5                	j	800019d4 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019ee:	4681                	li	a3,0
    800019f0:	4605                	li	a2,1
    800019f2:	040005b7          	lui	a1,0x4000
    800019f6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019f8:	05b2                	slli	a1,a1,0xc
    800019fa:	8526                	mv	a0,s1
    800019fc:	fbeff0ef          	jal	800011ba <uvmunmap>
    uvmfree(pagetable, 0);
    80001a00:	4581                	li	a1,0
    80001a02:	8526                	mv	a0,s1
    80001a04:	a41ff0ef          	jal	80001444 <uvmfree>
    return 0;
    80001a08:	4481                	li	s1,0
    80001a0a:	b7e9                	j	800019d4 <proc_pagetable+0x4c>

0000000080001a0c <proc_freepagetable>:
{
    80001a0c:	1101                	addi	sp,sp,-32
    80001a0e:	ec06                	sd	ra,24(sp)
    80001a10:	e822                	sd	s0,16(sp)
    80001a12:	e426                	sd	s1,8(sp)
    80001a14:	e04a                	sd	s2,0(sp)
    80001a16:	1000                	addi	s0,sp,32
    80001a18:	84aa                	mv	s1,a0
    80001a1a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a1c:	4681                	li	a3,0
    80001a1e:	4605                	li	a2,1
    80001a20:	040005b7          	lui	a1,0x4000
    80001a24:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a26:	05b2                	slli	a1,a1,0xc
    80001a28:	f92ff0ef          	jal	800011ba <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a2c:	4681                	li	a3,0
    80001a2e:	4605                	li	a2,1
    80001a30:	020005b7          	lui	a1,0x2000
    80001a34:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a36:	05b6                	slli	a1,a1,0xd
    80001a38:	8526                	mv	a0,s1
    80001a3a:	f80ff0ef          	jal	800011ba <uvmunmap>
  uvmfree(pagetable, sz);
    80001a3e:	85ca                	mv	a1,s2
    80001a40:	8526                	mv	a0,s1
    80001a42:	a03ff0ef          	jal	80001444 <uvmfree>
}
    80001a46:	60e2                	ld	ra,24(sp)
    80001a48:	6442                	ld	s0,16(sp)
    80001a4a:	64a2                	ld	s1,8(sp)
    80001a4c:	6902                	ld	s2,0(sp)
    80001a4e:	6105                	addi	sp,sp,32
    80001a50:	8082                	ret

0000000080001a52 <freeproc>:
{
    80001a52:	1101                	addi	sp,sp,-32
    80001a54:	ec06                	sd	ra,24(sp)
    80001a56:	e822                	sd	s0,16(sp)
    80001a58:	e426                	sd	s1,8(sp)
    80001a5a:	1000                	addi	s0,sp,32
    80001a5c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a5e:	6d28                	ld	a0,88(a0)
    80001a60:	c119                	beqz	a0,80001a66 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a62:	fe1fe0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    80001a66:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a6a:	68a8                	ld	a0,80(s1)
    80001a6c:	c501                	beqz	a0,80001a74 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a6e:	64ac                	ld	a1,72(s1)
    80001a70:	f9dff0ef          	jal	80001a0c <proc_freepagetable>
  p->pagetable = 0;
    80001a74:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a78:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a7c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a80:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001a84:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a88:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a8c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a90:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001a94:	0004ac23          	sw	zero,24(s1)
}
    80001a98:	60e2                	ld	ra,24(sp)
    80001a9a:	6442                	ld	s0,16(sp)
    80001a9c:	64a2                	ld	s1,8(sp)
    80001a9e:	6105                	addi	sp,sp,32
    80001aa0:	8082                	ret

0000000080001aa2 <allocproc>:
{
    80001aa2:	1101                	addi	sp,sp,-32
    80001aa4:	ec06                	sd	ra,24(sp)
    80001aa6:	e822                	sd	s0,16(sp)
    80001aa8:	e426                	sd	s1,8(sp)
    80001aaa:	e04a                	sd	s2,0(sp)
    80001aac:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001aae:	0000e497          	auipc	s1,0xe
    80001ab2:	3e248493          	addi	s1,s1,994 # 8000fe90 <proc>
    80001ab6:	00014917          	auipc	s2,0x14
    80001aba:	dda90913          	addi	s2,s2,-550 # 80015890 <tickslock>
    acquire(&p->lock);
    80001abe:	8526                	mv	a0,s1
    80001ac0:	934ff0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80001ac4:	4c9c                	lw	a5,24(s1)
    80001ac6:	cb91                	beqz	a5,80001ada <allocproc+0x38>
      release(&p->lock);
    80001ac8:	8526                	mv	a0,s1
    80001aca:	9c2ff0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ace:	16848493          	addi	s1,s1,360
    80001ad2:	ff2496e3          	bne	s1,s2,80001abe <allocproc+0x1c>
  return 0;
    80001ad6:	4481                	li	s1,0
    80001ad8:	a089                	j	80001b1a <allocproc+0x78>
  p->pid = allocpid();
    80001ada:	e71ff0ef          	jal	8000194a <allocpid>
    80001ade:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001ae0:	4785                	li	a5,1
    80001ae2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001ae4:	840ff0ef          	jal	80000b24 <kalloc>
    80001ae8:	892a                	mv	s2,a0
    80001aea:	eca8                	sd	a0,88(s1)
    80001aec:	cd15                	beqz	a0,80001b28 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001aee:	8526                	mv	a0,s1
    80001af0:	e99ff0ef          	jal	80001988 <proc_pagetable>
    80001af4:	892a                	mv	s2,a0
    80001af6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001af8:	c121                	beqz	a0,80001b38 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001afa:	07000613          	li	a2,112
    80001afe:	4581                	li	a1,0
    80001b00:	06048513          	addi	a0,s1,96
    80001b04:	9c4ff0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80001b08:	00000797          	auipc	a5,0x0
    80001b0c:	e0878793          	addi	a5,a5,-504 # 80001910 <forkret>
    80001b10:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b12:	60bc                	ld	a5,64(s1)
    80001b14:	6705                	lui	a4,0x1
    80001b16:	97ba                	add	a5,a5,a4
    80001b18:	f4bc                	sd	a5,104(s1)
}
    80001b1a:	8526                	mv	a0,s1
    80001b1c:	60e2                	ld	ra,24(sp)
    80001b1e:	6442                	ld	s0,16(sp)
    80001b20:	64a2                	ld	s1,8(sp)
    80001b22:	6902                	ld	s2,0(sp)
    80001b24:	6105                	addi	sp,sp,32
    80001b26:	8082                	ret
    freeproc(p);
    80001b28:	8526                	mv	a0,s1
    80001b2a:	f29ff0ef          	jal	80001a52 <freeproc>
    release(&p->lock);
    80001b2e:	8526                	mv	a0,s1
    80001b30:	95cff0ef          	jal	80000c8c <release>
    return 0;
    80001b34:	84ca                	mv	s1,s2
    80001b36:	b7d5                	j	80001b1a <allocproc+0x78>
    freeproc(p);
    80001b38:	8526                	mv	a0,s1
    80001b3a:	f19ff0ef          	jal	80001a52 <freeproc>
    release(&p->lock);
    80001b3e:	8526                	mv	a0,s1
    80001b40:	94cff0ef          	jal	80000c8c <release>
    return 0;
    80001b44:	84ca                	mv	s1,s2
    80001b46:	bfd1                	j	80001b1a <allocproc+0x78>

0000000080001b48 <userinit>:
{
    80001b48:	1101                	addi	sp,sp,-32
    80001b4a:	ec06                	sd	ra,24(sp)
    80001b4c:	e822                	sd	s0,16(sp)
    80001b4e:	e426                	sd	s1,8(sp)
    80001b50:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b52:	f51ff0ef          	jal	80001aa2 <allocproc>
    80001b56:	84aa                	mv	s1,a0
  initproc = p;
    80001b58:	00006797          	auipc	a5,0x6
    80001b5c:	dca7b423          	sd	a0,-568(a5) # 80007920 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b60:	03400613          	li	a2,52
    80001b64:	00006597          	auipc	a1,0x6
    80001b68:	d4c58593          	addi	a1,a1,-692 # 800078b0 <initcode>
    80001b6c:	6928                	ld	a0,80(a0)
    80001b6e:	f2eff0ef          	jal	8000129c <uvmfirst>
  p->sz = PGSIZE;
    80001b72:	6785                	lui	a5,0x1
    80001b74:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001b76:	6cb8                	ld	a4,88(s1)
    80001b78:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001b7c:	6cb8                	ld	a4,88(s1)
    80001b7e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b80:	4641                	li	a2,16
    80001b82:	00005597          	auipc	a1,0x5
    80001b86:	69e58593          	addi	a1,a1,1694 # 80007220 <etext+0x220>
    80001b8a:	15848513          	addi	a0,s1,344
    80001b8e:	a78ff0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80001b92:	00005517          	auipc	a0,0x5
    80001b96:	69e50513          	addi	a0,a0,1694 # 80007230 <etext+0x230>
    80001b9a:	5dd010ef          	jal	80003976 <namei>
    80001b9e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001ba2:	478d                	li	a5,3
    80001ba4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	8e4ff0ef          	jal	80000c8c <release>
}
    80001bac:	60e2                	ld	ra,24(sp)
    80001bae:	6442                	ld	s0,16(sp)
    80001bb0:	64a2                	ld	s1,8(sp)
    80001bb2:	6105                	addi	sp,sp,32
    80001bb4:	8082                	ret

0000000080001bb6 <growproc>:
{
    80001bb6:	1101                	addi	sp,sp,-32
    80001bb8:	ec06                	sd	ra,24(sp)
    80001bba:	e822                	sd	s0,16(sp)
    80001bbc:	e426                	sd	s1,8(sp)
    80001bbe:	e04a                	sd	s2,0(sp)
    80001bc0:	1000                	addi	s0,sp,32
    80001bc2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001bc4:	d1dff0ef          	jal	800018e0 <myproc>
    80001bc8:	84aa                	mv	s1,a0
  sz = p->sz;
    80001bca:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001bcc:	01204c63          	bgtz	s2,80001be4 <growproc+0x2e>
  } else if(n < 0){
    80001bd0:	02094463          	bltz	s2,80001bf8 <growproc+0x42>
  p->sz = sz;
    80001bd4:	e4ac                	sd	a1,72(s1)
  return 0;
    80001bd6:	4501                	li	a0,0
}
    80001bd8:	60e2                	ld	ra,24(sp)
    80001bda:	6442                	ld	s0,16(sp)
    80001bdc:	64a2                	ld	s1,8(sp)
    80001bde:	6902                	ld	s2,0(sp)
    80001be0:	6105                	addi	sp,sp,32
    80001be2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001be4:	4691                	li	a3,4
    80001be6:	00b90633          	add	a2,s2,a1
    80001bea:	6928                	ld	a0,80(a0)
    80001bec:	f52ff0ef          	jal	8000133e <uvmalloc>
    80001bf0:	85aa                	mv	a1,a0
    80001bf2:	f16d                	bnez	a0,80001bd4 <growproc+0x1e>
      return -1;
    80001bf4:	557d                	li	a0,-1
    80001bf6:	b7cd                	j	80001bd8 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001bf8:	00b90633          	add	a2,s2,a1
    80001bfc:	6928                	ld	a0,80(a0)
    80001bfe:	efcff0ef          	jal	800012fa <uvmdealloc>
    80001c02:	85aa                	mv	a1,a0
    80001c04:	bfc1                	j	80001bd4 <growproc+0x1e>

0000000080001c06 <fork>:
{
    80001c06:	7139                	addi	sp,sp,-64
    80001c08:	fc06                	sd	ra,56(sp)
    80001c0a:	f822                	sd	s0,48(sp)
    80001c0c:	f04a                	sd	s2,32(sp)
    80001c0e:	e456                	sd	s5,8(sp)
    80001c10:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c12:	ccfff0ef          	jal	800018e0 <myproc>
    80001c16:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c18:	e8bff0ef          	jal	80001aa2 <allocproc>
    80001c1c:	0e050a63          	beqz	a0,80001d10 <fork+0x10a>
    80001c20:	e852                	sd	s4,16(sp)
    80001c22:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c24:	048ab603          	ld	a2,72(s5)
    80001c28:	692c                	ld	a1,80(a0)
    80001c2a:	050ab503          	ld	a0,80(s5)
    80001c2e:	849ff0ef          	jal	80001476 <uvmcopy>
    80001c32:	04054a63          	bltz	a0,80001c86 <fork+0x80>
    80001c36:	f426                	sd	s1,40(sp)
    80001c38:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c3a:	048ab783          	ld	a5,72(s5)
    80001c3e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c42:	058ab683          	ld	a3,88(s5)
    80001c46:	87b6                	mv	a5,a3
    80001c48:	058a3703          	ld	a4,88(s4)
    80001c4c:	12068693          	addi	a3,a3,288
    80001c50:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c54:	6788                	ld	a0,8(a5)
    80001c56:	6b8c                	ld	a1,16(a5)
    80001c58:	6f90                	ld	a2,24(a5)
    80001c5a:	01073023          	sd	a6,0(a4)
    80001c5e:	e708                	sd	a0,8(a4)
    80001c60:	eb0c                	sd	a1,16(a4)
    80001c62:	ef10                	sd	a2,24(a4)
    80001c64:	02078793          	addi	a5,a5,32
    80001c68:	02070713          	addi	a4,a4,32
    80001c6c:	fed792e3          	bne	a5,a3,80001c50 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001c70:	058a3783          	ld	a5,88(s4)
    80001c74:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c78:	0d0a8493          	addi	s1,s5,208
    80001c7c:	0d0a0913          	addi	s2,s4,208
    80001c80:	150a8993          	addi	s3,s5,336
    80001c84:	a831                	j	80001ca0 <fork+0x9a>
    freeproc(np);
    80001c86:	8552                	mv	a0,s4
    80001c88:	dcbff0ef          	jal	80001a52 <freeproc>
    release(&np->lock);
    80001c8c:	8552                	mv	a0,s4
    80001c8e:	ffffe0ef          	jal	80000c8c <release>
    return -1;
    80001c92:	597d                	li	s2,-1
    80001c94:	6a42                	ld	s4,16(sp)
    80001c96:	a0b5                	j	80001d02 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001c98:	04a1                	addi	s1,s1,8
    80001c9a:	0921                	addi	s2,s2,8
    80001c9c:	01348963          	beq	s1,s3,80001cae <fork+0xa8>
    if(p->ofile[i])
    80001ca0:	6088                	ld	a0,0(s1)
    80001ca2:	d97d                	beqz	a0,80001c98 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ca4:	262020ef          	jal	80003f06 <filedup>
    80001ca8:	00a93023          	sd	a0,0(s2)
    80001cac:	b7f5                	j	80001c98 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001cae:	150ab503          	ld	a0,336(s5)
    80001cb2:	5b4010ef          	jal	80003266 <idup>
    80001cb6:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cba:	4641                	li	a2,16
    80001cbc:	158a8593          	addi	a1,s5,344
    80001cc0:	158a0513          	addi	a0,s4,344
    80001cc4:	942ff0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    80001cc8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001ccc:	8552                	mv	a0,s4
    80001cce:	fbffe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    80001cd2:	0000e497          	auipc	s1,0xe
    80001cd6:	da648493          	addi	s1,s1,-602 # 8000fa78 <wait_lock>
    80001cda:	8526                	mv	a0,s1
    80001cdc:	f19fe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    80001ce0:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001ce4:	8526                	mv	a0,s1
    80001ce6:	fa7fe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    80001cea:	8552                	mv	a0,s4
    80001cec:	f09fe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    80001cf0:	478d                	li	a5,3
    80001cf2:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001cf6:	8552                	mv	a0,s4
    80001cf8:	f95fe0ef          	jal	80000c8c <release>
  return pid;
    80001cfc:	74a2                	ld	s1,40(sp)
    80001cfe:	69e2                	ld	s3,24(sp)
    80001d00:	6a42                	ld	s4,16(sp)
}
    80001d02:	854a                	mv	a0,s2
    80001d04:	70e2                	ld	ra,56(sp)
    80001d06:	7442                	ld	s0,48(sp)
    80001d08:	7902                	ld	s2,32(sp)
    80001d0a:	6aa2                	ld	s5,8(sp)
    80001d0c:	6121                	addi	sp,sp,64
    80001d0e:	8082                	ret
    return -1;
    80001d10:	597d                	li	s2,-1
    80001d12:	bfc5                	j	80001d02 <fork+0xfc>

0000000080001d14 <scheduler>:
{
    80001d14:	7159                	addi	sp,sp,-112
    80001d16:	f486                	sd	ra,104(sp)
    80001d18:	f0a2                	sd	s0,96(sp)
    80001d1a:	eca6                	sd	s1,88(sp)
    80001d1c:	e8ca                	sd	s2,80(sp)
    80001d1e:	e4ce                	sd	s3,72(sp)
    80001d20:	e0d2                	sd	s4,64(sp)
    80001d22:	fc56                	sd	s5,56(sp)
    80001d24:	f85a                	sd	s6,48(sp)
    80001d26:	f45e                	sd	s7,40(sp)
    80001d28:	f062                	sd	s8,32(sp)
    80001d2a:	ec66                	sd	s9,24(sp)
    80001d2c:	e86a                	sd	s10,16(sp)
    80001d2e:	e46e                	sd	s11,8(sp)
    80001d30:	1880                	addi	s0,sp,112
    80001d32:	8792                	mv	a5,tp
  int id = r_tp();
    80001d34:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d36:	00779c13          	slli	s8,a5,0x7
    80001d3a:	0000e717          	auipc	a4,0xe
    80001d3e:	d2670713          	addi	a4,a4,-730 # 8000fa60 <pid_lock>
    80001d42:	9762                	add	a4,a4,s8
    80001d44:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d48:	0000e717          	auipc	a4,0xe
    80001d4c:	d5070713          	addi	a4,a4,-688 # 8000fa98 <cpus+0x8>
    80001d50:	9c3a                	add	s8,s8,a4
    80001d52:	00031cb7          	lui	s9,0x31
    80001d56:	d40c8c93          	addi	s9,s9,-704 # 30d40 <_entry-0x7ffcf2c0>
        c->proc = p;
    80001d5a:	079e                	slli	a5,a5,0x7
    80001d5c:	0000ea97          	auipc	s5,0xe
    80001d60:	d04a8a93          	addi	s5,s5,-764 # 8000fa60 <pid_lock>
    80001d64:	9abe                	add	s5,s5,a5
    80001d66:	0007ad37          	lui	s10,0x7a
    80001d6a:	120d0d13          	addi	s10,s10,288 # 7a120 <_entry-0x7ff85ee0>
    80001d6e:	a845                	j	80001e1e <scheduler+0x10a>
        proc_running++;
    80001d70:	2905                	addiw	s2,s2,1
      if(p->state == RUNNABLE) {
    80001d72:	a889                	j	80001dc4 <scheduler+0xb0>
    80001d74:	470d                	li	a4,3
    80001d76:	04e79763          	bne	a5,a4,80001dc4 <scheduler+0xb0>
        if(proc_running > 10) {
    80001d7a:	4729                	li	a4,10
    80001d7c:	87e6                	mv	a5,s9
    80001d7e:	03274063          	blt	a4,s2,80001d9e <scheduler+0x8a>
        } else if(proc_running > 5) {
    80001d82:	4715                	li	a4,5
    80001d84:	87ea                	mv	a5,s10
    80001d86:	01274c63          	blt	a4,s2,80001d9e <scheduler+0x8a>
        } else if(proc_running > 2) {
    80001d8a:	4709                	li	a4,2
    80001d8c:	87ee                	mv	a5,s11
    80001d8e:	01274863          	blt	a4,s2,80001d9e <scheduler+0x8a>
        } else if(proc_running > 1 || proc_sleeping > 5) {
    80001d92:	001e87b7          	lui	a5,0x1e8
    80001d96:	48078793          	addi	a5,a5,1152 # 1e8480 <_entry-0x7fe17b80>
    80001d9a:	04e91c63          	bne	s2,a4,80001df2 <scheduler+0xde>
          dynamic_tick_rate = 200000;
    80001d9e:	00fbb023          	sd	a5,0(s7) # 1000 <_entry-0x7ffff000>
        p->state = RUNNING;
    80001da2:	4791                	li	a5,4
    80001da4:	cc9c                	sw	a5,24(s1)
        c->proc = p;
    80001da6:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    80001daa:	06048593          	addi	a1,s1,96
    80001dae:	8562                	mv	a0,s8
    80001db0:	61c000ef          	jal	800023cc <swtch>
        total_context_switches++;
    80001db4:	000a3783          	ld	a5,0(s4)
    80001db8:	0785                	addi	a5,a5,1
    80001dba:	00fa3023          	sd	a5,0(s4)
        c->proc = 0;
    80001dbe:	020ab823          	sd	zero,48(s5)
        found = 1;
    80001dc2:	4b05                	li	s6,1
      release(&p->lock);
    80001dc4:	8526                	mv	a0,s1
    80001dc6:	ec7fe0ef          	jal	80000c8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dca:	16848493          	addi	s1,s1,360
    80001dce:	00014797          	auipc	a5,0x14
    80001dd2:	ac278793          	addi	a5,a5,-1342 # 80015890 <tickslock>
    80001dd6:	02f48a63          	beq	s1,a5,80001e0a <scheduler+0xf6>
      acquire(&p->lock);
    80001dda:	8526                	mv	a0,s1
    80001ddc:	e19fe0ef          	jal	80000bf4 <acquire>
      if(p->state == RUNNING) {
    80001de0:	4c9c                	lw	a5,24(s1)
    80001de2:	4711                	li	a4,4
    80001de4:	f8e786e3          	beq	a5,a4,80001d70 <scheduler+0x5c>
      if(p->state == SLEEPING) {
    80001de8:	4709                	li	a4,2
    80001dea:	f8e795e3          	bne	a5,a4,80001d74 <scheduler+0x60>
        proc_sleeping++;
    80001dee:	2985                	addiw	s3,s3,1
      if(p->state == RUNNABLE) {
    80001df0:	bfd1                	j	80001dc4 <scheduler+0xb0>
        } else if(proc_running > 1 || proc_sleeping > 5) {
    80001df2:	4715                	li	a4,5
    80001df4:	002dc7b7          	lui	a5,0x2dc
    80001df8:	6c078793          	addi	a5,a5,1728 # 2dc6c0 <_entry-0x7fd23940>
    80001dfc:	fb3751e3          	bge	a4,s3,80001d9e <scheduler+0x8a>
    80001e00:	001e87b7          	lui	a5,0x1e8
    80001e04:	48078793          	addi	a5,a5,1152 # 1e8480 <_entry-0x7fe17b80>
    80001e08:	bf59                	j	80001d9e <scheduler+0x8a>
    if(found == 0) {
    80001e0a:	000b1e63          	bnez	s6,80001e26 <scheduler+0x112>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e0e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e12:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e16:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001e1a:	10500073          	wfi
          dynamic_tick_rate = 200000;
    80001e1e:	00006b97          	auipc	s7,0x6
    80001e22:	a8ab8b93          	addi	s7,s7,-1398 # 800078a8 <dynamic_tick_rate>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e26:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e2a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e32:	4b01                	li	s6,0
    int proc_sleeping = 0;
    80001e34:	4981                	li	s3,0
    int proc_running = 0;
    80001e36:	4901                	li	s2,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e38:	0000e497          	auipc	s1,0xe
    80001e3c:	05848493          	addi	s1,s1,88 # 8000fe90 <proc>
        total_context_switches++;
    80001e40:	00006a17          	auipc	s4,0x6
    80001e44:	ad8a0a13          	addi	s4,s4,-1320 # 80007918 <total_context_switches>
    80001e48:	000f4db7          	lui	s11,0xf4
    80001e4c:	240d8d93          	addi	s11,s11,576 # f4240 <_entry-0x7ff0bdc0>
    80001e50:	b769                	j	80001dda <scheduler+0xc6>

0000000080001e52 <sched>:
{
    80001e52:	7179                	addi	sp,sp,-48
    80001e54:	f406                	sd	ra,40(sp)
    80001e56:	f022                	sd	s0,32(sp)
    80001e58:	ec26                	sd	s1,24(sp)
    80001e5a:	e84a                	sd	s2,16(sp)
    80001e5c:	e44e                	sd	s3,8(sp)
    80001e5e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e60:	a81ff0ef          	jal	800018e0 <myproc>
    80001e64:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e66:	d25fe0ef          	jal	80000b8a <holding>
    80001e6a:	c92d                	beqz	a0,80001edc <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e6c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e6e:	2781                	sext.w	a5,a5
    80001e70:	079e                	slli	a5,a5,0x7
    80001e72:	0000e717          	auipc	a4,0xe
    80001e76:	bee70713          	addi	a4,a4,-1042 # 8000fa60 <pid_lock>
    80001e7a:	97ba                	add	a5,a5,a4
    80001e7c:	0a87a703          	lw	a4,168(a5)
    80001e80:	4785                	li	a5,1
    80001e82:	06f71363          	bne	a4,a5,80001ee8 <sched+0x96>
  if(p->state == RUNNING)
    80001e86:	4c98                	lw	a4,24(s1)
    80001e88:	4791                	li	a5,4
    80001e8a:	06f70563          	beq	a4,a5,80001ef4 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e8e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e92:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e94:	e7b5                	bnez	a5,80001f00 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e96:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e98:	0000e917          	auipc	s2,0xe
    80001e9c:	bc890913          	addi	s2,s2,-1080 # 8000fa60 <pid_lock>
    80001ea0:	2781                	sext.w	a5,a5
    80001ea2:	079e                	slli	a5,a5,0x7
    80001ea4:	97ca                	add	a5,a5,s2
    80001ea6:	0ac7a983          	lw	s3,172(a5)
    80001eaa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001eac:	2781                	sext.w	a5,a5
    80001eae:	079e                	slli	a5,a5,0x7
    80001eb0:	0000e597          	auipc	a1,0xe
    80001eb4:	be858593          	addi	a1,a1,-1048 # 8000fa98 <cpus+0x8>
    80001eb8:	95be                	add	a1,a1,a5
    80001eba:	06048513          	addi	a0,s1,96
    80001ebe:	50e000ef          	jal	800023cc <swtch>
    80001ec2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ec4:	2781                	sext.w	a5,a5
    80001ec6:	079e                	slli	a5,a5,0x7
    80001ec8:	993e                	add	s2,s2,a5
    80001eca:	0b392623          	sw	s3,172(s2)
}
    80001ece:	70a2                	ld	ra,40(sp)
    80001ed0:	7402                	ld	s0,32(sp)
    80001ed2:	64e2                	ld	s1,24(sp)
    80001ed4:	6942                	ld	s2,16(sp)
    80001ed6:	69a2                	ld	s3,8(sp)
    80001ed8:	6145                	addi	sp,sp,48
    80001eda:	8082                	ret
    panic("sched p->lock");
    80001edc:	00005517          	auipc	a0,0x5
    80001ee0:	35c50513          	addi	a0,a0,860 # 80007238 <etext+0x238>
    80001ee4:	8b1fe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001ee8:	00005517          	auipc	a0,0x5
    80001eec:	36050513          	addi	a0,a0,864 # 80007248 <etext+0x248>
    80001ef0:	8a5fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001ef4:	00005517          	auipc	a0,0x5
    80001ef8:	36450513          	addi	a0,a0,868 # 80007258 <etext+0x258>
    80001efc:	899fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001f00:	00005517          	auipc	a0,0x5
    80001f04:	36850513          	addi	a0,a0,872 # 80007268 <etext+0x268>
    80001f08:	88dfe0ef          	jal	80000794 <panic>

0000000080001f0c <yield>:
{
    80001f0c:	1101                	addi	sp,sp,-32
    80001f0e:	ec06                	sd	ra,24(sp)
    80001f10:	e822                	sd	s0,16(sp)
    80001f12:	e426                	sd	s1,8(sp)
    80001f14:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f16:	9cbff0ef          	jal	800018e0 <myproc>
    80001f1a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f1c:	cd9fe0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    80001f20:	478d                	li	a5,3
    80001f22:	cc9c                	sw	a5,24(s1)
  sched();
    80001f24:	f2fff0ef          	jal	80001e52 <sched>
  release(&p->lock);
    80001f28:	8526                	mv	a0,s1
    80001f2a:	d63fe0ef          	jal	80000c8c <release>
}
    80001f2e:	60e2                	ld	ra,24(sp)
    80001f30:	6442                	ld	s0,16(sp)
    80001f32:	64a2                	ld	s1,8(sp)
    80001f34:	6105                	addi	sp,sp,32
    80001f36:	8082                	ret

0000000080001f38 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f38:	7179                	addi	sp,sp,-48
    80001f3a:	f406                	sd	ra,40(sp)
    80001f3c:	f022                	sd	s0,32(sp)
    80001f3e:	ec26                	sd	s1,24(sp)
    80001f40:	e84a                	sd	s2,16(sp)
    80001f42:	e44e                	sd	s3,8(sp)
    80001f44:	1800                	addi	s0,sp,48
    80001f46:	89aa                	mv	s3,a0
    80001f48:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f4a:	997ff0ef          	jal	800018e0 <myproc>
    80001f4e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001f50:	ca5fe0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001f54:	854a                	mv	a0,s2
    80001f56:	d37fe0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001f5a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f5e:	4789                	li	a5,2
    80001f60:	cc9c                	sw	a5,24(s1)

  sched();
    80001f62:	ef1ff0ef          	jal	80001e52 <sched>

  // Tidy up.
  p->chan = 0;
    80001f66:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f6a:	8526                	mv	a0,s1
    80001f6c:	d21fe0ef          	jal	80000c8c <release>
  acquire(lk);
    80001f70:	854a                	mv	a0,s2
    80001f72:	c83fe0ef          	jal	80000bf4 <acquire>
}
    80001f76:	70a2                	ld	ra,40(sp)
    80001f78:	7402                	ld	s0,32(sp)
    80001f7a:	64e2                	ld	s1,24(sp)
    80001f7c:	6942                	ld	s2,16(sp)
    80001f7e:	69a2                	ld	s3,8(sp)
    80001f80:	6145                	addi	sp,sp,48
    80001f82:	8082                	ret

0000000080001f84 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001f84:	7139                	addi	sp,sp,-64
    80001f86:	fc06                	sd	ra,56(sp)
    80001f88:	f822                	sd	s0,48(sp)
    80001f8a:	f426                	sd	s1,40(sp)
    80001f8c:	f04a                	sd	s2,32(sp)
    80001f8e:	ec4e                	sd	s3,24(sp)
    80001f90:	e852                	sd	s4,16(sp)
    80001f92:	e456                	sd	s5,8(sp)
    80001f94:	0080                	addi	s0,sp,64
    80001f96:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f98:	0000e497          	auipc	s1,0xe
    80001f9c:	ef848493          	addi	s1,s1,-264 # 8000fe90 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001fa0:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001fa2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fa4:	00014917          	auipc	s2,0x14
    80001fa8:	8ec90913          	addi	s2,s2,-1812 # 80015890 <tickslock>
    80001fac:	a801                	j	80001fbc <wakeup+0x38>
      }
      release(&p->lock);
    80001fae:	8526                	mv	a0,s1
    80001fb0:	cddfe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fb4:	16848493          	addi	s1,s1,360
    80001fb8:	03248263          	beq	s1,s2,80001fdc <wakeup+0x58>
    if(p != myproc()){
    80001fbc:	925ff0ef          	jal	800018e0 <myproc>
    80001fc0:	fea48ae3          	beq	s1,a0,80001fb4 <wakeup+0x30>
      acquire(&p->lock);
    80001fc4:	8526                	mv	a0,s1
    80001fc6:	c2ffe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001fca:	4c9c                	lw	a5,24(s1)
    80001fcc:	ff3791e3          	bne	a5,s3,80001fae <wakeup+0x2a>
    80001fd0:	709c                	ld	a5,32(s1)
    80001fd2:	fd479ee3          	bne	a5,s4,80001fae <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fd6:	0154ac23          	sw	s5,24(s1)
    80001fda:	bfd1                	j	80001fae <wakeup+0x2a>
    }
  }
}
    80001fdc:	70e2                	ld	ra,56(sp)
    80001fde:	7442                	ld	s0,48(sp)
    80001fe0:	74a2                	ld	s1,40(sp)
    80001fe2:	7902                	ld	s2,32(sp)
    80001fe4:	69e2                	ld	s3,24(sp)
    80001fe6:	6a42                	ld	s4,16(sp)
    80001fe8:	6aa2                	ld	s5,8(sp)
    80001fea:	6121                	addi	sp,sp,64
    80001fec:	8082                	ret

0000000080001fee <reparent>:
{
    80001fee:	7179                	addi	sp,sp,-48
    80001ff0:	f406                	sd	ra,40(sp)
    80001ff2:	f022                	sd	s0,32(sp)
    80001ff4:	ec26                	sd	s1,24(sp)
    80001ff6:	e84a                	sd	s2,16(sp)
    80001ff8:	e44e                	sd	s3,8(sp)
    80001ffa:	e052                	sd	s4,0(sp)
    80001ffc:	1800                	addi	s0,sp,48
    80001ffe:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002000:	0000e497          	auipc	s1,0xe
    80002004:	e9048493          	addi	s1,s1,-368 # 8000fe90 <proc>
      pp->parent = initproc;
    80002008:	00006a17          	auipc	s4,0x6
    8000200c:	918a0a13          	addi	s4,s4,-1768 # 80007920 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002010:	00014997          	auipc	s3,0x14
    80002014:	88098993          	addi	s3,s3,-1920 # 80015890 <tickslock>
    80002018:	a029                	j	80002022 <reparent+0x34>
    8000201a:	16848493          	addi	s1,s1,360
    8000201e:	01348b63          	beq	s1,s3,80002034 <reparent+0x46>
    if(pp->parent == p){
    80002022:	7c9c                	ld	a5,56(s1)
    80002024:	ff279be3          	bne	a5,s2,8000201a <reparent+0x2c>
      pp->parent = initproc;
    80002028:	000a3503          	ld	a0,0(s4)
    8000202c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000202e:	f57ff0ef          	jal	80001f84 <wakeup>
    80002032:	b7e5                	j	8000201a <reparent+0x2c>
}
    80002034:	70a2                	ld	ra,40(sp)
    80002036:	7402                	ld	s0,32(sp)
    80002038:	64e2                	ld	s1,24(sp)
    8000203a:	6942                	ld	s2,16(sp)
    8000203c:	69a2                	ld	s3,8(sp)
    8000203e:	6a02                	ld	s4,0(sp)
    80002040:	6145                	addi	sp,sp,48
    80002042:	8082                	ret

0000000080002044 <exit>:
{
    80002044:	7179                	addi	sp,sp,-48
    80002046:	f406                	sd	ra,40(sp)
    80002048:	f022                	sd	s0,32(sp)
    8000204a:	ec26                	sd	s1,24(sp)
    8000204c:	e84a                	sd	s2,16(sp)
    8000204e:	e44e                	sd	s3,8(sp)
    80002050:	e052                	sd	s4,0(sp)
    80002052:	1800                	addi	s0,sp,48
    80002054:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002056:	88bff0ef          	jal	800018e0 <myproc>
    8000205a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000205c:	00006797          	auipc	a5,0x6
    80002060:	8c47b783          	ld	a5,-1852(a5) # 80007920 <initproc>
    80002064:	0d050493          	addi	s1,a0,208
    80002068:	15050913          	addi	s2,a0,336
    8000206c:	00a79f63          	bne	a5,a0,8000208a <exit+0x46>
    panic("init exiting");
    80002070:	00005517          	auipc	a0,0x5
    80002074:	21050513          	addi	a0,a0,528 # 80007280 <etext+0x280>
    80002078:	f1cfe0ef          	jal	80000794 <panic>
      fileclose(f);
    8000207c:	6d1010ef          	jal	80003f4c <fileclose>
      p->ofile[fd] = 0;
    80002080:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002084:	04a1                	addi	s1,s1,8
    80002086:	01248563          	beq	s1,s2,80002090 <exit+0x4c>
    if(p->ofile[fd]){
    8000208a:	6088                	ld	a0,0(s1)
    8000208c:	f965                	bnez	a0,8000207c <exit+0x38>
    8000208e:	bfdd                	j	80002084 <exit+0x40>
  begin_op();
    80002090:	2a3010ef          	jal	80003b32 <begin_op>
  iput(p->cwd);
    80002094:	1509b503          	ld	a0,336(s3)
    80002098:	386010ef          	jal	8000341e <iput>
  end_op();
    8000209c:	301010ef          	jal	80003b9c <end_op>
  p->cwd = 0;
    800020a0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800020a4:	0000e497          	auipc	s1,0xe
    800020a8:	9d448493          	addi	s1,s1,-1580 # 8000fa78 <wait_lock>
    800020ac:	8526                	mv	a0,s1
    800020ae:	b47fe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    800020b2:	854e                	mv	a0,s3
    800020b4:	f3bff0ef          	jal	80001fee <reparent>
  wakeup(p->parent);
    800020b8:	0389b503          	ld	a0,56(s3)
    800020bc:	ec9ff0ef          	jal	80001f84 <wakeup>
  acquire(&p->lock);
    800020c0:	854e                	mv	a0,s3
    800020c2:	b33fe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    800020c6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020ca:	4795                	li	a5,5
    800020cc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020d0:	8526                	mv	a0,s1
    800020d2:	bbbfe0ef          	jal	80000c8c <release>
  sched();
    800020d6:	d7dff0ef          	jal	80001e52 <sched>
  panic("zombie exit");
    800020da:	00005517          	auipc	a0,0x5
    800020de:	1b650513          	addi	a0,a0,438 # 80007290 <etext+0x290>
    800020e2:	eb2fe0ef          	jal	80000794 <panic>

00000000800020e6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800020e6:	7179                	addi	sp,sp,-48
    800020e8:	f406                	sd	ra,40(sp)
    800020ea:	f022                	sd	s0,32(sp)
    800020ec:	ec26                	sd	s1,24(sp)
    800020ee:	e84a                	sd	s2,16(sp)
    800020f0:	e44e                	sd	s3,8(sp)
    800020f2:	1800                	addi	s0,sp,48
    800020f4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800020f6:	0000e497          	auipc	s1,0xe
    800020fa:	d9a48493          	addi	s1,s1,-614 # 8000fe90 <proc>
    800020fe:	00013997          	auipc	s3,0x13
    80002102:	79298993          	addi	s3,s3,1938 # 80015890 <tickslock>
    acquire(&p->lock);
    80002106:	8526                	mv	a0,s1
    80002108:	aedfe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    8000210c:	589c                	lw	a5,48(s1)
    8000210e:	01278b63          	beq	a5,s2,80002124 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002112:	8526                	mv	a0,s1
    80002114:	b79fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002118:	16848493          	addi	s1,s1,360
    8000211c:	ff3495e3          	bne	s1,s3,80002106 <kill+0x20>
  }
  return -1;
    80002120:	557d                	li	a0,-1
    80002122:	a819                	j	80002138 <kill+0x52>
      p->killed = 1;
    80002124:	4785                	li	a5,1
    80002126:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002128:	4c98                	lw	a4,24(s1)
    8000212a:	4789                	li	a5,2
    8000212c:	00f70d63          	beq	a4,a5,80002146 <kill+0x60>
      release(&p->lock);
    80002130:	8526                	mv	a0,s1
    80002132:	b5bfe0ef          	jal	80000c8c <release>
      return 0;
    80002136:	4501                	li	a0,0
}
    80002138:	70a2                	ld	ra,40(sp)
    8000213a:	7402                	ld	s0,32(sp)
    8000213c:	64e2                	ld	s1,24(sp)
    8000213e:	6942                	ld	s2,16(sp)
    80002140:	69a2                	ld	s3,8(sp)
    80002142:	6145                	addi	sp,sp,48
    80002144:	8082                	ret
        p->state = RUNNABLE;
    80002146:	478d                	li	a5,3
    80002148:	cc9c                	sw	a5,24(s1)
    8000214a:	b7dd                	j	80002130 <kill+0x4a>

000000008000214c <setkilled>:

void
setkilled(struct proc *p)
{
    8000214c:	1101                	addi	sp,sp,-32
    8000214e:	ec06                	sd	ra,24(sp)
    80002150:	e822                	sd	s0,16(sp)
    80002152:	e426                	sd	s1,8(sp)
    80002154:	1000                	addi	s0,sp,32
    80002156:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002158:	a9dfe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    8000215c:	4785                	li	a5,1
    8000215e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002160:	8526                	mv	a0,s1
    80002162:	b2bfe0ef          	jal	80000c8c <release>
}
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	64a2                	ld	s1,8(sp)
    8000216c:	6105                	addi	sp,sp,32
    8000216e:	8082                	ret

0000000080002170 <killed>:

int
killed(struct proc *p)
{
    80002170:	1101                	addi	sp,sp,-32
    80002172:	ec06                	sd	ra,24(sp)
    80002174:	e822                	sd	s0,16(sp)
    80002176:	e426                	sd	s1,8(sp)
    80002178:	e04a                	sd	s2,0(sp)
    8000217a:	1000                	addi	s0,sp,32
    8000217c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000217e:	a77fe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    80002182:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002186:	8526                	mv	a0,s1
    80002188:	b05fe0ef          	jal	80000c8c <release>
  return k;
}
    8000218c:	854a                	mv	a0,s2
    8000218e:	60e2                	ld	ra,24(sp)
    80002190:	6442                	ld	s0,16(sp)
    80002192:	64a2                	ld	s1,8(sp)
    80002194:	6902                	ld	s2,0(sp)
    80002196:	6105                	addi	sp,sp,32
    80002198:	8082                	ret

000000008000219a <wait>:
{
    8000219a:	715d                	addi	sp,sp,-80
    8000219c:	e486                	sd	ra,72(sp)
    8000219e:	e0a2                	sd	s0,64(sp)
    800021a0:	fc26                	sd	s1,56(sp)
    800021a2:	f84a                	sd	s2,48(sp)
    800021a4:	f44e                	sd	s3,40(sp)
    800021a6:	f052                	sd	s4,32(sp)
    800021a8:	ec56                	sd	s5,24(sp)
    800021aa:	e85a                	sd	s6,16(sp)
    800021ac:	e45e                	sd	s7,8(sp)
    800021ae:	e062                	sd	s8,0(sp)
    800021b0:	0880                	addi	s0,sp,80
    800021b2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800021b4:	f2cff0ef          	jal	800018e0 <myproc>
    800021b8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021ba:	0000e517          	auipc	a0,0xe
    800021be:	8be50513          	addi	a0,a0,-1858 # 8000fa78 <wait_lock>
    800021c2:	a33fe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    800021c6:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800021c8:	4a15                	li	s4,5
        havekids = 1;
    800021ca:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021cc:	00013997          	auipc	s3,0x13
    800021d0:	6c498993          	addi	s3,s3,1732 # 80015890 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021d4:	0000ec17          	auipc	s8,0xe
    800021d8:	8a4c0c13          	addi	s8,s8,-1884 # 8000fa78 <wait_lock>
    800021dc:	a871                	j	80002278 <wait+0xde>
          pid = pp->pid;
    800021de:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800021e2:	000b0c63          	beqz	s6,800021fa <wait+0x60>
    800021e6:	4691                	li	a3,4
    800021e8:	02c48613          	addi	a2,s1,44
    800021ec:	85da                	mv	a1,s6
    800021ee:	05093503          	ld	a0,80(s2)
    800021f2:	b60ff0ef          	jal	80001552 <copyout>
    800021f6:	02054b63          	bltz	a0,8000222c <wait+0x92>
          freeproc(pp);
    800021fa:	8526                	mv	a0,s1
    800021fc:	857ff0ef          	jal	80001a52 <freeproc>
          release(&pp->lock);
    80002200:	8526                	mv	a0,s1
    80002202:	a8bfe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    80002206:	0000e517          	auipc	a0,0xe
    8000220a:	87250513          	addi	a0,a0,-1934 # 8000fa78 <wait_lock>
    8000220e:	a7ffe0ef          	jal	80000c8c <release>
}
    80002212:	854e                	mv	a0,s3
    80002214:	60a6                	ld	ra,72(sp)
    80002216:	6406                	ld	s0,64(sp)
    80002218:	74e2                	ld	s1,56(sp)
    8000221a:	7942                	ld	s2,48(sp)
    8000221c:	79a2                	ld	s3,40(sp)
    8000221e:	7a02                	ld	s4,32(sp)
    80002220:	6ae2                	ld	s5,24(sp)
    80002222:	6b42                	ld	s6,16(sp)
    80002224:	6ba2                	ld	s7,8(sp)
    80002226:	6c02                	ld	s8,0(sp)
    80002228:	6161                	addi	sp,sp,80
    8000222a:	8082                	ret
            release(&pp->lock);
    8000222c:	8526                	mv	a0,s1
    8000222e:	a5ffe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    80002232:	0000e517          	auipc	a0,0xe
    80002236:	84650513          	addi	a0,a0,-1978 # 8000fa78 <wait_lock>
    8000223a:	a53fe0ef          	jal	80000c8c <release>
            return -1;
    8000223e:	59fd                	li	s3,-1
    80002240:	bfc9                	j	80002212 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002242:	16848493          	addi	s1,s1,360
    80002246:	03348063          	beq	s1,s3,80002266 <wait+0xcc>
      if(pp->parent == p){
    8000224a:	7c9c                	ld	a5,56(s1)
    8000224c:	ff279be3          	bne	a5,s2,80002242 <wait+0xa8>
        acquire(&pp->lock);
    80002250:	8526                	mv	a0,s1
    80002252:	9a3fe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    80002256:	4c9c                	lw	a5,24(s1)
    80002258:	f94783e3          	beq	a5,s4,800021de <wait+0x44>
        release(&pp->lock);
    8000225c:	8526                	mv	a0,s1
    8000225e:	a2ffe0ef          	jal	80000c8c <release>
        havekids = 1;
    80002262:	8756                	mv	a4,s5
    80002264:	bff9                	j	80002242 <wait+0xa8>
    if(!havekids || killed(p)){
    80002266:	cf19                	beqz	a4,80002284 <wait+0xea>
    80002268:	854a                	mv	a0,s2
    8000226a:	f07ff0ef          	jal	80002170 <killed>
    8000226e:	e919                	bnez	a0,80002284 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002270:	85e2                	mv	a1,s8
    80002272:	854a                	mv	a0,s2
    80002274:	cc5ff0ef          	jal	80001f38 <sleep>
    havekids = 0;
    80002278:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000227a:	0000e497          	auipc	s1,0xe
    8000227e:	c1648493          	addi	s1,s1,-1002 # 8000fe90 <proc>
    80002282:	b7e1                	j	8000224a <wait+0xb0>
      release(&wait_lock);
    80002284:	0000d517          	auipc	a0,0xd
    80002288:	7f450513          	addi	a0,a0,2036 # 8000fa78 <wait_lock>
    8000228c:	a01fe0ef          	jal	80000c8c <release>
      return -1;
    80002290:	59fd                	li	s3,-1
    80002292:	b741                	j	80002212 <wait+0x78>

0000000080002294 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002294:	7179                	addi	sp,sp,-48
    80002296:	f406                	sd	ra,40(sp)
    80002298:	f022                	sd	s0,32(sp)
    8000229a:	ec26                	sd	s1,24(sp)
    8000229c:	e84a                	sd	s2,16(sp)
    8000229e:	e44e                	sd	s3,8(sp)
    800022a0:	e052                	sd	s4,0(sp)
    800022a2:	1800                	addi	s0,sp,48
    800022a4:	84aa                	mv	s1,a0
    800022a6:	892e                	mv	s2,a1
    800022a8:	89b2                	mv	s3,a2
    800022aa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022ac:	e34ff0ef          	jal	800018e0 <myproc>
  if(user_dst){
    800022b0:	cc99                	beqz	s1,800022ce <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800022b2:	86d2                	mv	a3,s4
    800022b4:	864e                	mv	a2,s3
    800022b6:	85ca                	mv	a1,s2
    800022b8:	6928                	ld	a0,80(a0)
    800022ba:	a98ff0ef          	jal	80001552 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022be:	70a2                	ld	ra,40(sp)
    800022c0:	7402                	ld	s0,32(sp)
    800022c2:	64e2                	ld	s1,24(sp)
    800022c4:	6942                	ld	s2,16(sp)
    800022c6:	69a2                	ld	s3,8(sp)
    800022c8:	6a02                	ld	s4,0(sp)
    800022ca:	6145                	addi	sp,sp,48
    800022cc:	8082                	ret
    memmove((char *)dst, src, len);
    800022ce:	000a061b          	sext.w	a2,s4
    800022d2:	85ce                	mv	a1,s3
    800022d4:	854a                	mv	a0,s2
    800022d6:	a4ffe0ef          	jal	80000d24 <memmove>
    return 0;
    800022da:	8526                	mv	a0,s1
    800022dc:	b7cd                	j	800022be <either_copyout+0x2a>

00000000800022de <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022de:	7179                	addi	sp,sp,-48
    800022e0:	f406                	sd	ra,40(sp)
    800022e2:	f022                	sd	s0,32(sp)
    800022e4:	ec26                	sd	s1,24(sp)
    800022e6:	e84a                	sd	s2,16(sp)
    800022e8:	e44e                	sd	s3,8(sp)
    800022ea:	e052                	sd	s4,0(sp)
    800022ec:	1800                	addi	s0,sp,48
    800022ee:	892a                	mv	s2,a0
    800022f0:	84ae                	mv	s1,a1
    800022f2:	89b2                	mv	s3,a2
    800022f4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022f6:	deaff0ef          	jal	800018e0 <myproc>
  if(user_src){
    800022fa:	cc99                	beqz	s1,80002318 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800022fc:	86d2                	mv	a3,s4
    800022fe:	864e                	mv	a2,s3
    80002300:	85ca                	mv	a1,s2
    80002302:	6928                	ld	a0,80(a0)
    80002304:	b24ff0ef          	jal	80001628 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002308:	70a2                	ld	ra,40(sp)
    8000230a:	7402                	ld	s0,32(sp)
    8000230c:	64e2                	ld	s1,24(sp)
    8000230e:	6942                	ld	s2,16(sp)
    80002310:	69a2                	ld	s3,8(sp)
    80002312:	6a02                	ld	s4,0(sp)
    80002314:	6145                	addi	sp,sp,48
    80002316:	8082                	ret
    memmove(dst, (char*)src, len);
    80002318:	000a061b          	sext.w	a2,s4
    8000231c:	85ce                	mv	a1,s3
    8000231e:	854a                	mv	a0,s2
    80002320:	a05fe0ef          	jal	80000d24 <memmove>
    return 0;
    80002324:	8526                	mv	a0,s1
    80002326:	b7cd                	j	80002308 <either_copyin+0x2a>

0000000080002328 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002328:	715d                	addi	sp,sp,-80
    8000232a:	e486                	sd	ra,72(sp)
    8000232c:	e0a2                	sd	s0,64(sp)
    8000232e:	fc26                	sd	s1,56(sp)
    80002330:	f84a                	sd	s2,48(sp)
    80002332:	f44e                	sd	s3,40(sp)
    80002334:	f052                	sd	s4,32(sp)
    80002336:	ec56                	sd	s5,24(sp)
    80002338:	e85a                	sd	s6,16(sp)
    8000233a:	e45e                	sd	s7,8(sp)
    8000233c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000233e:	00005517          	auipc	a0,0x5
    80002342:	d3a50513          	addi	a0,a0,-710 # 80007078 <etext+0x78>
    80002346:	97cfe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000234a:	0000e497          	auipc	s1,0xe
    8000234e:	c9e48493          	addi	s1,s1,-866 # 8000ffe8 <proc+0x158>
    80002352:	00013917          	auipc	s2,0x13
    80002356:	69690913          	addi	s2,s2,1686 # 800159e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000235a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000235c:	00005997          	auipc	s3,0x5
    80002360:	f4498993          	addi	s3,s3,-188 # 800072a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    80002364:	00005a97          	auipc	s5,0x5
    80002368:	f44a8a93          	addi	s5,s5,-188 # 800072a8 <etext+0x2a8>
    printf("\n");
    8000236c:	00005a17          	auipc	s4,0x5
    80002370:	d0ca0a13          	addi	s4,s4,-756 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002374:	00005b97          	auipc	s7,0x5
    80002378:	414b8b93          	addi	s7,s7,1044 # 80007788 <states.0>
    8000237c:	a829                	j	80002396 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000237e:	ed86a583          	lw	a1,-296(a3)
    80002382:	8556                	mv	a0,s5
    80002384:	93efe0ef          	jal	800004c2 <printf>
    printf("\n");
    80002388:	8552                	mv	a0,s4
    8000238a:	938fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000238e:	16848493          	addi	s1,s1,360
    80002392:	03248263          	beq	s1,s2,800023b6 <procdump+0x8e>
    if(p->state == UNUSED)
    80002396:	86a6                	mv	a3,s1
    80002398:	ec04a783          	lw	a5,-320(s1)
    8000239c:	dbed                	beqz	a5,8000238e <procdump+0x66>
      state = "???";
    8000239e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023a0:	fcfb6fe3          	bltu	s6,a5,8000237e <procdump+0x56>
    800023a4:	02079713          	slli	a4,a5,0x20
    800023a8:	01d75793          	srli	a5,a4,0x1d
    800023ac:	97de                	add	a5,a5,s7
    800023ae:	6390                	ld	a2,0(a5)
    800023b0:	f679                	bnez	a2,8000237e <procdump+0x56>
      state = "???";
    800023b2:	864e                	mv	a2,s3
    800023b4:	b7e9                	j	8000237e <procdump+0x56>
  }
}
    800023b6:	60a6                	ld	ra,72(sp)
    800023b8:	6406                	ld	s0,64(sp)
    800023ba:	74e2                	ld	s1,56(sp)
    800023bc:	7942                	ld	s2,48(sp)
    800023be:	79a2                	ld	s3,40(sp)
    800023c0:	7a02                	ld	s4,32(sp)
    800023c2:	6ae2                	ld	s5,24(sp)
    800023c4:	6b42                	ld	s6,16(sp)
    800023c6:	6ba2                	ld	s7,8(sp)
    800023c8:	6161                	addi	sp,sp,80
    800023ca:	8082                	ret

00000000800023cc <swtch>:
    800023cc:	00153023          	sd	ra,0(a0)
    800023d0:	00253423          	sd	sp,8(a0)
    800023d4:	e900                	sd	s0,16(a0)
    800023d6:	ed04                	sd	s1,24(a0)
    800023d8:	03253023          	sd	s2,32(a0)
    800023dc:	03353423          	sd	s3,40(a0)
    800023e0:	03453823          	sd	s4,48(a0)
    800023e4:	03553c23          	sd	s5,56(a0)
    800023e8:	05653023          	sd	s6,64(a0)
    800023ec:	05753423          	sd	s7,72(a0)
    800023f0:	05853823          	sd	s8,80(a0)
    800023f4:	05953c23          	sd	s9,88(a0)
    800023f8:	07a53023          	sd	s10,96(a0)
    800023fc:	07b53423          	sd	s11,104(a0)
    80002400:	0005b083          	ld	ra,0(a1)
    80002404:	0085b103          	ld	sp,8(a1)
    80002408:	6980                	ld	s0,16(a1)
    8000240a:	6d84                	ld	s1,24(a1)
    8000240c:	0205b903          	ld	s2,32(a1)
    80002410:	0285b983          	ld	s3,40(a1)
    80002414:	0305ba03          	ld	s4,48(a1)
    80002418:	0385ba83          	ld	s5,56(a1)
    8000241c:	0405bb03          	ld	s6,64(a1)
    80002420:	0485bb83          	ld	s7,72(a1)
    80002424:	0505bc03          	ld	s8,80(a1)
    80002428:	0585bc83          	ld	s9,88(a1)
    8000242c:	0605bd03          	ld	s10,96(a1)
    80002430:	0685bd83          	ld	s11,104(a1)
    80002434:	8082                	ret

0000000080002436 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002436:	1141                	addi	sp,sp,-16
    80002438:	e406                	sd	ra,8(sp)
    8000243a:	e022                	sd	s0,0(sp)
    8000243c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000243e:	00005597          	auipc	a1,0x5
    80002442:	eaa58593          	addi	a1,a1,-342 # 800072e8 <etext+0x2e8>
    80002446:	00013517          	auipc	a0,0x13
    8000244a:	44a50513          	addi	a0,a0,1098 # 80015890 <tickslock>
    8000244e:	f26fe0ef          	jal	80000b74 <initlock>
}
    80002452:	60a2                	ld	ra,8(sp)
    80002454:	6402                	ld	s0,0(sp)
    80002456:	0141                	addi	sp,sp,16
    80002458:	8082                	ret

000000008000245a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000245a:	1141                	addi	sp,sp,-16
    8000245c:	e422                	sd	s0,8(sp)
    8000245e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002460:	00003797          	auipc	a5,0x3
    80002464:	e6078793          	addi	a5,a5,-416 # 800052c0 <kernelvec>
    80002468:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000246c:	6422                	ld	s0,8(sp)
    8000246e:	0141                	addi	sp,sp,16
    80002470:	8082                	ret

0000000080002472 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002472:	1141                	addi	sp,sp,-16
    80002474:	e406                	sd	ra,8(sp)
    80002476:	e022                	sd	s0,0(sp)
    80002478:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000247a:	c66ff0ef          	jal	800018e0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000247e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002482:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002484:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002488:	00004697          	auipc	a3,0x4
    8000248c:	b7868693          	addi	a3,a3,-1160 # 80006000 <_trampoline>
    80002490:	00004717          	auipc	a4,0x4
    80002494:	b7070713          	addi	a4,a4,-1168 # 80006000 <_trampoline>
    80002498:	8f15                	sub	a4,a4,a3
    8000249a:	040007b7          	lui	a5,0x4000
    8000249e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800024a0:	07b2                	slli	a5,a5,0xc
    800024a2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024a4:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800024a8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024aa:	18002673          	csrr	a2,satp
    800024ae:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024b0:	6d30                	ld	a2,88(a0)
    800024b2:	6138                	ld	a4,64(a0)
    800024b4:	6585                	lui	a1,0x1
    800024b6:	972e                	add	a4,a4,a1
    800024b8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024ba:	6d38                	ld	a4,88(a0)
    800024bc:	00000617          	auipc	a2,0x0
    800024c0:	12660613          	addi	a2,a2,294 # 800025e2 <usertrap>
    800024c4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800024c6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024c8:	8612                	mv	a2,tp
    800024ca:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024cc:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024d0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024d4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024d8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024dc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024de:	6f18                	ld	a4,24(a4)
    800024e0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800024e4:	6928                	ld	a0,80(a0)
    800024e6:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800024e8:	00004717          	auipc	a4,0x4
    800024ec:	bb470713          	addi	a4,a4,-1100 # 8000609c <userret>
    800024f0:	8f15                	sub	a4,a4,a3
    800024f2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800024f4:	577d                	li	a4,-1
    800024f6:	177e                	slli	a4,a4,0x3f
    800024f8:	8d59                	or	a0,a0,a4
    800024fa:	9782                	jalr	a5
}
    800024fc:	60a2                	ld	ra,8(sp)
    800024fe:	6402                	ld	s0,0(sp)
    80002500:	0141                	addi	sp,sp,16
    80002502:	8082                	ret

0000000080002504 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002504:	1101                	addi	sp,sp,-32
    80002506:	ec06                	sd	ra,24(sp)
    80002508:	e822                	sd	s0,16(sp)
    8000250a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000250c:	ba8ff0ef          	jal	800018b4 <cpuid>
    80002510:	cd11                	beqz	a0,8000252c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002512:	c01027f3          	rdtime	a5

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  // w_stimecmp(r_time() + 1000000);
  w_stimecmp(r_time() + dynamic_tick_rate);
    80002516:	00005717          	auipc	a4,0x5
    8000251a:	39273703          	ld	a4,914(a4) # 800078a8 <dynamic_tick_rate>
    8000251e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002520:	14d79073          	csrw	stimecmp,a5
}
    80002524:	60e2                	ld	ra,24(sp)
    80002526:	6442                	ld	s0,16(sp)
    80002528:	6105                	addi	sp,sp,32
    8000252a:	8082                	ret
    8000252c:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000252e:	00013497          	auipc	s1,0x13
    80002532:	36248493          	addi	s1,s1,866 # 80015890 <tickslock>
    80002536:	8526                	mv	a0,s1
    80002538:	ebcfe0ef          	jal	80000bf4 <acquire>
    ticks++;
    8000253c:	00005517          	auipc	a0,0x5
    80002540:	3f450513          	addi	a0,a0,1012 # 80007930 <ticks>
    80002544:	411c                	lw	a5,0(a0)
    80002546:	2785                	addiw	a5,a5,1
    80002548:	c11c                	sw	a5,0(a0)
    total_ticks += dynamic_tick_rate;
    8000254a:	00005717          	auipc	a4,0x5
    8000254e:	3de70713          	addi	a4,a4,990 # 80007928 <total_ticks>
    80002552:	631c                	ld	a5,0(a4)
    80002554:	00005697          	auipc	a3,0x5
    80002558:	3546b683          	ld	a3,852(a3) # 800078a8 <dynamic_tick_rate>
    8000255c:	97b6                	add	a5,a5,a3
    8000255e:	e31c                	sd	a5,0(a4)
    wakeup(&ticks);
    80002560:	a25ff0ef          	jal	80001f84 <wakeup>
    release(&tickslock);
    80002564:	8526                	mv	a0,s1
    80002566:	f26fe0ef          	jal	80000c8c <release>
    8000256a:	64a2                	ld	s1,8(sp)
    8000256c:	b75d                	j	80002512 <clockintr+0xe>

000000008000256e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000256e:	1101                	addi	sp,sp,-32
    80002570:	ec06                	sd	ra,24(sp)
    80002572:	e822                	sd	s0,16(sp)
    80002574:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002576:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000257a:	57fd                	li	a5,-1
    8000257c:	17fe                	slli	a5,a5,0x3f
    8000257e:	07a5                	addi	a5,a5,9
    80002580:	00f70c63          	beq	a4,a5,80002598 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002584:	57fd                	li	a5,-1
    80002586:	17fe                	slli	a5,a5,0x3f
    80002588:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000258a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000258c:	04f70763          	beq	a4,a5,800025da <devintr+0x6c>
  }
}
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	6105                	addi	sp,sp,32
    80002596:	8082                	ret
    80002598:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000259a:	5d3020ef          	jal	8000536c <plic_claim>
    8000259e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800025a0:	47a9                	li	a5,10
    800025a2:	00f50963          	beq	a0,a5,800025b4 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800025a6:	4785                	li	a5,1
    800025a8:	00f50963          	beq	a0,a5,800025ba <devintr+0x4c>
    return 1;
    800025ac:	4505                	li	a0,1
    } else if(irq){
    800025ae:	e889                	bnez	s1,800025c0 <devintr+0x52>
    800025b0:	64a2                	ld	s1,8(sp)
    800025b2:	bff9                	j	80002590 <devintr+0x22>
      uartintr();
    800025b4:	c52fe0ef          	jal	80000a06 <uartintr>
    if(irq)
    800025b8:	a819                	j	800025ce <devintr+0x60>
      virtio_disk_intr();
    800025ba:	278030ef          	jal	80005832 <virtio_disk_intr>
    if(irq)
    800025be:	a801                	j	800025ce <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800025c0:	85a6                	mv	a1,s1
    800025c2:	00005517          	auipc	a0,0x5
    800025c6:	d2e50513          	addi	a0,a0,-722 # 800072f0 <etext+0x2f0>
    800025ca:	ef9fd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    800025ce:	8526                	mv	a0,s1
    800025d0:	5bd020ef          	jal	8000538c <plic_complete>
    return 1;
    800025d4:	4505                	li	a0,1
    800025d6:	64a2                	ld	s1,8(sp)
    800025d8:	bf65                	j	80002590 <devintr+0x22>
    clockintr();
    800025da:	f2bff0ef          	jal	80002504 <clockintr>
    return 2;
    800025de:	4509                	li	a0,2
    800025e0:	bf45                	j	80002590 <devintr+0x22>

00000000800025e2 <usertrap>:
{
    800025e2:	1101                	addi	sp,sp,-32
    800025e4:	ec06                	sd	ra,24(sp)
    800025e6:	e822                	sd	s0,16(sp)
    800025e8:	e426                	sd	s1,8(sp)
    800025ea:	e04a                	sd	s2,0(sp)
    800025ec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025ee:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025f2:	1007f793          	andi	a5,a5,256
    800025f6:	ef85                	bnez	a5,8000262e <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025f8:	00003797          	auipc	a5,0x3
    800025fc:	cc878793          	addi	a5,a5,-824 # 800052c0 <kernelvec>
    80002600:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002604:	adcff0ef          	jal	800018e0 <myproc>
    80002608:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000260a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000260c:	14102773          	csrr	a4,sepc
    80002610:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002612:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002616:	47a1                	li	a5,8
    80002618:	02f70163          	beq	a4,a5,8000263a <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000261c:	f53ff0ef          	jal	8000256e <devintr>
    80002620:	892a                	mv	s2,a0
    80002622:	c135                	beqz	a0,80002686 <usertrap+0xa4>
  if(killed(p))
    80002624:	8526                	mv	a0,s1
    80002626:	b4bff0ef          	jal	80002170 <killed>
    8000262a:	cd1d                	beqz	a0,80002668 <usertrap+0x86>
    8000262c:	a81d                	j	80002662 <usertrap+0x80>
    panic("usertrap: not from user mode");
    8000262e:	00005517          	auipc	a0,0x5
    80002632:	ce250513          	addi	a0,a0,-798 # 80007310 <etext+0x310>
    80002636:	95efe0ef          	jal	80000794 <panic>
    if(killed(p))
    8000263a:	b37ff0ef          	jal	80002170 <killed>
    8000263e:	e121                	bnez	a0,8000267e <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002640:	6cb8                	ld	a4,88(s1)
    80002642:	6f1c                	ld	a5,24(a4)
    80002644:	0791                	addi	a5,a5,4
    80002646:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002648:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000264c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002650:	10079073          	csrw	sstatus,a5
    syscall();
    80002654:	248000ef          	jal	8000289c <syscall>
  if(killed(p))
    80002658:	8526                	mv	a0,s1
    8000265a:	b17ff0ef          	jal	80002170 <killed>
    8000265e:	c901                	beqz	a0,8000266e <usertrap+0x8c>
    80002660:	4901                	li	s2,0
    exit(-1);
    80002662:	557d                	li	a0,-1
    80002664:	9e1ff0ef          	jal	80002044 <exit>
  if(which_dev == 2)
    80002668:	4789                	li	a5,2
    8000266a:	04f90563          	beq	s2,a5,800026b4 <usertrap+0xd2>
  usertrapret();
    8000266e:	e05ff0ef          	jal	80002472 <usertrapret>
}
    80002672:	60e2                	ld	ra,24(sp)
    80002674:	6442                	ld	s0,16(sp)
    80002676:	64a2                	ld	s1,8(sp)
    80002678:	6902                	ld	s2,0(sp)
    8000267a:	6105                	addi	sp,sp,32
    8000267c:	8082                	ret
      exit(-1);
    8000267e:	557d                	li	a0,-1
    80002680:	9c5ff0ef          	jal	80002044 <exit>
    80002684:	bf75                	j	80002640 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002686:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000268a:	5890                	lw	a2,48(s1)
    8000268c:	00005517          	auipc	a0,0x5
    80002690:	ca450513          	addi	a0,a0,-860 # 80007330 <etext+0x330>
    80002694:	e2ffd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002698:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000269c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800026a0:	00005517          	auipc	a0,0x5
    800026a4:	cc050513          	addi	a0,a0,-832 # 80007360 <etext+0x360>
    800026a8:	e1bfd0ef          	jal	800004c2 <printf>
    setkilled(p);
    800026ac:	8526                	mv	a0,s1
    800026ae:	a9fff0ef          	jal	8000214c <setkilled>
    800026b2:	b75d                	j	80002658 <usertrap+0x76>
    yield();
    800026b4:	859ff0ef          	jal	80001f0c <yield>
    800026b8:	bf5d                	j	8000266e <usertrap+0x8c>

00000000800026ba <kerneltrap>:
{
    800026ba:	7179                	addi	sp,sp,-48
    800026bc:	f406                	sd	ra,40(sp)
    800026be:	f022                	sd	s0,32(sp)
    800026c0:	ec26                	sd	s1,24(sp)
    800026c2:	e84a                	sd	s2,16(sp)
    800026c4:	e44e                	sd	s3,8(sp)
    800026c6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026c8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026cc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026d0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800026d4:	1004f793          	andi	a5,s1,256
    800026d8:	c795                	beqz	a5,80002704 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026da:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026de:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026e0:	eb85                	bnez	a5,80002710 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800026e2:	e8dff0ef          	jal	8000256e <devintr>
    800026e6:	c91d                	beqz	a0,8000271c <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800026e8:	4789                	li	a5,2
    800026ea:	04f50a63          	beq	a0,a5,8000273e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026ee:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026f2:	10049073          	csrw	sstatus,s1
}
    800026f6:	70a2                	ld	ra,40(sp)
    800026f8:	7402                	ld	s0,32(sp)
    800026fa:	64e2                	ld	s1,24(sp)
    800026fc:	6942                	ld	s2,16(sp)
    800026fe:	69a2                	ld	s3,8(sp)
    80002700:	6145                	addi	sp,sp,48
    80002702:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002704:	00005517          	auipc	a0,0x5
    80002708:	c8450513          	addi	a0,a0,-892 # 80007388 <etext+0x388>
    8000270c:	888fe0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002710:	00005517          	auipc	a0,0x5
    80002714:	ca050513          	addi	a0,a0,-864 # 800073b0 <etext+0x3b0>
    80002718:	87cfe0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000271c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002720:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002724:	85ce                	mv	a1,s3
    80002726:	00005517          	auipc	a0,0x5
    8000272a:	caa50513          	addi	a0,a0,-854 # 800073d0 <etext+0x3d0>
    8000272e:	d95fd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    80002732:	00005517          	auipc	a0,0x5
    80002736:	cc650513          	addi	a0,a0,-826 # 800073f8 <etext+0x3f8>
    8000273a:	85afe0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000273e:	9a2ff0ef          	jal	800018e0 <myproc>
    80002742:	d555                	beqz	a0,800026ee <kerneltrap+0x34>
    yield();
    80002744:	fc8ff0ef          	jal	80001f0c <yield>
    80002748:	b75d                	j	800026ee <kerneltrap+0x34>

000000008000274a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000274a:	1101                	addi	sp,sp,-32
    8000274c:	ec06                	sd	ra,24(sp)
    8000274e:	e822                	sd	s0,16(sp)
    80002750:	e426                	sd	s1,8(sp)
    80002752:	1000                	addi	s0,sp,32
    80002754:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002756:	98aff0ef          	jal	800018e0 <myproc>
  switch (n) {
    8000275a:	4795                	li	a5,5
    8000275c:	0497e163          	bltu	a5,s1,8000279e <argraw+0x54>
    80002760:	048a                	slli	s1,s1,0x2
    80002762:	00005717          	auipc	a4,0x5
    80002766:	05670713          	addi	a4,a4,86 # 800077b8 <states.0+0x30>
    8000276a:	94ba                	add	s1,s1,a4
    8000276c:	409c                	lw	a5,0(s1)
    8000276e:	97ba                	add	a5,a5,a4
    80002770:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002772:	6d3c                	ld	a5,88(a0)
    80002774:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002776:	60e2                	ld	ra,24(sp)
    80002778:	6442                	ld	s0,16(sp)
    8000277a:	64a2                	ld	s1,8(sp)
    8000277c:	6105                	addi	sp,sp,32
    8000277e:	8082                	ret
    return p->trapframe->a1;
    80002780:	6d3c                	ld	a5,88(a0)
    80002782:	7fa8                	ld	a0,120(a5)
    80002784:	bfcd                	j	80002776 <argraw+0x2c>
    return p->trapframe->a2;
    80002786:	6d3c                	ld	a5,88(a0)
    80002788:	63c8                	ld	a0,128(a5)
    8000278a:	b7f5                	j	80002776 <argraw+0x2c>
    return p->trapframe->a3;
    8000278c:	6d3c                	ld	a5,88(a0)
    8000278e:	67c8                	ld	a0,136(a5)
    80002790:	b7dd                	j	80002776 <argraw+0x2c>
    return p->trapframe->a4;
    80002792:	6d3c                	ld	a5,88(a0)
    80002794:	6bc8                	ld	a0,144(a5)
    80002796:	b7c5                	j	80002776 <argraw+0x2c>
    return p->trapframe->a5;
    80002798:	6d3c                	ld	a5,88(a0)
    8000279a:	6fc8                	ld	a0,152(a5)
    8000279c:	bfe9                	j	80002776 <argraw+0x2c>
  panic("argraw");
    8000279e:	00005517          	auipc	a0,0x5
    800027a2:	c6a50513          	addi	a0,a0,-918 # 80007408 <etext+0x408>
    800027a6:	feffd0ef          	jal	80000794 <panic>

00000000800027aa <fetchaddr>:
{
    800027aa:	1101                	addi	sp,sp,-32
    800027ac:	ec06                	sd	ra,24(sp)
    800027ae:	e822                	sd	s0,16(sp)
    800027b0:	e426                	sd	s1,8(sp)
    800027b2:	e04a                	sd	s2,0(sp)
    800027b4:	1000                	addi	s0,sp,32
    800027b6:	84aa                	mv	s1,a0
    800027b8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027ba:	926ff0ef          	jal	800018e0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800027be:	653c                	ld	a5,72(a0)
    800027c0:	02f4f663          	bgeu	s1,a5,800027ec <fetchaddr+0x42>
    800027c4:	00848713          	addi	a4,s1,8
    800027c8:	02e7e463          	bltu	a5,a4,800027f0 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800027cc:	46a1                	li	a3,8
    800027ce:	8626                	mv	a2,s1
    800027d0:	85ca                	mv	a1,s2
    800027d2:	6928                	ld	a0,80(a0)
    800027d4:	e55fe0ef          	jal	80001628 <copyin>
    800027d8:	00a03533          	snez	a0,a0
    800027dc:	40a00533          	neg	a0,a0
}
    800027e0:	60e2                	ld	ra,24(sp)
    800027e2:	6442                	ld	s0,16(sp)
    800027e4:	64a2                	ld	s1,8(sp)
    800027e6:	6902                	ld	s2,0(sp)
    800027e8:	6105                	addi	sp,sp,32
    800027ea:	8082                	ret
    return -1;
    800027ec:	557d                	li	a0,-1
    800027ee:	bfcd                	j	800027e0 <fetchaddr+0x36>
    800027f0:	557d                	li	a0,-1
    800027f2:	b7fd                	j	800027e0 <fetchaddr+0x36>

00000000800027f4 <fetchstr>:
{
    800027f4:	7179                	addi	sp,sp,-48
    800027f6:	f406                	sd	ra,40(sp)
    800027f8:	f022                	sd	s0,32(sp)
    800027fa:	ec26                	sd	s1,24(sp)
    800027fc:	e84a                	sd	s2,16(sp)
    800027fe:	e44e                	sd	s3,8(sp)
    80002800:	1800                	addi	s0,sp,48
    80002802:	892a                	mv	s2,a0
    80002804:	84ae                	mv	s1,a1
    80002806:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002808:	8d8ff0ef          	jal	800018e0 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000280c:	86ce                	mv	a3,s3
    8000280e:	864a                	mv	a2,s2
    80002810:	85a6                	mv	a1,s1
    80002812:	6928                	ld	a0,80(a0)
    80002814:	e9bfe0ef          	jal	800016ae <copyinstr>
    80002818:	00054c63          	bltz	a0,80002830 <fetchstr+0x3c>
  return strlen(buf);
    8000281c:	8526                	mv	a0,s1
    8000281e:	e1afe0ef          	jal	80000e38 <strlen>
}
    80002822:	70a2                	ld	ra,40(sp)
    80002824:	7402                	ld	s0,32(sp)
    80002826:	64e2                	ld	s1,24(sp)
    80002828:	6942                	ld	s2,16(sp)
    8000282a:	69a2                	ld	s3,8(sp)
    8000282c:	6145                	addi	sp,sp,48
    8000282e:	8082                	ret
    return -1;
    80002830:	557d                	li	a0,-1
    80002832:	bfc5                	j	80002822 <fetchstr+0x2e>

0000000080002834 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002834:	1101                	addi	sp,sp,-32
    80002836:	ec06                	sd	ra,24(sp)
    80002838:	e822                	sd	s0,16(sp)
    8000283a:	e426                	sd	s1,8(sp)
    8000283c:	1000                	addi	s0,sp,32
    8000283e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002840:	f0bff0ef          	jal	8000274a <argraw>
    80002844:	c088                	sw	a0,0(s1)
}
    80002846:	60e2                	ld	ra,24(sp)
    80002848:	6442                	ld	s0,16(sp)
    8000284a:	64a2                	ld	s1,8(sp)
    8000284c:	6105                	addi	sp,sp,32
    8000284e:	8082                	ret

0000000080002850 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002850:	1101                	addi	sp,sp,-32
    80002852:	ec06                	sd	ra,24(sp)
    80002854:	e822                	sd	s0,16(sp)
    80002856:	e426                	sd	s1,8(sp)
    80002858:	1000                	addi	s0,sp,32
    8000285a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000285c:	eefff0ef          	jal	8000274a <argraw>
    80002860:	e088                	sd	a0,0(s1)
}
    80002862:	60e2                	ld	ra,24(sp)
    80002864:	6442                	ld	s0,16(sp)
    80002866:	64a2                	ld	s1,8(sp)
    80002868:	6105                	addi	sp,sp,32
    8000286a:	8082                	ret

000000008000286c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000286c:	7179                	addi	sp,sp,-48
    8000286e:	f406                	sd	ra,40(sp)
    80002870:	f022                	sd	s0,32(sp)
    80002872:	ec26                	sd	s1,24(sp)
    80002874:	e84a                	sd	s2,16(sp)
    80002876:	1800                	addi	s0,sp,48
    80002878:	84ae                	mv	s1,a1
    8000287a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000287c:	fd840593          	addi	a1,s0,-40
    80002880:	fd1ff0ef          	jal	80002850 <argaddr>
  return fetchstr(addr, buf, max);
    80002884:	864a                	mv	a2,s2
    80002886:	85a6                	mv	a1,s1
    80002888:	fd843503          	ld	a0,-40(s0)
    8000288c:	f69ff0ef          	jal	800027f4 <fetchstr>
}
    80002890:	70a2                	ld	ra,40(sp)
    80002892:	7402                	ld	s0,32(sp)
    80002894:	64e2                	ld	s1,24(sp)
    80002896:	6942                	ld	s2,16(sp)
    80002898:	6145                	addi	sp,sp,48
    8000289a:	8082                	ret

000000008000289c <syscall>:
[SYS_get_total_ticks]   sys_get_total_ticks,
};

void
syscall(void)
{
    8000289c:	1101                	addi	sp,sp,-32
    8000289e:	ec06                	sd	ra,24(sp)
    800028a0:	e822                	sd	s0,16(sp)
    800028a2:	e426                	sd	s1,8(sp)
    800028a4:	e04a                	sd	s2,0(sp)
    800028a6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800028a8:	838ff0ef          	jal	800018e0 <myproc>
    800028ac:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800028ae:	05853903          	ld	s2,88(a0)
    800028b2:	0a893783          	ld	a5,168(s2)
    800028b6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028ba:	37fd                	addiw	a5,a5,-1
    800028bc:	475d                	li	a4,23
    800028be:	00f76f63          	bltu	a4,a5,800028dc <syscall+0x40>
    800028c2:	00369713          	slli	a4,a3,0x3
    800028c6:	00005797          	auipc	a5,0x5
    800028ca:	f0a78793          	addi	a5,a5,-246 # 800077d0 <syscalls>
    800028ce:	97ba                	add	a5,a5,a4
    800028d0:	639c                	ld	a5,0(a5)
    800028d2:	c789                	beqz	a5,800028dc <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028d4:	9782                	jalr	a5
    800028d6:	06a93823          	sd	a0,112(s2)
    800028da:	a829                	j	800028f4 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800028dc:	15848613          	addi	a2,s1,344
    800028e0:	588c                	lw	a1,48(s1)
    800028e2:	00005517          	auipc	a0,0x5
    800028e6:	b2e50513          	addi	a0,a0,-1234 # 80007410 <etext+0x410>
    800028ea:	bd9fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800028ee:	6cbc                	ld	a5,88(s1)
    800028f0:	577d                	li	a4,-1
    800028f2:	fbb8                	sd	a4,112(a5)
  }
}
    800028f4:	60e2                	ld	ra,24(sp)
    800028f6:	6442                	ld	s0,16(sp)
    800028f8:	64a2                	ld	s1,8(sp)
    800028fa:	6902                	ld	s2,0(sp)
    800028fc:	6105                	addi	sp,sp,32
    800028fe:	8082                	ret

0000000080002900 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002900:	1101                	addi	sp,sp,-32
    80002902:	ec06                	sd	ra,24(sp)
    80002904:	e822                	sd	s0,16(sp)
    80002906:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002908:	fec40593          	addi	a1,s0,-20
    8000290c:	4501                	li	a0,0
    8000290e:	f27ff0ef          	jal	80002834 <argint>
  exit(n);
    80002912:	fec42503          	lw	a0,-20(s0)
    80002916:	f2eff0ef          	jal	80002044 <exit>
  return 0;  // not reached
}
    8000291a:	4501                	li	a0,0
    8000291c:	60e2                	ld	ra,24(sp)
    8000291e:	6442                	ld	s0,16(sp)
    80002920:	6105                	addi	sp,sp,32
    80002922:	8082                	ret

0000000080002924 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002924:	1141                	addi	sp,sp,-16
    80002926:	e406                	sd	ra,8(sp)
    80002928:	e022                	sd	s0,0(sp)
    8000292a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000292c:	fb5fe0ef          	jal	800018e0 <myproc>
}
    80002930:	5908                	lw	a0,48(a0)
    80002932:	60a2                	ld	ra,8(sp)
    80002934:	6402                	ld	s0,0(sp)
    80002936:	0141                	addi	sp,sp,16
    80002938:	8082                	ret

000000008000293a <sys_fork>:

uint64
sys_fork(void)
{
    8000293a:	1141                	addi	sp,sp,-16
    8000293c:	e406                	sd	ra,8(sp)
    8000293e:	e022                	sd	s0,0(sp)
    80002940:	0800                	addi	s0,sp,16
  return fork();
    80002942:	ac4ff0ef          	jal	80001c06 <fork>
}
    80002946:	60a2                	ld	ra,8(sp)
    80002948:	6402                	ld	s0,0(sp)
    8000294a:	0141                	addi	sp,sp,16
    8000294c:	8082                	ret

000000008000294e <sys_wait>:

uint64
sys_wait(void)
{
    8000294e:	1101                	addi	sp,sp,-32
    80002950:	ec06                	sd	ra,24(sp)
    80002952:	e822                	sd	s0,16(sp)
    80002954:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002956:	fe840593          	addi	a1,s0,-24
    8000295a:	4501                	li	a0,0
    8000295c:	ef5ff0ef          	jal	80002850 <argaddr>
  return wait(p);
    80002960:	fe843503          	ld	a0,-24(s0)
    80002964:	837ff0ef          	jal	8000219a <wait>
}
    80002968:	60e2                	ld	ra,24(sp)
    8000296a:	6442                	ld	s0,16(sp)
    8000296c:	6105                	addi	sp,sp,32
    8000296e:	8082                	ret

0000000080002970 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002970:	7179                	addi	sp,sp,-48
    80002972:	f406                	sd	ra,40(sp)
    80002974:	f022                	sd	s0,32(sp)
    80002976:	ec26                	sd	s1,24(sp)
    80002978:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000297a:	fdc40593          	addi	a1,s0,-36
    8000297e:	4501                	li	a0,0
    80002980:	eb5ff0ef          	jal	80002834 <argint>
  addr = myproc()->sz;
    80002984:	f5dfe0ef          	jal	800018e0 <myproc>
    80002988:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000298a:	fdc42503          	lw	a0,-36(s0)
    8000298e:	a28ff0ef          	jal	80001bb6 <growproc>
    80002992:	00054863          	bltz	a0,800029a2 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002996:	8526                	mv	a0,s1
    80002998:	70a2                	ld	ra,40(sp)
    8000299a:	7402                	ld	s0,32(sp)
    8000299c:	64e2                	ld	s1,24(sp)
    8000299e:	6145                	addi	sp,sp,48
    800029a0:	8082                	ret
    return -1;
    800029a2:	54fd                	li	s1,-1
    800029a4:	bfcd                	j	80002996 <sys_sbrk+0x26>

00000000800029a6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800029a6:	7139                	addi	sp,sp,-64
    800029a8:	fc06                	sd	ra,56(sp)
    800029aa:	f822                	sd	s0,48(sp)
    800029ac:	f04a                	sd	s2,32(sp)
    800029ae:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029b0:	fcc40593          	addi	a1,s0,-52
    800029b4:	4501                	li	a0,0
    800029b6:	e7fff0ef          	jal	80002834 <argint>
  if(n < 0)
    800029ba:	fcc42783          	lw	a5,-52(s0)
    800029be:	0607c763          	bltz	a5,80002a2c <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    800029c2:	00013517          	auipc	a0,0x13
    800029c6:	ece50513          	addi	a0,a0,-306 # 80015890 <tickslock>
    800029ca:	a2afe0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    800029ce:	00005917          	auipc	s2,0x5
    800029d2:	f6292903          	lw	s2,-158(s2) # 80007930 <ticks>
  while(ticks - ticks0 < n){
    800029d6:	fcc42783          	lw	a5,-52(s0)
    800029da:	cf8d                	beqz	a5,80002a14 <sys_sleep+0x6e>
    800029dc:	f426                	sd	s1,40(sp)
    800029de:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800029e0:	00013997          	auipc	s3,0x13
    800029e4:	eb098993          	addi	s3,s3,-336 # 80015890 <tickslock>
    800029e8:	00005497          	auipc	s1,0x5
    800029ec:	f4848493          	addi	s1,s1,-184 # 80007930 <ticks>
    if(killed(myproc())){
    800029f0:	ef1fe0ef          	jal	800018e0 <myproc>
    800029f4:	f7cff0ef          	jal	80002170 <killed>
    800029f8:	ed0d                	bnez	a0,80002a32 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    800029fa:	85ce                	mv	a1,s3
    800029fc:	8526                	mv	a0,s1
    800029fe:	d3aff0ef          	jal	80001f38 <sleep>
  while(ticks - ticks0 < n){
    80002a02:	409c                	lw	a5,0(s1)
    80002a04:	412787bb          	subw	a5,a5,s2
    80002a08:	fcc42703          	lw	a4,-52(s0)
    80002a0c:	fee7e2e3          	bltu	a5,a4,800029f0 <sys_sleep+0x4a>
    80002a10:	74a2                	ld	s1,40(sp)
    80002a12:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a14:	00013517          	auipc	a0,0x13
    80002a18:	e7c50513          	addi	a0,a0,-388 # 80015890 <tickslock>
    80002a1c:	a70fe0ef          	jal	80000c8c <release>
  return 0;
    80002a20:	4501                	li	a0,0
}
    80002a22:	70e2                	ld	ra,56(sp)
    80002a24:	7442                	ld	s0,48(sp)
    80002a26:	7902                	ld	s2,32(sp)
    80002a28:	6121                	addi	sp,sp,64
    80002a2a:	8082                	ret
    n = 0;
    80002a2c:	fc042623          	sw	zero,-52(s0)
    80002a30:	bf49                	j	800029c2 <sys_sleep+0x1c>
      release(&tickslock);
    80002a32:	00013517          	auipc	a0,0x13
    80002a36:	e5e50513          	addi	a0,a0,-418 # 80015890 <tickslock>
    80002a3a:	a52fe0ef          	jal	80000c8c <release>
      return -1;
    80002a3e:	557d                	li	a0,-1
    80002a40:	74a2                	ld	s1,40(sp)
    80002a42:	69e2                	ld	s3,24(sp)
    80002a44:	bff9                	j	80002a22 <sys_sleep+0x7c>

0000000080002a46 <sys_kill>:

uint64
sys_kill(void)
{
    80002a46:	1101                	addi	sp,sp,-32
    80002a48:	ec06                	sd	ra,24(sp)
    80002a4a:	e822                	sd	s0,16(sp)
    80002a4c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a4e:	fec40593          	addi	a1,s0,-20
    80002a52:	4501                	li	a0,0
    80002a54:	de1ff0ef          	jal	80002834 <argint>
  return kill(pid);
    80002a58:	fec42503          	lw	a0,-20(s0)
    80002a5c:	e8aff0ef          	jal	800020e6 <kill>
}
    80002a60:	60e2                	ld	ra,24(sp)
    80002a62:	6442                	ld	s0,16(sp)
    80002a64:	6105                	addi	sp,sp,32
    80002a66:	8082                	ret

0000000080002a68 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a68:	1101                	addi	sp,sp,-32
    80002a6a:	ec06                	sd	ra,24(sp)
    80002a6c:	e822                	sd	s0,16(sp)
    80002a6e:	e426                	sd	s1,8(sp)
    80002a70:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002a72:	00013517          	auipc	a0,0x13
    80002a76:	e1e50513          	addi	a0,a0,-482 # 80015890 <tickslock>
    80002a7a:	97afe0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002a7e:	00005497          	auipc	s1,0x5
    80002a82:	eb24a483          	lw	s1,-334(s1) # 80007930 <ticks>
  release(&tickslock);
    80002a86:	00013517          	auipc	a0,0x13
    80002a8a:	e0a50513          	addi	a0,a0,-502 # 80015890 <tickslock>
    80002a8e:	9fefe0ef          	jal	80000c8c <release>
  return xticks;
}
    80002a92:	02049513          	slli	a0,s1,0x20
    80002a96:	9101                	srli	a0,a0,0x20
    80002a98:	60e2                	ld	ra,24(sp)
    80002a9a:	6442                	ld	s0,16(sp)
    80002a9c:	64a2                	ld	s1,8(sp)
    80002a9e:	6105                	addi	sp,sp,32
    80002aa0:	8082                	ret

0000000080002aa2 <sys_get_context_switches>:

uint64
sys_get_context_switches(void)
{
    80002aa2:	1141                	addi	sp,sp,-16
    80002aa4:	e422                	sd	s0,8(sp)
    80002aa6:	0800                	addi	s0,sp,16
  extern uint64 total_context_switches;
  return total_context_switches;
}
    80002aa8:	00005517          	auipc	a0,0x5
    80002aac:	e7053503          	ld	a0,-400(a0) # 80007918 <total_context_switches>
    80002ab0:	6422                	ld	s0,8(sp)
    80002ab2:	0141                	addi	sp,sp,16
    80002ab4:	8082                	ret

0000000080002ab6 <sys_get_tick_rate>:

uint64
sys_get_tick_rate(void)
{
    80002ab6:	1141                	addi	sp,sp,-16
    80002ab8:	e422                	sd	s0,8(sp)
    80002aba:	0800                	addi	s0,sp,16
  extern uint64 dynamic_tick_rate;
  return dynamic_tick_rate;
}
    80002abc:	00005517          	auipc	a0,0x5
    80002ac0:	dec53503          	ld	a0,-532(a0) # 800078a8 <dynamic_tick_rate>
    80002ac4:	6422                	ld	s0,8(sp)
    80002ac6:	0141                	addi	sp,sp,16
    80002ac8:	8082                	ret

0000000080002aca <sys_get_total_ticks>:

uint64
sys_get_total_ticks(void)
{
    80002aca:	1141                	addi	sp,sp,-16
    80002acc:	e422                	sd	s0,8(sp)
    80002ace:	0800                	addi	s0,sp,16
  extern uint64 total_ticks;
  return total_ticks;
}
    80002ad0:	00005517          	auipc	a0,0x5
    80002ad4:	e5853503          	ld	a0,-424(a0) # 80007928 <total_ticks>
    80002ad8:	6422                	ld	s0,8(sp)
    80002ada:	0141                	addi	sp,sp,16
    80002adc:	8082                	ret

0000000080002ade <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ade:	7179                	addi	sp,sp,-48
    80002ae0:	f406                	sd	ra,40(sp)
    80002ae2:	f022                	sd	s0,32(sp)
    80002ae4:	ec26                	sd	s1,24(sp)
    80002ae6:	e84a                	sd	s2,16(sp)
    80002ae8:	e44e                	sd	s3,8(sp)
    80002aea:	e052                	sd	s4,0(sp)
    80002aec:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002aee:	00005597          	auipc	a1,0x5
    80002af2:	94258593          	addi	a1,a1,-1726 # 80007430 <etext+0x430>
    80002af6:	00013517          	auipc	a0,0x13
    80002afa:	db250513          	addi	a0,a0,-590 # 800158a8 <bcache>
    80002afe:	876fe0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b02:	0001b797          	auipc	a5,0x1b
    80002b06:	da678793          	addi	a5,a5,-602 # 8001d8a8 <bcache+0x8000>
    80002b0a:	0001b717          	auipc	a4,0x1b
    80002b0e:	00670713          	addi	a4,a4,6 # 8001db10 <bcache+0x8268>
    80002b12:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b16:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b1a:	00013497          	auipc	s1,0x13
    80002b1e:	da648493          	addi	s1,s1,-602 # 800158c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002b22:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b24:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b26:	00005a17          	auipc	s4,0x5
    80002b2a:	912a0a13          	addi	s4,s4,-1774 # 80007438 <etext+0x438>
    b->next = bcache.head.next;
    80002b2e:	2b893783          	ld	a5,696(s2)
    80002b32:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b34:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b38:	85d2                	mv	a1,s4
    80002b3a:	01048513          	addi	a0,s1,16
    80002b3e:	248010ef          	jal	80003d86 <initsleeplock>
    bcache.head.next->prev = b;
    80002b42:	2b893783          	ld	a5,696(s2)
    80002b46:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b48:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b4c:	45848493          	addi	s1,s1,1112
    80002b50:	fd349fe3          	bne	s1,s3,80002b2e <binit+0x50>
  }
}
    80002b54:	70a2                	ld	ra,40(sp)
    80002b56:	7402                	ld	s0,32(sp)
    80002b58:	64e2                	ld	s1,24(sp)
    80002b5a:	6942                	ld	s2,16(sp)
    80002b5c:	69a2                	ld	s3,8(sp)
    80002b5e:	6a02                	ld	s4,0(sp)
    80002b60:	6145                	addi	sp,sp,48
    80002b62:	8082                	ret

0000000080002b64 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002b64:	7179                	addi	sp,sp,-48
    80002b66:	f406                	sd	ra,40(sp)
    80002b68:	f022                	sd	s0,32(sp)
    80002b6a:	ec26                	sd	s1,24(sp)
    80002b6c:	e84a                	sd	s2,16(sp)
    80002b6e:	e44e                	sd	s3,8(sp)
    80002b70:	1800                	addi	s0,sp,48
    80002b72:	892a                	mv	s2,a0
    80002b74:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002b76:	00013517          	auipc	a0,0x13
    80002b7a:	d3250513          	addi	a0,a0,-718 # 800158a8 <bcache>
    80002b7e:	876fe0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002b82:	0001b497          	auipc	s1,0x1b
    80002b86:	fde4b483          	ld	s1,-34(s1) # 8001db60 <bcache+0x82b8>
    80002b8a:	0001b797          	auipc	a5,0x1b
    80002b8e:	f8678793          	addi	a5,a5,-122 # 8001db10 <bcache+0x8268>
    80002b92:	02f48b63          	beq	s1,a5,80002bc8 <bread+0x64>
    80002b96:	873e                	mv	a4,a5
    80002b98:	a021                	j	80002ba0 <bread+0x3c>
    80002b9a:	68a4                	ld	s1,80(s1)
    80002b9c:	02e48663          	beq	s1,a4,80002bc8 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002ba0:	449c                	lw	a5,8(s1)
    80002ba2:	ff279ce3          	bne	a5,s2,80002b9a <bread+0x36>
    80002ba6:	44dc                	lw	a5,12(s1)
    80002ba8:	ff3799e3          	bne	a5,s3,80002b9a <bread+0x36>
      b->refcnt++;
    80002bac:	40bc                	lw	a5,64(s1)
    80002bae:	2785                	addiw	a5,a5,1
    80002bb0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bb2:	00013517          	auipc	a0,0x13
    80002bb6:	cf650513          	addi	a0,a0,-778 # 800158a8 <bcache>
    80002bba:	8d2fe0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002bbe:	01048513          	addi	a0,s1,16
    80002bc2:	1fa010ef          	jal	80003dbc <acquiresleep>
      return b;
    80002bc6:	a889                	j	80002c18 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002bc8:	0001b497          	auipc	s1,0x1b
    80002bcc:	f904b483          	ld	s1,-112(s1) # 8001db58 <bcache+0x82b0>
    80002bd0:	0001b797          	auipc	a5,0x1b
    80002bd4:	f4078793          	addi	a5,a5,-192 # 8001db10 <bcache+0x8268>
    80002bd8:	00f48863          	beq	s1,a5,80002be8 <bread+0x84>
    80002bdc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002bde:	40bc                	lw	a5,64(s1)
    80002be0:	cb91                	beqz	a5,80002bf4 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002be2:	64a4                	ld	s1,72(s1)
    80002be4:	fee49de3          	bne	s1,a4,80002bde <bread+0x7a>
  panic("bget: no buffers");
    80002be8:	00005517          	auipc	a0,0x5
    80002bec:	85850513          	addi	a0,a0,-1960 # 80007440 <etext+0x440>
    80002bf0:	ba5fd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002bf4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002bf8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002bfc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c00:	4785                	li	a5,1
    80002c02:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c04:	00013517          	auipc	a0,0x13
    80002c08:	ca450513          	addi	a0,a0,-860 # 800158a8 <bcache>
    80002c0c:	880fe0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002c10:	01048513          	addi	a0,s1,16
    80002c14:	1a8010ef          	jal	80003dbc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002c18:	409c                	lw	a5,0(s1)
    80002c1a:	cb89                	beqz	a5,80002c2c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c1c:	8526                	mv	a0,s1
    80002c1e:	70a2                	ld	ra,40(sp)
    80002c20:	7402                	ld	s0,32(sp)
    80002c22:	64e2                	ld	s1,24(sp)
    80002c24:	6942                	ld	s2,16(sp)
    80002c26:	69a2                	ld	s3,8(sp)
    80002c28:	6145                	addi	sp,sp,48
    80002c2a:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c2c:	4581                	li	a1,0
    80002c2e:	8526                	mv	a0,s1
    80002c30:	1f1020ef          	jal	80005620 <virtio_disk_rw>
    b->valid = 1;
    80002c34:	4785                	li	a5,1
    80002c36:	c09c                	sw	a5,0(s1)
  return b;
    80002c38:	b7d5                	j	80002c1c <bread+0xb8>

0000000080002c3a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002c3a:	1101                	addi	sp,sp,-32
    80002c3c:	ec06                	sd	ra,24(sp)
    80002c3e:	e822                	sd	s0,16(sp)
    80002c40:	e426                	sd	s1,8(sp)
    80002c42:	1000                	addi	s0,sp,32
    80002c44:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c46:	0541                	addi	a0,a0,16
    80002c48:	1f2010ef          	jal	80003e3a <holdingsleep>
    80002c4c:	c911                	beqz	a0,80002c60 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c4e:	4585                	li	a1,1
    80002c50:	8526                	mv	a0,s1
    80002c52:	1cf020ef          	jal	80005620 <virtio_disk_rw>
}
    80002c56:	60e2                	ld	ra,24(sp)
    80002c58:	6442                	ld	s0,16(sp)
    80002c5a:	64a2                	ld	s1,8(sp)
    80002c5c:	6105                	addi	sp,sp,32
    80002c5e:	8082                	ret
    panic("bwrite");
    80002c60:	00004517          	auipc	a0,0x4
    80002c64:	7f850513          	addi	a0,a0,2040 # 80007458 <etext+0x458>
    80002c68:	b2dfd0ef          	jal	80000794 <panic>

0000000080002c6c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002c6c:	1101                	addi	sp,sp,-32
    80002c6e:	ec06                	sd	ra,24(sp)
    80002c70:	e822                	sd	s0,16(sp)
    80002c72:	e426                	sd	s1,8(sp)
    80002c74:	e04a                	sd	s2,0(sp)
    80002c76:	1000                	addi	s0,sp,32
    80002c78:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c7a:	01050913          	addi	s2,a0,16
    80002c7e:	854a                	mv	a0,s2
    80002c80:	1ba010ef          	jal	80003e3a <holdingsleep>
    80002c84:	c135                	beqz	a0,80002ce8 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002c86:	854a                	mv	a0,s2
    80002c88:	17a010ef          	jal	80003e02 <releasesleep>

  acquire(&bcache.lock);
    80002c8c:	00013517          	auipc	a0,0x13
    80002c90:	c1c50513          	addi	a0,a0,-996 # 800158a8 <bcache>
    80002c94:	f61fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002c98:	40bc                	lw	a5,64(s1)
    80002c9a:	37fd                	addiw	a5,a5,-1
    80002c9c:	0007871b          	sext.w	a4,a5
    80002ca0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002ca2:	e71d                	bnez	a4,80002cd0 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002ca4:	68b8                	ld	a4,80(s1)
    80002ca6:	64bc                	ld	a5,72(s1)
    80002ca8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002caa:	68b8                	ld	a4,80(s1)
    80002cac:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002cae:	0001b797          	auipc	a5,0x1b
    80002cb2:	bfa78793          	addi	a5,a5,-1030 # 8001d8a8 <bcache+0x8000>
    80002cb6:	2b87b703          	ld	a4,696(a5)
    80002cba:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002cbc:	0001b717          	auipc	a4,0x1b
    80002cc0:	e5470713          	addi	a4,a4,-428 # 8001db10 <bcache+0x8268>
    80002cc4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002cc6:	2b87b703          	ld	a4,696(a5)
    80002cca:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002ccc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002cd0:	00013517          	auipc	a0,0x13
    80002cd4:	bd850513          	addi	a0,a0,-1064 # 800158a8 <bcache>
    80002cd8:	fb5fd0ef          	jal	80000c8c <release>
}
    80002cdc:	60e2                	ld	ra,24(sp)
    80002cde:	6442                	ld	s0,16(sp)
    80002ce0:	64a2                	ld	s1,8(sp)
    80002ce2:	6902                	ld	s2,0(sp)
    80002ce4:	6105                	addi	sp,sp,32
    80002ce6:	8082                	ret
    panic("brelse");
    80002ce8:	00004517          	auipc	a0,0x4
    80002cec:	77850513          	addi	a0,a0,1912 # 80007460 <etext+0x460>
    80002cf0:	aa5fd0ef          	jal	80000794 <panic>

0000000080002cf4 <bpin>:

void
bpin(struct buf *b) {
    80002cf4:	1101                	addi	sp,sp,-32
    80002cf6:	ec06                	sd	ra,24(sp)
    80002cf8:	e822                	sd	s0,16(sp)
    80002cfa:	e426                	sd	s1,8(sp)
    80002cfc:	1000                	addi	s0,sp,32
    80002cfe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d00:	00013517          	auipc	a0,0x13
    80002d04:	ba850513          	addi	a0,a0,-1112 # 800158a8 <bcache>
    80002d08:	eedfd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    80002d0c:	40bc                	lw	a5,64(s1)
    80002d0e:	2785                	addiw	a5,a5,1
    80002d10:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d12:	00013517          	auipc	a0,0x13
    80002d16:	b9650513          	addi	a0,a0,-1130 # 800158a8 <bcache>
    80002d1a:	f73fd0ef          	jal	80000c8c <release>
}
    80002d1e:	60e2                	ld	ra,24(sp)
    80002d20:	6442                	ld	s0,16(sp)
    80002d22:	64a2                	ld	s1,8(sp)
    80002d24:	6105                	addi	sp,sp,32
    80002d26:	8082                	ret

0000000080002d28 <bunpin>:

void
bunpin(struct buf *b) {
    80002d28:	1101                	addi	sp,sp,-32
    80002d2a:	ec06                	sd	ra,24(sp)
    80002d2c:	e822                	sd	s0,16(sp)
    80002d2e:	e426                	sd	s1,8(sp)
    80002d30:	1000                	addi	s0,sp,32
    80002d32:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d34:	00013517          	auipc	a0,0x13
    80002d38:	b7450513          	addi	a0,a0,-1164 # 800158a8 <bcache>
    80002d3c:	eb9fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002d40:	40bc                	lw	a5,64(s1)
    80002d42:	37fd                	addiw	a5,a5,-1
    80002d44:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d46:	00013517          	auipc	a0,0x13
    80002d4a:	b6250513          	addi	a0,a0,-1182 # 800158a8 <bcache>
    80002d4e:	f3ffd0ef          	jal	80000c8c <release>
}
    80002d52:	60e2                	ld	ra,24(sp)
    80002d54:	6442                	ld	s0,16(sp)
    80002d56:	64a2                	ld	s1,8(sp)
    80002d58:	6105                	addi	sp,sp,32
    80002d5a:	8082                	ret

0000000080002d5c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d5c:	1101                	addi	sp,sp,-32
    80002d5e:	ec06                	sd	ra,24(sp)
    80002d60:	e822                	sd	s0,16(sp)
    80002d62:	e426                	sd	s1,8(sp)
    80002d64:	e04a                	sd	s2,0(sp)
    80002d66:	1000                	addi	s0,sp,32
    80002d68:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002d6a:	00d5d59b          	srliw	a1,a1,0xd
    80002d6e:	0001b797          	auipc	a5,0x1b
    80002d72:	2167a783          	lw	a5,534(a5) # 8001df84 <sb+0x1c>
    80002d76:	9dbd                	addw	a1,a1,a5
    80002d78:	dedff0ef          	jal	80002b64 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002d7c:	0074f713          	andi	a4,s1,7
    80002d80:	4785                	li	a5,1
    80002d82:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002d86:	14ce                	slli	s1,s1,0x33
    80002d88:	90d9                	srli	s1,s1,0x36
    80002d8a:	00950733          	add	a4,a0,s1
    80002d8e:	05874703          	lbu	a4,88(a4)
    80002d92:	00e7f6b3          	and	a3,a5,a4
    80002d96:	c29d                	beqz	a3,80002dbc <bfree+0x60>
    80002d98:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002d9a:	94aa                	add	s1,s1,a0
    80002d9c:	fff7c793          	not	a5,a5
    80002da0:	8f7d                	and	a4,a4,a5
    80002da2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002da6:	711000ef          	jal	80003cb6 <log_write>
  brelse(bp);
    80002daa:	854a                	mv	a0,s2
    80002dac:	ec1ff0ef          	jal	80002c6c <brelse>
}
    80002db0:	60e2                	ld	ra,24(sp)
    80002db2:	6442                	ld	s0,16(sp)
    80002db4:	64a2                	ld	s1,8(sp)
    80002db6:	6902                	ld	s2,0(sp)
    80002db8:	6105                	addi	sp,sp,32
    80002dba:	8082                	ret
    panic("freeing free block");
    80002dbc:	00004517          	auipc	a0,0x4
    80002dc0:	6ac50513          	addi	a0,a0,1708 # 80007468 <etext+0x468>
    80002dc4:	9d1fd0ef          	jal	80000794 <panic>

0000000080002dc8 <balloc>:
{
    80002dc8:	711d                	addi	sp,sp,-96
    80002dca:	ec86                	sd	ra,88(sp)
    80002dcc:	e8a2                	sd	s0,80(sp)
    80002dce:	e4a6                	sd	s1,72(sp)
    80002dd0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002dd2:	0001b797          	auipc	a5,0x1b
    80002dd6:	19a7a783          	lw	a5,410(a5) # 8001df6c <sb+0x4>
    80002dda:	0e078f63          	beqz	a5,80002ed8 <balloc+0x110>
    80002dde:	e0ca                	sd	s2,64(sp)
    80002de0:	fc4e                	sd	s3,56(sp)
    80002de2:	f852                	sd	s4,48(sp)
    80002de4:	f456                	sd	s5,40(sp)
    80002de6:	f05a                	sd	s6,32(sp)
    80002de8:	ec5e                	sd	s7,24(sp)
    80002dea:	e862                	sd	s8,16(sp)
    80002dec:	e466                	sd	s9,8(sp)
    80002dee:	8baa                	mv	s7,a0
    80002df0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002df2:	0001bb17          	auipc	s6,0x1b
    80002df6:	176b0b13          	addi	s6,s6,374 # 8001df68 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002dfa:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002dfc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002dfe:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002e00:	6c89                	lui	s9,0x2
    80002e02:	a0b5                	j	80002e6e <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002e04:	97ca                	add	a5,a5,s2
    80002e06:	8e55                	or	a2,a2,a3
    80002e08:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002e0c:	854a                	mv	a0,s2
    80002e0e:	6a9000ef          	jal	80003cb6 <log_write>
        brelse(bp);
    80002e12:	854a                	mv	a0,s2
    80002e14:	e59ff0ef          	jal	80002c6c <brelse>
  bp = bread(dev, bno);
    80002e18:	85a6                	mv	a1,s1
    80002e1a:	855e                	mv	a0,s7
    80002e1c:	d49ff0ef          	jal	80002b64 <bread>
    80002e20:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e22:	40000613          	li	a2,1024
    80002e26:	4581                	li	a1,0
    80002e28:	05850513          	addi	a0,a0,88
    80002e2c:	e9dfd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    80002e30:	854a                	mv	a0,s2
    80002e32:	685000ef          	jal	80003cb6 <log_write>
  brelse(bp);
    80002e36:	854a                	mv	a0,s2
    80002e38:	e35ff0ef          	jal	80002c6c <brelse>
}
    80002e3c:	6906                	ld	s2,64(sp)
    80002e3e:	79e2                	ld	s3,56(sp)
    80002e40:	7a42                	ld	s4,48(sp)
    80002e42:	7aa2                	ld	s5,40(sp)
    80002e44:	7b02                	ld	s6,32(sp)
    80002e46:	6be2                	ld	s7,24(sp)
    80002e48:	6c42                	ld	s8,16(sp)
    80002e4a:	6ca2                	ld	s9,8(sp)
}
    80002e4c:	8526                	mv	a0,s1
    80002e4e:	60e6                	ld	ra,88(sp)
    80002e50:	6446                	ld	s0,80(sp)
    80002e52:	64a6                	ld	s1,72(sp)
    80002e54:	6125                	addi	sp,sp,96
    80002e56:	8082                	ret
    brelse(bp);
    80002e58:	854a                	mv	a0,s2
    80002e5a:	e13ff0ef          	jal	80002c6c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002e5e:	015c87bb          	addw	a5,s9,s5
    80002e62:	00078a9b          	sext.w	s5,a5
    80002e66:	004b2703          	lw	a4,4(s6)
    80002e6a:	04eaff63          	bgeu	s5,a4,80002ec8 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002e6e:	41fad79b          	sraiw	a5,s5,0x1f
    80002e72:	0137d79b          	srliw	a5,a5,0x13
    80002e76:	015787bb          	addw	a5,a5,s5
    80002e7a:	40d7d79b          	sraiw	a5,a5,0xd
    80002e7e:	01cb2583          	lw	a1,28(s6)
    80002e82:	9dbd                	addw	a1,a1,a5
    80002e84:	855e                	mv	a0,s7
    80002e86:	cdfff0ef          	jal	80002b64 <bread>
    80002e8a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e8c:	004b2503          	lw	a0,4(s6)
    80002e90:	000a849b          	sext.w	s1,s5
    80002e94:	8762                	mv	a4,s8
    80002e96:	fca4f1e3          	bgeu	s1,a0,80002e58 <balloc+0x90>
      m = 1 << (bi % 8);
    80002e9a:	00777693          	andi	a3,a4,7
    80002e9e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002ea2:	41f7579b          	sraiw	a5,a4,0x1f
    80002ea6:	01d7d79b          	srliw	a5,a5,0x1d
    80002eaa:	9fb9                	addw	a5,a5,a4
    80002eac:	4037d79b          	sraiw	a5,a5,0x3
    80002eb0:	00f90633          	add	a2,s2,a5
    80002eb4:	05864603          	lbu	a2,88(a2)
    80002eb8:	00c6f5b3          	and	a1,a3,a2
    80002ebc:	d5a1                	beqz	a1,80002e04 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ebe:	2705                	addiw	a4,a4,1
    80002ec0:	2485                	addiw	s1,s1,1
    80002ec2:	fd471ae3          	bne	a4,s4,80002e96 <balloc+0xce>
    80002ec6:	bf49                	j	80002e58 <balloc+0x90>
    80002ec8:	6906                	ld	s2,64(sp)
    80002eca:	79e2                	ld	s3,56(sp)
    80002ecc:	7a42                	ld	s4,48(sp)
    80002ece:	7aa2                	ld	s5,40(sp)
    80002ed0:	7b02                	ld	s6,32(sp)
    80002ed2:	6be2                	ld	s7,24(sp)
    80002ed4:	6c42                	ld	s8,16(sp)
    80002ed6:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002ed8:	00004517          	auipc	a0,0x4
    80002edc:	5a850513          	addi	a0,a0,1448 # 80007480 <etext+0x480>
    80002ee0:	de2fd0ef          	jal	800004c2 <printf>
  return 0;
    80002ee4:	4481                	li	s1,0
    80002ee6:	b79d                	j	80002e4c <balloc+0x84>

0000000080002ee8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002ee8:	7179                	addi	sp,sp,-48
    80002eea:	f406                	sd	ra,40(sp)
    80002eec:	f022                	sd	s0,32(sp)
    80002eee:	ec26                	sd	s1,24(sp)
    80002ef0:	e84a                	sd	s2,16(sp)
    80002ef2:	e44e                	sd	s3,8(sp)
    80002ef4:	1800                	addi	s0,sp,48
    80002ef6:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002ef8:	47ad                	li	a5,11
    80002efa:	02b7e663          	bltu	a5,a1,80002f26 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002efe:	02059793          	slli	a5,a1,0x20
    80002f02:	01e7d593          	srli	a1,a5,0x1e
    80002f06:	00b504b3          	add	s1,a0,a1
    80002f0a:	0504a903          	lw	s2,80(s1)
    80002f0e:	06091a63          	bnez	s2,80002f82 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002f12:	4108                	lw	a0,0(a0)
    80002f14:	eb5ff0ef          	jal	80002dc8 <balloc>
    80002f18:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002f1c:	06090363          	beqz	s2,80002f82 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002f20:	0524a823          	sw	s2,80(s1)
    80002f24:	a8b9                	j	80002f82 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f26:	ff45849b          	addiw	s1,a1,-12
    80002f2a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002f2e:	0ff00793          	li	a5,255
    80002f32:	06e7ee63          	bltu	a5,a4,80002fae <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002f36:	08052903          	lw	s2,128(a0)
    80002f3a:	00091d63          	bnez	s2,80002f54 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002f3e:	4108                	lw	a0,0(a0)
    80002f40:	e89ff0ef          	jal	80002dc8 <balloc>
    80002f44:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002f48:	02090d63          	beqz	s2,80002f82 <bmap+0x9a>
    80002f4c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f4e:	0929a023          	sw	s2,128(s3)
    80002f52:	a011                	j	80002f56 <bmap+0x6e>
    80002f54:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002f56:	85ca                	mv	a1,s2
    80002f58:	0009a503          	lw	a0,0(s3)
    80002f5c:	c09ff0ef          	jal	80002b64 <bread>
    80002f60:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002f62:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002f66:	02049713          	slli	a4,s1,0x20
    80002f6a:	01e75593          	srli	a1,a4,0x1e
    80002f6e:	00b784b3          	add	s1,a5,a1
    80002f72:	0004a903          	lw	s2,0(s1)
    80002f76:	00090e63          	beqz	s2,80002f92 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f7a:	8552                	mv	a0,s4
    80002f7c:	cf1ff0ef          	jal	80002c6c <brelse>
    return addr;
    80002f80:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002f82:	854a                	mv	a0,s2
    80002f84:	70a2                	ld	ra,40(sp)
    80002f86:	7402                	ld	s0,32(sp)
    80002f88:	64e2                	ld	s1,24(sp)
    80002f8a:	6942                	ld	s2,16(sp)
    80002f8c:	69a2                	ld	s3,8(sp)
    80002f8e:	6145                	addi	sp,sp,48
    80002f90:	8082                	ret
      addr = balloc(ip->dev);
    80002f92:	0009a503          	lw	a0,0(s3)
    80002f96:	e33ff0ef          	jal	80002dc8 <balloc>
    80002f9a:	0005091b          	sext.w	s2,a0
      if(addr){
    80002f9e:	fc090ee3          	beqz	s2,80002f7a <bmap+0x92>
        a[bn] = addr;
    80002fa2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002fa6:	8552                	mv	a0,s4
    80002fa8:	50f000ef          	jal	80003cb6 <log_write>
    80002fac:	b7f9                	j	80002f7a <bmap+0x92>
    80002fae:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002fb0:	00004517          	auipc	a0,0x4
    80002fb4:	4e850513          	addi	a0,a0,1256 # 80007498 <etext+0x498>
    80002fb8:	fdcfd0ef          	jal	80000794 <panic>

0000000080002fbc <iget>:
{
    80002fbc:	7179                	addi	sp,sp,-48
    80002fbe:	f406                	sd	ra,40(sp)
    80002fc0:	f022                	sd	s0,32(sp)
    80002fc2:	ec26                	sd	s1,24(sp)
    80002fc4:	e84a                	sd	s2,16(sp)
    80002fc6:	e44e                	sd	s3,8(sp)
    80002fc8:	e052                	sd	s4,0(sp)
    80002fca:	1800                	addi	s0,sp,48
    80002fcc:	89aa                	mv	s3,a0
    80002fce:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002fd0:	0001b517          	auipc	a0,0x1b
    80002fd4:	fb850513          	addi	a0,a0,-72 # 8001df88 <itable>
    80002fd8:	c1dfd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    80002fdc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fde:	0001b497          	auipc	s1,0x1b
    80002fe2:	fc248493          	addi	s1,s1,-62 # 8001dfa0 <itable+0x18>
    80002fe6:	0001d697          	auipc	a3,0x1d
    80002fea:	a4a68693          	addi	a3,a3,-1462 # 8001fa30 <log>
    80002fee:	a039                	j	80002ffc <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ff0:	02090963          	beqz	s2,80003022 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ff4:	08848493          	addi	s1,s1,136
    80002ff8:	02d48863          	beq	s1,a3,80003028 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002ffc:	449c                	lw	a5,8(s1)
    80002ffe:	fef059e3          	blez	a5,80002ff0 <iget+0x34>
    80003002:	4098                	lw	a4,0(s1)
    80003004:	ff3716e3          	bne	a4,s3,80002ff0 <iget+0x34>
    80003008:	40d8                	lw	a4,4(s1)
    8000300a:	ff4713e3          	bne	a4,s4,80002ff0 <iget+0x34>
      ip->ref++;
    8000300e:	2785                	addiw	a5,a5,1
    80003010:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003012:	0001b517          	auipc	a0,0x1b
    80003016:	f7650513          	addi	a0,a0,-138 # 8001df88 <itable>
    8000301a:	c73fd0ef          	jal	80000c8c <release>
      return ip;
    8000301e:	8926                	mv	s2,s1
    80003020:	a02d                	j	8000304a <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003022:	fbe9                	bnez	a5,80002ff4 <iget+0x38>
      empty = ip;
    80003024:	8926                	mv	s2,s1
    80003026:	b7f9                	j	80002ff4 <iget+0x38>
  if(empty == 0)
    80003028:	02090a63          	beqz	s2,8000305c <iget+0xa0>
  ip->dev = dev;
    8000302c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003030:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003034:	4785                	li	a5,1
    80003036:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000303a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000303e:	0001b517          	auipc	a0,0x1b
    80003042:	f4a50513          	addi	a0,a0,-182 # 8001df88 <itable>
    80003046:	c47fd0ef          	jal	80000c8c <release>
}
    8000304a:	854a                	mv	a0,s2
    8000304c:	70a2                	ld	ra,40(sp)
    8000304e:	7402                	ld	s0,32(sp)
    80003050:	64e2                	ld	s1,24(sp)
    80003052:	6942                	ld	s2,16(sp)
    80003054:	69a2                	ld	s3,8(sp)
    80003056:	6a02                	ld	s4,0(sp)
    80003058:	6145                	addi	sp,sp,48
    8000305a:	8082                	ret
    panic("iget: no inodes");
    8000305c:	00004517          	auipc	a0,0x4
    80003060:	45450513          	addi	a0,a0,1108 # 800074b0 <etext+0x4b0>
    80003064:	f30fd0ef          	jal	80000794 <panic>

0000000080003068 <fsinit>:
fsinit(int dev) {
    80003068:	7179                	addi	sp,sp,-48
    8000306a:	f406                	sd	ra,40(sp)
    8000306c:	f022                	sd	s0,32(sp)
    8000306e:	ec26                	sd	s1,24(sp)
    80003070:	e84a                	sd	s2,16(sp)
    80003072:	e44e                	sd	s3,8(sp)
    80003074:	1800                	addi	s0,sp,48
    80003076:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003078:	4585                	li	a1,1
    8000307a:	aebff0ef          	jal	80002b64 <bread>
    8000307e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003080:	0001b997          	auipc	s3,0x1b
    80003084:	ee898993          	addi	s3,s3,-280 # 8001df68 <sb>
    80003088:	02000613          	li	a2,32
    8000308c:	05850593          	addi	a1,a0,88
    80003090:	854e                	mv	a0,s3
    80003092:	c93fd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    80003096:	8526                	mv	a0,s1
    80003098:	bd5ff0ef          	jal	80002c6c <brelse>
  if(sb.magic != FSMAGIC)
    8000309c:	0009a703          	lw	a4,0(s3)
    800030a0:	102037b7          	lui	a5,0x10203
    800030a4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800030a8:	02f71063          	bne	a4,a5,800030c8 <fsinit+0x60>
  initlog(dev, &sb);
    800030ac:	0001b597          	auipc	a1,0x1b
    800030b0:	ebc58593          	addi	a1,a1,-324 # 8001df68 <sb>
    800030b4:	854a                	mv	a0,s2
    800030b6:	1f9000ef          	jal	80003aae <initlog>
}
    800030ba:	70a2                	ld	ra,40(sp)
    800030bc:	7402                	ld	s0,32(sp)
    800030be:	64e2                	ld	s1,24(sp)
    800030c0:	6942                	ld	s2,16(sp)
    800030c2:	69a2                	ld	s3,8(sp)
    800030c4:	6145                	addi	sp,sp,48
    800030c6:	8082                	ret
    panic("invalid file system");
    800030c8:	00004517          	auipc	a0,0x4
    800030cc:	3f850513          	addi	a0,a0,1016 # 800074c0 <etext+0x4c0>
    800030d0:	ec4fd0ef          	jal	80000794 <panic>

00000000800030d4 <iinit>:
{
    800030d4:	7179                	addi	sp,sp,-48
    800030d6:	f406                	sd	ra,40(sp)
    800030d8:	f022                	sd	s0,32(sp)
    800030da:	ec26                	sd	s1,24(sp)
    800030dc:	e84a                	sd	s2,16(sp)
    800030de:	e44e                	sd	s3,8(sp)
    800030e0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800030e2:	00004597          	auipc	a1,0x4
    800030e6:	3f658593          	addi	a1,a1,1014 # 800074d8 <etext+0x4d8>
    800030ea:	0001b517          	auipc	a0,0x1b
    800030ee:	e9e50513          	addi	a0,a0,-354 # 8001df88 <itable>
    800030f2:	a83fd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    800030f6:	0001b497          	auipc	s1,0x1b
    800030fa:	eba48493          	addi	s1,s1,-326 # 8001dfb0 <itable+0x28>
    800030fe:	0001d997          	auipc	s3,0x1d
    80003102:	94298993          	addi	s3,s3,-1726 # 8001fa40 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003106:	00004917          	auipc	s2,0x4
    8000310a:	3da90913          	addi	s2,s2,986 # 800074e0 <etext+0x4e0>
    8000310e:	85ca                	mv	a1,s2
    80003110:	8526                	mv	a0,s1
    80003112:	475000ef          	jal	80003d86 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003116:	08848493          	addi	s1,s1,136
    8000311a:	ff349ae3          	bne	s1,s3,8000310e <iinit+0x3a>
}
    8000311e:	70a2                	ld	ra,40(sp)
    80003120:	7402                	ld	s0,32(sp)
    80003122:	64e2                	ld	s1,24(sp)
    80003124:	6942                	ld	s2,16(sp)
    80003126:	69a2                	ld	s3,8(sp)
    80003128:	6145                	addi	sp,sp,48
    8000312a:	8082                	ret

000000008000312c <ialloc>:
{
    8000312c:	7139                	addi	sp,sp,-64
    8000312e:	fc06                	sd	ra,56(sp)
    80003130:	f822                	sd	s0,48(sp)
    80003132:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003134:	0001b717          	auipc	a4,0x1b
    80003138:	e4072703          	lw	a4,-448(a4) # 8001df74 <sb+0xc>
    8000313c:	4785                	li	a5,1
    8000313e:	06e7f063          	bgeu	a5,a4,8000319e <ialloc+0x72>
    80003142:	f426                	sd	s1,40(sp)
    80003144:	f04a                	sd	s2,32(sp)
    80003146:	ec4e                	sd	s3,24(sp)
    80003148:	e852                	sd	s4,16(sp)
    8000314a:	e456                	sd	s5,8(sp)
    8000314c:	e05a                	sd	s6,0(sp)
    8000314e:	8aaa                	mv	s5,a0
    80003150:	8b2e                	mv	s6,a1
    80003152:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003154:	0001ba17          	auipc	s4,0x1b
    80003158:	e14a0a13          	addi	s4,s4,-492 # 8001df68 <sb>
    8000315c:	00495593          	srli	a1,s2,0x4
    80003160:	018a2783          	lw	a5,24(s4)
    80003164:	9dbd                	addw	a1,a1,a5
    80003166:	8556                	mv	a0,s5
    80003168:	9fdff0ef          	jal	80002b64 <bread>
    8000316c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000316e:	05850993          	addi	s3,a0,88
    80003172:	00f97793          	andi	a5,s2,15
    80003176:	079a                	slli	a5,a5,0x6
    80003178:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000317a:	00099783          	lh	a5,0(s3)
    8000317e:	cb9d                	beqz	a5,800031b4 <ialloc+0x88>
    brelse(bp);
    80003180:	aedff0ef          	jal	80002c6c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003184:	0905                	addi	s2,s2,1
    80003186:	00ca2703          	lw	a4,12(s4)
    8000318a:	0009079b          	sext.w	a5,s2
    8000318e:	fce7e7e3          	bltu	a5,a4,8000315c <ialloc+0x30>
    80003192:	74a2                	ld	s1,40(sp)
    80003194:	7902                	ld	s2,32(sp)
    80003196:	69e2                	ld	s3,24(sp)
    80003198:	6a42                	ld	s4,16(sp)
    8000319a:	6aa2                	ld	s5,8(sp)
    8000319c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000319e:	00004517          	auipc	a0,0x4
    800031a2:	34a50513          	addi	a0,a0,842 # 800074e8 <etext+0x4e8>
    800031a6:	b1cfd0ef          	jal	800004c2 <printf>
  return 0;
    800031aa:	4501                	li	a0,0
}
    800031ac:	70e2                	ld	ra,56(sp)
    800031ae:	7442                	ld	s0,48(sp)
    800031b0:	6121                	addi	sp,sp,64
    800031b2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800031b4:	04000613          	li	a2,64
    800031b8:	4581                	li	a1,0
    800031ba:	854e                	mv	a0,s3
    800031bc:	b0dfd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    800031c0:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800031c4:	8526                	mv	a0,s1
    800031c6:	2f1000ef          	jal	80003cb6 <log_write>
      brelse(bp);
    800031ca:	8526                	mv	a0,s1
    800031cc:	aa1ff0ef          	jal	80002c6c <brelse>
      return iget(dev, inum);
    800031d0:	0009059b          	sext.w	a1,s2
    800031d4:	8556                	mv	a0,s5
    800031d6:	de7ff0ef          	jal	80002fbc <iget>
    800031da:	74a2                	ld	s1,40(sp)
    800031dc:	7902                	ld	s2,32(sp)
    800031de:	69e2                	ld	s3,24(sp)
    800031e0:	6a42                	ld	s4,16(sp)
    800031e2:	6aa2                	ld	s5,8(sp)
    800031e4:	6b02                	ld	s6,0(sp)
    800031e6:	b7d9                	j	800031ac <ialloc+0x80>

00000000800031e8 <iupdate>:
{
    800031e8:	1101                	addi	sp,sp,-32
    800031ea:	ec06                	sd	ra,24(sp)
    800031ec:	e822                	sd	s0,16(sp)
    800031ee:	e426                	sd	s1,8(sp)
    800031f0:	e04a                	sd	s2,0(sp)
    800031f2:	1000                	addi	s0,sp,32
    800031f4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800031f6:	415c                	lw	a5,4(a0)
    800031f8:	0047d79b          	srliw	a5,a5,0x4
    800031fc:	0001b597          	auipc	a1,0x1b
    80003200:	d845a583          	lw	a1,-636(a1) # 8001df80 <sb+0x18>
    80003204:	9dbd                	addw	a1,a1,a5
    80003206:	4108                	lw	a0,0(a0)
    80003208:	95dff0ef          	jal	80002b64 <bread>
    8000320c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000320e:	05850793          	addi	a5,a0,88
    80003212:	40d8                	lw	a4,4(s1)
    80003214:	8b3d                	andi	a4,a4,15
    80003216:	071a                	slli	a4,a4,0x6
    80003218:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000321a:	04449703          	lh	a4,68(s1)
    8000321e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003222:	04649703          	lh	a4,70(s1)
    80003226:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000322a:	04849703          	lh	a4,72(s1)
    8000322e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003232:	04a49703          	lh	a4,74(s1)
    80003236:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000323a:	44f8                	lw	a4,76(s1)
    8000323c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000323e:	03400613          	li	a2,52
    80003242:	05048593          	addi	a1,s1,80
    80003246:	00c78513          	addi	a0,a5,12
    8000324a:	adbfd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    8000324e:	854a                	mv	a0,s2
    80003250:	267000ef          	jal	80003cb6 <log_write>
  brelse(bp);
    80003254:	854a                	mv	a0,s2
    80003256:	a17ff0ef          	jal	80002c6c <brelse>
}
    8000325a:	60e2                	ld	ra,24(sp)
    8000325c:	6442                	ld	s0,16(sp)
    8000325e:	64a2                	ld	s1,8(sp)
    80003260:	6902                	ld	s2,0(sp)
    80003262:	6105                	addi	sp,sp,32
    80003264:	8082                	ret

0000000080003266 <idup>:
{
    80003266:	1101                	addi	sp,sp,-32
    80003268:	ec06                	sd	ra,24(sp)
    8000326a:	e822                	sd	s0,16(sp)
    8000326c:	e426                	sd	s1,8(sp)
    8000326e:	1000                	addi	s0,sp,32
    80003270:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003272:	0001b517          	auipc	a0,0x1b
    80003276:	d1650513          	addi	a0,a0,-746 # 8001df88 <itable>
    8000327a:	97bfd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    8000327e:	449c                	lw	a5,8(s1)
    80003280:	2785                	addiw	a5,a5,1
    80003282:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003284:	0001b517          	auipc	a0,0x1b
    80003288:	d0450513          	addi	a0,a0,-764 # 8001df88 <itable>
    8000328c:	a01fd0ef          	jal	80000c8c <release>
}
    80003290:	8526                	mv	a0,s1
    80003292:	60e2                	ld	ra,24(sp)
    80003294:	6442                	ld	s0,16(sp)
    80003296:	64a2                	ld	s1,8(sp)
    80003298:	6105                	addi	sp,sp,32
    8000329a:	8082                	ret

000000008000329c <ilock>:
{
    8000329c:	1101                	addi	sp,sp,-32
    8000329e:	ec06                	sd	ra,24(sp)
    800032a0:	e822                	sd	s0,16(sp)
    800032a2:	e426                	sd	s1,8(sp)
    800032a4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800032a6:	cd19                	beqz	a0,800032c4 <ilock+0x28>
    800032a8:	84aa                	mv	s1,a0
    800032aa:	451c                	lw	a5,8(a0)
    800032ac:	00f05c63          	blez	a5,800032c4 <ilock+0x28>
  acquiresleep(&ip->lock);
    800032b0:	0541                	addi	a0,a0,16
    800032b2:	30b000ef          	jal	80003dbc <acquiresleep>
  if(ip->valid == 0){
    800032b6:	40bc                	lw	a5,64(s1)
    800032b8:	cf89                	beqz	a5,800032d2 <ilock+0x36>
}
    800032ba:	60e2                	ld	ra,24(sp)
    800032bc:	6442                	ld	s0,16(sp)
    800032be:	64a2                	ld	s1,8(sp)
    800032c0:	6105                	addi	sp,sp,32
    800032c2:	8082                	ret
    800032c4:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800032c6:	00004517          	auipc	a0,0x4
    800032ca:	23a50513          	addi	a0,a0,570 # 80007500 <etext+0x500>
    800032ce:	cc6fd0ef          	jal	80000794 <panic>
    800032d2:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032d4:	40dc                	lw	a5,4(s1)
    800032d6:	0047d79b          	srliw	a5,a5,0x4
    800032da:	0001b597          	auipc	a1,0x1b
    800032de:	ca65a583          	lw	a1,-858(a1) # 8001df80 <sb+0x18>
    800032e2:	9dbd                	addw	a1,a1,a5
    800032e4:	4088                	lw	a0,0(s1)
    800032e6:	87fff0ef          	jal	80002b64 <bread>
    800032ea:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800032ec:	05850593          	addi	a1,a0,88
    800032f0:	40dc                	lw	a5,4(s1)
    800032f2:	8bbd                	andi	a5,a5,15
    800032f4:	079a                	slli	a5,a5,0x6
    800032f6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800032f8:	00059783          	lh	a5,0(a1)
    800032fc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003300:	00259783          	lh	a5,2(a1)
    80003304:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003308:	00459783          	lh	a5,4(a1)
    8000330c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003310:	00659783          	lh	a5,6(a1)
    80003314:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003318:	459c                	lw	a5,8(a1)
    8000331a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000331c:	03400613          	li	a2,52
    80003320:	05b1                	addi	a1,a1,12
    80003322:	05048513          	addi	a0,s1,80
    80003326:	9fffd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    8000332a:	854a                	mv	a0,s2
    8000332c:	941ff0ef          	jal	80002c6c <brelse>
    ip->valid = 1;
    80003330:	4785                	li	a5,1
    80003332:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003334:	04449783          	lh	a5,68(s1)
    80003338:	c399                	beqz	a5,8000333e <ilock+0xa2>
    8000333a:	6902                	ld	s2,0(sp)
    8000333c:	bfbd                	j	800032ba <ilock+0x1e>
      panic("ilock: no type");
    8000333e:	00004517          	auipc	a0,0x4
    80003342:	1ca50513          	addi	a0,a0,458 # 80007508 <etext+0x508>
    80003346:	c4efd0ef          	jal	80000794 <panic>

000000008000334a <iunlock>:
{
    8000334a:	1101                	addi	sp,sp,-32
    8000334c:	ec06                	sd	ra,24(sp)
    8000334e:	e822                	sd	s0,16(sp)
    80003350:	e426                	sd	s1,8(sp)
    80003352:	e04a                	sd	s2,0(sp)
    80003354:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003356:	c505                	beqz	a0,8000337e <iunlock+0x34>
    80003358:	84aa                	mv	s1,a0
    8000335a:	01050913          	addi	s2,a0,16
    8000335e:	854a                	mv	a0,s2
    80003360:	2db000ef          	jal	80003e3a <holdingsleep>
    80003364:	cd09                	beqz	a0,8000337e <iunlock+0x34>
    80003366:	449c                	lw	a5,8(s1)
    80003368:	00f05b63          	blez	a5,8000337e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000336c:	854a                	mv	a0,s2
    8000336e:	295000ef          	jal	80003e02 <releasesleep>
}
    80003372:	60e2                	ld	ra,24(sp)
    80003374:	6442                	ld	s0,16(sp)
    80003376:	64a2                	ld	s1,8(sp)
    80003378:	6902                	ld	s2,0(sp)
    8000337a:	6105                	addi	sp,sp,32
    8000337c:	8082                	ret
    panic("iunlock");
    8000337e:	00004517          	auipc	a0,0x4
    80003382:	19a50513          	addi	a0,a0,410 # 80007518 <etext+0x518>
    80003386:	c0efd0ef          	jal	80000794 <panic>

000000008000338a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000338a:	7179                	addi	sp,sp,-48
    8000338c:	f406                	sd	ra,40(sp)
    8000338e:	f022                	sd	s0,32(sp)
    80003390:	ec26                	sd	s1,24(sp)
    80003392:	e84a                	sd	s2,16(sp)
    80003394:	e44e                	sd	s3,8(sp)
    80003396:	1800                	addi	s0,sp,48
    80003398:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000339a:	05050493          	addi	s1,a0,80
    8000339e:	08050913          	addi	s2,a0,128
    800033a2:	a021                	j	800033aa <itrunc+0x20>
    800033a4:	0491                	addi	s1,s1,4
    800033a6:	01248b63          	beq	s1,s2,800033bc <itrunc+0x32>
    if(ip->addrs[i]){
    800033aa:	408c                	lw	a1,0(s1)
    800033ac:	dde5                	beqz	a1,800033a4 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800033ae:	0009a503          	lw	a0,0(s3)
    800033b2:	9abff0ef          	jal	80002d5c <bfree>
      ip->addrs[i] = 0;
    800033b6:	0004a023          	sw	zero,0(s1)
    800033ba:	b7ed                	j	800033a4 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800033bc:	0809a583          	lw	a1,128(s3)
    800033c0:	ed89                	bnez	a1,800033da <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800033c2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800033c6:	854e                	mv	a0,s3
    800033c8:	e21ff0ef          	jal	800031e8 <iupdate>
}
    800033cc:	70a2                	ld	ra,40(sp)
    800033ce:	7402                	ld	s0,32(sp)
    800033d0:	64e2                	ld	s1,24(sp)
    800033d2:	6942                	ld	s2,16(sp)
    800033d4:	69a2                	ld	s3,8(sp)
    800033d6:	6145                	addi	sp,sp,48
    800033d8:	8082                	ret
    800033da:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800033dc:	0009a503          	lw	a0,0(s3)
    800033e0:	f84ff0ef          	jal	80002b64 <bread>
    800033e4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800033e6:	05850493          	addi	s1,a0,88
    800033ea:	45850913          	addi	s2,a0,1112
    800033ee:	a021                	j	800033f6 <itrunc+0x6c>
    800033f0:	0491                	addi	s1,s1,4
    800033f2:	01248963          	beq	s1,s2,80003404 <itrunc+0x7a>
      if(a[j])
    800033f6:	408c                	lw	a1,0(s1)
    800033f8:	dde5                	beqz	a1,800033f0 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800033fa:	0009a503          	lw	a0,0(s3)
    800033fe:	95fff0ef          	jal	80002d5c <bfree>
    80003402:	b7fd                	j	800033f0 <itrunc+0x66>
    brelse(bp);
    80003404:	8552                	mv	a0,s4
    80003406:	867ff0ef          	jal	80002c6c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000340a:	0809a583          	lw	a1,128(s3)
    8000340e:	0009a503          	lw	a0,0(s3)
    80003412:	94bff0ef          	jal	80002d5c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003416:	0809a023          	sw	zero,128(s3)
    8000341a:	6a02                	ld	s4,0(sp)
    8000341c:	b75d                	j	800033c2 <itrunc+0x38>

000000008000341e <iput>:
{
    8000341e:	1101                	addi	sp,sp,-32
    80003420:	ec06                	sd	ra,24(sp)
    80003422:	e822                	sd	s0,16(sp)
    80003424:	e426                	sd	s1,8(sp)
    80003426:	1000                	addi	s0,sp,32
    80003428:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000342a:	0001b517          	auipc	a0,0x1b
    8000342e:	b5e50513          	addi	a0,a0,-1186 # 8001df88 <itable>
    80003432:	fc2fd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003436:	4498                	lw	a4,8(s1)
    80003438:	4785                	li	a5,1
    8000343a:	02f70063          	beq	a4,a5,8000345a <iput+0x3c>
  ip->ref--;
    8000343e:	449c                	lw	a5,8(s1)
    80003440:	37fd                	addiw	a5,a5,-1
    80003442:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003444:	0001b517          	auipc	a0,0x1b
    80003448:	b4450513          	addi	a0,a0,-1212 # 8001df88 <itable>
    8000344c:	841fd0ef          	jal	80000c8c <release>
}
    80003450:	60e2                	ld	ra,24(sp)
    80003452:	6442                	ld	s0,16(sp)
    80003454:	64a2                	ld	s1,8(sp)
    80003456:	6105                	addi	sp,sp,32
    80003458:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000345a:	40bc                	lw	a5,64(s1)
    8000345c:	d3ed                	beqz	a5,8000343e <iput+0x20>
    8000345e:	04a49783          	lh	a5,74(s1)
    80003462:	fff1                	bnez	a5,8000343e <iput+0x20>
    80003464:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003466:	01048913          	addi	s2,s1,16
    8000346a:	854a                	mv	a0,s2
    8000346c:	151000ef          	jal	80003dbc <acquiresleep>
    release(&itable.lock);
    80003470:	0001b517          	auipc	a0,0x1b
    80003474:	b1850513          	addi	a0,a0,-1256 # 8001df88 <itable>
    80003478:	815fd0ef          	jal	80000c8c <release>
    itrunc(ip);
    8000347c:	8526                	mv	a0,s1
    8000347e:	f0dff0ef          	jal	8000338a <itrunc>
    ip->type = 0;
    80003482:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003486:	8526                	mv	a0,s1
    80003488:	d61ff0ef          	jal	800031e8 <iupdate>
    ip->valid = 0;
    8000348c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003490:	854a                	mv	a0,s2
    80003492:	171000ef          	jal	80003e02 <releasesleep>
    acquire(&itable.lock);
    80003496:	0001b517          	auipc	a0,0x1b
    8000349a:	af250513          	addi	a0,a0,-1294 # 8001df88 <itable>
    8000349e:	f56fd0ef          	jal	80000bf4 <acquire>
    800034a2:	6902                	ld	s2,0(sp)
    800034a4:	bf69                	j	8000343e <iput+0x20>

00000000800034a6 <iunlockput>:
{
    800034a6:	1101                	addi	sp,sp,-32
    800034a8:	ec06                	sd	ra,24(sp)
    800034aa:	e822                	sd	s0,16(sp)
    800034ac:	e426                	sd	s1,8(sp)
    800034ae:	1000                	addi	s0,sp,32
    800034b0:	84aa                	mv	s1,a0
  iunlock(ip);
    800034b2:	e99ff0ef          	jal	8000334a <iunlock>
  iput(ip);
    800034b6:	8526                	mv	a0,s1
    800034b8:	f67ff0ef          	jal	8000341e <iput>
}
    800034bc:	60e2                	ld	ra,24(sp)
    800034be:	6442                	ld	s0,16(sp)
    800034c0:	64a2                	ld	s1,8(sp)
    800034c2:	6105                	addi	sp,sp,32
    800034c4:	8082                	ret

00000000800034c6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800034c6:	1141                	addi	sp,sp,-16
    800034c8:	e422                	sd	s0,8(sp)
    800034ca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800034cc:	411c                	lw	a5,0(a0)
    800034ce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800034d0:	415c                	lw	a5,4(a0)
    800034d2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800034d4:	04451783          	lh	a5,68(a0)
    800034d8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800034dc:	04a51783          	lh	a5,74(a0)
    800034e0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800034e4:	04c56783          	lwu	a5,76(a0)
    800034e8:	e99c                	sd	a5,16(a1)
}
    800034ea:	6422                	ld	s0,8(sp)
    800034ec:	0141                	addi	sp,sp,16
    800034ee:	8082                	ret

00000000800034f0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800034f0:	457c                	lw	a5,76(a0)
    800034f2:	0ed7eb63          	bltu	a5,a3,800035e8 <readi+0xf8>
{
    800034f6:	7159                	addi	sp,sp,-112
    800034f8:	f486                	sd	ra,104(sp)
    800034fa:	f0a2                	sd	s0,96(sp)
    800034fc:	eca6                	sd	s1,88(sp)
    800034fe:	e0d2                	sd	s4,64(sp)
    80003500:	fc56                	sd	s5,56(sp)
    80003502:	f85a                	sd	s6,48(sp)
    80003504:	f45e                	sd	s7,40(sp)
    80003506:	1880                	addi	s0,sp,112
    80003508:	8b2a                	mv	s6,a0
    8000350a:	8bae                	mv	s7,a1
    8000350c:	8a32                	mv	s4,a2
    8000350e:	84b6                	mv	s1,a3
    80003510:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003512:	9f35                	addw	a4,a4,a3
    return 0;
    80003514:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003516:	0cd76063          	bltu	a4,a3,800035d6 <readi+0xe6>
    8000351a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000351c:	00e7f463          	bgeu	a5,a4,80003524 <readi+0x34>
    n = ip->size - off;
    80003520:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003524:	080a8f63          	beqz	s5,800035c2 <readi+0xd2>
    80003528:	e8ca                	sd	s2,80(sp)
    8000352a:	f062                	sd	s8,32(sp)
    8000352c:	ec66                	sd	s9,24(sp)
    8000352e:	e86a                	sd	s10,16(sp)
    80003530:	e46e                	sd	s11,8(sp)
    80003532:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003534:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003538:	5c7d                	li	s8,-1
    8000353a:	a80d                	j	8000356c <readi+0x7c>
    8000353c:	020d1d93          	slli	s11,s10,0x20
    80003540:	020ddd93          	srli	s11,s11,0x20
    80003544:	05890613          	addi	a2,s2,88
    80003548:	86ee                	mv	a3,s11
    8000354a:	963a                	add	a2,a2,a4
    8000354c:	85d2                	mv	a1,s4
    8000354e:	855e                	mv	a0,s7
    80003550:	d45fe0ef          	jal	80002294 <either_copyout>
    80003554:	05850763          	beq	a0,s8,800035a2 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003558:	854a                	mv	a0,s2
    8000355a:	f12ff0ef          	jal	80002c6c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000355e:	013d09bb          	addw	s3,s10,s3
    80003562:	009d04bb          	addw	s1,s10,s1
    80003566:	9a6e                	add	s4,s4,s11
    80003568:	0559f763          	bgeu	s3,s5,800035b6 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    8000356c:	00a4d59b          	srliw	a1,s1,0xa
    80003570:	855a                	mv	a0,s6
    80003572:	977ff0ef          	jal	80002ee8 <bmap>
    80003576:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000357a:	c5b1                	beqz	a1,800035c6 <readi+0xd6>
    bp = bread(ip->dev, addr);
    8000357c:	000b2503          	lw	a0,0(s6)
    80003580:	de4ff0ef          	jal	80002b64 <bread>
    80003584:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003586:	3ff4f713          	andi	a4,s1,1023
    8000358a:	40ec87bb          	subw	a5,s9,a4
    8000358e:	413a86bb          	subw	a3,s5,s3
    80003592:	8d3e                	mv	s10,a5
    80003594:	2781                	sext.w	a5,a5
    80003596:	0006861b          	sext.w	a2,a3
    8000359a:	faf671e3          	bgeu	a2,a5,8000353c <readi+0x4c>
    8000359e:	8d36                	mv	s10,a3
    800035a0:	bf71                	j	8000353c <readi+0x4c>
      brelse(bp);
    800035a2:	854a                	mv	a0,s2
    800035a4:	ec8ff0ef          	jal	80002c6c <brelse>
      tot = -1;
    800035a8:	59fd                	li	s3,-1
      break;
    800035aa:	6946                	ld	s2,80(sp)
    800035ac:	7c02                	ld	s8,32(sp)
    800035ae:	6ce2                	ld	s9,24(sp)
    800035b0:	6d42                	ld	s10,16(sp)
    800035b2:	6da2                	ld	s11,8(sp)
    800035b4:	a831                	j	800035d0 <readi+0xe0>
    800035b6:	6946                	ld	s2,80(sp)
    800035b8:	7c02                	ld	s8,32(sp)
    800035ba:	6ce2                	ld	s9,24(sp)
    800035bc:	6d42                	ld	s10,16(sp)
    800035be:	6da2                	ld	s11,8(sp)
    800035c0:	a801                	j	800035d0 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035c2:	89d6                	mv	s3,s5
    800035c4:	a031                	j	800035d0 <readi+0xe0>
    800035c6:	6946                	ld	s2,80(sp)
    800035c8:	7c02                	ld	s8,32(sp)
    800035ca:	6ce2                	ld	s9,24(sp)
    800035cc:	6d42                	ld	s10,16(sp)
    800035ce:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800035d0:	0009851b          	sext.w	a0,s3
    800035d4:	69a6                	ld	s3,72(sp)
}
    800035d6:	70a6                	ld	ra,104(sp)
    800035d8:	7406                	ld	s0,96(sp)
    800035da:	64e6                	ld	s1,88(sp)
    800035dc:	6a06                	ld	s4,64(sp)
    800035de:	7ae2                	ld	s5,56(sp)
    800035e0:	7b42                	ld	s6,48(sp)
    800035e2:	7ba2                	ld	s7,40(sp)
    800035e4:	6165                	addi	sp,sp,112
    800035e6:	8082                	ret
    return 0;
    800035e8:	4501                	li	a0,0
}
    800035ea:	8082                	ret

00000000800035ec <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800035ec:	457c                	lw	a5,76(a0)
    800035ee:	10d7e063          	bltu	a5,a3,800036ee <writei+0x102>
{
    800035f2:	7159                	addi	sp,sp,-112
    800035f4:	f486                	sd	ra,104(sp)
    800035f6:	f0a2                	sd	s0,96(sp)
    800035f8:	e8ca                	sd	s2,80(sp)
    800035fa:	e0d2                	sd	s4,64(sp)
    800035fc:	fc56                	sd	s5,56(sp)
    800035fe:	f85a                	sd	s6,48(sp)
    80003600:	f45e                	sd	s7,40(sp)
    80003602:	1880                	addi	s0,sp,112
    80003604:	8aaa                	mv	s5,a0
    80003606:	8bae                	mv	s7,a1
    80003608:	8a32                	mv	s4,a2
    8000360a:	8936                	mv	s2,a3
    8000360c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000360e:	00e687bb          	addw	a5,a3,a4
    80003612:	0ed7e063          	bltu	a5,a3,800036f2 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003616:	00043737          	lui	a4,0x43
    8000361a:	0cf76e63          	bltu	a4,a5,800036f6 <writei+0x10a>
    8000361e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003620:	0a0b0f63          	beqz	s6,800036de <writei+0xf2>
    80003624:	eca6                	sd	s1,88(sp)
    80003626:	f062                	sd	s8,32(sp)
    80003628:	ec66                	sd	s9,24(sp)
    8000362a:	e86a                	sd	s10,16(sp)
    8000362c:	e46e                	sd	s11,8(sp)
    8000362e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003630:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003634:	5c7d                	li	s8,-1
    80003636:	a825                	j	8000366e <writei+0x82>
    80003638:	020d1d93          	slli	s11,s10,0x20
    8000363c:	020ddd93          	srli	s11,s11,0x20
    80003640:	05848513          	addi	a0,s1,88
    80003644:	86ee                	mv	a3,s11
    80003646:	8652                	mv	a2,s4
    80003648:	85de                	mv	a1,s7
    8000364a:	953a                	add	a0,a0,a4
    8000364c:	c93fe0ef          	jal	800022de <either_copyin>
    80003650:	05850a63          	beq	a0,s8,800036a4 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003654:	8526                	mv	a0,s1
    80003656:	660000ef          	jal	80003cb6 <log_write>
    brelse(bp);
    8000365a:	8526                	mv	a0,s1
    8000365c:	e10ff0ef          	jal	80002c6c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003660:	013d09bb          	addw	s3,s10,s3
    80003664:	012d093b          	addw	s2,s10,s2
    80003668:	9a6e                	add	s4,s4,s11
    8000366a:	0569f063          	bgeu	s3,s6,800036aa <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000366e:	00a9559b          	srliw	a1,s2,0xa
    80003672:	8556                	mv	a0,s5
    80003674:	875ff0ef          	jal	80002ee8 <bmap>
    80003678:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000367c:	c59d                	beqz	a1,800036aa <writei+0xbe>
    bp = bread(ip->dev, addr);
    8000367e:	000aa503          	lw	a0,0(s5)
    80003682:	ce2ff0ef          	jal	80002b64 <bread>
    80003686:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003688:	3ff97713          	andi	a4,s2,1023
    8000368c:	40ec87bb          	subw	a5,s9,a4
    80003690:	413b06bb          	subw	a3,s6,s3
    80003694:	8d3e                	mv	s10,a5
    80003696:	2781                	sext.w	a5,a5
    80003698:	0006861b          	sext.w	a2,a3
    8000369c:	f8f67ee3          	bgeu	a2,a5,80003638 <writei+0x4c>
    800036a0:	8d36                	mv	s10,a3
    800036a2:	bf59                	j	80003638 <writei+0x4c>
      brelse(bp);
    800036a4:	8526                	mv	a0,s1
    800036a6:	dc6ff0ef          	jal	80002c6c <brelse>
  }

  if(off > ip->size)
    800036aa:	04caa783          	lw	a5,76(s5)
    800036ae:	0327fa63          	bgeu	a5,s2,800036e2 <writei+0xf6>
    ip->size = off;
    800036b2:	052aa623          	sw	s2,76(s5)
    800036b6:	64e6                	ld	s1,88(sp)
    800036b8:	7c02                	ld	s8,32(sp)
    800036ba:	6ce2                	ld	s9,24(sp)
    800036bc:	6d42                	ld	s10,16(sp)
    800036be:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800036c0:	8556                	mv	a0,s5
    800036c2:	b27ff0ef          	jal	800031e8 <iupdate>

  return tot;
    800036c6:	0009851b          	sext.w	a0,s3
    800036ca:	69a6                	ld	s3,72(sp)
}
    800036cc:	70a6                	ld	ra,104(sp)
    800036ce:	7406                	ld	s0,96(sp)
    800036d0:	6946                	ld	s2,80(sp)
    800036d2:	6a06                	ld	s4,64(sp)
    800036d4:	7ae2                	ld	s5,56(sp)
    800036d6:	7b42                	ld	s6,48(sp)
    800036d8:	7ba2                	ld	s7,40(sp)
    800036da:	6165                	addi	sp,sp,112
    800036dc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036de:	89da                	mv	s3,s6
    800036e0:	b7c5                	j	800036c0 <writei+0xd4>
    800036e2:	64e6                	ld	s1,88(sp)
    800036e4:	7c02                	ld	s8,32(sp)
    800036e6:	6ce2                	ld	s9,24(sp)
    800036e8:	6d42                	ld	s10,16(sp)
    800036ea:	6da2                	ld	s11,8(sp)
    800036ec:	bfd1                	j	800036c0 <writei+0xd4>
    return -1;
    800036ee:	557d                	li	a0,-1
}
    800036f0:	8082                	ret
    return -1;
    800036f2:	557d                	li	a0,-1
    800036f4:	bfe1                	j	800036cc <writei+0xe0>
    return -1;
    800036f6:	557d                	li	a0,-1
    800036f8:	bfd1                	j	800036cc <writei+0xe0>

00000000800036fa <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800036fa:	1141                	addi	sp,sp,-16
    800036fc:	e406                	sd	ra,8(sp)
    800036fe:	e022                	sd	s0,0(sp)
    80003700:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003702:	4639                	li	a2,14
    80003704:	e90fd0ef          	jal	80000d94 <strncmp>
}
    80003708:	60a2                	ld	ra,8(sp)
    8000370a:	6402                	ld	s0,0(sp)
    8000370c:	0141                	addi	sp,sp,16
    8000370e:	8082                	ret

0000000080003710 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003710:	7139                	addi	sp,sp,-64
    80003712:	fc06                	sd	ra,56(sp)
    80003714:	f822                	sd	s0,48(sp)
    80003716:	f426                	sd	s1,40(sp)
    80003718:	f04a                	sd	s2,32(sp)
    8000371a:	ec4e                	sd	s3,24(sp)
    8000371c:	e852                	sd	s4,16(sp)
    8000371e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003720:	04451703          	lh	a4,68(a0)
    80003724:	4785                	li	a5,1
    80003726:	00f71a63          	bne	a4,a5,8000373a <dirlookup+0x2a>
    8000372a:	892a                	mv	s2,a0
    8000372c:	89ae                	mv	s3,a1
    8000372e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003730:	457c                	lw	a5,76(a0)
    80003732:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003734:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003736:	e39d                	bnez	a5,8000375c <dirlookup+0x4c>
    80003738:	a095                	j	8000379c <dirlookup+0x8c>
    panic("dirlookup not DIR");
    8000373a:	00004517          	auipc	a0,0x4
    8000373e:	de650513          	addi	a0,a0,-538 # 80007520 <etext+0x520>
    80003742:	852fd0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003746:	00004517          	auipc	a0,0x4
    8000374a:	df250513          	addi	a0,a0,-526 # 80007538 <etext+0x538>
    8000374e:	846fd0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003752:	24c1                	addiw	s1,s1,16
    80003754:	04c92783          	lw	a5,76(s2)
    80003758:	04f4f163          	bgeu	s1,a5,8000379a <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000375c:	4741                	li	a4,16
    8000375e:	86a6                	mv	a3,s1
    80003760:	fc040613          	addi	a2,s0,-64
    80003764:	4581                	li	a1,0
    80003766:	854a                	mv	a0,s2
    80003768:	d89ff0ef          	jal	800034f0 <readi>
    8000376c:	47c1                	li	a5,16
    8000376e:	fcf51ce3          	bne	a0,a5,80003746 <dirlookup+0x36>
    if(de.inum == 0)
    80003772:	fc045783          	lhu	a5,-64(s0)
    80003776:	dff1                	beqz	a5,80003752 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003778:	fc240593          	addi	a1,s0,-62
    8000377c:	854e                	mv	a0,s3
    8000377e:	f7dff0ef          	jal	800036fa <namecmp>
    80003782:	f961                	bnez	a0,80003752 <dirlookup+0x42>
      if(poff)
    80003784:	000a0463          	beqz	s4,8000378c <dirlookup+0x7c>
        *poff = off;
    80003788:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000378c:	fc045583          	lhu	a1,-64(s0)
    80003790:	00092503          	lw	a0,0(s2)
    80003794:	829ff0ef          	jal	80002fbc <iget>
    80003798:	a011                	j	8000379c <dirlookup+0x8c>
  return 0;
    8000379a:	4501                	li	a0,0
}
    8000379c:	70e2                	ld	ra,56(sp)
    8000379e:	7442                	ld	s0,48(sp)
    800037a0:	74a2                	ld	s1,40(sp)
    800037a2:	7902                	ld	s2,32(sp)
    800037a4:	69e2                	ld	s3,24(sp)
    800037a6:	6a42                	ld	s4,16(sp)
    800037a8:	6121                	addi	sp,sp,64
    800037aa:	8082                	ret

00000000800037ac <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800037ac:	711d                	addi	sp,sp,-96
    800037ae:	ec86                	sd	ra,88(sp)
    800037b0:	e8a2                	sd	s0,80(sp)
    800037b2:	e4a6                	sd	s1,72(sp)
    800037b4:	e0ca                	sd	s2,64(sp)
    800037b6:	fc4e                	sd	s3,56(sp)
    800037b8:	f852                	sd	s4,48(sp)
    800037ba:	f456                	sd	s5,40(sp)
    800037bc:	f05a                	sd	s6,32(sp)
    800037be:	ec5e                	sd	s7,24(sp)
    800037c0:	e862                	sd	s8,16(sp)
    800037c2:	e466                	sd	s9,8(sp)
    800037c4:	1080                	addi	s0,sp,96
    800037c6:	84aa                	mv	s1,a0
    800037c8:	8b2e                	mv	s6,a1
    800037ca:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800037cc:	00054703          	lbu	a4,0(a0)
    800037d0:	02f00793          	li	a5,47
    800037d4:	00f70e63          	beq	a4,a5,800037f0 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800037d8:	908fe0ef          	jal	800018e0 <myproc>
    800037dc:	15053503          	ld	a0,336(a0)
    800037e0:	a87ff0ef          	jal	80003266 <idup>
    800037e4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800037e6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800037ea:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800037ec:	4b85                	li	s7,1
    800037ee:	a871                	j	8000388a <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    800037f0:	4585                	li	a1,1
    800037f2:	4505                	li	a0,1
    800037f4:	fc8ff0ef          	jal	80002fbc <iget>
    800037f8:	8a2a                	mv	s4,a0
    800037fa:	b7f5                	j	800037e6 <namex+0x3a>
      iunlockput(ip);
    800037fc:	8552                	mv	a0,s4
    800037fe:	ca9ff0ef          	jal	800034a6 <iunlockput>
      return 0;
    80003802:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003804:	8552                	mv	a0,s4
    80003806:	60e6                	ld	ra,88(sp)
    80003808:	6446                	ld	s0,80(sp)
    8000380a:	64a6                	ld	s1,72(sp)
    8000380c:	6906                	ld	s2,64(sp)
    8000380e:	79e2                	ld	s3,56(sp)
    80003810:	7a42                	ld	s4,48(sp)
    80003812:	7aa2                	ld	s5,40(sp)
    80003814:	7b02                	ld	s6,32(sp)
    80003816:	6be2                	ld	s7,24(sp)
    80003818:	6c42                	ld	s8,16(sp)
    8000381a:	6ca2                	ld	s9,8(sp)
    8000381c:	6125                	addi	sp,sp,96
    8000381e:	8082                	ret
      iunlock(ip);
    80003820:	8552                	mv	a0,s4
    80003822:	b29ff0ef          	jal	8000334a <iunlock>
      return ip;
    80003826:	bff9                	j	80003804 <namex+0x58>
      iunlockput(ip);
    80003828:	8552                	mv	a0,s4
    8000382a:	c7dff0ef          	jal	800034a6 <iunlockput>
      return 0;
    8000382e:	8a4e                	mv	s4,s3
    80003830:	bfd1                	j	80003804 <namex+0x58>
  len = path - s;
    80003832:	40998633          	sub	a2,s3,s1
    80003836:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000383a:	099c5063          	bge	s8,s9,800038ba <namex+0x10e>
    memmove(name, s, DIRSIZ);
    8000383e:	4639                	li	a2,14
    80003840:	85a6                	mv	a1,s1
    80003842:	8556                	mv	a0,s5
    80003844:	ce0fd0ef          	jal	80000d24 <memmove>
    80003848:	84ce                	mv	s1,s3
  while(*path == '/')
    8000384a:	0004c783          	lbu	a5,0(s1)
    8000384e:	01279763          	bne	a5,s2,8000385c <namex+0xb0>
    path++;
    80003852:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003854:	0004c783          	lbu	a5,0(s1)
    80003858:	ff278de3          	beq	a5,s2,80003852 <namex+0xa6>
    ilock(ip);
    8000385c:	8552                	mv	a0,s4
    8000385e:	a3fff0ef          	jal	8000329c <ilock>
    if(ip->type != T_DIR){
    80003862:	044a1783          	lh	a5,68(s4)
    80003866:	f9779be3          	bne	a5,s7,800037fc <namex+0x50>
    if(nameiparent && *path == '\0'){
    8000386a:	000b0563          	beqz	s6,80003874 <namex+0xc8>
    8000386e:	0004c783          	lbu	a5,0(s1)
    80003872:	d7dd                	beqz	a5,80003820 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003874:	4601                	li	a2,0
    80003876:	85d6                	mv	a1,s5
    80003878:	8552                	mv	a0,s4
    8000387a:	e97ff0ef          	jal	80003710 <dirlookup>
    8000387e:	89aa                	mv	s3,a0
    80003880:	d545                	beqz	a0,80003828 <namex+0x7c>
    iunlockput(ip);
    80003882:	8552                	mv	a0,s4
    80003884:	c23ff0ef          	jal	800034a6 <iunlockput>
    ip = next;
    80003888:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000388a:	0004c783          	lbu	a5,0(s1)
    8000388e:	01279763          	bne	a5,s2,8000389c <namex+0xf0>
    path++;
    80003892:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003894:	0004c783          	lbu	a5,0(s1)
    80003898:	ff278de3          	beq	a5,s2,80003892 <namex+0xe6>
  if(*path == 0)
    8000389c:	cb8d                	beqz	a5,800038ce <namex+0x122>
  while(*path != '/' && *path != 0)
    8000389e:	0004c783          	lbu	a5,0(s1)
    800038a2:	89a6                	mv	s3,s1
  len = path - s;
    800038a4:	4c81                	li	s9,0
    800038a6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800038a8:	01278963          	beq	a5,s2,800038ba <namex+0x10e>
    800038ac:	d3d9                	beqz	a5,80003832 <namex+0x86>
    path++;
    800038ae:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800038b0:	0009c783          	lbu	a5,0(s3)
    800038b4:	ff279ce3          	bne	a5,s2,800038ac <namex+0x100>
    800038b8:	bfad                	j	80003832 <namex+0x86>
    memmove(name, s, len);
    800038ba:	2601                	sext.w	a2,a2
    800038bc:	85a6                	mv	a1,s1
    800038be:	8556                	mv	a0,s5
    800038c0:	c64fd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    800038c4:	9cd6                	add	s9,s9,s5
    800038c6:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800038ca:	84ce                	mv	s1,s3
    800038cc:	bfbd                	j	8000384a <namex+0x9e>
  if(nameiparent){
    800038ce:	f20b0be3          	beqz	s6,80003804 <namex+0x58>
    iput(ip);
    800038d2:	8552                	mv	a0,s4
    800038d4:	b4bff0ef          	jal	8000341e <iput>
    return 0;
    800038d8:	4a01                	li	s4,0
    800038da:	b72d                	j	80003804 <namex+0x58>

00000000800038dc <dirlink>:
{
    800038dc:	7139                	addi	sp,sp,-64
    800038de:	fc06                	sd	ra,56(sp)
    800038e0:	f822                	sd	s0,48(sp)
    800038e2:	f04a                	sd	s2,32(sp)
    800038e4:	ec4e                	sd	s3,24(sp)
    800038e6:	e852                	sd	s4,16(sp)
    800038e8:	0080                	addi	s0,sp,64
    800038ea:	892a                	mv	s2,a0
    800038ec:	8a2e                	mv	s4,a1
    800038ee:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800038f0:	4601                	li	a2,0
    800038f2:	e1fff0ef          	jal	80003710 <dirlookup>
    800038f6:	e535                	bnez	a0,80003962 <dirlink+0x86>
    800038f8:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038fa:	04c92483          	lw	s1,76(s2)
    800038fe:	c48d                	beqz	s1,80003928 <dirlink+0x4c>
    80003900:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003902:	4741                	li	a4,16
    80003904:	86a6                	mv	a3,s1
    80003906:	fc040613          	addi	a2,s0,-64
    8000390a:	4581                	li	a1,0
    8000390c:	854a                	mv	a0,s2
    8000390e:	be3ff0ef          	jal	800034f0 <readi>
    80003912:	47c1                	li	a5,16
    80003914:	04f51b63          	bne	a0,a5,8000396a <dirlink+0x8e>
    if(de.inum == 0)
    80003918:	fc045783          	lhu	a5,-64(s0)
    8000391c:	c791                	beqz	a5,80003928 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000391e:	24c1                	addiw	s1,s1,16
    80003920:	04c92783          	lw	a5,76(s2)
    80003924:	fcf4efe3          	bltu	s1,a5,80003902 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003928:	4639                	li	a2,14
    8000392a:	85d2                	mv	a1,s4
    8000392c:	fc240513          	addi	a0,s0,-62
    80003930:	c9afd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    80003934:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003938:	4741                	li	a4,16
    8000393a:	86a6                	mv	a3,s1
    8000393c:	fc040613          	addi	a2,s0,-64
    80003940:	4581                	li	a1,0
    80003942:	854a                	mv	a0,s2
    80003944:	ca9ff0ef          	jal	800035ec <writei>
    80003948:	1541                	addi	a0,a0,-16
    8000394a:	00a03533          	snez	a0,a0
    8000394e:	40a00533          	neg	a0,a0
    80003952:	74a2                	ld	s1,40(sp)
}
    80003954:	70e2                	ld	ra,56(sp)
    80003956:	7442                	ld	s0,48(sp)
    80003958:	7902                	ld	s2,32(sp)
    8000395a:	69e2                	ld	s3,24(sp)
    8000395c:	6a42                	ld	s4,16(sp)
    8000395e:	6121                	addi	sp,sp,64
    80003960:	8082                	ret
    iput(ip);
    80003962:	abdff0ef          	jal	8000341e <iput>
    return -1;
    80003966:	557d                	li	a0,-1
    80003968:	b7f5                	j	80003954 <dirlink+0x78>
      panic("dirlink read");
    8000396a:	00004517          	auipc	a0,0x4
    8000396e:	bde50513          	addi	a0,a0,-1058 # 80007548 <etext+0x548>
    80003972:	e23fc0ef          	jal	80000794 <panic>

0000000080003976 <namei>:

struct inode*
namei(char *path)
{
    80003976:	1101                	addi	sp,sp,-32
    80003978:	ec06                	sd	ra,24(sp)
    8000397a:	e822                	sd	s0,16(sp)
    8000397c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000397e:	fe040613          	addi	a2,s0,-32
    80003982:	4581                	li	a1,0
    80003984:	e29ff0ef          	jal	800037ac <namex>
}
    80003988:	60e2                	ld	ra,24(sp)
    8000398a:	6442                	ld	s0,16(sp)
    8000398c:	6105                	addi	sp,sp,32
    8000398e:	8082                	ret

0000000080003990 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003990:	1141                	addi	sp,sp,-16
    80003992:	e406                	sd	ra,8(sp)
    80003994:	e022                	sd	s0,0(sp)
    80003996:	0800                	addi	s0,sp,16
    80003998:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000399a:	4585                	li	a1,1
    8000399c:	e11ff0ef          	jal	800037ac <namex>
}
    800039a0:	60a2                	ld	ra,8(sp)
    800039a2:	6402                	ld	s0,0(sp)
    800039a4:	0141                	addi	sp,sp,16
    800039a6:	8082                	ret

00000000800039a8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800039a8:	1101                	addi	sp,sp,-32
    800039aa:	ec06                	sd	ra,24(sp)
    800039ac:	e822                	sd	s0,16(sp)
    800039ae:	e426                	sd	s1,8(sp)
    800039b0:	e04a                	sd	s2,0(sp)
    800039b2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800039b4:	0001c917          	auipc	s2,0x1c
    800039b8:	07c90913          	addi	s2,s2,124 # 8001fa30 <log>
    800039bc:	01892583          	lw	a1,24(s2)
    800039c0:	02892503          	lw	a0,40(s2)
    800039c4:	9a0ff0ef          	jal	80002b64 <bread>
    800039c8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800039ca:	02c92603          	lw	a2,44(s2)
    800039ce:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800039d0:	00c05f63          	blez	a2,800039ee <write_head+0x46>
    800039d4:	0001c717          	auipc	a4,0x1c
    800039d8:	08c70713          	addi	a4,a4,140 # 8001fa60 <log+0x30>
    800039dc:	87aa                	mv	a5,a0
    800039de:	060a                	slli	a2,a2,0x2
    800039e0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800039e2:	4314                	lw	a3,0(a4)
    800039e4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800039e6:	0711                	addi	a4,a4,4
    800039e8:	0791                	addi	a5,a5,4
    800039ea:	fec79ce3          	bne	a5,a2,800039e2 <write_head+0x3a>
  }
  bwrite(buf);
    800039ee:	8526                	mv	a0,s1
    800039f0:	a4aff0ef          	jal	80002c3a <bwrite>
  brelse(buf);
    800039f4:	8526                	mv	a0,s1
    800039f6:	a76ff0ef          	jal	80002c6c <brelse>
}
    800039fa:	60e2                	ld	ra,24(sp)
    800039fc:	6442                	ld	s0,16(sp)
    800039fe:	64a2                	ld	s1,8(sp)
    80003a00:	6902                	ld	s2,0(sp)
    80003a02:	6105                	addi	sp,sp,32
    80003a04:	8082                	ret

0000000080003a06 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a06:	0001c797          	auipc	a5,0x1c
    80003a0a:	0567a783          	lw	a5,86(a5) # 8001fa5c <log+0x2c>
    80003a0e:	08f05f63          	blez	a5,80003aac <install_trans+0xa6>
{
    80003a12:	7139                	addi	sp,sp,-64
    80003a14:	fc06                	sd	ra,56(sp)
    80003a16:	f822                	sd	s0,48(sp)
    80003a18:	f426                	sd	s1,40(sp)
    80003a1a:	f04a                	sd	s2,32(sp)
    80003a1c:	ec4e                	sd	s3,24(sp)
    80003a1e:	e852                	sd	s4,16(sp)
    80003a20:	e456                	sd	s5,8(sp)
    80003a22:	e05a                	sd	s6,0(sp)
    80003a24:	0080                	addi	s0,sp,64
    80003a26:	8b2a                	mv	s6,a0
    80003a28:	0001ca97          	auipc	s5,0x1c
    80003a2c:	038a8a93          	addi	s5,s5,56 # 8001fa60 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a30:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003a32:	0001c997          	auipc	s3,0x1c
    80003a36:	ffe98993          	addi	s3,s3,-2 # 8001fa30 <log>
    80003a3a:	a829                	j	80003a54 <install_trans+0x4e>
    brelse(lbuf);
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	a2eff0ef          	jal	80002c6c <brelse>
    brelse(dbuf);
    80003a42:	8526                	mv	a0,s1
    80003a44:	a28ff0ef          	jal	80002c6c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a48:	2a05                	addiw	s4,s4,1
    80003a4a:	0a91                	addi	s5,s5,4
    80003a4c:	02c9a783          	lw	a5,44(s3)
    80003a50:	04fa5463          	bge	s4,a5,80003a98 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003a54:	0189a583          	lw	a1,24(s3)
    80003a58:	014585bb          	addw	a1,a1,s4
    80003a5c:	2585                	addiw	a1,a1,1
    80003a5e:	0289a503          	lw	a0,40(s3)
    80003a62:	902ff0ef          	jal	80002b64 <bread>
    80003a66:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003a68:	000aa583          	lw	a1,0(s5)
    80003a6c:	0289a503          	lw	a0,40(s3)
    80003a70:	8f4ff0ef          	jal	80002b64 <bread>
    80003a74:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003a76:	40000613          	li	a2,1024
    80003a7a:	05890593          	addi	a1,s2,88
    80003a7e:	05850513          	addi	a0,a0,88
    80003a82:	aa2fd0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003a86:	8526                	mv	a0,s1
    80003a88:	9b2ff0ef          	jal	80002c3a <bwrite>
    if(recovering == 0)
    80003a8c:	fa0b18e3          	bnez	s6,80003a3c <install_trans+0x36>
      bunpin(dbuf);
    80003a90:	8526                	mv	a0,s1
    80003a92:	a96ff0ef          	jal	80002d28 <bunpin>
    80003a96:	b75d                	j	80003a3c <install_trans+0x36>
}
    80003a98:	70e2                	ld	ra,56(sp)
    80003a9a:	7442                	ld	s0,48(sp)
    80003a9c:	74a2                	ld	s1,40(sp)
    80003a9e:	7902                	ld	s2,32(sp)
    80003aa0:	69e2                	ld	s3,24(sp)
    80003aa2:	6a42                	ld	s4,16(sp)
    80003aa4:	6aa2                	ld	s5,8(sp)
    80003aa6:	6b02                	ld	s6,0(sp)
    80003aa8:	6121                	addi	sp,sp,64
    80003aaa:	8082                	ret
    80003aac:	8082                	ret

0000000080003aae <initlog>:
{
    80003aae:	7179                	addi	sp,sp,-48
    80003ab0:	f406                	sd	ra,40(sp)
    80003ab2:	f022                	sd	s0,32(sp)
    80003ab4:	ec26                	sd	s1,24(sp)
    80003ab6:	e84a                	sd	s2,16(sp)
    80003ab8:	e44e                	sd	s3,8(sp)
    80003aba:	1800                	addi	s0,sp,48
    80003abc:	892a                	mv	s2,a0
    80003abe:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003ac0:	0001c497          	auipc	s1,0x1c
    80003ac4:	f7048493          	addi	s1,s1,-144 # 8001fa30 <log>
    80003ac8:	00004597          	auipc	a1,0x4
    80003acc:	a9058593          	addi	a1,a1,-1392 # 80007558 <etext+0x558>
    80003ad0:	8526                	mv	a0,s1
    80003ad2:	8a2fd0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003ad6:	0149a583          	lw	a1,20(s3)
    80003ada:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003adc:	0109a783          	lw	a5,16(s3)
    80003ae0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003ae2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003ae6:	854a                	mv	a0,s2
    80003ae8:	87cff0ef          	jal	80002b64 <bread>
  log.lh.n = lh->n;
    80003aec:	4d30                	lw	a2,88(a0)
    80003aee:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003af0:	00c05f63          	blez	a2,80003b0e <initlog+0x60>
    80003af4:	87aa                	mv	a5,a0
    80003af6:	0001c717          	auipc	a4,0x1c
    80003afa:	f6a70713          	addi	a4,a4,-150 # 8001fa60 <log+0x30>
    80003afe:	060a                	slli	a2,a2,0x2
    80003b00:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003b02:	4ff4                	lw	a3,92(a5)
    80003b04:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003b06:	0791                	addi	a5,a5,4
    80003b08:	0711                	addi	a4,a4,4
    80003b0a:	fec79ce3          	bne	a5,a2,80003b02 <initlog+0x54>
  brelse(buf);
    80003b0e:	95eff0ef          	jal	80002c6c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003b12:	4505                	li	a0,1
    80003b14:	ef3ff0ef          	jal	80003a06 <install_trans>
  log.lh.n = 0;
    80003b18:	0001c797          	auipc	a5,0x1c
    80003b1c:	f407a223          	sw	zero,-188(a5) # 8001fa5c <log+0x2c>
  write_head(); // clear the log
    80003b20:	e89ff0ef          	jal	800039a8 <write_head>
}
    80003b24:	70a2                	ld	ra,40(sp)
    80003b26:	7402                	ld	s0,32(sp)
    80003b28:	64e2                	ld	s1,24(sp)
    80003b2a:	6942                	ld	s2,16(sp)
    80003b2c:	69a2                	ld	s3,8(sp)
    80003b2e:	6145                	addi	sp,sp,48
    80003b30:	8082                	ret

0000000080003b32 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003b32:	1101                	addi	sp,sp,-32
    80003b34:	ec06                	sd	ra,24(sp)
    80003b36:	e822                	sd	s0,16(sp)
    80003b38:	e426                	sd	s1,8(sp)
    80003b3a:	e04a                	sd	s2,0(sp)
    80003b3c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003b3e:	0001c517          	auipc	a0,0x1c
    80003b42:	ef250513          	addi	a0,a0,-270 # 8001fa30 <log>
    80003b46:	8aefd0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003b4a:	0001c497          	auipc	s1,0x1c
    80003b4e:	ee648493          	addi	s1,s1,-282 # 8001fa30 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003b52:	4979                	li	s2,30
    80003b54:	a029                	j	80003b5e <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003b56:	85a6                	mv	a1,s1
    80003b58:	8526                	mv	a0,s1
    80003b5a:	bdefe0ef          	jal	80001f38 <sleep>
    if(log.committing){
    80003b5e:	50dc                	lw	a5,36(s1)
    80003b60:	fbfd                	bnez	a5,80003b56 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003b62:	5098                	lw	a4,32(s1)
    80003b64:	2705                	addiw	a4,a4,1
    80003b66:	0027179b          	slliw	a5,a4,0x2
    80003b6a:	9fb9                	addw	a5,a5,a4
    80003b6c:	0017979b          	slliw	a5,a5,0x1
    80003b70:	54d4                	lw	a3,44(s1)
    80003b72:	9fb5                	addw	a5,a5,a3
    80003b74:	00f95763          	bge	s2,a5,80003b82 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003b78:	85a6                	mv	a1,s1
    80003b7a:	8526                	mv	a0,s1
    80003b7c:	bbcfe0ef          	jal	80001f38 <sleep>
    80003b80:	bff9                	j	80003b5e <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003b82:	0001c517          	auipc	a0,0x1c
    80003b86:	eae50513          	addi	a0,a0,-338 # 8001fa30 <log>
    80003b8a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003b8c:	900fd0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003b90:	60e2                	ld	ra,24(sp)
    80003b92:	6442                	ld	s0,16(sp)
    80003b94:	64a2                	ld	s1,8(sp)
    80003b96:	6902                	ld	s2,0(sp)
    80003b98:	6105                	addi	sp,sp,32
    80003b9a:	8082                	ret

0000000080003b9c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003b9c:	7139                	addi	sp,sp,-64
    80003b9e:	fc06                	sd	ra,56(sp)
    80003ba0:	f822                	sd	s0,48(sp)
    80003ba2:	f426                	sd	s1,40(sp)
    80003ba4:	f04a                	sd	s2,32(sp)
    80003ba6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003ba8:	0001c497          	auipc	s1,0x1c
    80003bac:	e8848493          	addi	s1,s1,-376 # 8001fa30 <log>
    80003bb0:	8526                	mv	a0,s1
    80003bb2:	842fd0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003bb6:	509c                	lw	a5,32(s1)
    80003bb8:	37fd                	addiw	a5,a5,-1
    80003bba:	0007891b          	sext.w	s2,a5
    80003bbe:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003bc0:	50dc                	lw	a5,36(s1)
    80003bc2:	ef9d                	bnez	a5,80003c00 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003bc4:	04091763          	bnez	s2,80003c12 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003bc8:	0001c497          	auipc	s1,0x1c
    80003bcc:	e6848493          	addi	s1,s1,-408 # 8001fa30 <log>
    80003bd0:	4785                	li	a5,1
    80003bd2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003bd4:	8526                	mv	a0,s1
    80003bd6:	8b6fd0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003bda:	54dc                	lw	a5,44(s1)
    80003bdc:	04f04b63          	bgtz	a5,80003c32 <end_op+0x96>
    acquire(&log.lock);
    80003be0:	0001c497          	auipc	s1,0x1c
    80003be4:	e5048493          	addi	s1,s1,-432 # 8001fa30 <log>
    80003be8:	8526                	mv	a0,s1
    80003bea:	80afd0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003bee:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003bf2:	8526                	mv	a0,s1
    80003bf4:	b90fe0ef          	jal	80001f84 <wakeup>
    release(&log.lock);
    80003bf8:	8526                	mv	a0,s1
    80003bfa:	892fd0ef          	jal	80000c8c <release>
}
    80003bfe:	a025                	j	80003c26 <end_op+0x8a>
    80003c00:	ec4e                	sd	s3,24(sp)
    80003c02:	e852                	sd	s4,16(sp)
    80003c04:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003c06:	00004517          	auipc	a0,0x4
    80003c0a:	95a50513          	addi	a0,a0,-1702 # 80007560 <etext+0x560>
    80003c0e:	b87fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003c12:	0001c497          	auipc	s1,0x1c
    80003c16:	e1e48493          	addi	s1,s1,-482 # 8001fa30 <log>
    80003c1a:	8526                	mv	a0,s1
    80003c1c:	b68fe0ef          	jal	80001f84 <wakeup>
  release(&log.lock);
    80003c20:	8526                	mv	a0,s1
    80003c22:	86afd0ef          	jal	80000c8c <release>
}
    80003c26:	70e2                	ld	ra,56(sp)
    80003c28:	7442                	ld	s0,48(sp)
    80003c2a:	74a2                	ld	s1,40(sp)
    80003c2c:	7902                	ld	s2,32(sp)
    80003c2e:	6121                	addi	sp,sp,64
    80003c30:	8082                	ret
    80003c32:	ec4e                	sd	s3,24(sp)
    80003c34:	e852                	sd	s4,16(sp)
    80003c36:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c38:	0001ca97          	auipc	s5,0x1c
    80003c3c:	e28a8a93          	addi	s5,s5,-472 # 8001fa60 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003c40:	0001ca17          	auipc	s4,0x1c
    80003c44:	df0a0a13          	addi	s4,s4,-528 # 8001fa30 <log>
    80003c48:	018a2583          	lw	a1,24(s4)
    80003c4c:	012585bb          	addw	a1,a1,s2
    80003c50:	2585                	addiw	a1,a1,1
    80003c52:	028a2503          	lw	a0,40(s4)
    80003c56:	f0ffe0ef          	jal	80002b64 <bread>
    80003c5a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003c5c:	000aa583          	lw	a1,0(s5)
    80003c60:	028a2503          	lw	a0,40(s4)
    80003c64:	f01fe0ef          	jal	80002b64 <bread>
    80003c68:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003c6a:	40000613          	li	a2,1024
    80003c6e:	05850593          	addi	a1,a0,88
    80003c72:	05848513          	addi	a0,s1,88
    80003c76:	8aefd0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80003c7a:	8526                	mv	a0,s1
    80003c7c:	fbffe0ef          	jal	80002c3a <bwrite>
    brelse(from);
    80003c80:	854e                	mv	a0,s3
    80003c82:	febfe0ef          	jal	80002c6c <brelse>
    brelse(to);
    80003c86:	8526                	mv	a0,s1
    80003c88:	fe5fe0ef          	jal	80002c6c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c8c:	2905                	addiw	s2,s2,1
    80003c8e:	0a91                	addi	s5,s5,4
    80003c90:	02ca2783          	lw	a5,44(s4)
    80003c94:	faf94ae3          	blt	s2,a5,80003c48 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003c98:	d11ff0ef          	jal	800039a8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003c9c:	4501                	li	a0,0
    80003c9e:	d69ff0ef          	jal	80003a06 <install_trans>
    log.lh.n = 0;
    80003ca2:	0001c797          	auipc	a5,0x1c
    80003ca6:	da07ad23          	sw	zero,-582(a5) # 8001fa5c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003caa:	cffff0ef          	jal	800039a8 <write_head>
    80003cae:	69e2                	ld	s3,24(sp)
    80003cb0:	6a42                	ld	s4,16(sp)
    80003cb2:	6aa2                	ld	s5,8(sp)
    80003cb4:	b735                	j	80003be0 <end_op+0x44>

0000000080003cb6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003cb6:	1101                	addi	sp,sp,-32
    80003cb8:	ec06                	sd	ra,24(sp)
    80003cba:	e822                	sd	s0,16(sp)
    80003cbc:	e426                	sd	s1,8(sp)
    80003cbe:	e04a                	sd	s2,0(sp)
    80003cc0:	1000                	addi	s0,sp,32
    80003cc2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003cc4:	0001c917          	auipc	s2,0x1c
    80003cc8:	d6c90913          	addi	s2,s2,-660 # 8001fa30 <log>
    80003ccc:	854a                	mv	a0,s2
    80003cce:	f27fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003cd2:	02c92603          	lw	a2,44(s2)
    80003cd6:	47f5                	li	a5,29
    80003cd8:	06c7c363          	blt	a5,a2,80003d3e <log_write+0x88>
    80003cdc:	0001c797          	auipc	a5,0x1c
    80003ce0:	d707a783          	lw	a5,-656(a5) # 8001fa4c <log+0x1c>
    80003ce4:	37fd                	addiw	a5,a5,-1
    80003ce6:	04f65c63          	bge	a2,a5,80003d3e <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003cea:	0001c797          	auipc	a5,0x1c
    80003cee:	d667a783          	lw	a5,-666(a5) # 8001fa50 <log+0x20>
    80003cf2:	04f05c63          	blez	a5,80003d4a <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003cf6:	4781                	li	a5,0
    80003cf8:	04c05f63          	blez	a2,80003d56 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003cfc:	44cc                	lw	a1,12(s1)
    80003cfe:	0001c717          	auipc	a4,0x1c
    80003d02:	d6270713          	addi	a4,a4,-670 # 8001fa60 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003d06:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d08:	4314                	lw	a3,0(a4)
    80003d0a:	04b68663          	beq	a3,a1,80003d56 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003d0e:	2785                	addiw	a5,a5,1
    80003d10:	0711                	addi	a4,a4,4
    80003d12:	fef61be3          	bne	a2,a5,80003d08 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003d16:	0621                	addi	a2,a2,8
    80003d18:	060a                	slli	a2,a2,0x2
    80003d1a:	0001c797          	auipc	a5,0x1c
    80003d1e:	d1678793          	addi	a5,a5,-746 # 8001fa30 <log>
    80003d22:	97b2                	add	a5,a5,a2
    80003d24:	44d8                	lw	a4,12(s1)
    80003d26:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003d28:	8526                	mv	a0,s1
    80003d2a:	fcbfe0ef          	jal	80002cf4 <bpin>
    log.lh.n++;
    80003d2e:	0001c717          	auipc	a4,0x1c
    80003d32:	d0270713          	addi	a4,a4,-766 # 8001fa30 <log>
    80003d36:	575c                	lw	a5,44(a4)
    80003d38:	2785                	addiw	a5,a5,1
    80003d3a:	d75c                	sw	a5,44(a4)
    80003d3c:	a80d                	j	80003d6e <log_write+0xb8>
    panic("too big a transaction");
    80003d3e:	00004517          	auipc	a0,0x4
    80003d42:	83250513          	addi	a0,a0,-1998 # 80007570 <etext+0x570>
    80003d46:	a4ffc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80003d4a:	00004517          	auipc	a0,0x4
    80003d4e:	83e50513          	addi	a0,a0,-1986 # 80007588 <etext+0x588>
    80003d52:	a43fc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80003d56:	00878693          	addi	a3,a5,8
    80003d5a:	068a                	slli	a3,a3,0x2
    80003d5c:	0001c717          	auipc	a4,0x1c
    80003d60:	cd470713          	addi	a4,a4,-812 # 8001fa30 <log>
    80003d64:	9736                	add	a4,a4,a3
    80003d66:	44d4                	lw	a3,12(s1)
    80003d68:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003d6a:	faf60fe3          	beq	a2,a5,80003d28 <log_write+0x72>
  }
  release(&log.lock);
    80003d6e:	0001c517          	auipc	a0,0x1c
    80003d72:	cc250513          	addi	a0,a0,-830 # 8001fa30 <log>
    80003d76:	f17fc0ef          	jal	80000c8c <release>
}
    80003d7a:	60e2                	ld	ra,24(sp)
    80003d7c:	6442                	ld	s0,16(sp)
    80003d7e:	64a2                	ld	s1,8(sp)
    80003d80:	6902                	ld	s2,0(sp)
    80003d82:	6105                	addi	sp,sp,32
    80003d84:	8082                	ret

0000000080003d86 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003d86:	1101                	addi	sp,sp,-32
    80003d88:	ec06                	sd	ra,24(sp)
    80003d8a:	e822                	sd	s0,16(sp)
    80003d8c:	e426                	sd	s1,8(sp)
    80003d8e:	e04a                	sd	s2,0(sp)
    80003d90:	1000                	addi	s0,sp,32
    80003d92:	84aa                	mv	s1,a0
    80003d94:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003d96:	00004597          	auipc	a1,0x4
    80003d9a:	81258593          	addi	a1,a1,-2030 # 800075a8 <etext+0x5a8>
    80003d9e:	0521                	addi	a0,a0,8
    80003da0:	dd5fc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    80003da4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003da8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003dac:	0204a423          	sw	zero,40(s1)
}
    80003db0:	60e2                	ld	ra,24(sp)
    80003db2:	6442                	ld	s0,16(sp)
    80003db4:	64a2                	ld	s1,8(sp)
    80003db6:	6902                	ld	s2,0(sp)
    80003db8:	6105                	addi	sp,sp,32
    80003dba:	8082                	ret

0000000080003dbc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003dbc:	1101                	addi	sp,sp,-32
    80003dbe:	ec06                	sd	ra,24(sp)
    80003dc0:	e822                	sd	s0,16(sp)
    80003dc2:	e426                	sd	s1,8(sp)
    80003dc4:	e04a                	sd	s2,0(sp)
    80003dc6:	1000                	addi	s0,sp,32
    80003dc8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003dca:	00850913          	addi	s2,a0,8
    80003dce:	854a                	mv	a0,s2
    80003dd0:	e25fc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    80003dd4:	409c                	lw	a5,0(s1)
    80003dd6:	c799                	beqz	a5,80003de4 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003dd8:	85ca                	mv	a1,s2
    80003dda:	8526                	mv	a0,s1
    80003ddc:	95cfe0ef          	jal	80001f38 <sleep>
  while (lk->locked) {
    80003de0:	409c                	lw	a5,0(s1)
    80003de2:	fbfd                	bnez	a5,80003dd8 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003de4:	4785                	li	a5,1
    80003de6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003de8:	af9fd0ef          	jal	800018e0 <myproc>
    80003dec:	591c                	lw	a5,48(a0)
    80003dee:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003df0:	854a                	mv	a0,s2
    80003df2:	e9bfc0ef          	jal	80000c8c <release>
}
    80003df6:	60e2                	ld	ra,24(sp)
    80003df8:	6442                	ld	s0,16(sp)
    80003dfa:	64a2                	ld	s1,8(sp)
    80003dfc:	6902                	ld	s2,0(sp)
    80003dfe:	6105                	addi	sp,sp,32
    80003e00:	8082                	ret

0000000080003e02 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003e02:	1101                	addi	sp,sp,-32
    80003e04:	ec06                	sd	ra,24(sp)
    80003e06:	e822                	sd	s0,16(sp)
    80003e08:	e426                	sd	s1,8(sp)
    80003e0a:	e04a                	sd	s2,0(sp)
    80003e0c:	1000                	addi	s0,sp,32
    80003e0e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e10:	00850913          	addi	s2,a0,8
    80003e14:	854a                	mv	a0,s2
    80003e16:	ddffc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    80003e1a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e1e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003e22:	8526                	mv	a0,s1
    80003e24:	960fe0ef          	jal	80001f84 <wakeup>
  release(&lk->lk);
    80003e28:	854a                	mv	a0,s2
    80003e2a:	e63fc0ef          	jal	80000c8c <release>
}
    80003e2e:	60e2                	ld	ra,24(sp)
    80003e30:	6442                	ld	s0,16(sp)
    80003e32:	64a2                	ld	s1,8(sp)
    80003e34:	6902                	ld	s2,0(sp)
    80003e36:	6105                	addi	sp,sp,32
    80003e38:	8082                	ret

0000000080003e3a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003e3a:	7179                	addi	sp,sp,-48
    80003e3c:	f406                	sd	ra,40(sp)
    80003e3e:	f022                	sd	s0,32(sp)
    80003e40:	ec26                	sd	s1,24(sp)
    80003e42:	e84a                	sd	s2,16(sp)
    80003e44:	1800                	addi	s0,sp,48
    80003e46:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003e48:	00850913          	addi	s2,a0,8
    80003e4c:	854a                	mv	a0,s2
    80003e4e:	da7fc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e52:	409c                	lw	a5,0(s1)
    80003e54:	ef81                	bnez	a5,80003e6c <holdingsleep+0x32>
    80003e56:	4481                	li	s1,0
  release(&lk->lk);
    80003e58:	854a                	mv	a0,s2
    80003e5a:	e33fc0ef          	jal	80000c8c <release>
  return r;
}
    80003e5e:	8526                	mv	a0,s1
    80003e60:	70a2                	ld	ra,40(sp)
    80003e62:	7402                	ld	s0,32(sp)
    80003e64:	64e2                	ld	s1,24(sp)
    80003e66:	6942                	ld	s2,16(sp)
    80003e68:	6145                	addi	sp,sp,48
    80003e6a:	8082                	ret
    80003e6c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e6e:	0284a983          	lw	s3,40(s1)
    80003e72:	a6ffd0ef          	jal	800018e0 <myproc>
    80003e76:	5904                	lw	s1,48(a0)
    80003e78:	413484b3          	sub	s1,s1,s3
    80003e7c:	0014b493          	seqz	s1,s1
    80003e80:	69a2                	ld	s3,8(sp)
    80003e82:	bfd9                	j	80003e58 <holdingsleep+0x1e>

0000000080003e84 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003e84:	1141                	addi	sp,sp,-16
    80003e86:	e406                	sd	ra,8(sp)
    80003e88:	e022                	sd	s0,0(sp)
    80003e8a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003e8c:	00003597          	auipc	a1,0x3
    80003e90:	72c58593          	addi	a1,a1,1836 # 800075b8 <etext+0x5b8>
    80003e94:	0001c517          	auipc	a0,0x1c
    80003e98:	ce450513          	addi	a0,a0,-796 # 8001fb78 <ftable>
    80003e9c:	cd9fc0ef          	jal	80000b74 <initlock>
}
    80003ea0:	60a2                	ld	ra,8(sp)
    80003ea2:	6402                	ld	s0,0(sp)
    80003ea4:	0141                	addi	sp,sp,16
    80003ea6:	8082                	ret

0000000080003ea8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ea8:	1101                	addi	sp,sp,-32
    80003eaa:	ec06                	sd	ra,24(sp)
    80003eac:	e822                	sd	s0,16(sp)
    80003eae:	e426                	sd	s1,8(sp)
    80003eb0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003eb2:	0001c517          	auipc	a0,0x1c
    80003eb6:	cc650513          	addi	a0,a0,-826 # 8001fb78 <ftable>
    80003eba:	d3bfc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ebe:	0001c497          	auipc	s1,0x1c
    80003ec2:	cd248493          	addi	s1,s1,-814 # 8001fb90 <ftable+0x18>
    80003ec6:	0001d717          	auipc	a4,0x1d
    80003eca:	c6a70713          	addi	a4,a4,-918 # 80020b30 <disk>
    if(f->ref == 0){
    80003ece:	40dc                	lw	a5,4(s1)
    80003ed0:	cf89                	beqz	a5,80003eea <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ed2:	02848493          	addi	s1,s1,40
    80003ed6:	fee49ce3          	bne	s1,a4,80003ece <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003eda:	0001c517          	auipc	a0,0x1c
    80003ede:	c9e50513          	addi	a0,a0,-866 # 8001fb78 <ftable>
    80003ee2:	dabfc0ef          	jal	80000c8c <release>
  return 0;
    80003ee6:	4481                	li	s1,0
    80003ee8:	a809                	j	80003efa <filealloc+0x52>
      f->ref = 1;
    80003eea:	4785                	li	a5,1
    80003eec:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003eee:	0001c517          	auipc	a0,0x1c
    80003ef2:	c8a50513          	addi	a0,a0,-886 # 8001fb78 <ftable>
    80003ef6:	d97fc0ef          	jal	80000c8c <release>
}
    80003efa:	8526                	mv	a0,s1
    80003efc:	60e2                	ld	ra,24(sp)
    80003efe:	6442                	ld	s0,16(sp)
    80003f00:	64a2                	ld	s1,8(sp)
    80003f02:	6105                	addi	sp,sp,32
    80003f04:	8082                	ret

0000000080003f06 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003f06:	1101                	addi	sp,sp,-32
    80003f08:	ec06                	sd	ra,24(sp)
    80003f0a:	e822                	sd	s0,16(sp)
    80003f0c:	e426                	sd	s1,8(sp)
    80003f0e:	1000                	addi	s0,sp,32
    80003f10:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003f12:	0001c517          	auipc	a0,0x1c
    80003f16:	c6650513          	addi	a0,a0,-922 # 8001fb78 <ftable>
    80003f1a:	cdbfc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80003f1e:	40dc                	lw	a5,4(s1)
    80003f20:	02f05063          	blez	a5,80003f40 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003f24:	2785                	addiw	a5,a5,1
    80003f26:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003f28:	0001c517          	auipc	a0,0x1c
    80003f2c:	c5050513          	addi	a0,a0,-944 # 8001fb78 <ftable>
    80003f30:	d5dfc0ef          	jal	80000c8c <release>
  return f;
}
    80003f34:	8526                	mv	a0,s1
    80003f36:	60e2                	ld	ra,24(sp)
    80003f38:	6442                	ld	s0,16(sp)
    80003f3a:	64a2                	ld	s1,8(sp)
    80003f3c:	6105                	addi	sp,sp,32
    80003f3e:	8082                	ret
    panic("filedup");
    80003f40:	00003517          	auipc	a0,0x3
    80003f44:	68050513          	addi	a0,a0,1664 # 800075c0 <etext+0x5c0>
    80003f48:	84dfc0ef          	jal	80000794 <panic>

0000000080003f4c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003f4c:	7139                	addi	sp,sp,-64
    80003f4e:	fc06                	sd	ra,56(sp)
    80003f50:	f822                	sd	s0,48(sp)
    80003f52:	f426                	sd	s1,40(sp)
    80003f54:	0080                	addi	s0,sp,64
    80003f56:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003f58:	0001c517          	auipc	a0,0x1c
    80003f5c:	c2050513          	addi	a0,a0,-992 # 8001fb78 <ftable>
    80003f60:	c95fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80003f64:	40dc                	lw	a5,4(s1)
    80003f66:	04f05a63          	blez	a5,80003fba <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003f6a:	37fd                	addiw	a5,a5,-1
    80003f6c:	0007871b          	sext.w	a4,a5
    80003f70:	c0dc                	sw	a5,4(s1)
    80003f72:	04e04e63          	bgtz	a4,80003fce <fileclose+0x82>
    80003f76:	f04a                	sd	s2,32(sp)
    80003f78:	ec4e                	sd	s3,24(sp)
    80003f7a:	e852                	sd	s4,16(sp)
    80003f7c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003f7e:	0004a903          	lw	s2,0(s1)
    80003f82:	0094ca83          	lbu	s5,9(s1)
    80003f86:	0104ba03          	ld	s4,16(s1)
    80003f8a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003f8e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003f92:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003f96:	0001c517          	auipc	a0,0x1c
    80003f9a:	be250513          	addi	a0,a0,-1054 # 8001fb78 <ftable>
    80003f9e:	ceffc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    80003fa2:	4785                	li	a5,1
    80003fa4:	04f90063          	beq	s2,a5,80003fe4 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003fa8:	3979                	addiw	s2,s2,-2
    80003faa:	4785                	li	a5,1
    80003fac:	0527f563          	bgeu	a5,s2,80003ff6 <fileclose+0xaa>
    80003fb0:	7902                	ld	s2,32(sp)
    80003fb2:	69e2                	ld	s3,24(sp)
    80003fb4:	6a42                	ld	s4,16(sp)
    80003fb6:	6aa2                	ld	s5,8(sp)
    80003fb8:	a00d                	j	80003fda <fileclose+0x8e>
    80003fba:	f04a                	sd	s2,32(sp)
    80003fbc:	ec4e                	sd	s3,24(sp)
    80003fbe:	e852                	sd	s4,16(sp)
    80003fc0:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003fc2:	00003517          	auipc	a0,0x3
    80003fc6:	60650513          	addi	a0,a0,1542 # 800075c8 <etext+0x5c8>
    80003fca:	fcafc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    80003fce:	0001c517          	auipc	a0,0x1c
    80003fd2:	baa50513          	addi	a0,a0,-1110 # 8001fb78 <ftable>
    80003fd6:	cb7fc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003fda:	70e2                	ld	ra,56(sp)
    80003fdc:	7442                	ld	s0,48(sp)
    80003fde:	74a2                	ld	s1,40(sp)
    80003fe0:	6121                	addi	sp,sp,64
    80003fe2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003fe4:	85d6                	mv	a1,s5
    80003fe6:	8552                	mv	a0,s4
    80003fe8:	336000ef          	jal	8000431e <pipeclose>
    80003fec:	7902                	ld	s2,32(sp)
    80003fee:	69e2                	ld	s3,24(sp)
    80003ff0:	6a42                	ld	s4,16(sp)
    80003ff2:	6aa2                	ld	s5,8(sp)
    80003ff4:	b7dd                	j	80003fda <fileclose+0x8e>
    begin_op();
    80003ff6:	b3dff0ef          	jal	80003b32 <begin_op>
    iput(ff.ip);
    80003ffa:	854e                	mv	a0,s3
    80003ffc:	c22ff0ef          	jal	8000341e <iput>
    end_op();
    80004000:	b9dff0ef          	jal	80003b9c <end_op>
    80004004:	7902                	ld	s2,32(sp)
    80004006:	69e2                	ld	s3,24(sp)
    80004008:	6a42                	ld	s4,16(sp)
    8000400a:	6aa2                	ld	s5,8(sp)
    8000400c:	b7f9                	j	80003fda <fileclose+0x8e>

000000008000400e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000400e:	715d                	addi	sp,sp,-80
    80004010:	e486                	sd	ra,72(sp)
    80004012:	e0a2                	sd	s0,64(sp)
    80004014:	fc26                	sd	s1,56(sp)
    80004016:	f44e                	sd	s3,40(sp)
    80004018:	0880                	addi	s0,sp,80
    8000401a:	84aa                	mv	s1,a0
    8000401c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000401e:	8c3fd0ef          	jal	800018e0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004022:	409c                	lw	a5,0(s1)
    80004024:	37f9                	addiw	a5,a5,-2
    80004026:	4705                	li	a4,1
    80004028:	04f76063          	bltu	a4,a5,80004068 <filestat+0x5a>
    8000402c:	f84a                	sd	s2,48(sp)
    8000402e:	892a                	mv	s2,a0
    ilock(f->ip);
    80004030:	6c88                	ld	a0,24(s1)
    80004032:	a6aff0ef          	jal	8000329c <ilock>
    stati(f->ip, &st);
    80004036:	fb840593          	addi	a1,s0,-72
    8000403a:	6c88                	ld	a0,24(s1)
    8000403c:	c8aff0ef          	jal	800034c6 <stati>
    iunlock(f->ip);
    80004040:	6c88                	ld	a0,24(s1)
    80004042:	b08ff0ef          	jal	8000334a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004046:	46e1                	li	a3,24
    80004048:	fb840613          	addi	a2,s0,-72
    8000404c:	85ce                	mv	a1,s3
    8000404e:	05093503          	ld	a0,80(s2)
    80004052:	d00fd0ef          	jal	80001552 <copyout>
    80004056:	41f5551b          	sraiw	a0,a0,0x1f
    8000405a:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000405c:	60a6                	ld	ra,72(sp)
    8000405e:	6406                	ld	s0,64(sp)
    80004060:	74e2                	ld	s1,56(sp)
    80004062:	79a2                	ld	s3,40(sp)
    80004064:	6161                	addi	sp,sp,80
    80004066:	8082                	ret
  return -1;
    80004068:	557d                	li	a0,-1
    8000406a:	bfcd                	j	8000405c <filestat+0x4e>

000000008000406c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000406c:	7179                	addi	sp,sp,-48
    8000406e:	f406                	sd	ra,40(sp)
    80004070:	f022                	sd	s0,32(sp)
    80004072:	e84a                	sd	s2,16(sp)
    80004074:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004076:	00854783          	lbu	a5,8(a0)
    8000407a:	cfd1                	beqz	a5,80004116 <fileread+0xaa>
    8000407c:	ec26                	sd	s1,24(sp)
    8000407e:	e44e                	sd	s3,8(sp)
    80004080:	84aa                	mv	s1,a0
    80004082:	89ae                	mv	s3,a1
    80004084:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004086:	411c                	lw	a5,0(a0)
    80004088:	4705                	li	a4,1
    8000408a:	04e78363          	beq	a5,a4,800040d0 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000408e:	470d                	li	a4,3
    80004090:	04e78763          	beq	a5,a4,800040de <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004094:	4709                	li	a4,2
    80004096:	06e79a63          	bne	a5,a4,8000410a <fileread+0x9e>
    ilock(f->ip);
    8000409a:	6d08                	ld	a0,24(a0)
    8000409c:	a00ff0ef          	jal	8000329c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800040a0:	874a                	mv	a4,s2
    800040a2:	5094                	lw	a3,32(s1)
    800040a4:	864e                	mv	a2,s3
    800040a6:	4585                	li	a1,1
    800040a8:	6c88                	ld	a0,24(s1)
    800040aa:	c46ff0ef          	jal	800034f0 <readi>
    800040ae:	892a                	mv	s2,a0
    800040b0:	00a05563          	blez	a0,800040ba <fileread+0x4e>
      f->off += r;
    800040b4:	509c                	lw	a5,32(s1)
    800040b6:	9fa9                	addw	a5,a5,a0
    800040b8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800040ba:	6c88                	ld	a0,24(s1)
    800040bc:	a8eff0ef          	jal	8000334a <iunlock>
    800040c0:	64e2                	ld	s1,24(sp)
    800040c2:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800040c4:	854a                	mv	a0,s2
    800040c6:	70a2                	ld	ra,40(sp)
    800040c8:	7402                	ld	s0,32(sp)
    800040ca:	6942                	ld	s2,16(sp)
    800040cc:	6145                	addi	sp,sp,48
    800040ce:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800040d0:	6908                	ld	a0,16(a0)
    800040d2:	388000ef          	jal	8000445a <piperead>
    800040d6:	892a                	mv	s2,a0
    800040d8:	64e2                	ld	s1,24(sp)
    800040da:	69a2                	ld	s3,8(sp)
    800040dc:	b7e5                	j	800040c4 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800040de:	02451783          	lh	a5,36(a0)
    800040e2:	03079693          	slli	a3,a5,0x30
    800040e6:	92c1                	srli	a3,a3,0x30
    800040e8:	4725                	li	a4,9
    800040ea:	02d76863          	bltu	a4,a3,8000411a <fileread+0xae>
    800040ee:	0792                	slli	a5,a5,0x4
    800040f0:	0001c717          	auipc	a4,0x1c
    800040f4:	9e870713          	addi	a4,a4,-1560 # 8001fad8 <devsw>
    800040f8:	97ba                	add	a5,a5,a4
    800040fa:	639c                	ld	a5,0(a5)
    800040fc:	c39d                	beqz	a5,80004122 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800040fe:	4505                	li	a0,1
    80004100:	9782                	jalr	a5
    80004102:	892a                	mv	s2,a0
    80004104:	64e2                	ld	s1,24(sp)
    80004106:	69a2                	ld	s3,8(sp)
    80004108:	bf75                	j	800040c4 <fileread+0x58>
    panic("fileread");
    8000410a:	00003517          	auipc	a0,0x3
    8000410e:	4ce50513          	addi	a0,a0,1230 # 800075d8 <etext+0x5d8>
    80004112:	e82fc0ef          	jal	80000794 <panic>
    return -1;
    80004116:	597d                	li	s2,-1
    80004118:	b775                	j	800040c4 <fileread+0x58>
      return -1;
    8000411a:	597d                	li	s2,-1
    8000411c:	64e2                	ld	s1,24(sp)
    8000411e:	69a2                	ld	s3,8(sp)
    80004120:	b755                	j	800040c4 <fileread+0x58>
    80004122:	597d                	li	s2,-1
    80004124:	64e2                	ld	s1,24(sp)
    80004126:	69a2                	ld	s3,8(sp)
    80004128:	bf71                	j	800040c4 <fileread+0x58>

000000008000412a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000412a:	00954783          	lbu	a5,9(a0)
    8000412e:	10078b63          	beqz	a5,80004244 <filewrite+0x11a>
{
    80004132:	715d                	addi	sp,sp,-80
    80004134:	e486                	sd	ra,72(sp)
    80004136:	e0a2                	sd	s0,64(sp)
    80004138:	f84a                	sd	s2,48(sp)
    8000413a:	f052                	sd	s4,32(sp)
    8000413c:	e85a                	sd	s6,16(sp)
    8000413e:	0880                	addi	s0,sp,80
    80004140:	892a                	mv	s2,a0
    80004142:	8b2e                	mv	s6,a1
    80004144:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004146:	411c                	lw	a5,0(a0)
    80004148:	4705                	li	a4,1
    8000414a:	02e78763          	beq	a5,a4,80004178 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000414e:	470d                	li	a4,3
    80004150:	02e78863          	beq	a5,a4,80004180 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004154:	4709                	li	a4,2
    80004156:	0ce79c63          	bne	a5,a4,8000422e <filewrite+0x104>
    8000415a:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000415c:	0ac05863          	blez	a2,8000420c <filewrite+0xe2>
    80004160:	fc26                	sd	s1,56(sp)
    80004162:	ec56                	sd	s5,24(sp)
    80004164:	e45e                	sd	s7,8(sp)
    80004166:	e062                	sd	s8,0(sp)
    int i = 0;
    80004168:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000416a:	6b85                	lui	s7,0x1
    8000416c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004170:	6c05                	lui	s8,0x1
    80004172:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004176:	a8b5                	j	800041f2 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004178:	6908                	ld	a0,16(a0)
    8000417a:	1fc000ef          	jal	80004376 <pipewrite>
    8000417e:	a04d                	j	80004220 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004180:	02451783          	lh	a5,36(a0)
    80004184:	03079693          	slli	a3,a5,0x30
    80004188:	92c1                	srli	a3,a3,0x30
    8000418a:	4725                	li	a4,9
    8000418c:	0ad76e63          	bltu	a4,a3,80004248 <filewrite+0x11e>
    80004190:	0792                	slli	a5,a5,0x4
    80004192:	0001c717          	auipc	a4,0x1c
    80004196:	94670713          	addi	a4,a4,-1722 # 8001fad8 <devsw>
    8000419a:	97ba                	add	a5,a5,a4
    8000419c:	679c                	ld	a5,8(a5)
    8000419e:	c7dd                	beqz	a5,8000424c <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800041a0:	4505                	li	a0,1
    800041a2:	9782                	jalr	a5
    800041a4:	a8b5                	j	80004220 <filewrite+0xf6>
      if(n1 > max)
    800041a6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800041aa:	989ff0ef          	jal	80003b32 <begin_op>
      ilock(f->ip);
    800041ae:	01893503          	ld	a0,24(s2)
    800041b2:	8eaff0ef          	jal	8000329c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800041b6:	8756                	mv	a4,s5
    800041b8:	02092683          	lw	a3,32(s2)
    800041bc:	01698633          	add	a2,s3,s6
    800041c0:	4585                	li	a1,1
    800041c2:	01893503          	ld	a0,24(s2)
    800041c6:	c26ff0ef          	jal	800035ec <writei>
    800041ca:	84aa                	mv	s1,a0
    800041cc:	00a05763          	blez	a0,800041da <filewrite+0xb0>
        f->off += r;
    800041d0:	02092783          	lw	a5,32(s2)
    800041d4:	9fa9                	addw	a5,a5,a0
    800041d6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800041da:	01893503          	ld	a0,24(s2)
    800041de:	96cff0ef          	jal	8000334a <iunlock>
      end_op();
    800041e2:	9bbff0ef          	jal	80003b9c <end_op>

      if(r != n1){
    800041e6:	029a9563          	bne	s5,s1,80004210 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800041ea:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800041ee:	0149da63          	bge	s3,s4,80004202 <filewrite+0xd8>
      int n1 = n - i;
    800041f2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800041f6:	0004879b          	sext.w	a5,s1
    800041fa:	fafbd6e3          	bge	s7,a5,800041a6 <filewrite+0x7c>
    800041fe:	84e2                	mv	s1,s8
    80004200:	b75d                	j	800041a6 <filewrite+0x7c>
    80004202:	74e2                	ld	s1,56(sp)
    80004204:	6ae2                	ld	s5,24(sp)
    80004206:	6ba2                	ld	s7,8(sp)
    80004208:	6c02                	ld	s8,0(sp)
    8000420a:	a039                	j	80004218 <filewrite+0xee>
    int i = 0;
    8000420c:	4981                	li	s3,0
    8000420e:	a029                	j	80004218 <filewrite+0xee>
    80004210:	74e2                	ld	s1,56(sp)
    80004212:	6ae2                	ld	s5,24(sp)
    80004214:	6ba2                	ld	s7,8(sp)
    80004216:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004218:	033a1c63          	bne	s4,s3,80004250 <filewrite+0x126>
    8000421c:	8552                	mv	a0,s4
    8000421e:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004220:	60a6                	ld	ra,72(sp)
    80004222:	6406                	ld	s0,64(sp)
    80004224:	7942                	ld	s2,48(sp)
    80004226:	7a02                	ld	s4,32(sp)
    80004228:	6b42                	ld	s6,16(sp)
    8000422a:	6161                	addi	sp,sp,80
    8000422c:	8082                	ret
    8000422e:	fc26                	sd	s1,56(sp)
    80004230:	f44e                	sd	s3,40(sp)
    80004232:	ec56                	sd	s5,24(sp)
    80004234:	e45e                	sd	s7,8(sp)
    80004236:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004238:	00003517          	auipc	a0,0x3
    8000423c:	3b050513          	addi	a0,a0,944 # 800075e8 <etext+0x5e8>
    80004240:	d54fc0ef          	jal	80000794 <panic>
    return -1;
    80004244:	557d                	li	a0,-1
}
    80004246:	8082                	ret
      return -1;
    80004248:	557d                	li	a0,-1
    8000424a:	bfd9                	j	80004220 <filewrite+0xf6>
    8000424c:	557d                	li	a0,-1
    8000424e:	bfc9                	j	80004220 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004250:	557d                	li	a0,-1
    80004252:	79a2                	ld	s3,40(sp)
    80004254:	b7f1                	j	80004220 <filewrite+0xf6>

0000000080004256 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004256:	7179                	addi	sp,sp,-48
    80004258:	f406                	sd	ra,40(sp)
    8000425a:	f022                	sd	s0,32(sp)
    8000425c:	ec26                	sd	s1,24(sp)
    8000425e:	e052                	sd	s4,0(sp)
    80004260:	1800                	addi	s0,sp,48
    80004262:	84aa                	mv	s1,a0
    80004264:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004266:	0005b023          	sd	zero,0(a1)
    8000426a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000426e:	c3bff0ef          	jal	80003ea8 <filealloc>
    80004272:	e088                	sd	a0,0(s1)
    80004274:	c549                	beqz	a0,800042fe <pipealloc+0xa8>
    80004276:	c33ff0ef          	jal	80003ea8 <filealloc>
    8000427a:	00aa3023          	sd	a0,0(s4)
    8000427e:	cd25                	beqz	a0,800042f6 <pipealloc+0xa0>
    80004280:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004282:	8a3fc0ef          	jal	80000b24 <kalloc>
    80004286:	892a                	mv	s2,a0
    80004288:	c12d                	beqz	a0,800042ea <pipealloc+0x94>
    8000428a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000428c:	4985                	li	s3,1
    8000428e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004292:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004296:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000429a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000429e:	00003597          	auipc	a1,0x3
    800042a2:	35a58593          	addi	a1,a1,858 # 800075f8 <etext+0x5f8>
    800042a6:	8cffc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    800042aa:	609c                	ld	a5,0(s1)
    800042ac:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800042b0:	609c                	ld	a5,0(s1)
    800042b2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800042b6:	609c                	ld	a5,0(s1)
    800042b8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800042bc:	609c                	ld	a5,0(s1)
    800042be:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800042c2:	000a3783          	ld	a5,0(s4)
    800042c6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800042ca:	000a3783          	ld	a5,0(s4)
    800042ce:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800042d2:	000a3783          	ld	a5,0(s4)
    800042d6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800042da:	000a3783          	ld	a5,0(s4)
    800042de:	0127b823          	sd	s2,16(a5)
  return 0;
    800042e2:	4501                	li	a0,0
    800042e4:	6942                	ld	s2,16(sp)
    800042e6:	69a2                	ld	s3,8(sp)
    800042e8:	a01d                	j	8000430e <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800042ea:	6088                	ld	a0,0(s1)
    800042ec:	c119                	beqz	a0,800042f2 <pipealloc+0x9c>
    800042ee:	6942                	ld	s2,16(sp)
    800042f0:	a029                	j	800042fa <pipealloc+0xa4>
    800042f2:	6942                	ld	s2,16(sp)
    800042f4:	a029                	j	800042fe <pipealloc+0xa8>
    800042f6:	6088                	ld	a0,0(s1)
    800042f8:	c10d                	beqz	a0,8000431a <pipealloc+0xc4>
    fileclose(*f0);
    800042fa:	c53ff0ef          	jal	80003f4c <fileclose>
  if(*f1)
    800042fe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004302:	557d                	li	a0,-1
  if(*f1)
    80004304:	c789                	beqz	a5,8000430e <pipealloc+0xb8>
    fileclose(*f1);
    80004306:	853e                	mv	a0,a5
    80004308:	c45ff0ef          	jal	80003f4c <fileclose>
  return -1;
    8000430c:	557d                	li	a0,-1
}
    8000430e:	70a2                	ld	ra,40(sp)
    80004310:	7402                	ld	s0,32(sp)
    80004312:	64e2                	ld	s1,24(sp)
    80004314:	6a02                	ld	s4,0(sp)
    80004316:	6145                	addi	sp,sp,48
    80004318:	8082                	ret
  return -1;
    8000431a:	557d                	li	a0,-1
    8000431c:	bfcd                	j	8000430e <pipealloc+0xb8>

000000008000431e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000431e:	1101                	addi	sp,sp,-32
    80004320:	ec06                	sd	ra,24(sp)
    80004322:	e822                	sd	s0,16(sp)
    80004324:	e426                	sd	s1,8(sp)
    80004326:	e04a                	sd	s2,0(sp)
    80004328:	1000                	addi	s0,sp,32
    8000432a:	84aa                	mv	s1,a0
    8000432c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000432e:	8c7fc0ef          	jal	80000bf4 <acquire>
  if(writable){
    80004332:	02090763          	beqz	s2,80004360 <pipeclose+0x42>
    pi->writeopen = 0;
    80004336:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000433a:	21848513          	addi	a0,s1,536
    8000433e:	c47fd0ef          	jal	80001f84 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004342:	2204b783          	ld	a5,544(s1)
    80004346:	e785                	bnez	a5,8000436e <pipeclose+0x50>
    release(&pi->lock);
    80004348:	8526                	mv	a0,s1
    8000434a:	943fc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    8000434e:	8526                	mv	a0,s1
    80004350:	ef2fc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    80004354:	60e2                	ld	ra,24(sp)
    80004356:	6442                	ld	s0,16(sp)
    80004358:	64a2                	ld	s1,8(sp)
    8000435a:	6902                	ld	s2,0(sp)
    8000435c:	6105                	addi	sp,sp,32
    8000435e:	8082                	ret
    pi->readopen = 0;
    80004360:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004364:	21c48513          	addi	a0,s1,540
    80004368:	c1dfd0ef          	jal	80001f84 <wakeup>
    8000436c:	bfd9                	j	80004342 <pipeclose+0x24>
    release(&pi->lock);
    8000436e:	8526                	mv	a0,s1
    80004370:	91dfc0ef          	jal	80000c8c <release>
}
    80004374:	b7c5                	j	80004354 <pipeclose+0x36>

0000000080004376 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004376:	711d                	addi	sp,sp,-96
    80004378:	ec86                	sd	ra,88(sp)
    8000437a:	e8a2                	sd	s0,80(sp)
    8000437c:	e4a6                	sd	s1,72(sp)
    8000437e:	e0ca                	sd	s2,64(sp)
    80004380:	fc4e                	sd	s3,56(sp)
    80004382:	f852                	sd	s4,48(sp)
    80004384:	f456                	sd	s5,40(sp)
    80004386:	1080                	addi	s0,sp,96
    80004388:	84aa                	mv	s1,a0
    8000438a:	8aae                	mv	s5,a1
    8000438c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000438e:	d52fd0ef          	jal	800018e0 <myproc>
    80004392:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004394:	8526                	mv	a0,s1
    80004396:	85ffc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    8000439a:	0b405a63          	blez	s4,8000444e <pipewrite+0xd8>
    8000439e:	f05a                	sd	s6,32(sp)
    800043a0:	ec5e                	sd	s7,24(sp)
    800043a2:	e862                	sd	s8,16(sp)
  int i = 0;
    800043a4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800043a6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800043a8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800043ac:	21c48b93          	addi	s7,s1,540
    800043b0:	a81d                	j	800043e6 <pipewrite+0x70>
      release(&pi->lock);
    800043b2:	8526                	mv	a0,s1
    800043b4:	8d9fc0ef          	jal	80000c8c <release>
      return -1;
    800043b8:	597d                	li	s2,-1
    800043ba:	7b02                	ld	s6,32(sp)
    800043bc:	6be2                	ld	s7,24(sp)
    800043be:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800043c0:	854a                	mv	a0,s2
    800043c2:	60e6                	ld	ra,88(sp)
    800043c4:	6446                	ld	s0,80(sp)
    800043c6:	64a6                	ld	s1,72(sp)
    800043c8:	6906                	ld	s2,64(sp)
    800043ca:	79e2                	ld	s3,56(sp)
    800043cc:	7a42                	ld	s4,48(sp)
    800043ce:	7aa2                	ld	s5,40(sp)
    800043d0:	6125                	addi	sp,sp,96
    800043d2:	8082                	ret
      wakeup(&pi->nread);
    800043d4:	8562                	mv	a0,s8
    800043d6:	baffd0ef          	jal	80001f84 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800043da:	85a6                	mv	a1,s1
    800043dc:	855e                	mv	a0,s7
    800043de:	b5bfd0ef          	jal	80001f38 <sleep>
  while(i < n){
    800043e2:	05495b63          	bge	s2,s4,80004438 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800043e6:	2204a783          	lw	a5,544(s1)
    800043ea:	d7e1                	beqz	a5,800043b2 <pipewrite+0x3c>
    800043ec:	854e                	mv	a0,s3
    800043ee:	d83fd0ef          	jal	80002170 <killed>
    800043f2:	f161                	bnez	a0,800043b2 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800043f4:	2184a783          	lw	a5,536(s1)
    800043f8:	21c4a703          	lw	a4,540(s1)
    800043fc:	2007879b          	addiw	a5,a5,512
    80004400:	fcf70ae3          	beq	a4,a5,800043d4 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004404:	4685                	li	a3,1
    80004406:	01590633          	add	a2,s2,s5
    8000440a:	faf40593          	addi	a1,s0,-81
    8000440e:	0509b503          	ld	a0,80(s3)
    80004412:	a16fd0ef          	jal	80001628 <copyin>
    80004416:	03650e63          	beq	a0,s6,80004452 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000441a:	21c4a783          	lw	a5,540(s1)
    8000441e:	0017871b          	addiw	a4,a5,1
    80004422:	20e4ae23          	sw	a4,540(s1)
    80004426:	1ff7f793          	andi	a5,a5,511
    8000442a:	97a6                	add	a5,a5,s1
    8000442c:	faf44703          	lbu	a4,-81(s0)
    80004430:	00e78c23          	sb	a4,24(a5)
      i++;
    80004434:	2905                	addiw	s2,s2,1
    80004436:	b775                	j	800043e2 <pipewrite+0x6c>
    80004438:	7b02                	ld	s6,32(sp)
    8000443a:	6be2                	ld	s7,24(sp)
    8000443c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000443e:	21848513          	addi	a0,s1,536
    80004442:	b43fd0ef          	jal	80001f84 <wakeup>
  release(&pi->lock);
    80004446:	8526                	mv	a0,s1
    80004448:	845fc0ef          	jal	80000c8c <release>
  return i;
    8000444c:	bf95                	j	800043c0 <pipewrite+0x4a>
  int i = 0;
    8000444e:	4901                	li	s2,0
    80004450:	b7fd                	j	8000443e <pipewrite+0xc8>
    80004452:	7b02                	ld	s6,32(sp)
    80004454:	6be2                	ld	s7,24(sp)
    80004456:	6c42                	ld	s8,16(sp)
    80004458:	b7dd                	j	8000443e <pipewrite+0xc8>

000000008000445a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000445a:	715d                	addi	sp,sp,-80
    8000445c:	e486                	sd	ra,72(sp)
    8000445e:	e0a2                	sd	s0,64(sp)
    80004460:	fc26                	sd	s1,56(sp)
    80004462:	f84a                	sd	s2,48(sp)
    80004464:	f44e                	sd	s3,40(sp)
    80004466:	f052                	sd	s4,32(sp)
    80004468:	ec56                	sd	s5,24(sp)
    8000446a:	0880                	addi	s0,sp,80
    8000446c:	84aa                	mv	s1,a0
    8000446e:	892e                	mv	s2,a1
    80004470:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004472:	c6efd0ef          	jal	800018e0 <myproc>
    80004476:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004478:	8526                	mv	a0,s1
    8000447a:	f7afc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000447e:	2184a703          	lw	a4,536(s1)
    80004482:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004486:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000448a:	02f71563          	bne	a4,a5,800044b4 <piperead+0x5a>
    8000448e:	2244a783          	lw	a5,548(s1)
    80004492:	cb85                	beqz	a5,800044c2 <piperead+0x68>
    if(killed(pr)){
    80004494:	8552                	mv	a0,s4
    80004496:	cdbfd0ef          	jal	80002170 <killed>
    8000449a:	ed19                	bnez	a0,800044b8 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000449c:	85a6                	mv	a1,s1
    8000449e:	854e                	mv	a0,s3
    800044a0:	a99fd0ef          	jal	80001f38 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800044a4:	2184a703          	lw	a4,536(s1)
    800044a8:	21c4a783          	lw	a5,540(s1)
    800044ac:	fef701e3          	beq	a4,a5,8000448e <piperead+0x34>
    800044b0:	e85a                	sd	s6,16(sp)
    800044b2:	a809                	j	800044c4 <piperead+0x6a>
    800044b4:	e85a                	sd	s6,16(sp)
    800044b6:	a039                	j	800044c4 <piperead+0x6a>
      release(&pi->lock);
    800044b8:	8526                	mv	a0,s1
    800044ba:	fd2fc0ef          	jal	80000c8c <release>
      return -1;
    800044be:	59fd                	li	s3,-1
    800044c0:	a8b1                	j	8000451c <piperead+0xc2>
    800044c2:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800044c4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800044c6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800044c8:	05505263          	blez	s5,8000450c <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800044cc:	2184a783          	lw	a5,536(s1)
    800044d0:	21c4a703          	lw	a4,540(s1)
    800044d4:	02f70c63          	beq	a4,a5,8000450c <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800044d8:	0017871b          	addiw	a4,a5,1
    800044dc:	20e4ac23          	sw	a4,536(s1)
    800044e0:	1ff7f793          	andi	a5,a5,511
    800044e4:	97a6                	add	a5,a5,s1
    800044e6:	0187c783          	lbu	a5,24(a5)
    800044ea:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800044ee:	4685                	li	a3,1
    800044f0:	fbf40613          	addi	a2,s0,-65
    800044f4:	85ca                	mv	a1,s2
    800044f6:	050a3503          	ld	a0,80(s4)
    800044fa:	858fd0ef          	jal	80001552 <copyout>
    800044fe:	01650763          	beq	a0,s6,8000450c <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004502:	2985                	addiw	s3,s3,1
    80004504:	0905                	addi	s2,s2,1
    80004506:	fd3a93e3          	bne	s5,s3,800044cc <piperead+0x72>
    8000450a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000450c:	21c48513          	addi	a0,s1,540
    80004510:	a75fd0ef          	jal	80001f84 <wakeup>
  release(&pi->lock);
    80004514:	8526                	mv	a0,s1
    80004516:	f76fc0ef          	jal	80000c8c <release>
    8000451a:	6b42                	ld	s6,16(sp)
  return i;
}
    8000451c:	854e                	mv	a0,s3
    8000451e:	60a6                	ld	ra,72(sp)
    80004520:	6406                	ld	s0,64(sp)
    80004522:	74e2                	ld	s1,56(sp)
    80004524:	7942                	ld	s2,48(sp)
    80004526:	79a2                	ld	s3,40(sp)
    80004528:	7a02                	ld	s4,32(sp)
    8000452a:	6ae2                	ld	s5,24(sp)
    8000452c:	6161                	addi	sp,sp,80
    8000452e:	8082                	ret

0000000080004530 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004530:	1141                	addi	sp,sp,-16
    80004532:	e422                	sd	s0,8(sp)
    80004534:	0800                	addi	s0,sp,16
    80004536:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004538:	8905                	andi	a0,a0,1
    8000453a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000453c:	8b89                	andi	a5,a5,2
    8000453e:	c399                	beqz	a5,80004544 <flags2perm+0x14>
      perm |= PTE_W;
    80004540:	00456513          	ori	a0,a0,4
    return perm;
}
    80004544:	6422                	ld	s0,8(sp)
    80004546:	0141                	addi	sp,sp,16
    80004548:	8082                	ret

000000008000454a <exec>:

int
exec(char *path, char **argv)
{
    8000454a:	df010113          	addi	sp,sp,-528
    8000454e:	20113423          	sd	ra,520(sp)
    80004552:	20813023          	sd	s0,512(sp)
    80004556:	ffa6                	sd	s1,504(sp)
    80004558:	fbca                	sd	s2,496(sp)
    8000455a:	0c00                	addi	s0,sp,528
    8000455c:	892a                	mv	s2,a0
    8000455e:	dea43c23          	sd	a0,-520(s0)
    80004562:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004566:	b7afd0ef          	jal	800018e0 <myproc>
    8000456a:	84aa                	mv	s1,a0

  begin_op();
    8000456c:	dc6ff0ef          	jal	80003b32 <begin_op>

  if((ip = namei(path)) == 0){
    80004570:	854a                	mv	a0,s2
    80004572:	c04ff0ef          	jal	80003976 <namei>
    80004576:	c931                	beqz	a0,800045ca <exec+0x80>
    80004578:	f3d2                	sd	s4,480(sp)
    8000457a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000457c:	d21fe0ef          	jal	8000329c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004580:	04000713          	li	a4,64
    80004584:	4681                	li	a3,0
    80004586:	e5040613          	addi	a2,s0,-432
    8000458a:	4581                	li	a1,0
    8000458c:	8552                	mv	a0,s4
    8000458e:	f63fe0ef          	jal	800034f0 <readi>
    80004592:	04000793          	li	a5,64
    80004596:	00f51a63          	bne	a0,a5,800045aa <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000459a:	e5042703          	lw	a4,-432(s0)
    8000459e:	464c47b7          	lui	a5,0x464c4
    800045a2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800045a6:	02f70663          	beq	a4,a5,800045d2 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800045aa:	8552                	mv	a0,s4
    800045ac:	efbfe0ef          	jal	800034a6 <iunlockput>
    end_op();
    800045b0:	decff0ef          	jal	80003b9c <end_op>
  }
  return -1;
    800045b4:	557d                	li	a0,-1
    800045b6:	7a1e                	ld	s4,480(sp)
}
    800045b8:	20813083          	ld	ra,520(sp)
    800045bc:	20013403          	ld	s0,512(sp)
    800045c0:	74fe                	ld	s1,504(sp)
    800045c2:	795e                	ld	s2,496(sp)
    800045c4:	21010113          	addi	sp,sp,528
    800045c8:	8082                	ret
    end_op();
    800045ca:	dd2ff0ef          	jal	80003b9c <end_op>
    return -1;
    800045ce:	557d                	li	a0,-1
    800045d0:	b7e5                	j	800045b8 <exec+0x6e>
    800045d2:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800045d4:	8526                	mv	a0,s1
    800045d6:	bb2fd0ef          	jal	80001988 <proc_pagetable>
    800045da:	8b2a                	mv	s6,a0
    800045dc:	2c050b63          	beqz	a0,800048b2 <exec+0x368>
    800045e0:	f7ce                	sd	s3,488(sp)
    800045e2:	efd6                	sd	s5,472(sp)
    800045e4:	e7de                	sd	s7,456(sp)
    800045e6:	e3e2                	sd	s8,448(sp)
    800045e8:	ff66                	sd	s9,440(sp)
    800045ea:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045ec:	e7042d03          	lw	s10,-400(s0)
    800045f0:	e8845783          	lhu	a5,-376(s0)
    800045f4:	12078963          	beqz	a5,80004726 <exec+0x1dc>
    800045f8:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045fa:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045fc:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800045fe:	6c85                	lui	s9,0x1
    80004600:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004604:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004608:	6a85                	lui	s5,0x1
    8000460a:	a085                	j	8000466a <exec+0x120>
      panic("loadseg: address should exist");
    8000460c:	00003517          	auipc	a0,0x3
    80004610:	ff450513          	addi	a0,a0,-12 # 80007600 <etext+0x600>
    80004614:	980fc0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    80004618:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000461a:	8726                	mv	a4,s1
    8000461c:	012c06bb          	addw	a3,s8,s2
    80004620:	4581                	li	a1,0
    80004622:	8552                	mv	a0,s4
    80004624:	ecdfe0ef          	jal	800034f0 <readi>
    80004628:	2501                	sext.w	a0,a0
    8000462a:	24a49a63          	bne	s1,a0,8000487e <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    8000462e:	012a893b          	addw	s2,s5,s2
    80004632:	03397363          	bgeu	s2,s3,80004658 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004636:	02091593          	slli	a1,s2,0x20
    8000463a:	9181                	srli	a1,a1,0x20
    8000463c:	95de                	add	a1,a1,s7
    8000463e:	855a                	mv	a0,s6
    80004640:	997fc0ef          	jal	80000fd6 <walkaddr>
    80004644:	862a                	mv	a2,a0
    if(pa == 0)
    80004646:	d179                	beqz	a0,8000460c <exec+0xc2>
    if(sz - i < PGSIZE)
    80004648:	412984bb          	subw	s1,s3,s2
    8000464c:	0004879b          	sext.w	a5,s1
    80004650:	fcfcf4e3          	bgeu	s9,a5,80004618 <exec+0xce>
    80004654:	84d6                	mv	s1,s5
    80004656:	b7c9                	j	80004618 <exec+0xce>
    sz = sz1;
    80004658:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000465c:	2d85                	addiw	s11,s11,1
    8000465e:	038d0d1b          	addiw	s10,s10,56
    80004662:	e8845783          	lhu	a5,-376(s0)
    80004666:	08fdd063          	bge	s11,a5,800046e6 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000466a:	2d01                	sext.w	s10,s10
    8000466c:	03800713          	li	a4,56
    80004670:	86ea                	mv	a3,s10
    80004672:	e1840613          	addi	a2,s0,-488
    80004676:	4581                	li	a1,0
    80004678:	8552                	mv	a0,s4
    8000467a:	e77fe0ef          	jal	800034f0 <readi>
    8000467e:	03800793          	li	a5,56
    80004682:	1cf51663          	bne	a0,a5,8000484e <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004686:	e1842783          	lw	a5,-488(s0)
    8000468a:	4705                	li	a4,1
    8000468c:	fce798e3          	bne	a5,a4,8000465c <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004690:	e4043483          	ld	s1,-448(s0)
    80004694:	e3843783          	ld	a5,-456(s0)
    80004698:	1af4ef63          	bltu	s1,a5,80004856 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000469c:	e2843783          	ld	a5,-472(s0)
    800046a0:	94be                	add	s1,s1,a5
    800046a2:	1af4ee63          	bltu	s1,a5,8000485e <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    800046a6:	df043703          	ld	a4,-528(s0)
    800046aa:	8ff9                	and	a5,a5,a4
    800046ac:	1a079d63          	bnez	a5,80004866 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800046b0:	e1c42503          	lw	a0,-484(s0)
    800046b4:	e7dff0ef          	jal	80004530 <flags2perm>
    800046b8:	86aa                	mv	a3,a0
    800046ba:	8626                	mv	a2,s1
    800046bc:	85ca                	mv	a1,s2
    800046be:	855a                	mv	a0,s6
    800046c0:	c7ffc0ef          	jal	8000133e <uvmalloc>
    800046c4:	e0a43423          	sd	a0,-504(s0)
    800046c8:	1a050363          	beqz	a0,8000486e <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800046cc:	e2843b83          	ld	s7,-472(s0)
    800046d0:	e2042c03          	lw	s8,-480(s0)
    800046d4:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800046d8:	00098463          	beqz	s3,800046e0 <exec+0x196>
    800046dc:	4901                	li	s2,0
    800046de:	bfa1                	j	80004636 <exec+0xec>
    sz = sz1;
    800046e0:	e0843903          	ld	s2,-504(s0)
    800046e4:	bfa5                	j	8000465c <exec+0x112>
    800046e6:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800046e8:	8552                	mv	a0,s4
    800046ea:	dbdfe0ef          	jal	800034a6 <iunlockput>
  end_op();
    800046ee:	caeff0ef          	jal	80003b9c <end_op>
  p = myproc();
    800046f2:	9eefd0ef          	jal	800018e0 <myproc>
    800046f6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800046f8:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800046fc:	6985                	lui	s3,0x1
    800046fe:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004700:	99ca                	add	s3,s3,s2
    80004702:	77fd                	lui	a5,0xfffff
    80004704:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004708:	4691                	li	a3,4
    8000470a:	6609                	lui	a2,0x2
    8000470c:	964e                	add	a2,a2,s3
    8000470e:	85ce                	mv	a1,s3
    80004710:	855a                	mv	a0,s6
    80004712:	c2dfc0ef          	jal	8000133e <uvmalloc>
    80004716:	892a                	mv	s2,a0
    80004718:	e0a43423          	sd	a0,-504(s0)
    8000471c:	e519                	bnez	a0,8000472a <exec+0x1e0>
  if(pagetable)
    8000471e:	e1343423          	sd	s3,-504(s0)
    80004722:	4a01                	li	s4,0
    80004724:	aab1                	j	80004880 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004726:	4901                	li	s2,0
    80004728:	b7c1                	j	800046e8 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000472a:	75f9                	lui	a1,0xffffe
    8000472c:	95aa                	add	a1,a1,a0
    8000472e:	855a                	mv	a0,s6
    80004730:	df9fc0ef          	jal	80001528 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004734:	7bfd                	lui	s7,0xfffff
    80004736:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004738:	e0043783          	ld	a5,-512(s0)
    8000473c:	6388                	ld	a0,0(a5)
    8000473e:	cd39                	beqz	a0,8000479c <exec+0x252>
    80004740:	e9040993          	addi	s3,s0,-368
    80004744:	f9040c13          	addi	s8,s0,-112
    80004748:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000474a:	eeefc0ef          	jal	80000e38 <strlen>
    8000474e:	0015079b          	addiw	a5,a0,1
    80004752:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004756:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000475a:	11796e63          	bltu	s2,s7,80004876 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000475e:	e0043d03          	ld	s10,-512(s0)
    80004762:	000d3a03          	ld	s4,0(s10)
    80004766:	8552                	mv	a0,s4
    80004768:	ed0fc0ef          	jal	80000e38 <strlen>
    8000476c:	0015069b          	addiw	a3,a0,1
    80004770:	8652                	mv	a2,s4
    80004772:	85ca                	mv	a1,s2
    80004774:	855a                	mv	a0,s6
    80004776:	dddfc0ef          	jal	80001552 <copyout>
    8000477a:	10054063          	bltz	a0,8000487a <exec+0x330>
    ustack[argc] = sp;
    8000477e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004782:	0485                	addi	s1,s1,1
    80004784:	008d0793          	addi	a5,s10,8
    80004788:	e0f43023          	sd	a5,-512(s0)
    8000478c:	008d3503          	ld	a0,8(s10)
    80004790:	c909                	beqz	a0,800047a2 <exec+0x258>
    if(argc >= MAXARG)
    80004792:	09a1                	addi	s3,s3,8
    80004794:	fb899be3          	bne	s3,s8,8000474a <exec+0x200>
  ip = 0;
    80004798:	4a01                	li	s4,0
    8000479a:	a0dd                	j	80004880 <exec+0x336>
  sp = sz;
    8000479c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800047a0:	4481                	li	s1,0
  ustack[argc] = 0;
    800047a2:	00349793          	slli	a5,s1,0x3
    800047a6:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffde320>
    800047aa:	97a2                	add	a5,a5,s0
    800047ac:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800047b0:	00148693          	addi	a3,s1,1
    800047b4:	068e                	slli	a3,a3,0x3
    800047b6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800047ba:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800047be:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800047c2:	f5796ee3          	bltu	s2,s7,8000471e <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800047c6:	e9040613          	addi	a2,s0,-368
    800047ca:	85ca                	mv	a1,s2
    800047cc:	855a                	mv	a0,s6
    800047ce:	d85fc0ef          	jal	80001552 <copyout>
    800047d2:	0e054263          	bltz	a0,800048b6 <exec+0x36c>
  p->trapframe->a1 = sp;
    800047d6:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800047da:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800047de:	df843783          	ld	a5,-520(s0)
    800047e2:	0007c703          	lbu	a4,0(a5)
    800047e6:	cf11                	beqz	a4,80004802 <exec+0x2b8>
    800047e8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800047ea:	02f00693          	li	a3,47
    800047ee:	a039                	j	800047fc <exec+0x2b2>
      last = s+1;
    800047f0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800047f4:	0785                	addi	a5,a5,1
    800047f6:	fff7c703          	lbu	a4,-1(a5)
    800047fa:	c701                	beqz	a4,80004802 <exec+0x2b8>
    if(*s == '/')
    800047fc:	fed71ce3          	bne	a4,a3,800047f4 <exec+0x2aa>
    80004800:	bfc5                	j	800047f0 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004802:	4641                	li	a2,16
    80004804:	df843583          	ld	a1,-520(s0)
    80004808:	158a8513          	addi	a0,s5,344
    8000480c:	dfafc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    80004810:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004814:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004818:	e0843783          	ld	a5,-504(s0)
    8000481c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004820:	058ab783          	ld	a5,88(s5)
    80004824:	e6843703          	ld	a4,-408(s0)
    80004828:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000482a:	058ab783          	ld	a5,88(s5)
    8000482e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004832:	85e6                	mv	a1,s9
    80004834:	9d8fd0ef          	jal	80001a0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004838:	0004851b          	sext.w	a0,s1
    8000483c:	79be                	ld	s3,488(sp)
    8000483e:	7a1e                	ld	s4,480(sp)
    80004840:	6afe                	ld	s5,472(sp)
    80004842:	6b5e                	ld	s6,464(sp)
    80004844:	6bbe                	ld	s7,456(sp)
    80004846:	6c1e                	ld	s8,448(sp)
    80004848:	7cfa                	ld	s9,440(sp)
    8000484a:	7d5a                	ld	s10,432(sp)
    8000484c:	b3b5                	j	800045b8 <exec+0x6e>
    8000484e:	e1243423          	sd	s2,-504(s0)
    80004852:	7dba                	ld	s11,424(sp)
    80004854:	a035                	j	80004880 <exec+0x336>
    80004856:	e1243423          	sd	s2,-504(s0)
    8000485a:	7dba                	ld	s11,424(sp)
    8000485c:	a015                	j	80004880 <exec+0x336>
    8000485e:	e1243423          	sd	s2,-504(s0)
    80004862:	7dba                	ld	s11,424(sp)
    80004864:	a831                	j	80004880 <exec+0x336>
    80004866:	e1243423          	sd	s2,-504(s0)
    8000486a:	7dba                	ld	s11,424(sp)
    8000486c:	a811                	j	80004880 <exec+0x336>
    8000486e:	e1243423          	sd	s2,-504(s0)
    80004872:	7dba                	ld	s11,424(sp)
    80004874:	a031                	j	80004880 <exec+0x336>
  ip = 0;
    80004876:	4a01                	li	s4,0
    80004878:	a021                	j	80004880 <exec+0x336>
    8000487a:	4a01                	li	s4,0
  if(pagetable)
    8000487c:	a011                	j	80004880 <exec+0x336>
    8000487e:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004880:	e0843583          	ld	a1,-504(s0)
    80004884:	855a                	mv	a0,s6
    80004886:	986fd0ef          	jal	80001a0c <proc_freepagetable>
  return -1;
    8000488a:	557d                	li	a0,-1
  if(ip){
    8000488c:	000a1b63          	bnez	s4,800048a2 <exec+0x358>
    80004890:	79be                	ld	s3,488(sp)
    80004892:	7a1e                	ld	s4,480(sp)
    80004894:	6afe                	ld	s5,472(sp)
    80004896:	6b5e                	ld	s6,464(sp)
    80004898:	6bbe                	ld	s7,456(sp)
    8000489a:	6c1e                	ld	s8,448(sp)
    8000489c:	7cfa                	ld	s9,440(sp)
    8000489e:	7d5a                	ld	s10,432(sp)
    800048a0:	bb21                	j	800045b8 <exec+0x6e>
    800048a2:	79be                	ld	s3,488(sp)
    800048a4:	6afe                	ld	s5,472(sp)
    800048a6:	6b5e                	ld	s6,464(sp)
    800048a8:	6bbe                	ld	s7,456(sp)
    800048aa:	6c1e                	ld	s8,448(sp)
    800048ac:	7cfa                	ld	s9,440(sp)
    800048ae:	7d5a                	ld	s10,432(sp)
    800048b0:	b9ed                	j	800045aa <exec+0x60>
    800048b2:	6b5e                	ld	s6,464(sp)
    800048b4:	b9dd                	j	800045aa <exec+0x60>
  sz = sz1;
    800048b6:	e0843983          	ld	s3,-504(s0)
    800048ba:	b595                	j	8000471e <exec+0x1d4>

00000000800048bc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800048bc:	7179                	addi	sp,sp,-48
    800048be:	f406                	sd	ra,40(sp)
    800048c0:	f022                	sd	s0,32(sp)
    800048c2:	ec26                	sd	s1,24(sp)
    800048c4:	e84a                	sd	s2,16(sp)
    800048c6:	1800                	addi	s0,sp,48
    800048c8:	892e                	mv	s2,a1
    800048ca:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800048cc:	fdc40593          	addi	a1,s0,-36
    800048d0:	f65fd0ef          	jal	80002834 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800048d4:	fdc42703          	lw	a4,-36(s0)
    800048d8:	47bd                	li	a5,15
    800048da:	02e7e963          	bltu	a5,a4,8000490c <argfd+0x50>
    800048de:	802fd0ef          	jal	800018e0 <myproc>
    800048e2:	fdc42703          	lw	a4,-36(s0)
    800048e6:	01a70793          	addi	a5,a4,26
    800048ea:	078e                	slli	a5,a5,0x3
    800048ec:	953e                	add	a0,a0,a5
    800048ee:	611c                	ld	a5,0(a0)
    800048f0:	c385                	beqz	a5,80004910 <argfd+0x54>
    return -1;
  if(pfd)
    800048f2:	00090463          	beqz	s2,800048fa <argfd+0x3e>
    *pfd = fd;
    800048f6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800048fa:	4501                	li	a0,0
  if(pf)
    800048fc:	c091                	beqz	s1,80004900 <argfd+0x44>
    *pf = f;
    800048fe:	e09c                	sd	a5,0(s1)
}
    80004900:	70a2                	ld	ra,40(sp)
    80004902:	7402                	ld	s0,32(sp)
    80004904:	64e2                	ld	s1,24(sp)
    80004906:	6942                	ld	s2,16(sp)
    80004908:	6145                	addi	sp,sp,48
    8000490a:	8082                	ret
    return -1;
    8000490c:	557d                	li	a0,-1
    8000490e:	bfcd                	j	80004900 <argfd+0x44>
    80004910:	557d                	li	a0,-1
    80004912:	b7fd                	j	80004900 <argfd+0x44>

0000000080004914 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004914:	1101                	addi	sp,sp,-32
    80004916:	ec06                	sd	ra,24(sp)
    80004918:	e822                	sd	s0,16(sp)
    8000491a:	e426                	sd	s1,8(sp)
    8000491c:	1000                	addi	s0,sp,32
    8000491e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004920:	fc1fc0ef          	jal	800018e0 <myproc>
    80004924:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004926:	0d050793          	addi	a5,a0,208
    8000492a:	4501                	li	a0,0
    8000492c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000492e:	6398                	ld	a4,0(a5)
    80004930:	cb19                	beqz	a4,80004946 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004932:	2505                	addiw	a0,a0,1
    80004934:	07a1                	addi	a5,a5,8
    80004936:	fed51ce3          	bne	a0,a3,8000492e <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000493a:	557d                	li	a0,-1
}
    8000493c:	60e2                	ld	ra,24(sp)
    8000493e:	6442                	ld	s0,16(sp)
    80004940:	64a2                	ld	s1,8(sp)
    80004942:	6105                	addi	sp,sp,32
    80004944:	8082                	ret
      p->ofile[fd] = f;
    80004946:	01a50793          	addi	a5,a0,26
    8000494a:	078e                	slli	a5,a5,0x3
    8000494c:	963e                	add	a2,a2,a5
    8000494e:	e204                	sd	s1,0(a2)
      return fd;
    80004950:	b7f5                	j	8000493c <fdalloc+0x28>

0000000080004952 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004952:	715d                	addi	sp,sp,-80
    80004954:	e486                	sd	ra,72(sp)
    80004956:	e0a2                	sd	s0,64(sp)
    80004958:	fc26                	sd	s1,56(sp)
    8000495a:	f84a                	sd	s2,48(sp)
    8000495c:	f44e                	sd	s3,40(sp)
    8000495e:	ec56                	sd	s5,24(sp)
    80004960:	e85a                	sd	s6,16(sp)
    80004962:	0880                	addi	s0,sp,80
    80004964:	8b2e                	mv	s6,a1
    80004966:	89b2                	mv	s3,a2
    80004968:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000496a:	fb040593          	addi	a1,s0,-80
    8000496e:	822ff0ef          	jal	80003990 <nameiparent>
    80004972:	84aa                	mv	s1,a0
    80004974:	10050a63          	beqz	a0,80004a88 <create+0x136>
    return 0;

  ilock(dp);
    80004978:	925fe0ef          	jal	8000329c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000497c:	4601                	li	a2,0
    8000497e:	fb040593          	addi	a1,s0,-80
    80004982:	8526                	mv	a0,s1
    80004984:	d8dfe0ef          	jal	80003710 <dirlookup>
    80004988:	8aaa                	mv	s5,a0
    8000498a:	c129                	beqz	a0,800049cc <create+0x7a>
    iunlockput(dp);
    8000498c:	8526                	mv	a0,s1
    8000498e:	b19fe0ef          	jal	800034a6 <iunlockput>
    ilock(ip);
    80004992:	8556                	mv	a0,s5
    80004994:	909fe0ef          	jal	8000329c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004998:	4789                	li	a5,2
    8000499a:	02fb1463          	bne	s6,a5,800049c2 <create+0x70>
    8000499e:	044ad783          	lhu	a5,68(s5)
    800049a2:	37f9                	addiw	a5,a5,-2
    800049a4:	17c2                	slli	a5,a5,0x30
    800049a6:	93c1                	srli	a5,a5,0x30
    800049a8:	4705                	li	a4,1
    800049aa:	00f76c63          	bltu	a4,a5,800049c2 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800049ae:	8556                	mv	a0,s5
    800049b0:	60a6                	ld	ra,72(sp)
    800049b2:	6406                	ld	s0,64(sp)
    800049b4:	74e2                	ld	s1,56(sp)
    800049b6:	7942                	ld	s2,48(sp)
    800049b8:	79a2                	ld	s3,40(sp)
    800049ba:	6ae2                	ld	s5,24(sp)
    800049bc:	6b42                	ld	s6,16(sp)
    800049be:	6161                	addi	sp,sp,80
    800049c0:	8082                	ret
    iunlockput(ip);
    800049c2:	8556                	mv	a0,s5
    800049c4:	ae3fe0ef          	jal	800034a6 <iunlockput>
    return 0;
    800049c8:	4a81                	li	s5,0
    800049ca:	b7d5                	j	800049ae <create+0x5c>
    800049cc:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800049ce:	85da                	mv	a1,s6
    800049d0:	4088                	lw	a0,0(s1)
    800049d2:	f5afe0ef          	jal	8000312c <ialloc>
    800049d6:	8a2a                	mv	s4,a0
    800049d8:	cd15                	beqz	a0,80004a14 <create+0xc2>
  ilock(ip);
    800049da:	8c3fe0ef          	jal	8000329c <ilock>
  ip->major = major;
    800049de:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800049e2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800049e6:	4905                	li	s2,1
    800049e8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800049ec:	8552                	mv	a0,s4
    800049ee:	ffafe0ef          	jal	800031e8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800049f2:	032b0763          	beq	s6,s2,80004a20 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800049f6:	004a2603          	lw	a2,4(s4)
    800049fa:	fb040593          	addi	a1,s0,-80
    800049fe:	8526                	mv	a0,s1
    80004a00:	eddfe0ef          	jal	800038dc <dirlink>
    80004a04:	06054563          	bltz	a0,80004a6e <create+0x11c>
  iunlockput(dp);
    80004a08:	8526                	mv	a0,s1
    80004a0a:	a9dfe0ef          	jal	800034a6 <iunlockput>
  return ip;
    80004a0e:	8ad2                	mv	s5,s4
    80004a10:	7a02                	ld	s4,32(sp)
    80004a12:	bf71                	j	800049ae <create+0x5c>
    iunlockput(dp);
    80004a14:	8526                	mv	a0,s1
    80004a16:	a91fe0ef          	jal	800034a6 <iunlockput>
    return 0;
    80004a1a:	8ad2                	mv	s5,s4
    80004a1c:	7a02                	ld	s4,32(sp)
    80004a1e:	bf41                	j	800049ae <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004a20:	004a2603          	lw	a2,4(s4)
    80004a24:	00003597          	auipc	a1,0x3
    80004a28:	bfc58593          	addi	a1,a1,-1028 # 80007620 <etext+0x620>
    80004a2c:	8552                	mv	a0,s4
    80004a2e:	eaffe0ef          	jal	800038dc <dirlink>
    80004a32:	02054e63          	bltz	a0,80004a6e <create+0x11c>
    80004a36:	40d0                	lw	a2,4(s1)
    80004a38:	00003597          	auipc	a1,0x3
    80004a3c:	bf058593          	addi	a1,a1,-1040 # 80007628 <etext+0x628>
    80004a40:	8552                	mv	a0,s4
    80004a42:	e9bfe0ef          	jal	800038dc <dirlink>
    80004a46:	02054463          	bltz	a0,80004a6e <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004a4a:	004a2603          	lw	a2,4(s4)
    80004a4e:	fb040593          	addi	a1,s0,-80
    80004a52:	8526                	mv	a0,s1
    80004a54:	e89fe0ef          	jal	800038dc <dirlink>
    80004a58:	00054b63          	bltz	a0,80004a6e <create+0x11c>
    dp->nlink++;  // for ".."
    80004a5c:	04a4d783          	lhu	a5,74(s1)
    80004a60:	2785                	addiw	a5,a5,1
    80004a62:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a66:	8526                	mv	a0,s1
    80004a68:	f80fe0ef          	jal	800031e8 <iupdate>
    80004a6c:	bf71                	j	80004a08 <create+0xb6>
  ip->nlink = 0;
    80004a6e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004a72:	8552                	mv	a0,s4
    80004a74:	f74fe0ef          	jal	800031e8 <iupdate>
  iunlockput(ip);
    80004a78:	8552                	mv	a0,s4
    80004a7a:	a2dfe0ef          	jal	800034a6 <iunlockput>
  iunlockput(dp);
    80004a7e:	8526                	mv	a0,s1
    80004a80:	a27fe0ef          	jal	800034a6 <iunlockput>
  return 0;
    80004a84:	7a02                	ld	s4,32(sp)
    80004a86:	b725                	j	800049ae <create+0x5c>
    return 0;
    80004a88:	8aaa                	mv	s5,a0
    80004a8a:	b715                	j	800049ae <create+0x5c>

0000000080004a8c <sys_dup>:
{
    80004a8c:	7179                	addi	sp,sp,-48
    80004a8e:	f406                	sd	ra,40(sp)
    80004a90:	f022                	sd	s0,32(sp)
    80004a92:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004a94:	fd840613          	addi	a2,s0,-40
    80004a98:	4581                	li	a1,0
    80004a9a:	4501                	li	a0,0
    80004a9c:	e21ff0ef          	jal	800048bc <argfd>
    return -1;
    80004aa0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004aa2:	02054363          	bltz	a0,80004ac8 <sys_dup+0x3c>
    80004aa6:	ec26                	sd	s1,24(sp)
    80004aa8:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004aaa:	fd843903          	ld	s2,-40(s0)
    80004aae:	854a                	mv	a0,s2
    80004ab0:	e65ff0ef          	jal	80004914 <fdalloc>
    80004ab4:	84aa                	mv	s1,a0
    return -1;
    80004ab6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004ab8:	00054d63          	bltz	a0,80004ad2 <sys_dup+0x46>
  filedup(f);
    80004abc:	854a                	mv	a0,s2
    80004abe:	c48ff0ef          	jal	80003f06 <filedup>
  return fd;
    80004ac2:	87a6                	mv	a5,s1
    80004ac4:	64e2                	ld	s1,24(sp)
    80004ac6:	6942                	ld	s2,16(sp)
}
    80004ac8:	853e                	mv	a0,a5
    80004aca:	70a2                	ld	ra,40(sp)
    80004acc:	7402                	ld	s0,32(sp)
    80004ace:	6145                	addi	sp,sp,48
    80004ad0:	8082                	ret
    80004ad2:	64e2                	ld	s1,24(sp)
    80004ad4:	6942                	ld	s2,16(sp)
    80004ad6:	bfcd                	j	80004ac8 <sys_dup+0x3c>

0000000080004ad8 <sys_read>:
{
    80004ad8:	7179                	addi	sp,sp,-48
    80004ada:	f406                	sd	ra,40(sp)
    80004adc:	f022                	sd	s0,32(sp)
    80004ade:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004ae0:	fd840593          	addi	a1,s0,-40
    80004ae4:	4505                	li	a0,1
    80004ae6:	d6bfd0ef          	jal	80002850 <argaddr>
  argint(2, &n);
    80004aea:	fe440593          	addi	a1,s0,-28
    80004aee:	4509                	li	a0,2
    80004af0:	d45fd0ef          	jal	80002834 <argint>
  if(argfd(0, 0, &f) < 0)
    80004af4:	fe840613          	addi	a2,s0,-24
    80004af8:	4581                	li	a1,0
    80004afa:	4501                	li	a0,0
    80004afc:	dc1ff0ef          	jal	800048bc <argfd>
    80004b00:	87aa                	mv	a5,a0
    return -1;
    80004b02:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b04:	0007ca63          	bltz	a5,80004b18 <sys_read+0x40>
  return fileread(f, p, n);
    80004b08:	fe442603          	lw	a2,-28(s0)
    80004b0c:	fd843583          	ld	a1,-40(s0)
    80004b10:	fe843503          	ld	a0,-24(s0)
    80004b14:	d58ff0ef          	jal	8000406c <fileread>
}
    80004b18:	70a2                	ld	ra,40(sp)
    80004b1a:	7402                	ld	s0,32(sp)
    80004b1c:	6145                	addi	sp,sp,48
    80004b1e:	8082                	ret

0000000080004b20 <sys_write>:
{
    80004b20:	7179                	addi	sp,sp,-48
    80004b22:	f406                	sd	ra,40(sp)
    80004b24:	f022                	sd	s0,32(sp)
    80004b26:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004b28:	fd840593          	addi	a1,s0,-40
    80004b2c:	4505                	li	a0,1
    80004b2e:	d23fd0ef          	jal	80002850 <argaddr>
  argint(2, &n);
    80004b32:	fe440593          	addi	a1,s0,-28
    80004b36:	4509                	li	a0,2
    80004b38:	cfdfd0ef          	jal	80002834 <argint>
  if(argfd(0, 0, &f) < 0)
    80004b3c:	fe840613          	addi	a2,s0,-24
    80004b40:	4581                	li	a1,0
    80004b42:	4501                	li	a0,0
    80004b44:	d79ff0ef          	jal	800048bc <argfd>
    80004b48:	87aa                	mv	a5,a0
    return -1;
    80004b4a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b4c:	0007ca63          	bltz	a5,80004b60 <sys_write+0x40>
  return filewrite(f, p, n);
    80004b50:	fe442603          	lw	a2,-28(s0)
    80004b54:	fd843583          	ld	a1,-40(s0)
    80004b58:	fe843503          	ld	a0,-24(s0)
    80004b5c:	dceff0ef          	jal	8000412a <filewrite>
}
    80004b60:	70a2                	ld	ra,40(sp)
    80004b62:	7402                	ld	s0,32(sp)
    80004b64:	6145                	addi	sp,sp,48
    80004b66:	8082                	ret

0000000080004b68 <sys_close>:
{
    80004b68:	1101                	addi	sp,sp,-32
    80004b6a:	ec06                	sd	ra,24(sp)
    80004b6c:	e822                	sd	s0,16(sp)
    80004b6e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004b70:	fe040613          	addi	a2,s0,-32
    80004b74:	fec40593          	addi	a1,s0,-20
    80004b78:	4501                	li	a0,0
    80004b7a:	d43ff0ef          	jal	800048bc <argfd>
    return -1;
    80004b7e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004b80:	02054063          	bltz	a0,80004ba0 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004b84:	d5dfc0ef          	jal	800018e0 <myproc>
    80004b88:	fec42783          	lw	a5,-20(s0)
    80004b8c:	07e9                	addi	a5,a5,26
    80004b8e:	078e                	slli	a5,a5,0x3
    80004b90:	953e                	add	a0,a0,a5
    80004b92:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004b96:	fe043503          	ld	a0,-32(s0)
    80004b9a:	bb2ff0ef          	jal	80003f4c <fileclose>
  return 0;
    80004b9e:	4781                	li	a5,0
}
    80004ba0:	853e                	mv	a0,a5
    80004ba2:	60e2                	ld	ra,24(sp)
    80004ba4:	6442                	ld	s0,16(sp)
    80004ba6:	6105                	addi	sp,sp,32
    80004ba8:	8082                	ret

0000000080004baa <sys_fstat>:
{
    80004baa:	1101                	addi	sp,sp,-32
    80004bac:	ec06                	sd	ra,24(sp)
    80004bae:	e822                	sd	s0,16(sp)
    80004bb0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004bb2:	fe040593          	addi	a1,s0,-32
    80004bb6:	4505                	li	a0,1
    80004bb8:	c99fd0ef          	jal	80002850 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004bbc:	fe840613          	addi	a2,s0,-24
    80004bc0:	4581                	li	a1,0
    80004bc2:	4501                	li	a0,0
    80004bc4:	cf9ff0ef          	jal	800048bc <argfd>
    80004bc8:	87aa                	mv	a5,a0
    return -1;
    80004bca:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004bcc:	0007c863          	bltz	a5,80004bdc <sys_fstat+0x32>
  return filestat(f, st);
    80004bd0:	fe043583          	ld	a1,-32(s0)
    80004bd4:	fe843503          	ld	a0,-24(s0)
    80004bd8:	c36ff0ef          	jal	8000400e <filestat>
}
    80004bdc:	60e2                	ld	ra,24(sp)
    80004bde:	6442                	ld	s0,16(sp)
    80004be0:	6105                	addi	sp,sp,32
    80004be2:	8082                	ret

0000000080004be4 <sys_link>:
{
    80004be4:	7169                	addi	sp,sp,-304
    80004be6:	f606                	sd	ra,296(sp)
    80004be8:	f222                	sd	s0,288(sp)
    80004bea:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bec:	08000613          	li	a2,128
    80004bf0:	ed040593          	addi	a1,s0,-304
    80004bf4:	4501                	li	a0,0
    80004bf6:	c77fd0ef          	jal	8000286c <argstr>
    return -1;
    80004bfa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bfc:	0c054e63          	bltz	a0,80004cd8 <sys_link+0xf4>
    80004c00:	08000613          	li	a2,128
    80004c04:	f5040593          	addi	a1,s0,-176
    80004c08:	4505                	li	a0,1
    80004c0a:	c63fd0ef          	jal	8000286c <argstr>
    return -1;
    80004c0e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c10:	0c054463          	bltz	a0,80004cd8 <sys_link+0xf4>
    80004c14:	ee26                	sd	s1,280(sp)
  begin_op();
    80004c16:	f1dfe0ef          	jal	80003b32 <begin_op>
  if((ip = namei(old)) == 0){
    80004c1a:	ed040513          	addi	a0,s0,-304
    80004c1e:	d59fe0ef          	jal	80003976 <namei>
    80004c22:	84aa                	mv	s1,a0
    80004c24:	c53d                	beqz	a0,80004c92 <sys_link+0xae>
  ilock(ip);
    80004c26:	e76fe0ef          	jal	8000329c <ilock>
  if(ip->type == T_DIR){
    80004c2a:	04449703          	lh	a4,68(s1)
    80004c2e:	4785                	li	a5,1
    80004c30:	06f70663          	beq	a4,a5,80004c9c <sys_link+0xb8>
    80004c34:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004c36:	04a4d783          	lhu	a5,74(s1)
    80004c3a:	2785                	addiw	a5,a5,1
    80004c3c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c40:	8526                	mv	a0,s1
    80004c42:	da6fe0ef          	jal	800031e8 <iupdate>
  iunlock(ip);
    80004c46:	8526                	mv	a0,s1
    80004c48:	f02fe0ef          	jal	8000334a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004c4c:	fd040593          	addi	a1,s0,-48
    80004c50:	f5040513          	addi	a0,s0,-176
    80004c54:	d3dfe0ef          	jal	80003990 <nameiparent>
    80004c58:	892a                	mv	s2,a0
    80004c5a:	cd21                	beqz	a0,80004cb2 <sys_link+0xce>
  ilock(dp);
    80004c5c:	e40fe0ef          	jal	8000329c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004c60:	00092703          	lw	a4,0(s2)
    80004c64:	409c                	lw	a5,0(s1)
    80004c66:	04f71363          	bne	a4,a5,80004cac <sys_link+0xc8>
    80004c6a:	40d0                	lw	a2,4(s1)
    80004c6c:	fd040593          	addi	a1,s0,-48
    80004c70:	854a                	mv	a0,s2
    80004c72:	c6bfe0ef          	jal	800038dc <dirlink>
    80004c76:	02054b63          	bltz	a0,80004cac <sys_link+0xc8>
  iunlockput(dp);
    80004c7a:	854a                	mv	a0,s2
    80004c7c:	82bfe0ef          	jal	800034a6 <iunlockput>
  iput(ip);
    80004c80:	8526                	mv	a0,s1
    80004c82:	f9cfe0ef          	jal	8000341e <iput>
  end_op();
    80004c86:	f17fe0ef          	jal	80003b9c <end_op>
  return 0;
    80004c8a:	4781                	li	a5,0
    80004c8c:	64f2                	ld	s1,280(sp)
    80004c8e:	6952                	ld	s2,272(sp)
    80004c90:	a0a1                	j	80004cd8 <sys_link+0xf4>
    end_op();
    80004c92:	f0bfe0ef          	jal	80003b9c <end_op>
    return -1;
    80004c96:	57fd                	li	a5,-1
    80004c98:	64f2                	ld	s1,280(sp)
    80004c9a:	a83d                	j	80004cd8 <sys_link+0xf4>
    iunlockput(ip);
    80004c9c:	8526                	mv	a0,s1
    80004c9e:	809fe0ef          	jal	800034a6 <iunlockput>
    end_op();
    80004ca2:	efbfe0ef          	jal	80003b9c <end_op>
    return -1;
    80004ca6:	57fd                	li	a5,-1
    80004ca8:	64f2                	ld	s1,280(sp)
    80004caa:	a03d                	j	80004cd8 <sys_link+0xf4>
    iunlockput(dp);
    80004cac:	854a                	mv	a0,s2
    80004cae:	ff8fe0ef          	jal	800034a6 <iunlockput>
  ilock(ip);
    80004cb2:	8526                	mv	a0,s1
    80004cb4:	de8fe0ef          	jal	8000329c <ilock>
  ip->nlink--;
    80004cb8:	04a4d783          	lhu	a5,74(s1)
    80004cbc:	37fd                	addiw	a5,a5,-1
    80004cbe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004cc2:	8526                	mv	a0,s1
    80004cc4:	d24fe0ef          	jal	800031e8 <iupdate>
  iunlockput(ip);
    80004cc8:	8526                	mv	a0,s1
    80004cca:	fdcfe0ef          	jal	800034a6 <iunlockput>
  end_op();
    80004cce:	ecffe0ef          	jal	80003b9c <end_op>
  return -1;
    80004cd2:	57fd                	li	a5,-1
    80004cd4:	64f2                	ld	s1,280(sp)
    80004cd6:	6952                	ld	s2,272(sp)
}
    80004cd8:	853e                	mv	a0,a5
    80004cda:	70b2                	ld	ra,296(sp)
    80004cdc:	7412                	ld	s0,288(sp)
    80004cde:	6155                	addi	sp,sp,304
    80004ce0:	8082                	ret

0000000080004ce2 <sys_unlink>:
{
    80004ce2:	7151                	addi	sp,sp,-240
    80004ce4:	f586                	sd	ra,232(sp)
    80004ce6:	f1a2                	sd	s0,224(sp)
    80004ce8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004cea:	08000613          	li	a2,128
    80004cee:	f3040593          	addi	a1,s0,-208
    80004cf2:	4501                	li	a0,0
    80004cf4:	b79fd0ef          	jal	8000286c <argstr>
    80004cf8:	16054063          	bltz	a0,80004e58 <sys_unlink+0x176>
    80004cfc:	eda6                	sd	s1,216(sp)
  begin_op();
    80004cfe:	e35fe0ef          	jal	80003b32 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004d02:	fb040593          	addi	a1,s0,-80
    80004d06:	f3040513          	addi	a0,s0,-208
    80004d0a:	c87fe0ef          	jal	80003990 <nameiparent>
    80004d0e:	84aa                	mv	s1,a0
    80004d10:	c945                	beqz	a0,80004dc0 <sys_unlink+0xde>
  ilock(dp);
    80004d12:	d8afe0ef          	jal	8000329c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004d16:	00003597          	auipc	a1,0x3
    80004d1a:	90a58593          	addi	a1,a1,-1782 # 80007620 <etext+0x620>
    80004d1e:	fb040513          	addi	a0,s0,-80
    80004d22:	9d9fe0ef          	jal	800036fa <namecmp>
    80004d26:	10050e63          	beqz	a0,80004e42 <sys_unlink+0x160>
    80004d2a:	00003597          	auipc	a1,0x3
    80004d2e:	8fe58593          	addi	a1,a1,-1794 # 80007628 <etext+0x628>
    80004d32:	fb040513          	addi	a0,s0,-80
    80004d36:	9c5fe0ef          	jal	800036fa <namecmp>
    80004d3a:	10050463          	beqz	a0,80004e42 <sys_unlink+0x160>
    80004d3e:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004d40:	f2c40613          	addi	a2,s0,-212
    80004d44:	fb040593          	addi	a1,s0,-80
    80004d48:	8526                	mv	a0,s1
    80004d4a:	9c7fe0ef          	jal	80003710 <dirlookup>
    80004d4e:	892a                	mv	s2,a0
    80004d50:	0e050863          	beqz	a0,80004e40 <sys_unlink+0x15e>
  ilock(ip);
    80004d54:	d48fe0ef          	jal	8000329c <ilock>
  if(ip->nlink < 1)
    80004d58:	04a91783          	lh	a5,74(s2)
    80004d5c:	06f05763          	blez	a5,80004dca <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d60:	04491703          	lh	a4,68(s2)
    80004d64:	4785                	li	a5,1
    80004d66:	06f70963          	beq	a4,a5,80004dd8 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004d6a:	4641                	li	a2,16
    80004d6c:	4581                	li	a1,0
    80004d6e:	fc040513          	addi	a0,s0,-64
    80004d72:	f57fb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d76:	4741                	li	a4,16
    80004d78:	f2c42683          	lw	a3,-212(s0)
    80004d7c:	fc040613          	addi	a2,s0,-64
    80004d80:	4581                	li	a1,0
    80004d82:	8526                	mv	a0,s1
    80004d84:	869fe0ef          	jal	800035ec <writei>
    80004d88:	47c1                	li	a5,16
    80004d8a:	08f51b63          	bne	a0,a5,80004e20 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004d8e:	04491703          	lh	a4,68(s2)
    80004d92:	4785                	li	a5,1
    80004d94:	08f70d63          	beq	a4,a5,80004e2e <sys_unlink+0x14c>
  iunlockput(dp);
    80004d98:	8526                	mv	a0,s1
    80004d9a:	f0cfe0ef          	jal	800034a6 <iunlockput>
  ip->nlink--;
    80004d9e:	04a95783          	lhu	a5,74(s2)
    80004da2:	37fd                	addiw	a5,a5,-1
    80004da4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004da8:	854a                	mv	a0,s2
    80004daa:	c3efe0ef          	jal	800031e8 <iupdate>
  iunlockput(ip);
    80004dae:	854a                	mv	a0,s2
    80004db0:	ef6fe0ef          	jal	800034a6 <iunlockput>
  end_op();
    80004db4:	de9fe0ef          	jal	80003b9c <end_op>
  return 0;
    80004db8:	4501                	li	a0,0
    80004dba:	64ee                	ld	s1,216(sp)
    80004dbc:	694e                	ld	s2,208(sp)
    80004dbe:	a849                	j	80004e50 <sys_unlink+0x16e>
    end_op();
    80004dc0:	dddfe0ef          	jal	80003b9c <end_op>
    return -1;
    80004dc4:	557d                	li	a0,-1
    80004dc6:	64ee                	ld	s1,216(sp)
    80004dc8:	a061                	j	80004e50 <sys_unlink+0x16e>
    80004dca:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004dcc:	00003517          	auipc	a0,0x3
    80004dd0:	86450513          	addi	a0,a0,-1948 # 80007630 <etext+0x630>
    80004dd4:	9c1fb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dd8:	04c92703          	lw	a4,76(s2)
    80004ddc:	02000793          	li	a5,32
    80004de0:	f8e7f5e3          	bgeu	a5,a4,80004d6a <sys_unlink+0x88>
    80004de4:	e5ce                	sd	s3,200(sp)
    80004de6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dea:	4741                	li	a4,16
    80004dec:	86ce                	mv	a3,s3
    80004dee:	f1840613          	addi	a2,s0,-232
    80004df2:	4581                	li	a1,0
    80004df4:	854a                	mv	a0,s2
    80004df6:	efafe0ef          	jal	800034f0 <readi>
    80004dfa:	47c1                	li	a5,16
    80004dfc:	00f51c63          	bne	a0,a5,80004e14 <sys_unlink+0x132>
    if(de.inum != 0)
    80004e00:	f1845783          	lhu	a5,-232(s0)
    80004e04:	efa1                	bnez	a5,80004e5c <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e06:	29c1                	addiw	s3,s3,16
    80004e08:	04c92783          	lw	a5,76(s2)
    80004e0c:	fcf9efe3          	bltu	s3,a5,80004dea <sys_unlink+0x108>
    80004e10:	69ae                	ld	s3,200(sp)
    80004e12:	bfa1                	j	80004d6a <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004e14:	00003517          	auipc	a0,0x3
    80004e18:	83450513          	addi	a0,a0,-1996 # 80007648 <etext+0x648>
    80004e1c:	979fb0ef          	jal	80000794 <panic>
    80004e20:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004e22:	00003517          	auipc	a0,0x3
    80004e26:	83e50513          	addi	a0,a0,-1986 # 80007660 <etext+0x660>
    80004e2a:	96bfb0ef          	jal	80000794 <panic>
    dp->nlink--;
    80004e2e:	04a4d783          	lhu	a5,74(s1)
    80004e32:	37fd                	addiw	a5,a5,-1
    80004e34:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e38:	8526                	mv	a0,s1
    80004e3a:	baefe0ef          	jal	800031e8 <iupdate>
    80004e3e:	bfa9                	j	80004d98 <sys_unlink+0xb6>
    80004e40:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004e42:	8526                	mv	a0,s1
    80004e44:	e62fe0ef          	jal	800034a6 <iunlockput>
  end_op();
    80004e48:	d55fe0ef          	jal	80003b9c <end_op>
  return -1;
    80004e4c:	557d                	li	a0,-1
    80004e4e:	64ee                	ld	s1,216(sp)
}
    80004e50:	70ae                	ld	ra,232(sp)
    80004e52:	740e                	ld	s0,224(sp)
    80004e54:	616d                	addi	sp,sp,240
    80004e56:	8082                	ret
    return -1;
    80004e58:	557d                	li	a0,-1
    80004e5a:	bfdd                	j	80004e50 <sys_unlink+0x16e>
    iunlockput(ip);
    80004e5c:	854a                	mv	a0,s2
    80004e5e:	e48fe0ef          	jal	800034a6 <iunlockput>
    goto bad;
    80004e62:	694e                	ld	s2,208(sp)
    80004e64:	69ae                	ld	s3,200(sp)
    80004e66:	bff1                	j	80004e42 <sys_unlink+0x160>

0000000080004e68 <sys_open>:

uint64
sys_open(void)
{
    80004e68:	7131                	addi	sp,sp,-192
    80004e6a:	fd06                	sd	ra,184(sp)
    80004e6c:	f922                	sd	s0,176(sp)
    80004e6e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004e70:	f4c40593          	addi	a1,s0,-180
    80004e74:	4505                	li	a0,1
    80004e76:	9bffd0ef          	jal	80002834 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e7a:	08000613          	li	a2,128
    80004e7e:	f5040593          	addi	a1,s0,-176
    80004e82:	4501                	li	a0,0
    80004e84:	9e9fd0ef          	jal	8000286c <argstr>
    80004e88:	87aa                	mv	a5,a0
    return -1;
    80004e8a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e8c:	0a07c263          	bltz	a5,80004f30 <sys_open+0xc8>
    80004e90:	f526                	sd	s1,168(sp)

  begin_op();
    80004e92:	ca1fe0ef          	jal	80003b32 <begin_op>

  if(omode & O_CREATE){
    80004e96:	f4c42783          	lw	a5,-180(s0)
    80004e9a:	2007f793          	andi	a5,a5,512
    80004e9e:	c3d5                	beqz	a5,80004f42 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004ea0:	4681                	li	a3,0
    80004ea2:	4601                	li	a2,0
    80004ea4:	4589                	li	a1,2
    80004ea6:	f5040513          	addi	a0,s0,-176
    80004eaa:	aa9ff0ef          	jal	80004952 <create>
    80004eae:	84aa                	mv	s1,a0
    if(ip == 0){
    80004eb0:	c541                	beqz	a0,80004f38 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004eb2:	04449703          	lh	a4,68(s1)
    80004eb6:	478d                	li	a5,3
    80004eb8:	00f71763          	bne	a4,a5,80004ec6 <sys_open+0x5e>
    80004ebc:	0464d703          	lhu	a4,70(s1)
    80004ec0:	47a5                	li	a5,9
    80004ec2:	0ae7ed63          	bltu	a5,a4,80004f7c <sys_open+0x114>
    80004ec6:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ec8:	fe1fe0ef          	jal	80003ea8 <filealloc>
    80004ecc:	892a                	mv	s2,a0
    80004ece:	c179                	beqz	a0,80004f94 <sys_open+0x12c>
    80004ed0:	ed4e                	sd	s3,152(sp)
    80004ed2:	a43ff0ef          	jal	80004914 <fdalloc>
    80004ed6:	89aa                	mv	s3,a0
    80004ed8:	0a054a63          	bltz	a0,80004f8c <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004edc:	04449703          	lh	a4,68(s1)
    80004ee0:	478d                	li	a5,3
    80004ee2:	0cf70263          	beq	a4,a5,80004fa6 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ee6:	4789                	li	a5,2
    80004ee8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004eec:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004ef0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004ef4:	f4c42783          	lw	a5,-180(s0)
    80004ef8:	0017c713          	xori	a4,a5,1
    80004efc:	8b05                	andi	a4,a4,1
    80004efe:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f02:	0037f713          	andi	a4,a5,3
    80004f06:	00e03733          	snez	a4,a4
    80004f0a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f0e:	4007f793          	andi	a5,a5,1024
    80004f12:	c791                	beqz	a5,80004f1e <sys_open+0xb6>
    80004f14:	04449703          	lh	a4,68(s1)
    80004f18:	4789                	li	a5,2
    80004f1a:	08f70d63          	beq	a4,a5,80004fb4 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004f1e:	8526                	mv	a0,s1
    80004f20:	c2afe0ef          	jal	8000334a <iunlock>
  end_op();
    80004f24:	c79fe0ef          	jal	80003b9c <end_op>

  return fd;
    80004f28:	854e                	mv	a0,s3
    80004f2a:	74aa                	ld	s1,168(sp)
    80004f2c:	790a                	ld	s2,160(sp)
    80004f2e:	69ea                	ld	s3,152(sp)
}
    80004f30:	70ea                	ld	ra,184(sp)
    80004f32:	744a                	ld	s0,176(sp)
    80004f34:	6129                	addi	sp,sp,192
    80004f36:	8082                	ret
      end_op();
    80004f38:	c65fe0ef          	jal	80003b9c <end_op>
      return -1;
    80004f3c:	557d                	li	a0,-1
    80004f3e:	74aa                	ld	s1,168(sp)
    80004f40:	bfc5                	j	80004f30 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004f42:	f5040513          	addi	a0,s0,-176
    80004f46:	a31fe0ef          	jal	80003976 <namei>
    80004f4a:	84aa                	mv	s1,a0
    80004f4c:	c11d                	beqz	a0,80004f72 <sys_open+0x10a>
    ilock(ip);
    80004f4e:	b4efe0ef          	jal	8000329c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f52:	04449703          	lh	a4,68(s1)
    80004f56:	4785                	li	a5,1
    80004f58:	f4f71de3          	bne	a4,a5,80004eb2 <sys_open+0x4a>
    80004f5c:	f4c42783          	lw	a5,-180(s0)
    80004f60:	d3bd                	beqz	a5,80004ec6 <sys_open+0x5e>
      iunlockput(ip);
    80004f62:	8526                	mv	a0,s1
    80004f64:	d42fe0ef          	jal	800034a6 <iunlockput>
      end_op();
    80004f68:	c35fe0ef          	jal	80003b9c <end_op>
      return -1;
    80004f6c:	557d                	li	a0,-1
    80004f6e:	74aa                	ld	s1,168(sp)
    80004f70:	b7c1                	j	80004f30 <sys_open+0xc8>
      end_op();
    80004f72:	c2bfe0ef          	jal	80003b9c <end_op>
      return -1;
    80004f76:	557d                	li	a0,-1
    80004f78:	74aa                	ld	s1,168(sp)
    80004f7a:	bf5d                	j	80004f30 <sys_open+0xc8>
    iunlockput(ip);
    80004f7c:	8526                	mv	a0,s1
    80004f7e:	d28fe0ef          	jal	800034a6 <iunlockput>
    end_op();
    80004f82:	c1bfe0ef          	jal	80003b9c <end_op>
    return -1;
    80004f86:	557d                	li	a0,-1
    80004f88:	74aa                	ld	s1,168(sp)
    80004f8a:	b75d                	j	80004f30 <sys_open+0xc8>
      fileclose(f);
    80004f8c:	854a                	mv	a0,s2
    80004f8e:	fbffe0ef          	jal	80003f4c <fileclose>
    80004f92:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004f94:	8526                	mv	a0,s1
    80004f96:	d10fe0ef          	jal	800034a6 <iunlockput>
    end_op();
    80004f9a:	c03fe0ef          	jal	80003b9c <end_op>
    return -1;
    80004f9e:	557d                	li	a0,-1
    80004fa0:	74aa                	ld	s1,168(sp)
    80004fa2:	790a                	ld	s2,160(sp)
    80004fa4:	b771                	j	80004f30 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004fa6:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004faa:	04649783          	lh	a5,70(s1)
    80004fae:	02f91223          	sh	a5,36(s2)
    80004fb2:	bf3d                	j	80004ef0 <sys_open+0x88>
    itrunc(ip);
    80004fb4:	8526                	mv	a0,s1
    80004fb6:	bd4fe0ef          	jal	8000338a <itrunc>
    80004fba:	b795                	j	80004f1e <sys_open+0xb6>

0000000080004fbc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004fbc:	7175                	addi	sp,sp,-144
    80004fbe:	e506                	sd	ra,136(sp)
    80004fc0:	e122                	sd	s0,128(sp)
    80004fc2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004fc4:	b6ffe0ef          	jal	80003b32 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004fc8:	08000613          	li	a2,128
    80004fcc:	f7040593          	addi	a1,s0,-144
    80004fd0:	4501                	li	a0,0
    80004fd2:	89bfd0ef          	jal	8000286c <argstr>
    80004fd6:	02054363          	bltz	a0,80004ffc <sys_mkdir+0x40>
    80004fda:	4681                	li	a3,0
    80004fdc:	4601                	li	a2,0
    80004fde:	4585                	li	a1,1
    80004fe0:	f7040513          	addi	a0,s0,-144
    80004fe4:	96fff0ef          	jal	80004952 <create>
    80004fe8:	c911                	beqz	a0,80004ffc <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fea:	cbcfe0ef          	jal	800034a6 <iunlockput>
  end_op();
    80004fee:	baffe0ef          	jal	80003b9c <end_op>
  return 0;
    80004ff2:	4501                	li	a0,0
}
    80004ff4:	60aa                	ld	ra,136(sp)
    80004ff6:	640a                	ld	s0,128(sp)
    80004ff8:	6149                	addi	sp,sp,144
    80004ffa:	8082                	ret
    end_op();
    80004ffc:	ba1fe0ef          	jal	80003b9c <end_op>
    return -1;
    80005000:	557d                	li	a0,-1
    80005002:	bfcd                	j	80004ff4 <sys_mkdir+0x38>

0000000080005004 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005004:	7135                	addi	sp,sp,-160
    80005006:	ed06                	sd	ra,152(sp)
    80005008:	e922                	sd	s0,144(sp)
    8000500a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000500c:	b27fe0ef          	jal	80003b32 <begin_op>
  argint(1, &major);
    80005010:	f6c40593          	addi	a1,s0,-148
    80005014:	4505                	li	a0,1
    80005016:	81ffd0ef          	jal	80002834 <argint>
  argint(2, &minor);
    8000501a:	f6840593          	addi	a1,s0,-152
    8000501e:	4509                	li	a0,2
    80005020:	815fd0ef          	jal	80002834 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005024:	08000613          	li	a2,128
    80005028:	f7040593          	addi	a1,s0,-144
    8000502c:	4501                	li	a0,0
    8000502e:	83ffd0ef          	jal	8000286c <argstr>
    80005032:	02054563          	bltz	a0,8000505c <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005036:	f6841683          	lh	a3,-152(s0)
    8000503a:	f6c41603          	lh	a2,-148(s0)
    8000503e:	458d                	li	a1,3
    80005040:	f7040513          	addi	a0,s0,-144
    80005044:	90fff0ef          	jal	80004952 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005048:	c911                	beqz	a0,8000505c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000504a:	c5cfe0ef          	jal	800034a6 <iunlockput>
  end_op();
    8000504e:	b4ffe0ef          	jal	80003b9c <end_op>
  return 0;
    80005052:	4501                	li	a0,0
}
    80005054:	60ea                	ld	ra,152(sp)
    80005056:	644a                	ld	s0,144(sp)
    80005058:	610d                	addi	sp,sp,160
    8000505a:	8082                	ret
    end_op();
    8000505c:	b41fe0ef          	jal	80003b9c <end_op>
    return -1;
    80005060:	557d                	li	a0,-1
    80005062:	bfcd                	j	80005054 <sys_mknod+0x50>

0000000080005064 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005064:	7135                	addi	sp,sp,-160
    80005066:	ed06                	sd	ra,152(sp)
    80005068:	e922                	sd	s0,144(sp)
    8000506a:	e14a                	sd	s2,128(sp)
    8000506c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000506e:	873fc0ef          	jal	800018e0 <myproc>
    80005072:	892a                	mv	s2,a0
  
  begin_op();
    80005074:	abffe0ef          	jal	80003b32 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005078:	08000613          	li	a2,128
    8000507c:	f6040593          	addi	a1,s0,-160
    80005080:	4501                	li	a0,0
    80005082:	feafd0ef          	jal	8000286c <argstr>
    80005086:	04054363          	bltz	a0,800050cc <sys_chdir+0x68>
    8000508a:	e526                	sd	s1,136(sp)
    8000508c:	f6040513          	addi	a0,s0,-160
    80005090:	8e7fe0ef          	jal	80003976 <namei>
    80005094:	84aa                	mv	s1,a0
    80005096:	c915                	beqz	a0,800050ca <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005098:	a04fe0ef          	jal	8000329c <ilock>
  if(ip->type != T_DIR){
    8000509c:	04449703          	lh	a4,68(s1)
    800050a0:	4785                	li	a5,1
    800050a2:	02f71963          	bne	a4,a5,800050d4 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800050a6:	8526                	mv	a0,s1
    800050a8:	aa2fe0ef          	jal	8000334a <iunlock>
  iput(p->cwd);
    800050ac:	15093503          	ld	a0,336(s2)
    800050b0:	b6efe0ef          	jal	8000341e <iput>
  end_op();
    800050b4:	ae9fe0ef          	jal	80003b9c <end_op>
  p->cwd = ip;
    800050b8:	14993823          	sd	s1,336(s2)
  return 0;
    800050bc:	4501                	li	a0,0
    800050be:	64aa                	ld	s1,136(sp)
}
    800050c0:	60ea                	ld	ra,152(sp)
    800050c2:	644a                	ld	s0,144(sp)
    800050c4:	690a                	ld	s2,128(sp)
    800050c6:	610d                	addi	sp,sp,160
    800050c8:	8082                	ret
    800050ca:	64aa                	ld	s1,136(sp)
    end_op();
    800050cc:	ad1fe0ef          	jal	80003b9c <end_op>
    return -1;
    800050d0:	557d                	li	a0,-1
    800050d2:	b7fd                	j	800050c0 <sys_chdir+0x5c>
    iunlockput(ip);
    800050d4:	8526                	mv	a0,s1
    800050d6:	bd0fe0ef          	jal	800034a6 <iunlockput>
    end_op();
    800050da:	ac3fe0ef          	jal	80003b9c <end_op>
    return -1;
    800050de:	557d                	li	a0,-1
    800050e0:	64aa                	ld	s1,136(sp)
    800050e2:	bff9                	j	800050c0 <sys_chdir+0x5c>

00000000800050e4 <sys_exec>:

uint64
sys_exec(void)
{
    800050e4:	7121                	addi	sp,sp,-448
    800050e6:	ff06                	sd	ra,440(sp)
    800050e8:	fb22                	sd	s0,432(sp)
    800050ea:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800050ec:	e4840593          	addi	a1,s0,-440
    800050f0:	4505                	li	a0,1
    800050f2:	f5efd0ef          	jal	80002850 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800050f6:	08000613          	li	a2,128
    800050fa:	f5040593          	addi	a1,s0,-176
    800050fe:	4501                	li	a0,0
    80005100:	f6cfd0ef          	jal	8000286c <argstr>
    80005104:	87aa                	mv	a5,a0
    return -1;
    80005106:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005108:	0c07c463          	bltz	a5,800051d0 <sys_exec+0xec>
    8000510c:	f726                	sd	s1,424(sp)
    8000510e:	f34a                	sd	s2,416(sp)
    80005110:	ef4e                	sd	s3,408(sp)
    80005112:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005114:	10000613          	li	a2,256
    80005118:	4581                	li	a1,0
    8000511a:	e5040513          	addi	a0,s0,-432
    8000511e:	babfb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005122:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005126:	89a6                	mv	s3,s1
    80005128:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000512a:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000512e:	00391513          	slli	a0,s2,0x3
    80005132:	e4040593          	addi	a1,s0,-448
    80005136:	e4843783          	ld	a5,-440(s0)
    8000513a:	953e                	add	a0,a0,a5
    8000513c:	e6efd0ef          	jal	800027aa <fetchaddr>
    80005140:	02054663          	bltz	a0,8000516c <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005144:	e4043783          	ld	a5,-448(s0)
    80005148:	c3a9                	beqz	a5,8000518a <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000514a:	9dbfb0ef          	jal	80000b24 <kalloc>
    8000514e:	85aa                	mv	a1,a0
    80005150:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005154:	cd01                	beqz	a0,8000516c <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005156:	6605                	lui	a2,0x1
    80005158:	e4043503          	ld	a0,-448(s0)
    8000515c:	e98fd0ef          	jal	800027f4 <fetchstr>
    80005160:	00054663          	bltz	a0,8000516c <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005164:	0905                	addi	s2,s2,1
    80005166:	09a1                	addi	s3,s3,8
    80005168:	fd4913e3          	bne	s2,s4,8000512e <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000516c:	f5040913          	addi	s2,s0,-176
    80005170:	6088                	ld	a0,0(s1)
    80005172:	c931                	beqz	a0,800051c6 <sys_exec+0xe2>
    kfree(argv[i]);
    80005174:	8cffb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005178:	04a1                	addi	s1,s1,8
    8000517a:	ff249be3          	bne	s1,s2,80005170 <sys_exec+0x8c>
  return -1;
    8000517e:	557d                	li	a0,-1
    80005180:	74ba                	ld	s1,424(sp)
    80005182:	791a                	ld	s2,416(sp)
    80005184:	69fa                	ld	s3,408(sp)
    80005186:	6a5a                	ld	s4,400(sp)
    80005188:	a0a1                	j	800051d0 <sys_exec+0xec>
      argv[i] = 0;
    8000518a:	0009079b          	sext.w	a5,s2
    8000518e:	078e                	slli	a5,a5,0x3
    80005190:	fd078793          	addi	a5,a5,-48
    80005194:	97a2                	add	a5,a5,s0
    80005196:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000519a:	e5040593          	addi	a1,s0,-432
    8000519e:	f5040513          	addi	a0,s0,-176
    800051a2:	ba8ff0ef          	jal	8000454a <exec>
    800051a6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051a8:	f5040993          	addi	s3,s0,-176
    800051ac:	6088                	ld	a0,0(s1)
    800051ae:	c511                	beqz	a0,800051ba <sys_exec+0xd6>
    kfree(argv[i]);
    800051b0:	893fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051b4:	04a1                	addi	s1,s1,8
    800051b6:	ff349be3          	bne	s1,s3,800051ac <sys_exec+0xc8>
  return ret;
    800051ba:	854a                	mv	a0,s2
    800051bc:	74ba                	ld	s1,424(sp)
    800051be:	791a                	ld	s2,416(sp)
    800051c0:	69fa                	ld	s3,408(sp)
    800051c2:	6a5a                	ld	s4,400(sp)
    800051c4:	a031                	j	800051d0 <sys_exec+0xec>
  return -1;
    800051c6:	557d                	li	a0,-1
    800051c8:	74ba                	ld	s1,424(sp)
    800051ca:	791a                	ld	s2,416(sp)
    800051cc:	69fa                	ld	s3,408(sp)
    800051ce:	6a5a                	ld	s4,400(sp)
}
    800051d0:	70fa                	ld	ra,440(sp)
    800051d2:	745a                	ld	s0,432(sp)
    800051d4:	6139                	addi	sp,sp,448
    800051d6:	8082                	ret

00000000800051d8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051d8:	7139                	addi	sp,sp,-64
    800051da:	fc06                	sd	ra,56(sp)
    800051dc:	f822                	sd	s0,48(sp)
    800051de:	f426                	sd	s1,40(sp)
    800051e0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051e2:	efefc0ef          	jal	800018e0 <myproc>
    800051e6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800051e8:	fd840593          	addi	a1,s0,-40
    800051ec:	4501                	li	a0,0
    800051ee:	e62fd0ef          	jal	80002850 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800051f2:	fc840593          	addi	a1,s0,-56
    800051f6:	fd040513          	addi	a0,s0,-48
    800051fa:	85cff0ef          	jal	80004256 <pipealloc>
    return -1;
    800051fe:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005200:	0a054463          	bltz	a0,800052a8 <sys_pipe+0xd0>
  fd0 = -1;
    80005204:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005208:	fd043503          	ld	a0,-48(s0)
    8000520c:	f08ff0ef          	jal	80004914 <fdalloc>
    80005210:	fca42223          	sw	a0,-60(s0)
    80005214:	08054163          	bltz	a0,80005296 <sys_pipe+0xbe>
    80005218:	fc843503          	ld	a0,-56(s0)
    8000521c:	ef8ff0ef          	jal	80004914 <fdalloc>
    80005220:	fca42023          	sw	a0,-64(s0)
    80005224:	06054063          	bltz	a0,80005284 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005228:	4691                	li	a3,4
    8000522a:	fc440613          	addi	a2,s0,-60
    8000522e:	fd843583          	ld	a1,-40(s0)
    80005232:	68a8                	ld	a0,80(s1)
    80005234:	b1efc0ef          	jal	80001552 <copyout>
    80005238:	00054e63          	bltz	a0,80005254 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000523c:	4691                	li	a3,4
    8000523e:	fc040613          	addi	a2,s0,-64
    80005242:	fd843583          	ld	a1,-40(s0)
    80005246:	0591                	addi	a1,a1,4
    80005248:	68a8                	ld	a0,80(s1)
    8000524a:	b08fc0ef          	jal	80001552 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000524e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005250:	04055c63          	bgez	a0,800052a8 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005254:	fc442783          	lw	a5,-60(s0)
    80005258:	07e9                	addi	a5,a5,26
    8000525a:	078e                	slli	a5,a5,0x3
    8000525c:	97a6                	add	a5,a5,s1
    8000525e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005262:	fc042783          	lw	a5,-64(s0)
    80005266:	07e9                	addi	a5,a5,26
    80005268:	078e                	slli	a5,a5,0x3
    8000526a:	94be                	add	s1,s1,a5
    8000526c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005270:	fd043503          	ld	a0,-48(s0)
    80005274:	cd9fe0ef          	jal	80003f4c <fileclose>
    fileclose(wf);
    80005278:	fc843503          	ld	a0,-56(s0)
    8000527c:	cd1fe0ef          	jal	80003f4c <fileclose>
    return -1;
    80005280:	57fd                	li	a5,-1
    80005282:	a01d                	j	800052a8 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005284:	fc442783          	lw	a5,-60(s0)
    80005288:	0007c763          	bltz	a5,80005296 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000528c:	07e9                	addi	a5,a5,26
    8000528e:	078e                	slli	a5,a5,0x3
    80005290:	97a6                	add	a5,a5,s1
    80005292:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005296:	fd043503          	ld	a0,-48(s0)
    8000529a:	cb3fe0ef          	jal	80003f4c <fileclose>
    fileclose(wf);
    8000529e:	fc843503          	ld	a0,-56(s0)
    800052a2:	cabfe0ef          	jal	80003f4c <fileclose>
    return -1;
    800052a6:	57fd                	li	a5,-1
}
    800052a8:	853e                	mv	a0,a5
    800052aa:	70e2                	ld	ra,56(sp)
    800052ac:	7442                	ld	s0,48(sp)
    800052ae:	74a2                	ld	s1,40(sp)
    800052b0:	6121                	addi	sp,sp,64
    800052b2:	8082                	ret
	...

00000000800052c0 <kernelvec>:
    800052c0:	7111                	addi	sp,sp,-256
    800052c2:	e006                	sd	ra,0(sp)
    800052c4:	e40a                	sd	sp,8(sp)
    800052c6:	e80e                	sd	gp,16(sp)
    800052c8:	ec12                	sd	tp,24(sp)
    800052ca:	f016                	sd	t0,32(sp)
    800052cc:	f41a                	sd	t1,40(sp)
    800052ce:	f81e                	sd	t2,48(sp)
    800052d0:	e4aa                	sd	a0,72(sp)
    800052d2:	e8ae                	sd	a1,80(sp)
    800052d4:	ecb2                	sd	a2,88(sp)
    800052d6:	f0b6                	sd	a3,96(sp)
    800052d8:	f4ba                	sd	a4,104(sp)
    800052da:	f8be                	sd	a5,112(sp)
    800052dc:	fcc2                	sd	a6,120(sp)
    800052de:	e146                	sd	a7,128(sp)
    800052e0:	edf2                	sd	t3,216(sp)
    800052e2:	f1f6                	sd	t4,224(sp)
    800052e4:	f5fa                	sd	t5,232(sp)
    800052e6:	f9fe                	sd	t6,240(sp)
    800052e8:	bd2fd0ef          	jal	800026ba <kerneltrap>
    800052ec:	6082                	ld	ra,0(sp)
    800052ee:	6122                	ld	sp,8(sp)
    800052f0:	61c2                	ld	gp,16(sp)
    800052f2:	7282                	ld	t0,32(sp)
    800052f4:	7322                	ld	t1,40(sp)
    800052f6:	73c2                	ld	t2,48(sp)
    800052f8:	6526                	ld	a0,72(sp)
    800052fa:	65c6                	ld	a1,80(sp)
    800052fc:	6666                	ld	a2,88(sp)
    800052fe:	7686                	ld	a3,96(sp)
    80005300:	7726                	ld	a4,104(sp)
    80005302:	77c6                	ld	a5,112(sp)
    80005304:	7866                	ld	a6,120(sp)
    80005306:	688a                	ld	a7,128(sp)
    80005308:	6e6e                	ld	t3,216(sp)
    8000530a:	7e8e                	ld	t4,224(sp)
    8000530c:	7f2e                	ld	t5,232(sp)
    8000530e:	7fce                	ld	t6,240(sp)
    80005310:	6111                	addi	sp,sp,256
    80005312:	10200073          	sret
	...

000000008000531e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000531e:	1141                	addi	sp,sp,-16
    80005320:	e422                	sd	s0,8(sp)
    80005322:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005324:	0c0007b7          	lui	a5,0xc000
    80005328:	4705                	li	a4,1
    8000532a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000532c:	0c0007b7          	lui	a5,0xc000
    80005330:	c3d8                	sw	a4,4(a5)
}
    80005332:	6422                	ld	s0,8(sp)
    80005334:	0141                	addi	sp,sp,16
    80005336:	8082                	ret

0000000080005338 <plicinithart>:

void
plicinithart(void)
{
    80005338:	1141                	addi	sp,sp,-16
    8000533a:	e406                	sd	ra,8(sp)
    8000533c:	e022                	sd	s0,0(sp)
    8000533e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005340:	d74fc0ef          	jal	800018b4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005344:	0085171b          	slliw	a4,a0,0x8
    80005348:	0c0027b7          	lui	a5,0xc002
    8000534c:	97ba                	add	a5,a5,a4
    8000534e:	40200713          	li	a4,1026
    80005352:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005356:	00d5151b          	slliw	a0,a0,0xd
    8000535a:	0c2017b7          	lui	a5,0xc201
    8000535e:	97aa                	add	a5,a5,a0
    80005360:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005364:	60a2                	ld	ra,8(sp)
    80005366:	6402                	ld	s0,0(sp)
    80005368:	0141                	addi	sp,sp,16
    8000536a:	8082                	ret

000000008000536c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000536c:	1141                	addi	sp,sp,-16
    8000536e:	e406                	sd	ra,8(sp)
    80005370:	e022                	sd	s0,0(sp)
    80005372:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005374:	d40fc0ef          	jal	800018b4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005378:	00d5151b          	slliw	a0,a0,0xd
    8000537c:	0c2017b7          	lui	a5,0xc201
    80005380:	97aa                	add	a5,a5,a0
  return irq;
}
    80005382:	43c8                	lw	a0,4(a5)
    80005384:	60a2                	ld	ra,8(sp)
    80005386:	6402                	ld	s0,0(sp)
    80005388:	0141                	addi	sp,sp,16
    8000538a:	8082                	ret

000000008000538c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000538c:	1101                	addi	sp,sp,-32
    8000538e:	ec06                	sd	ra,24(sp)
    80005390:	e822                	sd	s0,16(sp)
    80005392:	e426                	sd	s1,8(sp)
    80005394:	1000                	addi	s0,sp,32
    80005396:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005398:	d1cfc0ef          	jal	800018b4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000539c:	00d5151b          	slliw	a0,a0,0xd
    800053a0:	0c2017b7          	lui	a5,0xc201
    800053a4:	97aa                	add	a5,a5,a0
    800053a6:	c3c4                	sw	s1,4(a5)
}
    800053a8:	60e2                	ld	ra,24(sp)
    800053aa:	6442                	ld	s0,16(sp)
    800053ac:	64a2                	ld	s1,8(sp)
    800053ae:	6105                	addi	sp,sp,32
    800053b0:	8082                	ret

00000000800053b2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053b2:	1141                	addi	sp,sp,-16
    800053b4:	e406                	sd	ra,8(sp)
    800053b6:	e022                	sd	s0,0(sp)
    800053b8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ba:	479d                	li	a5,7
    800053bc:	04a7ca63          	blt	a5,a0,80005410 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800053c0:	0001b797          	auipc	a5,0x1b
    800053c4:	77078793          	addi	a5,a5,1904 # 80020b30 <disk>
    800053c8:	97aa                	add	a5,a5,a0
    800053ca:	0187c783          	lbu	a5,24(a5)
    800053ce:	e7b9                	bnez	a5,8000541c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053d0:	00451693          	slli	a3,a0,0x4
    800053d4:	0001b797          	auipc	a5,0x1b
    800053d8:	75c78793          	addi	a5,a5,1884 # 80020b30 <disk>
    800053dc:	6398                	ld	a4,0(a5)
    800053de:	9736                	add	a4,a4,a3
    800053e0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800053e4:	6398                	ld	a4,0(a5)
    800053e6:	9736                	add	a4,a4,a3
    800053e8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053ec:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053f0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053f4:	97aa                	add	a5,a5,a0
    800053f6:	4705                	li	a4,1
    800053f8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800053fc:	0001b517          	auipc	a0,0x1b
    80005400:	74c50513          	addi	a0,a0,1868 # 80020b48 <disk+0x18>
    80005404:	b81fc0ef          	jal	80001f84 <wakeup>
}
    80005408:	60a2                	ld	ra,8(sp)
    8000540a:	6402                	ld	s0,0(sp)
    8000540c:	0141                	addi	sp,sp,16
    8000540e:	8082                	ret
    panic("free_desc 1");
    80005410:	00002517          	auipc	a0,0x2
    80005414:	26050513          	addi	a0,a0,608 # 80007670 <etext+0x670>
    80005418:	b7cfb0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000541c:	00002517          	auipc	a0,0x2
    80005420:	26450513          	addi	a0,a0,612 # 80007680 <etext+0x680>
    80005424:	b70fb0ef          	jal	80000794 <panic>

0000000080005428 <virtio_disk_init>:
{
    80005428:	1101                	addi	sp,sp,-32
    8000542a:	ec06                	sd	ra,24(sp)
    8000542c:	e822                	sd	s0,16(sp)
    8000542e:	e426                	sd	s1,8(sp)
    80005430:	e04a                	sd	s2,0(sp)
    80005432:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005434:	00002597          	auipc	a1,0x2
    80005438:	25c58593          	addi	a1,a1,604 # 80007690 <etext+0x690>
    8000543c:	0001c517          	auipc	a0,0x1c
    80005440:	81c50513          	addi	a0,a0,-2020 # 80020c58 <disk+0x128>
    80005444:	f30fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005448:	100017b7          	lui	a5,0x10001
    8000544c:	4398                	lw	a4,0(a5)
    8000544e:	2701                	sext.w	a4,a4
    80005450:	747277b7          	lui	a5,0x74727
    80005454:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005458:	18f71063          	bne	a4,a5,800055d8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000545c:	100017b7          	lui	a5,0x10001
    80005460:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005462:	439c                	lw	a5,0(a5)
    80005464:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005466:	4709                	li	a4,2
    80005468:	16e79863          	bne	a5,a4,800055d8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000546c:	100017b7          	lui	a5,0x10001
    80005470:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005472:	439c                	lw	a5,0(a5)
    80005474:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005476:	16e79163          	bne	a5,a4,800055d8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000547a:	100017b7          	lui	a5,0x10001
    8000547e:	47d8                	lw	a4,12(a5)
    80005480:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005482:	554d47b7          	lui	a5,0x554d4
    80005486:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000548a:	14f71763          	bne	a4,a5,800055d8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000548e:	100017b7          	lui	a5,0x10001
    80005492:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005496:	4705                	li	a4,1
    80005498:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000549a:	470d                	li	a4,3
    8000549c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000549e:	10001737          	lui	a4,0x10001
    800054a2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054a4:	c7ffe737          	lui	a4,0xc7ffe
    800054a8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fddaef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054ac:	8ef9                	and	a3,a3,a4
    800054ae:	10001737          	lui	a4,0x10001
    800054b2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b4:	472d                	li	a4,11
    800054b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800054bc:	439c                	lw	a5,0(a5)
    800054be:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054c2:	8ba1                	andi	a5,a5,8
    800054c4:	12078063          	beqz	a5,800055e4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054c8:	100017b7          	lui	a5,0x10001
    800054cc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054d0:	100017b7          	lui	a5,0x10001
    800054d4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800054d8:	439c                	lw	a5,0(a5)
    800054da:	2781                	sext.w	a5,a5
    800054dc:	10079a63          	bnez	a5,800055f0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054e0:	100017b7          	lui	a5,0x10001
    800054e4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800054e8:	439c                	lw	a5,0(a5)
    800054ea:	2781                	sext.w	a5,a5
  if(max == 0)
    800054ec:	10078863          	beqz	a5,800055fc <virtio_disk_init+0x1d4>
  if(max < NUM)
    800054f0:	471d                	li	a4,7
    800054f2:	10f77b63          	bgeu	a4,a5,80005608 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800054f6:	e2efb0ef          	jal	80000b24 <kalloc>
    800054fa:	0001b497          	auipc	s1,0x1b
    800054fe:	63648493          	addi	s1,s1,1590 # 80020b30 <disk>
    80005502:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005504:	e20fb0ef          	jal	80000b24 <kalloc>
    80005508:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000550a:	e1afb0ef          	jal	80000b24 <kalloc>
    8000550e:	87aa                	mv	a5,a0
    80005510:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005512:	6088                	ld	a0,0(s1)
    80005514:	10050063          	beqz	a0,80005614 <virtio_disk_init+0x1ec>
    80005518:	0001b717          	auipc	a4,0x1b
    8000551c:	62073703          	ld	a4,1568(a4) # 80020b38 <disk+0x8>
    80005520:	0e070a63          	beqz	a4,80005614 <virtio_disk_init+0x1ec>
    80005524:	0e078863          	beqz	a5,80005614 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005528:	6605                	lui	a2,0x1
    8000552a:	4581                	li	a1,0
    8000552c:	f9cfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005530:	0001b497          	auipc	s1,0x1b
    80005534:	60048493          	addi	s1,s1,1536 # 80020b30 <disk>
    80005538:	6605                	lui	a2,0x1
    8000553a:	4581                	li	a1,0
    8000553c:	6488                	ld	a0,8(s1)
    8000553e:	f8afb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005542:	6605                	lui	a2,0x1
    80005544:	4581                	li	a1,0
    80005546:	6888                	ld	a0,16(s1)
    80005548:	f80fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000554c:	100017b7          	lui	a5,0x10001
    80005550:	4721                	li	a4,8
    80005552:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005554:	4098                	lw	a4,0(s1)
    80005556:	100017b7          	lui	a5,0x10001
    8000555a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000555e:	40d8                	lw	a4,4(s1)
    80005560:	100017b7          	lui	a5,0x10001
    80005564:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005568:	649c                	ld	a5,8(s1)
    8000556a:	0007869b          	sext.w	a3,a5
    8000556e:	10001737          	lui	a4,0x10001
    80005572:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005576:	9781                	srai	a5,a5,0x20
    80005578:	10001737          	lui	a4,0x10001
    8000557c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005580:	689c                	ld	a5,16(s1)
    80005582:	0007869b          	sext.w	a3,a5
    80005586:	10001737          	lui	a4,0x10001
    8000558a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000558e:	9781                	srai	a5,a5,0x20
    80005590:	10001737          	lui	a4,0x10001
    80005594:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005598:	10001737          	lui	a4,0x10001
    8000559c:	4785                	li	a5,1
    8000559e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800055a0:	00f48c23          	sb	a5,24(s1)
    800055a4:	00f48ca3          	sb	a5,25(s1)
    800055a8:	00f48d23          	sb	a5,26(s1)
    800055ac:	00f48da3          	sb	a5,27(s1)
    800055b0:	00f48e23          	sb	a5,28(s1)
    800055b4:	00f48ea3          	sb	a5,29(s1)
    800055b8:	00f48f23          	sb	a5,30(s1)
    800055bc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055c0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055c4:	100017b7          	lui	a5,0x10001
    800055c8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800055cc:	60e2                	ld	ra,24(sp)
    800055ce:	6442                	ld	s0,16(sp)
    800055d0:	64a2                	ld	s1,8(sp)
    800055d2:	6902                	ld	s2,0(sp)
    800055d4:	6105                	addi	sp,sp,32
    800055d6:	8082                	ret
    panic("could not find virtio disk");
    800055d8:	00002517          	auipc	a0,0x2
    800055dc:	0c850513          	addi	a0,a0,200 # 800076a0 <etext+0x6a0>
    800055e0:	9b4fb0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055e4:	00002517          	auipc	a0,0x2
    800055e8:	0dc50513          	addi	a0,a0,220 # 800076c0 <etext+0x6c0>
    800055ec:	9a8fb0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    800055f0:	00002517          	auipc	a0,0x2
    800055f4:	0f050513          	addi	a0,a0,240 # 800076e0 <etext+0x6e0>
    800055f8:	99cfb0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    800055fc:	00002517          	auipc	a0,0x2
    80005600:	10450513          	addi	a0,a0,260 # 80007700 <etext+0x700>
    80005604:	990fb0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005608:	00002517          	auipc	a0,0x2
    8000560c:	11850513          	addi	a0,a0,280 # 80007720 <etext+0x720>
    80005610:	984fb0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005614:	00002517          	auipc	a0,0x2
    80005618:	12c50513          	addi	a0,a0,300 # 80007740 <etext+0x740>
    8000561c:	978fb0ef          	jal	80000794 <panic>

0000000080005620 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005620:	7159                	addi	sp,sp,-112
    80005622:	f486                	sd	ra,104(sp)
    80005624:	f0a2                	sd	s0,96(sp)
    80005626:	eca6                	sd	s1,88(sp)
    80005628:	e8ca                	sd	s2,80(sp)
    8000562a:	e4ce                	sd	s3,72(sp)
    8000562c:	e0d2                	sd	s4,64(sp)
    8000562e:	fc56                	sd	s5,56(sp)
    80005630:	f85a                	sd	s6,48(sp)
    80005632:	f45e                	sd	s7,40(sp)
    80005634:	f062                	sd	s8,32(sp)
    80005636:	ec66                	sd	s9,24(sp)
    80005638:	1880                	addi	s0,sp,112
    8000563a:	8a2a                	mv	s4,a0
    8000563c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000563e:	00c52c83          	lw	s9,12(a0)
    80005642:	001c9c9b          	slliw	s9,s9,0x1
    80005646:	1c82                	slli	s9,s9,0x20
    80005648:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000564c:	0001b517          	auipc	a0,0x1b
    80005650:	60c50513          	addi	a0,a0,1548 # 80020c58 <disk+0x128>
    80005654:	da0fb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    80005658:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000565a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000565c:	0001bb17          	auipc	s6,0x1b
    80005660:	4d4b0b13          	addi	s6,s6,1236 # 80020b30 <disk>
  for(int i = 0; i < 3; i++){
    80005664:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005666:	0001bc17          	auipc	s8,0x1b
    8000566a:	5f2c0c13          	addi	s8,s8,1522 # 80020c58 <disk+0x128>
    8000566e:	a8b9                	j	800056cc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005670:	00fb0733          	add	a4,s6,a5
    80005674:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005678:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000567a:	0207c563          	bltz	a5,800056a4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000567e:	2905                	addiw	s2,s2,1
    80005680:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005682:	05590963          	beq	s2,s5,800056d4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005686:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005688:	0001b717          	auipc	a4,0x1b
    8000568c:	4a870713          	addi	a4,a4,1192 # 80020b30 <disk>
    80005690:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005692:	01874683          	lbu	a3,24(a4)
    80005696:	fee9                	bnez	a3,80005670 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005698:	2785                	addiw	a5,a5,1
    8000569a:	0705                	addi	a4,a4,1
    8000569c:	fe979be3          	bne	a5,s1,80005692 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800056a0:	57fd                	li	a5,-1
    800056a2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056a4:	01205d63          	blez	s2,800056be <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800056a8:	f9042503          	lw	a0,-112(s0)
    800056ac:	d07ff0ef          	jal	800053b2 <free_desc>
      for(int j = 0; j < i; j++)
    800056b0:	4785                	li	a5,1
    800056b2:	0127d663          	bge	a5,s2,800056be <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800056b6:	f9442503          	lw	a0,-108(s0)
    800056ba:	cf9ff0ef          	jal	800053b2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056be:	85e2                	mv	a1,s8
    800056c0:	0001b517          	auipc	a0,0x1b
    800056c4:	48850513          	addi	a0,a0,1160 # 80020b48 <disk+0x18>
    800056c8:	871fc0ef          	jal	80001f38 <sleep>
  for(int i = 0; i < 3; i++){
    800056cc:	f9040613          	addi	a2,s0,-112
    800056d0:	894e                	mv	s2,s3
    800056d2:	bf55                	j	80005686 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056d4:	f9042503          	lw	a0,-112(s0)
    800056d8:	00451693          	slli	a3,a0,0x4

  if(write)
    800056dc:	0001b797          	auipc	a5,0x1b
    800056e0:	45478793          	addi	a5,a5,1108 # 80020b30 <disk>
    800056e4:	00a50713          	addi	a4,a0,10
    800056e8:	0712                	slli	a4,a4,0x4
    800056ea:	973e                	add	a4,a4,a5
    800056ec:	01703633          	snez	a2,s7
    800056f0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056f2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800056f6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056fa:	6398                	ld	a4,0(a5)
    800056fc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056fe:	0a868613          	addi	a2,a3,168
    80005702:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005704:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005706:	6390                	ld	a2,0(a5)
    80005708:	00d605b3          	add	a1,a2,a3
    8000570c:	4741                	li	a4,16
    8000570e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005710:	4805                	li	a6,1
    80005712:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005716:	f9442703          	lw	a4,-108(s0)
    8000571a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000571e:	0712                	slli	a4,a4,0x4
    80005720:	963a                	add	a2,a2,a4
    80005722:	058a0593          	addi	a1,s4,88
    80005726:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005728:	0007b883          	ld	a7,0(a5)
    8000572c:	9746                	add	a4,a4,a7
    8000572e:	40000613          	li	a2,1024
    80005732:	c710                	sw	a2,8(a4)
  if(write)
    80005734:	001bb613          	seqz	a2,s7
    80005738:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000573c:	00166613          	ori	a2,a2,1
    80005740:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005744:	f9842583          	lw	a1,-104(s0)
    80005748:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000574c:	00250613          	addi	a2,a0,2
    80005750:	0612                	slli	a2,a2,0x4
    80005752:	963e                	add	a2,a2,a5
    80005754:	577d                	li	a4,-1
    80005756:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000575a:	0592                	slli	a1,a1,0x4
    8000575c:	98ae                	add	a7,a7,a1
    8000575e:	03068713          	addi	a4,a3,48
    80005762:	973e                	add	a4,a4,a5
    80005764:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005768:	6398                	ld	a4,0(a5)
    8000576a:	972e                	add	a4,a4,a1
    8000576c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005770:	4689                	li	a3,2
    80005772:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005776:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000577a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000577e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005782:	6794                	ld	a3,8(a5)
    80005784:	0026d703          	lhu	a4,2(a3)
    80005788:	8b1d                	andi	a4,a4,7
    8000578a:	0706                	slli	a4,a4,0x1
    8000578c:	96ba                	add	a3,a3,a4
    8000578e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005792:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005796:	6798                	ld	a4,8(a5)
    80005798:	00275783          	lhu	a5,2(a4)
    8000579c:	2785                	addiw	a5,a5,1
    8000579e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057a2:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057a6:	100017b7          	lui	a5,0x10001
    800057aa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057ae:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800057b2:	0001b917          	auipc	s2,0x1b
    800057b6:	4a690913          	addi	s2,s2,1190 # 80020c58 <disk+0x128>
  while(b->disk == 1) {
    800057ba:	4485                	li	s1,1
    800057bc:	01079a63          	bne	a5,a6,800057d0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800057c0:	85ca                	mv	a1,s2
    800057c2:	8552                	mv	a0,s4
    800057c4:	f74fc0ef          	jal	80001f38 <sleep>
  while(b->disk == 1) {
    800057c8:	004a2783          	lw	a5,4(s4)
    800057cc:	fe978ae3          	beq	a5,s1,800057c0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800057d0:	f9042903          	lw	s2,-112(s0)
    800057d4:	00290713          	addi	a4,s2,2
    800057d8:	0712                	slli	a4,a4,0x4
    800057da:	0001b797          	auipc	a5,0x1b
    800057de:	35678793          	addi	a5,a5,854 # 80020b30 <disk>
    800057e2:	97ba                	add	a5,a5,a4
    800057e4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057e8:	0001b997          	auipc	s3,0x1b
    800057ec:	34898993          	addi	s3,s3,840 # 80020b30 <disk>
    800057f0:	00491713          	slli	a4,s2,0x4
    800057f4:	0009b783          	ld	a5,0(s3)
    800057f8:	97ba                	add	a5,a5,a4
    800057fa:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057fe:	854a                	mv	a0,s2
    80005800:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005804:	bafff0ef          	jal	800053b2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005808:	8885                	andi	s1,s1,1
    8000580a:	f0fd                	bnez	s1,800057f0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000580c:	0001b517          	auipc	a0,0x1b
    80005810:	44c50513          	addi	a0,a0,1100 # 80020c58 <disk+0x128>
    80005814:	c78fb0ef          	jal	80000c8c <release>
}
    80005818:	70a6                	ld	ra,104(sp)
    8000581a:	7406                	ld	s0,96(sp)
    8000581c:	64e6                	ld	s1,88(sp)
    8000581e:	6946                	ld	s2,80(sp)
    80005820:	69a6                	ld	s3,72(sp)
    80005822:	6a06                	ld	s4,64(sp)
    80005824:	7ae2                	ld	s5,56(sp)
    80005826:	7b42                	ld	s6,48(sp)
    80005828:	7ba2                	ld	s7,40(sp)
    8000582a:	7c02                	ld	s8,32(sp)
    8000582c:	6ce2                	ld	s9,24(sp)
    8000582e:	6165                	addi	sp,sp,112
    80005830:	8082                	ret

0000000080005832 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005832:	1101                	addi	sp,sp,-32
    80005834:	ec06                	sd	ra,24(sp)
    80005836:	e822                	sd	s0,16(sp)
    80005838:	e426                	sd	s1,8(sp)
    8000583a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000583c:	0001b497          	auipc	s1,0x1b
    80005840:	2f448493          	addi	s1,s1,756 # 80020b30 <disk>
    80005844:	0001b517          	auipc	a0,0x1b
    80005848:	41450513          	addi	a0,a0,1044 # 80020c58 <disk+0x128>
    8000584c:	ba8fb0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005850:	100017b7          	lui	a5,0x10001
    80005854:	53b8                	lw	a4,96(a5)
    80005856:	8b0d                	andi	a4,a4,3
    80005858:	100017b7          	lui	a5,0x10001
    8000585c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000585e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005862:	689c                	ld	a5,16(s1)
    80005864:	0204d703          	lhu	a4,32(s1)
    80005868:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000586c:	04f70663          	beq	a4,a5,800058b8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005870:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005874:	6898                	ld	a4,16(s1)
    80005876:	0204d783          	lhu	a5,32(s1)
    8000587a:	8b9d                	andi	a5,a5,7
    8000587c:	078e                	slli	a5,a5,0x3
    8000587e:	97ba                	add	a5,a5,a4
    80005880:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005882:	00278713          	addi	a4,a5,2
    80005886:	0712                	slli	a4,a4,0x4
    80005888:	9726                	add	a4,a4,s1
    8000588a:	01074703          	lbu	a4,16(a4)
    8000588e:	e321                	bnez	a4,800058ce <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005890:	0789                	addi	a5,a5,2
    80005892:	0792                	slli	a5,a5,0x4
    80005894:	97a6                	add	a5,a5,s1
    80005896:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005898:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000589c:	ee8fc0ef          	jal	80001f84 <wakeup>

    disk.used_idx += 1;
    800058a0:	0204d783          	lhu	a5,32(s1)
    800058a4:	2785                	addiw	a5,a5,1
    800058a6:	17c2                	slli	a5,a5,0x30
    800058a8:	93c1                	srli	a5,a5,0x30
    800058aa:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058ae:	6898                	ld	a4,16(s1)
    800058b0:	00275703          	lhu	a4,2(a4)
    800058b4:	faf71ee3          	bne	a4,a5,80005870 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800058b8:	0001b517          	auipc	a0,0x1b
    800058bc:	3a050513          	addi	a0,a0,928 # 80020c58 <disk+0x128>
    800058c0:	bccfb0ef          	jal	80000c8c <release>
}
    800058c4:	60e2                	ld	ra,24(sp)
    800058c6:	6442                	ld	s0,16(sp)
    800058c8:	64a2                	ld	s1,8(sp)
    800058ca:	6105                	addi	sp,sp,32
    800058cc:	8082                	ret
      panic("virtio_disk_intr status");
    800058ce:	00002517          	auipc	a0,0x2
    800058d2:	e8a50513          	addi	a0,a0,-374 # 80007758 <etext+0x758>
    800058d6:	ebffa0ef          	jal	80000794 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
