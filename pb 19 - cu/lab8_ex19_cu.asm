bits 32
global start

extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

; Se dau in segmentul de date un nume de fisier si un text (poate contine orice tip de caracter).
; Sa se calculeze suma cifrelor din text. Sa se creeze un fisier cu numele dat si sa se scrie suma obtinuta in fisier.

segment data use32 class=data
    file_name db "ex19.txt", 0
    file_mode db "w", 0

    text db "Ana are 4 mere si Maria are 18 pere.", 0
    l equ $-text

    format_afisare db "suma = %d", 0
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

        mov ecx, l ; lungimea textului 
        mov esi, 0 ; indexul textului
        mov edx, 0 ; in EDX calculez suma

    Repeta:
        mov al, [text + esi] ; pun caracterul curent in AL
        mov bl, '0'
        mov bh, '9'

        ; verific daca AL >= '0' si AL <= '9', adica daca este cifra
        cmp al, bl
        jb NuCifra

        cmp al, bh
        ja NuCifra

        sub al, '0' ; daca e cifra, scad '0', ca am cifra in integer

        push edx ; salvez suma din EDX ca sa pot converti cifra la dword sa pot sa o adaug in EDX

        mov ah, 0
        mov dx, 0
        push dx
        push ax
        pop eax

        pop edx
        add edx, eax

    NuCifra:
        inc esi
        loop Repeta

    Afisare:
        ; afisez suma
        push dword edx
        push dword format_afisare
        push dword [file_descriptor]
        call [fprintf]
        add esp, 3*4

        ; inchid fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:
	    push dword 0 
	    call [exit] 