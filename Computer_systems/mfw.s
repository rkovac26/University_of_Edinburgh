	.data 
	
length:		.space 1001
current_word:    .space 51   #space for current word
lengths:         .space 2004 #space for integers array lengths[501]

prompt1:        .asciiz  "input: "
prompt2:	.asciiz  "output:\n"


	.text
	
	.globl main
	
main:
        
        li   $v0, 4           # print_string("input: ");
        la   $a0, prompt1
        syscall

        li   $v0, 8           # input_string = read_string();
        la   $a0, length	#starting position of our input string
        add $s0, $a0, $zero     #$s0 now holds the starting position of our input string
        la   $a1, 1001
        syscall
	
	li   $v0, 4           # print_string("output:\n");
        la   $a0, prompt2
        syscall
        
        
variables:

	#$s0 = start of input array
	li  $t4, 0     #current_word_length
        la  $s3, current_word  #s3 start of current_word array
        la  $s4, lengths   #int lengths[501];
        li $t4, 4
        li $t5, 5
        add $t3, $zero, $s4  #index ofr lengths
        
loop_variables_int:

	sw $t4, ($t3)
	addi $t3, $t3, 4
	sw $t5, ($t3)
	lw $t4, ($t3)
 
loop_variables:

        li $t3, 0    #int i = loop counter
        #li $t4, 4    #length of input word
	add $t1, $zero, $s3    #index for current_word array
	add $t2, $zero, $s0    #index for input array

loop:

	beq, $t3, $t4, print
	lb $t0, ($t2)
	sb $t0, ($t1)
	addi $t1, $t1, 1   #current_word_index++;
	addi $t2, $t2, 1   #input_array_index++;
	addi $t3, $t3, 1   #int i++;
	j loop
	
print:

	#addi $t1, $t1, 0    #start of current_word array
	#add $s1, $t1, $zero
	
	li   $v0, 4
	move $a0, $s3         
        la   $a0, 0($s3)         #start of current_word array
        syscall
        
        j main
	