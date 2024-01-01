bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Sa se citeasca de la tastatura un numar hexazecimal format din 2 cifre.
; Sa se afiseze pe ecran acest numar in baza 10, interpretat atat ca numar fara semn cat si ca numar cu semn (pe 8 biti).

segment data use32 class=data
    numar resb 1

    format_citire db "%x", 0
    format_afisare db "%d", 10, 0

segment code use32 class=code
    start:
        ; citesc numarul de la tastatura
        push dword numar
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; pun byte-ul citit in eax
        mov eax, 0
        mov al, [numar]
        
        ; verific daca are si interpretare cu semn
        cmp eax, 128
        jae Negativ

        ; afisez numarul daca n-are interpretare cu semn
        push dword eax
        push dword format_afisare
        call [printf]
        add esp, 2*4
        jmp final

        Negativ:
            ; daca are interpretare cu semn, afisez mai intai pe cea fara semn
            push dword eax
            push dword format_afisare
            call [printf]
            add esp, 2*4

            ; creez interpretarea cu semn (ex nr = 129, rezulta ca in interpretarea cu semn va fi -127)
            mov eax, 256
            sub eax, [numar]
            imul eax, -1

            ; afisez interpretarea cu semn
            push dword eax
            push dword format_afisare
            call [printf]
            add esp, 2*4

    final:
	    push dword 0 
	    call [exit] 