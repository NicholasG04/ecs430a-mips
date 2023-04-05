evalX:
  # x = (2b * a/8) + (d/8 ^ 2d)/16
  # a0 = a, a1 = b, a2 = c, a3 = d
  addu  $t0 $a1 $a1 # $t0 = $a1 + $a1 (2b)
  ori   $t1 $0 8
  # sra		$t1 $a0 3			# $t1 = $a0 >> 3 (a/8)  THIS DOES NOT CURRENTLY ACCOUNT FOR NEGATIVES HUGE L?
  div  $a0 $t1 # $a0 / $t1 (a/8) NOW ACCOUNTS FOR NEGATIVES
  mflo  $t1 # $t1 = $t1 / $a0 (a/8)

  mult $t0 $t1	# $t0 * $t1
  mflo  $t0 # $t0 = $t0 * $t1 (first bracket complete)

  # sra		$t1 $a3 3			# $t1 = $a3 >> 3 (d/8) THIS DOES NOT CURRENTLY ACCOUNT FOR NEGATIVES HUGE L?
  ori   $t1 $0 8
  div  $a3 $t1 # $a3 / $t1 (d/8) NOW ACCOUNTS FOR NEGATIVES
  mflo  $t1 # $t1 = $t1 / $a3 (d/8)

  addu  $t2 $a3 $a3 # $t2 = $a3 + $a3 (2d)
  xor   $t3 $t1 $t2 # $t3 = $t1 ^ $t2 (d/8 ^ 2d)
  # sra		$t3 $t3 4			# $t3 = $t3 >> 4 (d/8 ^ 2d)/16 THIS DOES NOT CURRENTLY ACCOUNT FOR NEGATIVES HUGE L?
  ori   $t4 $0 16
  div  $t3 $t4 # $t3 / $t4 (d/8 ^ 2d)/16 NOW ACCOUNTS FOR NEGATIVES
  mflo  $t3 # $t3 = $t3 / $t4 (d/8 ^ 2d)/16

  addu  $v0 $t0 $t3 # $v0 = $t0 + $t3 (sum complete)

  jr    $ra

evalY:
  # y = (d/32 % -c) + (5b / (-5389 - 3d))/32
  # a0 = a, a1 = b, a2 = c, a3 = d
  # sra   $t0 $a3 5			# $t0 = $a3 >> 5 (d/32) THIS DOES NOT CURRENTLY ACCOUNT FOR NEGATIVES HUGE L?
  ori   $t0 $0 32
  div  $a3 $t0 # $a3 / $t0 (d/32) NOW ACCOUNTS FOR NEGATIVES
  mflo  $t0 # t0 = $t0 / $a3 (d/32)

  subu  $t1 $0 $a2 # $t1 = -c
  div  $t0 $t1 # $t0 / $t1
  mfhi  $t0 # $t0 = $t0 % $t1 (first bracket complete)

  ori   $t1 $0 5
  mult $t1 $a1 # $t1 * $a1 (5b)
  mflo  $t1 # $t1 = $t1 * $a1 (5b)

  subu  $t2 $0 5389 # $t2 = -5389
  ori   $t3 $0 3 # $t3 = 3
  mult $t3 $a3 # $t3 * $a3 (3d)
  mflo  $t3 # $t3 = $t3 * $a3 (3d)

  subu  $t2 $t2 $t3 # $t2 = $t2 - $t3 (-5389 - 3d)

  div  $t1 $t2 # $t1 / $t2
  mflo  $t1 # $t1 = $t1 / $t2 

  # li    $t2 32 # $t2 = 32
  # div  $t1 $t2 # $t1 / $t2
  # mflo  $t1 # $t1 = $t1 / $t2

  # sra   $t1 $t1 5 # $t1 = $t1 >> 5 (5b / (-5389 - 3d))/32 
  ori   $t2 $0 32
  div  $t1 $t2 # $t1 / $t2
  mflo  $t1 # $t1 = $t1 / $t2 (5b / (-5389 - 3d))/32

  addu  $v0 $t0 $t1 # $v0 = $t0 + $t1 (sum complete)

  jr    $ra

proc:
  addiu $sp $sp -28 # decrement stack pointer
  sw $ra 0($sp) # save return address

  # b a d d d c b d
  # N = a0, starting address of input data = a1, starting address of output data = a2

  sw $s0 4($sp) # store s0 on stack
  sw $s1 8($sp) # store s1 on stack
  sw $s2 12($sp) # store s2 on stack


  addi $s0 $a0 0 # store N in s0
  addi $s1 $a1 0 # store input data address in s1
  addi $s2 $a2 0 # store output data address in s2

  loop:
    lw $a0 4($s1) # load a
    lw $a1 0($s1) # load b
    lw $a2 20($s1) # load c
    lw $a3 8($s1) # load d

    jal evalX

    nop
    nop
    nop

    # sw $v0 0($a2) # store x
    # addi $t0 $v0 0 # store x in a0
    sw $v0 16($sp) # store x on the stack

    jal evalY

    nop
    nop
    nop

    sw $v0 20($sp) # store y
    addi $a1 $v0 0 # store y in a1

    lw $a0 16($sp) # load x from stack

    jal numb1
    andi $t0 $v0 0x000000FF # store LSB of ret in t0
    sw $t0 24($sp) # store LSB of ret on the stack

    lw $a0 16($sp) # load x from stack
    lw $a1 20($sp) # load y from stack

    jal numb2
    andi $t1 $v0 0x000000FF # store LSB of ret in t1

    lw $t0 24($sp) # load LSB of ret from the stack
    addu $t2 $t0 $t1 # add LSBs
    andi $t2 $t2 0x000000FF # mask to 8 bits
    sb $t2 0($s2) # store in output

    addiu $s1 $s1 32 # increment input address TODO: CONFIRM IF 36 OR 32 IN PROD GIVEN I ONLY HAVE 8 WORDS. ONLY 32 IN produced
    addiu $s2 $s2 1 # increment output address
    addiu $s0 $s0 -1 # decrement N

    bgtz $s0 loop # if N > 0, loop



    nop
    nop
    nop

  nop
  nop
  nop

  lw $s2 12($sp) # restore s2 from stack
  lw $s1 8($sp) # restore s1 from stack
  lw $s0 4($sp) # restore s0 from stack

  lw $ra 0($sp) # load return address
  addiu $sp $sp 28 # increment stack pointer
  jr $ra