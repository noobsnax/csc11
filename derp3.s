.data
.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1

.equ GREEN, 3 //bcm 22
.equ YELLOW, 2 //bcm 27
.equ RED, 0 //bcm 17

.equ DONTWALKLED, 24 //BCM 19
.equ WALKLED, 22 //BCM 6

.equ INTERRUPT, 4 //BCM 23
.equ WALK, 29 //bcm 21

.text
.global main

main: 
    push {lr}
    bl wiringPiSetup
    
    mov r0, #WALK
    bl pinInput
    mov r0, #INTERRUPT
    bl pinInput
    mov r0, #GREEN
    bl pinOutput
    mov r0, #YELLOW
    bl pinOutput
    mov r0, #RED
    bl pinOutput
    mov r0, #WALKLED
    bl pinOutput
    mov r0, #DONTWALKLED
    bl pinOutput
    
    mov r0, #DONTWALKLED
    bl pinOn

//control of the program begins here
dowhilecontrol:
    bl readInterrupt
    cmp r0, #1
    beq reset
    bl readPushbutton
    cmp r0, #1
    beq gogreen
    bne gored

gored:
    mov r0, #RED
    bl pinOn
    mov r0, #DONTWALKLED
    bl pinOn
    bl dowhilecontrol

//loop for walk
gogreen:
    ldr r0, =#3500
    bl delay
    mov r0, #DONTWALKLED
    bl pinOff
    mov r0, #RED
    bl pinOff
    mov r0, #WALKLED    
    bl pinOn
    mov r0, #GREEN
    bl pinOn
    ldr r0, =#10000
    bl delay
    mov r0, #GREEN
    bl pinOff
    
blinkercount:
    mov r10, #0 @ blink counter
    b loopyellow

loopyellow:
    add r10, r10, #1 @blink increment
    mov r0, #YELLOW
    bl pinOn
    ldr r0, =#500
    bl delay
    mov r0, #YELLOW
    bl pinOff
    ldr r0, =#500
    bl delay
    cmp r10, #6 @ compare blink counter 
    blt loopyellow
    
    mov r0, #WALKLED
    bl pinOff
    mov r0, #DONTWALKLED
    bl pinOn
    bl gored

//when pushed, this will terminate the program
readInterrupt:
    push {lr}
    mov r0, #INTERRUPT
    bl digitalRead
    pop {pc}

//when pushed, the walk loop will begin
readPushbutton:
    push {lr}
    mov r0, #WALK
    bl digitalRead
    pop {pc}

//clears status of LED's when program terminates
reset: 
    mov r0, #GREEN
    bl pinOff
    mov r0, #YELLOW
    bl pinOff
    mov r0, #RED
    bl pinOff
    mov r0, #DONTWALKLED
    bl pinOff
    mov r0, #WALKLED
    bl pinOff
   
    mov r0, #0
    pop {pc}

pinInput:
    push {lr}
    mov r1, #INPUT
    bl pinMode
    pop {pc}

pinOutput:
    push {lr}
    mov r1, #OUTPUT
    bl pinMode
    pop {pc}

pinOn:
    push {lr}
    mov r1, #HIGH
    bl digitalWrite
    pop {pc}

pinOff:
    push {lr}
    mov r1, #LOW
    bl digitalWrite
    pop {pc}

