bits 32
global start

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

; Se dau doua numere naturale a si b (a, b: word, definite in segmentul de date).
; Sa se calculeze a/b si sa se afiseze catul si restul impartirii in urmatorul format: "Cat = <cat>, rest = <rest>"
; Exemplu: pentru a=23 si b=10 se va afisa: "Cat = 2, rest = 3"
; Valorile vor fi afisate in format decimal (baza 10) cu semn.

segment data use32 class=data
    a dw 25
    b dw 10

    catul dd 0
    restul dd 0

    format_afisare db "cat = %d, rest = %d", 0

segment code use32 class=code
    start:
        mov ax, word [a]
        cwd ; pun in DX:AX variabila a, convertind cu semn
        idiv word [b] ; il impart la b => DX <- restul, AX <- catul

        cwde ; convertesc cu semn catul si-l salvez in variabila catul
        mov dword [catul], eax

        mov ax, dx ; la fel fac pentru rest
        cwde
        mov dword [restul], eax

        ; afisez catul si restul dupa cum se cere in enunt
        push dword [restul]
        push dword [catul]
        push dword format_afisare
        call [printf]
        add esp, 3*2

	    push dword 0 
	    call [exit] 