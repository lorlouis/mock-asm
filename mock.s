section .bss
    char_buff resb 1

section .data
    msg_usage db 'Usage: mock <',34,'string to mock',34,'> other words to mock ...',0ah
    msg_usage_len equ $-msg_usage
    msg_newline db 0ah

section .text

global _start

; eax char
; ebx file desc
print_char:
    mov ecx, eax
    mov eax, 4
    mov edx, 1
    int 80h
    ret

; eax null terminated str*
strlen:
    mov ecx, 0
    __loopcharisnotnone:
        add ecx, 1
        cmp byte [eax+ecx], 0
    jne __loopcharisnotnone
    mov eax, ecx
    ret

; eax pointer to a char
invert_case:
    mov ebx, 0
    mov bl, byte [eax]
    cmp bl, 122
    jg _inv_case_end
    cmp bl, 65
    jl _inv_case_end
    cmp bl, 90
    jle __cap
    cmp bl, 97
    jl _inv_case_end
    ; at this point bl must
    ; be a lower case char
    sub bl, 32
    jmp ___merge
    __cap:
    ; at this point bl must
    ; be a capital char
    add bl, 32
    ___merge:
    mov byte [eax], bl
    _inv_case_end:
    ret

; eax pointer to str
str_invert_half_case:
    mov ebx, 0
    __inv_case_loopcharisnotnone:
        not ebx
        cmp ebx, 0
        jne __inv_case_do_nothing
        push ebx
        push eax
        call invert_case
        pop eax
        pop ebx
        __inv_case_do_nothing:
        add eax, 1
        cmp byte [eax], 0
    jne __inv_case_loopcharisnotnone
    ret

_start:

    ; esp is a pointer to the number of args
    cmp byte [esp], 1
    jg args_are_valid
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_usage
    mov edx, msg_usage_len
    int 80h
    jmp exit

    ;mov al, byte [esp]  ; [esp] is argn
    ; [exp+4*n] is argv
    ; print the nb of args
    ;add al, 48
    ;mov [char_buff], al
    ;mov eax, char_buff
    ;mov ebx, 1
    ;call print_char
    ;; print new line
    ;mov eax, msg_newline
    ;mov ebx, 1
    ;call print_char


    ; loop through each arg
    args_are_valid:
    mov ebx, 2  ; argv[1]
    __looptillnoargs:

        
        mov eax, [esp+4*ebx]
        push ebx
        call str_invert_half_case

        pop ebx
        mov eax, [esp+4*ebx]
        push ebx
        call strlen
        
        ; print and arg
        pop ebx 
        mov ecx, [esp+4*ebx]
        push ebx
        mov edx, eax
        mov eax, 4
        mov ebx, 1
        int 80h
        ; insert a space
        mov eax, 32
        mov [char_buff], eax
        mov eax, char_buff
        mov ebx, 1  ; stdout
        call print_char
    
        pop ebx
        add ebx, 1
        cmp ebx, [esp]
        jle __looptillnoargs
    mov eax, msg_newline
    mov ebx, 1
    call print_char


exit:
    mov eax, 1
    mov ebx, 0
    int 80h
