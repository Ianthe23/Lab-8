bits 32
global start

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

; Se dau doua numere natural a si b (a: dword, b: word, definite in segmentul de date).
; Sa se calculeze a/b si sa se afiseze restul impartirii in urmatorul format: "<a> mod <b> = <rest>"
; Exemplu: pentru a = 23 si b = 5 se va afisa: "23 mod 5 = 3"
; Valorile vor fi afisate in format decimal (baza 10) cu semn.

segment data use32 class=data
    format_afisare db "%d mod %d = %d", 0

    a dd 45
    b dw 16
segment code use32 class=code
    start:
        ; DX:AX <- a
        mov ax, word [a]
        mov dx, word [a + 2]
        div word [b] ; DX <- a % b

        ; convertesc wordul din DX la double word
        mov ax, 0
        push ax
        push dx
        pop eax

        ; afisez dupa cum se cere in enunt
        push dword eax
        push dword [b]
        push dword [a]
        push format_afisare
        call [printf]
        add esp, 4*4

	    push dword 0 
	    call [exit] 