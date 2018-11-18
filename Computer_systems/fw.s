	.data 
	
		.align 0
current_word:   .space 51   #space for current word
                .align 0
length:		.space 1001
prompt1:        .asciiz  "\ninput: "
prompt2:	.asciiz  "output:\n"
newline:        .asciiz  "\n"
space:		.ascii " " 
char1:		.ascii ","
char2:		.ascii "."
char3:		.ascii "!"
char4:		.ascii "?"
char5:		.ascii "-"
char6:		.ascii "_"
char7:		.ascii "("
char8:		.ascii ")"
char9:		.ascii  "\0"


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

	li  $s4, 0     #current_word_length
        la  $s3, current_word  #s3 start of current_word array

process_input:
#current character in $t0
#result of is_delimiting_char in $t1
	#beq $t4, $t7, print DELETE THIS
	lb $t0, ($s0) #get one character of input
	jal is_delimiting_char
	bnez $t1, is_delim   #if it is delim char go to is_delim
	beqz $t1, is_not_delim #else;

is_delimiting_char:
	
	lb $t2, space    #if current char is delimiting, set $t1 to 1, if not, set to 0
	seq $t1, $t0, $t2
	bnez $t1, jump_ra
	lb $t2, char1
	seq $t1, $t0, $t2
	bnez $t1, jump_ra
	lb $t2, char2
	seq $t1, $t0, $t2
	bnez $t1, jump_ra
	lb $t2, char3
	seq $t1, $t0, $t2
	bnez $t1, jump_ra
	lb $t2, char4
	seq $t1, $t0, $t2
	bnez $t1, jump_ra
	lb $t2, char5
	seq $t1, $t0, $t2
	bnez $t1, jump_ra
	lb $t2, char6
	seq $t1, $t0, $t2
	bnez $t1, jump_ra
	lb $t2, char7
	seq $t1, $t0, $t2
	bnez $t1, jump_ra
	lb $t2, char8
	seq $t1, $t0, $t2
	bnez $t1, jump_ra
	lb $t2, char9
	seq $t1, $t0, $t2
	bnez $t1, jump_ra
	lb $t2, newline
	seq $t1, $t0, $t2
	bnez $t1, jump_ra

jump_ra:
	
	jr $ra
	
is_delim:

	bnez $s4, current_word_len_greater_than_zero
	beqz $s4, end_of_sentence
	
current_word_len_greater_than_zero:
    
	li $s1, 0                #int i = 0;
	add $s5, $s3, $zero        #index for current word 
	jal print
	li $s4, 0   #current_word_len = 0;
	

end_of_sentence:

	lb $t1, newline
	beq $t0, $t1, main #if current processed character is '\n'
	j loop_inp

	

is_not_delim:

         add $t1, $s4, $s3  #current_word[current_word_len]
         sb $t0, ($t1)      #current_word[current_word_len] = cur_char;
         addi $s4, $s4, 1   #current_word_len++;
         
loop_inp:

	addi $s0, $s0, 1
	j process_input
	
print:

	beq $s1, $s4, print_new_line
	lb $s6 ($s5)
	li   $v0, 11          # prints out a character;
        move $a0, $s6     
        syscall
        
        addi $s1, $s1, 1      #int i++
        addi $s5, $s5, 1
        
        j print
        
print_new_line:

        li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall
        
        jr $ra
     
