	.data 
	
length:		.space 1001
current_word:    .space 51   #space for current word
lengths:         .space 2004 #space for integers array lengths[501]
histogram:       .space 2004 #space for integers array histogram[501]
compare:         .space 1001
prompt1:        .asciiz  "input: "
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
        la   $a1, 1001
        syscall
        
        li   $s1, 1001          # MAX_CHARS;
	add $s2, $a0, $zero     #$s2 now holds the starting position of our input string
	
	li   $v0, 4           # print_string("output:\n");
        la   $a0, prompt2
        syscall
        
        li  $t4, 0     #current_word_length
        la  $s3, current_word  #s3 start of current_word array
        la  $s4, lengths   #int lengths[501];
        la  $s5, histogram #int histogram[501];
        la  $s6, compare   #char compare[MAX_CHARS];
        li  $a0, 0         #int lengths_number = number of unique words
        li  $a1, 0         #int total_length;
        li  $a2, 0         #result
        li  $a3, 0         #result1
        
process_input:
#current character in $t0
#result of is_delimiting_char in $t1
	lb $t0, 0($s2) #get one character of input
	jal is_delimiting_char
	bnez $t1, is_delim   #if it is delim char go to is_delim
	beqz $t1, is_not_delim #else;
	
loop_inp:
	addi $s2, $s2, 1          #inp++;
	j process_input
        
is_delimiting_char:
	
	lb $t2, space    #if current char is delimiting, set $t1 to 1, if not, set to 0
	seq $t1, $t0, $t2
	lb $t2, char1
	seq $t1, $t0, $t2
	lb $t2, char2
	seq $t1, $t0, $t2
	lb $t2, char3
	seq $t1, $t0, $t2
	lb $t2, char4
	seq $t1, $t0, $t2
	lb $t2, char5
	seq $t1, $t0, $t2
	lb $t2, char6
	seq $t1, $t0, $t2
	lb $t2, char7
	seq $t1, $t0, $t2
	lb $t2, char8
	seq $t1, $t0, $t2
	lb $t2, char9
	seq $t1, $t0, $t2
	lb $t2, newline
	seq $t1, $t0, $t2
	
	jr $ra
	
is_delim:

	bne $t4, $zero, current_word_index_greater_than_zero   #if ( current_word_index > 0 )
	j end_of_sentence
	
end_of_sentence:	
	lb $t0, 0($s2)  #current char
	lb $t2, newline
	beq $t0, $t2, end                                      #if cur_char == '\n' then end of sentence
	j loop_inp                                             #else

is_not_delim:

        add  $t3, $s3, $zero    #current_word_index
        sb   $t0, ($t3)
        addi $t4, $t4, 1             #current_word_len++;
        addi $t3, $t3, 1             # current_word_index++;
        j loop_inp
        
current_word_index_greater_than_zero:

	jal histogram_creator
	li $t4, 0  #current_word_len = 0;
	la $t5, 0($s6)  #compare_index = 0;
	la $t3, 0($s3)  #current_word_index = 0;
	j end_of_sentence
	
histogram_creator:
	#$t3 = current_word_index
	#$t4 = current_word_length
	#$t5 = compare_index
	#$a0 = number of lengths = number of unique words
	#$a1 = int total_length;
        #$a2 = result
        #$a3 = result1
        #$s3 = char current_word[MAX_WORD_LENGTH];
        #$s4 = int lengths[501];
        #$s5 = int histogram[501];
        #$s6 = char compare[MAX_CHARS];
        
        #add $t0, $t0, $zero    #int i counter
	beqz $a0, if_histogram_creator   #if number of lengths = 0; - unique array is empty
	move $t0, $zero              #int i counter for outer_for_loop
	add $t1, $s4, $zero              #get the adress of int lengths[501];
	bnez $a0, outer_for_loop         #if number of lengths > 0; - unique array is not empty
	
	beqz $a3, if_histogram_creator
	bnez $a3, else_histogram_creator
	
outer_for_loop:

	 
	 beq $t0, $a0, if_histogram_creator #int i = number of unique words
	 lw $t2, ($t1)                 #lengths[i];
	 move $t6, $zero              #$t6 = int j counter for outer_for_loop
	 add $t7, $zero, $s6    #start of compare[]
	 add $s7, $zero, $s3    #start of current_word[]
	 beq $t4, $t2, inner_for_loop
	 add $t5, $t5, $t2             #compare_index += lengths[i];
	 addi $t0, $t0, 1              #i++;
	 j outer_for_loop
	 

inner_for_loop:

	 add $t7, $t6, $t5    #j + compare_index
	 lb $t8, ($t7)        #compare[j + compare_index]
	 add $s7, $s7, $s6
	 lb $t9, ($s7)        #word[j]
	 addi $t6, $t6, 1     #j++
	 beq $t8, $t9, increment_result
	 
increment_result:

	addi $a2, $a2, 1
	beq $a2, $t2, if_part
	bne $a2, $t2, if_histogram_creator
	j inner_for_loop

if_part:        #if( result == lengths[i]) {}

	add $t5, $zero, $s5   #$t5 = starting position of histogram[]
	sll $t6, $t0, 2     #t6 = i in histogram[i]
	lw $t7 ($t5)         #histogram[i]
	addi $t7, $t7, 1    #histogram[i]++;
	move $a2, $zero     #result = 0
	move $a3, $zero     #result1 = 0
	jr $ra
	
