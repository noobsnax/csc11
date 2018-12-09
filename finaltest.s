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
.equ STOP_PINS, 29 //BCM 21

.text
.global main

main: 
    push {lr}
    bl wiringPiSetup
    
    bl readPushbutton
    cmp r0, #1
    bne walk
    bl readPushbutton
    cmp r0, #0
    beq redLight


gogreen:
    mov r0, #GREEN
    bl pinOutput
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
    bl blink
    cmp r10, #6 @ compare blink counter 
    blt loopyellow

redLight:
    mov r0, #RED
    bl pinOutput
    mov r0, #RED
    bl pinOn
    mov r0, #DONTWALKLED
    bl pinOn

walk: 
    cmp r0, #HIGH
    b gogreen 
    
reset: 
    push {lr}
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
    bl stopwalk
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

blink:
    push {lr}
    mov r1, #HIGH
    bl pinOn
    ldr r0, =#500
    bl delay
    mov r1, #LOW
    bl pinOff
    ldr r0, =#500
    bl delay
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

readPushbutton:
    push {lr}
    mov r0, #STOP_PINS
    bl digitalRead
    pop {pc}

stopwalk:
    bl reset
    pop {r4, r5, pc}
