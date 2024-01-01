bits 32
global start

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

; Se dau doua numere naturale a si b (a, b: dword, definite in segmentul de date). 
; Sa se calculeze suma lor si sa se afiseze in urmatorul format: "<a> + <b> = <result>"
; Exemplu: "1 + 2 = 3"
; Valorile vor fi afisate in format decimal (baza 10) cu semn.
 
segment data use32 class=data
    a dd -128
    b dd 256

    rezultat dd 0

    format_afisare db "%d + %d  = %d", 0

segment code use32 class=code
    start:
        mov eax, [a]
        add eax, [b]
        mov [rezultat], eax ; rezultat <- a + b
        
        ; afisam rezultatul dupa format
        push dword [rezultat]
        push dword [b]
        push dword [a]
        push format_afisare
        call [printf]
        add esp, 4*4

	    push dword 0 
	    call [exit] 