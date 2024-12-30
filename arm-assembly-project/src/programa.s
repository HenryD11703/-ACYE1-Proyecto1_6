.section .data
menu_msg: .asciz "1. Print Team Members\n2. Perform Statistical Analysis\n3. Export Results to Text File\n4. Exit\nSelect an option: "
team_members: .asciz "Team Members:\n1. Alice\n2. Bob\n3. Charlie\n"
error_msg: .asciz "Invalid option. Please try again.\n"
error_len: .equ . - error_msg

.section .bss
.option: .space 4

.section .text
.global _start

_start:
    // Present menu to user
    ldr x0, =menu_msg
    bl print_string

    // Read user input
    ldr x0, =.option
    bl read_input

    // Handle user input
    ldr w1, [.option]
    cmp w1, #1
    beq print_team_members
    cmp w1, #2
    beq perform_statistical_analysis
    cmp w1, #3
    beq export_results
    cmp w1, #4
    beq exit_program

    // Invalid option
    ldr x0, =error_msg
    bl print_string
    b _start

print_team_members:
    ldr x0, =team_members
    bl print_string
    b _start

perform_statistical_analysis:
    // Call statistical analysis function
    // Placeholder for actual implementation
    b _start

export_results:
    // Call export results function
    // Placeholder for actual implementation
    b _start

exit_program:
    mov x8, #93 // syscall exit
    svc 0

print_string:
    // Print string function
    mov x8, #64 // syscall write
    mov x1, x0
    ldr x2, =.option
    svc 0
    ret

read_input:
    // Read input function
    mov x8, #63 // syscall read
    mov x1, x0
    mov x2, #4
    svc 0
    ret