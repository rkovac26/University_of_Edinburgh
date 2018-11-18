	.data 
	
		.align 0
length:		.space 1001
		.align 0
current_word:    .space 51   #space for current word
		.align 2
lengths:         .space 2004 #space for integers array lengths[501]
		.align 2
histogram:       .space 2004 #space for integers array histogram[501]
                  .align 0
compare:         .space 1001
		  .align 0
word:            .space 51
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
        
	#add $s0, $a0, $zero     #$s0 now holds the starting position of our input string
	
	li   $v0, 4           # print_string("output:\n");
        la   $a0, prompt2
        syscall
        
variables:

        li  $t4, 0     #current_word_length
        la  $s3, current_word  #s3 start of current_word array
        la  $s4, lengths   #int lengths[501];
        la  $s5, histogram #int histogram[501];
        la  $s6, compare   #char compare[MAX_CHARS];
        li  $a0, 0         #result = 0
        li  $a1, 0         #int total_length;
        li  $s1, 0         #int lengths_number = number of uniqeu words = 0;
        li  $t5, 0         #compare_index
        
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

	bnez $t4, current_word_len_greater_than_zero
	beqz $t4, end_of_sentence
	
current_word_len_greater_than_zero:

	li $t1, 0      #int i = 0;
	jal histogram_creator
	li $t5, 0   #compare_index = 0;
	li $t4, 0   #current_word_len = 0;
	

end_of_sentence:

	lb $t1, newline
	beq $t0, $t1, end #CHANGE na main #if current processed character is '\n'
	j loop_inp

	

is_not_delim:

         add $t1, $t4, $s3  #current_word[current_word_len]
         sb $t0, ($t1)      #current_word[current_word_len] = cur_char;
         addi $t4, $t4, 1   #current_word_len++;
         
loop_inp:

	addi $s0, $s0, 1
	j process_input
	
histogram_creator:

	beq $s1, $t1, if_part_histogram_creator    #if lengths_number = int i
	sll $t2, $t1, 2                            #int i couter for arrays of integers
	add $t3, $s4, $t2                          #index for lengths[i]
	lw $t6, ($t3)                              #lengths[i]
	bne  $t4, $t6, rest_of_outer_loop          #if(current_word_len == lengths[i])
	li $t7, 0                                  #int j = 0
	
inner_loop_histogram_creator:

	beq $t7, $t6, if_result_equal_lengths      #j == lengths[i]
	add $t8, $s3, $t7                          #index for word[j]
	add $t9, $t5, $t7                          #j + compare_index
	add $t9, $s6, $t9                          #index for compare[j + compare_index]
	lb $a2, ($t8)
	lb $a3, ($t9)
	beq $a2, $a3, increment_result             #if(word[j] == compare[j + compare_index])
	bne $a2, $a3, rest_of_outer_loop
	
increment_result:

	addi $a0, $a0, 1                           #result++;
	addi $t7, $t7, 1                           #j++;
	j inner_loop_histogram_creator
	
	
if_result_equal_lengths:

	add $t8, $s5, $t2                         #index for histogram[i]
	lw $t9, ($t8)                             #histogram[i]
	addi $t9, $t9, 1                          #histogram[i]++;
	sw $t9, ($t8)
	li $a0, 0                                 #result = 0;
	jr $ra

rest_of_outer_loop:

	add $t5, $t5, $t6                          #compare_index += lengths[i];
	addi $t1, $t1, 1                           #i++;
	j histogram_creator


	
if_part_histogram_creator:

	sll $t2, $s1, 2    #index for lengths[lengths_number]
	add $t3, $t2, $s4  #lengths[lengths_number]
	sw $t4, ($t3)      #lengths[lengths_number] = current_word_len;
	add $t6, $t2, $s5  #histogram[lengths_number]
	li $t1, 1          #$t1 = 1
	sw $t1, ($t6)      #histogram[lengths_number] = 1;
	li $t1, 0          #int i = 0
	j loop_if_part_histogram_creator
	
loop_if_part_histogram_creator:

	beq $t1, $t4, after_loop_if_part_histogram_creator
	add $t2, $t1, $a1   #i + total_length
	add $t2, $t2, $s6   #index for compare[i + total_length]
	add $t3, $t1, $s3   #index for word[i]
	lb $t6, ($t3)
	sb $t6, ($t2)       #compare[i + total_length] = word[i];
	addi $t1, $t1, 1    #i++;
	j loop_if_part_histogram_creator
	
	
