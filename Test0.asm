####################################
#
# Test0.asm
#
# See instructions at bottom for 
# how test rig appends student code.
#
# Once code is appended, load into 
# Spim and run. Output produced by 
# student's 'proc' will be printed 
# to Console.
#
####################################

# Labels in the test code are prefixed with __ 
# so as not to clash with labels in student code.
# So student code must not use double-underscores.

main:

# Save return address becasue we call sub-routines.
#
  addiu    $sp, $sp, -8 # Make space but keep double-word aligned.
  sw       $ra, 0($sp)  # Save ra.

# Call student's 'evalX'
#
  li       $a0, 739   # Load a0 with some number for a.
  li       $a1, 112   # Load a1 with emergency number for b.
  li       $a2, 1729  # Load a2 with interesting number for r.
  li       $a3, 42    # Load a3 with answer for d.
  jal      evalX
#
# Print value found in v0.
#
  move     $a0, $v0    # Put value returned for x in a0.
  jal      __PI        # Print it.

# Call student's 'evalY'
#
  li       $a0, -1780407104 # Load a0 with some number for a.
  li       $a1, 211506152   # Load a1 with some number for b.
  li       $a2, 1067097496  # Load a2 with some number for c.
  li       $a3, -441375407  # Load a3 with some number for d.
  jal      evalY
#
# Print value found in v0.
#
  move     $a0, $v0    # Put value returned for x in a0.
  jal      __PI        # Print it.

# Call student's 'proc'
#
  la       $a0, __NNN  # First put address of NNN in a0.
  lw       $a0, 0($a0) # Then swap in data at that address.
  la       $a1, __IN   # Point to data we want processed.
  la       $a2, __OUT  # Point to where we'd like the results to go.
  jal      proc 
#
# Print data found at OUT.
#
  la       $t0, __OUT  # Point to bytes we're printing
  la       $t1, __NNN  # First put address of NNN in t1.
  lw       $t1, 0($t1) # Swap in data at that address.

  # t1 controls this loop.
  #
__PLOOP:
  lbu      $a0, 0($t0) # Load one byte (clears top 3 bytes).
  jal      __PI        # Print it.
          

  addiu    $t0, $t0, 1      # Pointer += 1 byte
  subu     $t1, $t1, 1      # Decrement counter.
  bne      $t1, $0, __PLOOP # Loop back if not 0
  #
  # End of loop.

# Go back to Kansas.
#
  lw       $ra, 0($sp) # Restore return address.
  addiu    $sp, $sp, 8 # Restore stack pointer.
  jr       $ra         

###
# Print integer. 
#
__PI:
  li       $v0, 1      # Print integer.
  syscall              
  la       $a0, __SEP  # Separating string.
  li       $v0, 4      # Print string.
  syscall    
  jr       $ra         # Return

###
# Very sensitive 'numb' good for testing (but only sensitve to x).
#
# Add all four bytes of x together and place in low byte of v0.
# 
numb1:
  andi     $v0, $a0, 0xff # Low byte to v0.
  srl      $a0, $a0, 8
  andi     $t0, $a0, 0xff # Second byte to t0.
  addu     $v0, $v0, $t0  # Add to v0.
  srl      $a0, $a0, 8
  andi     $t0, $a0, 0xff # Third byte to t0.
  addu     $v0, $v0, $t0  # Add to v0.
  srl      $a0, $a0, 8
  andi     $t0, $a0, 0xff # Fourth byte to t0.
  addu     $v0, $v0, $t0  # Add to v0.
  andi     $v0, $v0, 0xff # Mask low byte. Not necessary but polite.
  jr       $ra

###
# Same but for y (so only sensivtive to y).
# When 'numb's are added togther the sum will 
# be sensitive to both x and y, which is good for testing.
#
numb2:
  andi     $v0, $a1, 0xff # Low byte to v0.
  srl      $a1, $a1, 8
  andi     $t0, $a1, 0xff # Second byte to t0.
  addu     $v0, $v0, $t0  # Add to v0.
  srl      $a1, $a1, 8
  andi     $t0, $a1, 0xff # Third byte to t0.
  addu     $v0, $v0, $t0  # Add to v0.
  srl      $a1, $a1, 8
  andi     $t0, $a1, 0xff # Fourth byte to t0.
  addu     $v0, $v0, $t0  # Add to v0.
  andi     $v0, $v0, 0xff # Mask low byte.
  jr       $ra

.data # Begin data area.

