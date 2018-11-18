	.data 
	
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
        la   $a1, 1001
        syscall


        li   $s1, 1001          # MAX_CHARS;
	add $s3, $a0, $zero     #$s3 now holds the starting position of our input string
	
	li   $v0, 4           # print_string("output:\n");
        la   $a0, prompt2
        syscall
	j loop1
	
	
loop1: #gets next character and checks if it is delimiting


 	 beq $s1, $s3, main_end 
 	 lb $t0, 0($s3)
 	 
 	 j is_delimiting_char1
 	 
loop2: #gets next character and checks if it is delimiting

	 beq $s1, $s3, main_end 
 	 lb $t0, 0($s3)
 	 
 	 j is_delimiting_char2

is_delimiting_char1: 
#if character is delimitng it does 'nothing', that is it moves to another character without printing it
#else it prints current character
 
	 lb $t2, space
	 seq $t1, $t0, $t2
	 bnez  $t1, nothing
	 lb $t2, char1
	 seq $t1, $t0, $t2
	 bnez $t1, nothing
	 lb $t2, char2
	 seq $t1, $t0, $t2
	 bnez $t1, nothing
	 lb $t2, char3
	 seq $t1, $t0, $t2
	 bnez $t1, nothing
	 lb $t2, char4
	 seq $t1, $t0, $t2
	 bnez $t1, nothing
	 lb $t2, char5
	 seq $t1, $t0, $t2
	 bnez $t1, nothing
	 lb $t2, char6
	 seq $t1, $t0, $t2
	 bnez $t1, nothing
	 lb $t2, char7
	 seq $t1, $t0, $t2
	 bnez $t1, nothing
	 lb $t2, char8
	 seq $t1, $t0, $t2
	 bnez $t1, nothing
	 lb $t2, char9
	 seq $t1, $t0, $t2
	 bnez $t1, main_end
	 
	 j print

is_delimiting_char2: 
#if character is delimitng it goes to 'print_new_line', that is it prints new line
#if current character is not delimiting, it goes to 'print' and prints this character

	 lb $t2, space
	 seq $t1, $t0, $t2
	 bnez  $t1, print_new_line
	 lb $t2, char1
	 seq $t1, $t0, $t2
	 bnez $t1, print_new_line
	 lb $t2, char2
	 seq $t1, $t0, $t2
	 bnez $t1, print_new_line
	 lb $t2, char3
	 seq $t1, $t0, $t2
	 bnez $t1, print_new_line
	 lb $t2, char4
	 seq $t1, $t0, $t2
	 bnez $t1, print_new_line
	 lb $t2, char5
	 seq $t1, $t0, $t2
	 bnez $t1, print_new_line
	 lb $t2, char6
	 seq $t1, $t0, $t2
	 bnez $t1, print_new_line
	 lb $t2, char7
	 seq $t1, $t0, $t2
	 bnez $t1, print_new_line
	 lb $t2, char8
	 seq $t1, $t0, $t2
	 bnez $t1, print_new_line
	 lb $t2, char9
	 seq $t1, $t0, $t2
	 bnez $t1, main
	 
	 j print
	 


	 
print: #prints current non-delimiting character

	li   $v0, 11          #    prints out a character;
        move $a0, $t0      
        syscall
        
        addi $s3, $s3, 1     #loop count 1
        
        j loop2

print_new_line: #prints new line after one or more delimiting characters

	li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall
        
        addi $s3, $s3, 1    #loop count 1
        
        j loop1
        
nothing: #add 1 to loop counter

	addi $s3, $s3, 1     #loop count 1
        
        j loop1
        
main_end:

	li   $v0, 10          # exit()
        syscall
	
