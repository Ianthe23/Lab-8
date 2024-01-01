bits 32
global start

extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

; Se dau un nume de fisier si un text (definite in segmentul de date). 
; Textul contine litere mici, litere mari, cifre si caractere speciale.
; Sa se transforme toate literele mici din textul dat in litere mari.
; Sa se creeze un fisier cu numele dat si sa se scrie textul obtinut in fisier.

segment data use32 class=data
    file_name db "ex13.txt", 0
    file_mode db "w", 0

    text db "Ana, Maria si Alex au mere!", 0
    l equ $-text
    text_nou times l db 0

    format_afisare db "%s", 0
    file_descriptor dd -1

segment code use32 class=code
    start:
        ; deschid fisierul
        push dword file_mode
        push dword file_name
        call [fopen]
        add esp, 2*4

        ; verific daca s-a deschis corect
        cmp eax, 0
        je final

        mov [file_descriptor], eax
        mov ecx, l ; pun lungimea textului in ECX pt loop
        mov esi, 0 ; indexul sirurilor de caractere

    Repeta:
        mov al, [text + esi]
        mov bl, 'a'
        mov bh, 'z'

        ; compar caracter cu caracter cu 'a' si 'z'
        cmp al, bl
        jb Continua

        cmp al, bh
        ja Continua

        sub al, 32 ; daca AL >= 'a' si AL <= 'z', atunci modific caracterul in litera mare

    Continua:
        mov [text_nou + esi], al ; pun caracterul ne- sau modificat in textul nou
        inc esi ; cresc indexul sirurilor
        loop Repeta

    Iesire:
        ; afisam textul obtinut
        push dword text_nou
        push dword format_afisare
        push dword [file_descriptor]
        call [fprintf]
        add esp, 3*4

        ;inchid fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:
	    push dword 0 
	    call [exit] 