# Separator used when printing output.
# Replace with "\n" for one number per line.
#
__SEP: .asciiz ", " 

# Number of groups in the IN data.
#
__NNN: .word  20 

# Test code's input data.
# Here, groups of size 9 - student's format may have samller groups.
# Test rig will use data of group size matching student's format,
# but any 'proc' should run ok with this data as a 'proc' expecting 
# a smaller group size will just read less of this data.
# For testing, you can replace this data with data whose
# expected output you know.
#
__IN:  
.word -1517918040, 1115789266, -208917030, 1019800440, -611652875, 1362132786, 1968097058, -1933932397, 1442904595, 
.word 397902075, 875635521, 64950077, 1489956094, 1957992572, -1643623517, 442180728, -228236395, 1697976025, 
.word 68289794, 1039969854, 1746061949, 2062777118, 299683815, -718691403, 212908357, 132984726, 1032908145, 
.word 82783393, -1035563318, 1297131613, 1128164436, -929119207, 1259270109, -506736844, 1687192100, 1980650109, 
.word -1258025950, -1134942060, 629585107, 829125286, 1592839482, 2048933381, 165189752, 367089247, -2059185116, 
.word -1058874961, -441375407, -1470890476, -1044420384, 293463857, 1673193995, 778745801, 703971413, 262671793, 
.word -1303994816, -1722869427, -1756414860, -1551018189, -571877056, 673507758, 1590266524, 1738307886, 1099690259, 
.word -1114460689, 947176512, 1720160860, -290241090, 351915256, 362280390, 741503441, -716866363, -1166508339, 
.word 308064178, -715801777, 1410429169, -2084635901, -616561149, -297829160, 1403116115, -1704682898, -1182162468, 
.word 915343747, -146541944, 973135903, -621819545, 2136157587, -1390569155, -1877500531, 1234797046, -540078139, 
.word 434289909, -1591302639, -920768406, 211506152, 796003337, 1477887383, 1832147928, 706630323, 463286768, 
.word -1959203182, 632780393, -2018542894, -1780407104, -1760308432, -1278816127, 694628161, 471287540, 1926585807, 
.word -214033886, 1423816413, -1620024977, -947995474, 753538707, -1104080584, -124339775, -2129070873, 920806972, 
.word -808270676, -1276852056, -1549061988, -1684305197, -2044986958, -1452124968, 1938504816, 1406306749, -1195935884, 
.word -1466829314, 2100553785, -173682514, -2066328160, -814398462, -212582669, -1706737518, 85817214, 105789069, 
.word -1652176393, 1306362543, 478618692, 1437104330, 239555435, 822152202, -514502488, 1243460975, -1631790084, 
.word -1173130486, 300314039, 1748246270, 1233958858, -698221733, -402140955, 2053552199, -1489172828, 1071545365, 
.word -444724892, -1521802958, 888404853, -736099300, -1221806407, 314633147, -1783585027, 1436475593, -1060326261, 
.word 1498594620, 2100902339, -413668663, 314093501, -1196310542, 1985409353, 257768773, -1824163649, -877123399, 
.word 986129537, -862405821, -1231247583, 1676137754, 231482240, -1587083445, -1067097496, 505824647, -1581261199,

# NNN bytes of space for 'proc' to put its output.
#
__OUT: .space 20 

.text # End of data area.

################ Student code is appended below ####################
#
# NB These are NOT instructions for preparing student code for 
# upload as a coursework submission. Students should upload 
# unmodified code that loads and runs on Spim and which 
# does not contain double underscores.
#
# After the student code is appended to this test code, 
# the appended code must be modified (this is what the test rig does). 
# 1. Cut-and-paste student code below.
# 2. Change exactly three lines: 
#    replace the labels 'main:', 'numb1:' and 'numb2:'
#    with 'STUDENTmain:', 'STUDENTnumb1:' and 'STUDENTnumb2:', 
#    respectively.
# 
# Do NOT change the calls to 'numb1' and 'numb2' in 'proc'! 
# (These will now call the test code 'numb's above.)
#
# This test code is for testing only, not for upload.
# If you forget and upload this test code with your code appended,
# it will fail all tests (because it contains double underscores
# that will clash with the code the test rig appends it to).
#
####################################################################

# Model code appended below.
#
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

    addiu $s1 $s1 36 # increment input address TODO: CONFIRM IF 36 OR 32 IN PROD GIVEN I ONLY HAVE 8 WORDS. ONLY 32 IN produced
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