after_loop_if_part_histogram_creator:
	
	addi $s1, $s1, 1   #lengths_number++;
	add $a1, $a1, $t4  #total_length += current_word_len;
	jr $ra
	
end: #filling the required variables

	#num_unique_words
	li   $v0, 1           # print number of unique words;
        move $a0, $s1
        syscall
        
        li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall
        
        li $t0, 0   #int k = 0
        li $s0, -1  #max_frequency
        li $s2, 0   #num_words_with_max_frequency;
        
loop_for_max_frequency:

       beq $t0, $s1, max_frequency_print  #k < lengths_number
       sll $t1, $t0, 2
       add $t2, $s5, $t1      #index for histogram[k]
       lw $t3, ($t2)          #histogram[k]
       slt $t4, $s0, $t3      #histogram[k]>max_frequency
       bnez $t4, change_max_frequency
       addi $t0, $t0, 1       #k++;
       j loop_for_max_frequency
       
change_max_frequency:

	li $s0, 0
	add $s0, $s0, $t3         # max_frequency=histogram[k];
	addi $t0, $t0, 1     #k++;
	j loop_for_max_frequency
        
max_frequency_print:
        
	li   $v0, 1           # print number of unique words;
        move $a0, $s0
        syscall
        
        li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall

	li $t0, 0  #int k = 0;

loop_for_num_words_with_max_frequency:

	beq $t0, $s1, print_num_words_with_max_frequency
	sll $t1, $t0, 2
        add $t2, $s5, $t1      #index for histogram[k]
        lw $t3, ($t2)          #histogram[k]
        seq $t4, $t3, $s0      #if(histogram[k]==max_frequency)
        bnez $t4, increment_num_with_max_frequency
        addi $t0, $t0, 1
        j loop_for_num_words_with_max_frequency
        
increment_num_with_max_frequency:

        addi $s2, $s2, 1       #num_words_with_max_frequency++;
        addi $t0, $t0, 1
        j loop_for_num_words_with_max_frequency

print_num_words_with_max_frequency:

	li   $v0, 1           # num_words_with_max_frequency;
        move $a0, $s2
        syscall
        
        li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall
        
        li $t0, 0             #int k = 0
        li $t5, 0             #compare_index
        la $s3, word
loop_word:

	beq $t0, $s1, print_word_variables
	sll $t1, $t0, 2
	add $t2, $s5, $t1      #index for histogram[k]
        lw $t3, ($t2)          #histogram[k]
        seq $t4, $t3, $s0      #if(histogram[k]==max_frequency)
        li $t8, 0              #int i = 0
        add $t6, $s4, $t1      #index for lengths[k];
        lw $t7 ($t6)           #lengths[k]
        bnez $t4, inner_loop_word
        add $t5, $t5, $t7      #compare_index += lengths[k];
        add $t0, $t0, 1
        j loop_word
        
        
inner_loop_word:

	beq $t8, $t7, print_word_variables
	add $t0, $t5, $t8
	add $t1, $s6, $t0        #index for compare[compare_index + i]
	add $t9, $s3, $t8        #index for word[i]
	lb $t2, ($t1)
	sb $t2, ($t9)
	addi $t8, $t8, 1         #word[i] = compare[compare_index + i];
	j inner_loop_word
	
	
print_word_variables:

        li $s2, 0
        add $s2, $s2, $t7       #lengths[k] for syscalls
        li $s0, 0           #int i = 0
        
print_word:

	beq $s0, $s2, main
	lb $s4 ($s3)
	li   $v0, 11          # prints out a character;
        move $a0, $s4     
        syscall
        
        addi $s0, $s0, 1      #int i++
        addi $s3, $s3, 1
        j print_word

	

print:

	
	li   $v0, 4
	move $a0, $s6       
        la   $a0, ($s6)         #start of current_word array
        syscall
        
        li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall
        
        add $t1, $zero, $s5
        lw $s2, ($t1)
        li $v0, 1
        move $a0, $s2
        syscall
        
        li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall
        
        addi $t1, $s5, 4
        lw $s2, ($t1)
        li $v0, 1
        move $a0, $s2
        syscall
        
        j main
