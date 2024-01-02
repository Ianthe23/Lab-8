bits 32
global start

extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

; Se dau un nume de fisier si un text (definite in segmentul de date).
; Textul contine litere mici, cifre si spatii. Sa se inlocuiasca toate cifrele de pe pozitii impare cu caracterul ‘X’.
; Sa se creeze un fisier cu numele dat si sa se scrie textul obtinut in fisier.

segment data use32 class=data
    file_name db "ex21.txt", 0
    file_mode db "w", 0

    text db "ana 232 maria 43 ivona 1", 0
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

        mov ecx, l ; pun lungimea textului in ECX pentru loop
        mov esi, 0 ; indexul textului

    Repeta:
        mov al, [text + esi] ; pun caracterul curent in AL
        mov bl, '0'
        mov bh, '9'

        ; verific daca AL >= '0' si AL <= '9', adica daca este cifra
        cmp al, bl
        jb NuCifra

        cmp al, bh
        ja NuCifra

        ; daca este cifra, verific daca pozitia din sir este impara, shiftand-o la dreapta cu o pozitie (am impartit-o la 2)
        mov edx, esi
        shr edx, 1
        jnc NuCifra ; daca CF = 0, atunci pozitia nu-i impara

        mov al, 'X' ; daca CF = 1, schimb caracterul in 'X'

    NuCifra:
        mov [text_nou + esi], al ; adaug caracterul ne - / modificat in textul nou
        inc esi
        loop Repeta

    Afisare:
        ; afisez textul nou
        push dword text_nou
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