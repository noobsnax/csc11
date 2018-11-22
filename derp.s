
.data
prompt:		.asciz		"Enter a positive integer and I'll add it to a running total (negative value entered to stop): "
input:			.asciz		"%d"
outprompt:		.asciz		"The sum is %d and average is %d"


sum:	.word		0
count:	.word		0
inNum: .word 		0

.text
.global main
.extern printf
.extern scanf

main:
	push {lr}
	ldr r5, =sum
	ldr r5, [r5]
	ldr r4, =count
	ldr r4, [r4]
maindo:
	ldr r0, =prompt
	bl printf
	
	ldr r0, =input
	ldr r1, =inNum
	bl scanf
	
	ldr r1, =inNum //loaded
	ldr r1, [r1] //puts value in r1
	cmp r1, #0	
	blt endmaindo
	add r5, r5, r1
	add r4, #1
	b maindo

endmaindo:
	
	push {r5} // adds sum to stack
	mov r0, r5
	mov r1, #0
	mov r2, #1
	mov r3, r4
	
do_while_label1:
		
	mov r3, r3, lsl#1
	mov r2, r2, lsl#1
	cmp r0, r3 //r0 is new sum r3 is counter
	bgt do_while_label1
	
while_r0gtr3:
	
	mov r3, r3, lsr#1
	mov r2, r2, lsr#1


subtract:
	cmp r0, r3 		//compare r0 and r3
	blt output		//branch if less than to output
	
	add r1, r1, r2		//r1=r1+r2
	sub r0, r0, r3		//r0=r0-r3
    

shift_right:
	cmp r2, #1		//compare r2 == 1
	beq subtract		//branch not equal to subtract
	cmp r3, r0		//compare r3 and r0
	ble subtract		//branch less than or equal to subtract
	
	mov r2, r2, lsr#1
	mov r3, r3, lsr#1
	
	b shift_right

output:
	ldr r0, =outprompt
	mov r2, r1
	pop {r1} // pops off the sum
	
	bl printf

end:
	mov r0, #0
	pop {pc}
	
