bits 32
global start

extern exit, scanf, fprintf, fopen, fclose
import exit msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll

; Sa se citeasca de la tastatura un nume de fisier si un text.
; Sa se creeze un fisier cu numele dat in directorul curent si sa se scrie textul in acel fisier.
; Observatii: Numele de fisier este de maxim 30 de caractere. Textul este de maxim 120 de caractere.

segment data use32 class=data
    fisier resb 30
    text resb 120

    format_citire db "%s", 0

    mod_acces db "w", 0 ; am deschis fisierul ca sa scriem in el
    descriptor dd -1 ; variabila in care salvam descriptorul fisierului

segment code use32 class=code
    start:
        ; citim de la tastatura numele fisierului
        push dword fisier
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; citim de la tastatura textul de scris in fisier
        push dword text
        push dword format_citire
        call [scanf]
        add esp, 2*4

        ; apelam fopen pentru a creea fisierul
        ; functia va returna in EAX descriptorul sau 0 in caz de eroare
        push dword mod_acces
        push dword fisier
        call [fopen]
        add esp, 2*4 ; eliberam parametrii de pe stiva

        mov [descriptor], eax ; salvam valoarea returnata de fopen in variabila descriptor

        cmp eax, 0 ; verificam daca functia fopen a creat cu succes fisierul
        je Final

    Sfarsit:
        ; scriem textul in fisierul deschis folosind fprintf
        push dword text
        push dword [descriptor]
        call [fprintf]
        add esp, 2*4

        ; apelam functia fclose pentru a inchide fisierul
        push dword [descriptor]
        call [fclose]
        add esp, 4

    Final:

	    push dword 0 
	    call [exit] 