bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; Sa se citeasca de la tastatura doua numere a si b de tip word.
; Sa se afiseze in baza 16 numarul c de tip dword pentru care partea low este suma celor doua numere,
; iar partea high este diferenta celor doua numere.
; EX: a = 574, b = 136, c = 01B602C6h

segment data use32 class=data
    a dd 15
    b dd 3
    c dd 0

    format_citire db "%d", 0
    format_afisare db "%x", 0

segment code use32 class=code
    start:
        ; citesc de la tastatura numarul a
        push dword a
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; citesc de la tastatura numarul b
        push dword b
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; pun variabilele in bx si cx, fiind cuvinte
        mov bx, [a]
        mov cx, [b]

        ; pun suma lor in ax, fara sa ma intereseze de carry (ax <- a + b)
        mov ax, bx
        add ax, cx

        ; compar variabilele ca sa nu efectuez o scadere cu rezultat negativ
        cmp bx, cx
        jb Jump

        ; daca a >= b
        mov dx, bx
        sub dx, cx
        jmp Sfarsit

        Jump:
            ; daca a < b
            mov dx, cx
            sub dx, bx
            jmp Sfarsit

    Sfarsit:

        ; formez dublu-cuvantul cu registrii dx si ax
        push dx
        push ax
        pop eax

        mov [c], eax ; pun in c dublucuvantul rezultat

        ; afiseaz dublucuvantul pe consola
        push dword [c]
        push format_afisare
        call [printf]
        add esp, 2*4
        

	    push dword 0 
	    call [exit] 