if_histogram_creator:    #if (result1 == 0) {};

	sll $t6, $a0, 2  #multiply number of unique words
	add $t7, $s4, $t6 #position for lengths[lengths_number] => array + num_unique_words*4
	sw $t4, ($t7) #lengths[lengths_number] = current_word_len;
	add $t8, $s5, $t6  ##position for histogram[lengths_number]
	li $t6, 0
	sw $t6, ($t8) #histogram[lengths_number] = 0;
	lw $t1, ($t8)   #current value of lengths_number
	addi $t1, $t1, 1 #histogram[lengths_number]++;
	li $t2, 0
	add $t2, $s3, $zero #position of char for current_word[]
	li $t3, 0
	li $t5, 0
	add $t5, $t5, $1  #compare[i + total_length]
	sll $t5, $t5, 2   #compare[i + total_length]*4
	add $t3, $s6, $t5 #position of char for compare[i + total_length]
	li $t5, 0     #int i counter for for_loop
	j for_loop
	
for_loop:

	beq $t5, $a0, rest_of_histogram_creator # int i = current value of lengths_number
	#add $t0, $t0, $zero #int i counter
	lb $t1, ($t2)
	sb $t1, ($t3)
	addi $t2, $t2, 4
	addi $t3, $t3, 4
	addi $t5, $t5, 1
	j for_loop
	
rest_of_histogram_creator:

	addi $a0, $a0 1    #lengths_number++;
	add $a1, $a1, $t4  #total_length += current_word_len;
	addi $s4, $s4, 4  #increment indexes in lengths and histogram
	addi $s5, $s5, 4
	jr $ra
	
else_histogram_creator:
	
	move $a3, $zero
	jr $ra
	
print_new_line:

	li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall

end: #filling the required variables

	move $s4, $zero  #the compare_index
	move $s6, $a0  #lengths_number will be needed after syscalls
	move $t0, $zero
	addi $t0, $t0, -1
	move  $s7, $t0
	move $s0, $zero  #num_words_with_max_frequency
	
	li   $v0, 1           # print number of unique words;
        move $a0, $s6
        syscall
        
        li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall
        
        move $t0, $zero     #k = 0
loop_for_max_frequency:  
        #add $t0, $t0, $zero   #k = 0;
        beq $t0, $s6, max_frequency
        add $t2, $s5, $zero    #start of histogram
        lw $t3, ($t2)
        slt $t1, $s7, $t3
        bnez $t1, change_max_freq
        addi $t2, $t2, 4    #k++;
        addi $t0, $t0, 1    #loop counter++;
        j loop_for_max_frequency
        
change_max_freq:

	addi $t0, $t0, 1    #loop counter++;
	move $s7, $t3
	addi $t2, $t2, 4    #k++;
	j loop_for_max_frequency
        
max_frequency:

	li   $v0, 1           # print number of unique words;
        move $a0, $s7
        syscall
        
        li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall
        
        li $t0, 0  #k = 0;
        
        
        
loop_for_num_words_with_max_frequency:

	#add $t0, $t0, $zero   #k = 0;
        beq $t0, $s6, num_words_with_max_frequency
        move $t2, $s5    #start of histogram
        lw $t3, ($t2)
        beq $s7, $t3, increment_num_with_max_frequency
        addi $t2, $t2, 4    #k++;
        addi $t0, $t0, 1    #loop counter++
        j loop_for_num_words_with_max_frequency
        
increment_num_with_max_frequency:

	addi $s0, $s0, 1    ##num_words_with_max_frequency++;
	addi $t0, $t0, 1    #loop counter++
	addi $t2, $t2, 4    #k++;
	j loop_for_num_words_with_max_frequency

num_words_with_max_frequency:

	li   $v0, 1           # num_words_with_max_frequency;
        move $a0, $s0
        syscall
        
        li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall
        
indexes_for_loop_for_word:

	sll $s6, $s6, 2
	la $a0, current_word   #word;
	move $t0, $zero        #k = 0;

loop_for_word:

        beq $t0, $s6, word
        move $t2, $s5          #start of histogram
        lw $t3, ($t2)          #get number from histogram
        li $t6, 0              #i = 0; for in_loop
        add $t4, $t4, $s4      #start of lengths
        lw $t5, 0($t4)         #get number from lengths = lengths[k]
        beq $t3, $s7, in_loop  #if(histogram[k]==max_frequency) {};
        add $s4, $s4, $t4      #compare_index += lengths[k];
        addi $t0, $t0, 4
        j loop_for_word
        
in_loop:

	beq $t5, $t6, word
	add $t7, $s6, $zero #starting of compare[]
	add $t9, $a0, $zero #starting of word[]
	add $t7, $t7, $s5   #compare_index + i
	lb $t8, ($t7)
	sb  $t8, ($t9)        #word[i] = compare[compare_index + i];
	addi $t6, $t6, 1
	j in_loop
        
        
word:
        #lb $s2, char9   #load '\0'
        add $t9, $t9, $0 #add '\0' at the end
	move $s0, $a0   #for syscalls
	move $s2, $t5   #lengths[k] for syscalls
	move $s3, $zero  #loop counter for syscalls
        
        
word_syscall:

	beq $s3, $s2, end_all  
	lb $s1, ($s0)         # get one character
	li   $v0, 11          # prints out a character;
        move $a0, $s1     
        syscall
        
        addi $s0, $s0, 1     #next character
        addi $s3, $s3, 1     # loop count 1
        
        j word_syscall

end_all:

	li   $v0, 10          # exit()
        syscall

	
        
        
