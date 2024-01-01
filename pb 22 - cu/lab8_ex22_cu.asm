bits 32
global start

extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

; Se da numele unui fisier si un numar pe cuvant scris in memorie.
; Se considera numarul in reprezentarea fara semn.
; Sa se scrie cifrele zecimale ale acestui numar ca text in fisier, fiecare cifra pe o linie separata.

segment data use32 class=data
    file_name db "ex22.txt", 0
    file_mode db "w", 0

    numar dw 8773
    text times 10 db 0

    format_afisare db "%c", 10, 0
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

        mov ecx, 0 ; in ECX contorizez numarul de cifre din numar
        mov eax, [numar] ; pun numarul in EAX
        mov ebx, 10 ; in EBX pun 10 ca sa-l impart pe EAX la 10 si sa aflu nr de cifre

    ; calculez numarul de cifre
    NumarCifre:
        mov edx, 0 ; lucrez pe EDX:EAX
        div ebx ; impart EDX:EAX la EBX => EAX <- catul, EDX <- restul

        inc ecx ; cresc contorul de cifre
        test eax, eax ; verific daca EAX = 0
        jnz NumarCifre

        mov eax, [numar] ; pun numarul in EAX
        mov edi, ecx ; fac o copie a contorului de cifre
    
    ; pun cifrele intr-un sir de caractere
    Repeta:
        mov edx, 0 ; lucrez pe EDX:EAX
        div ebx ; impart EDX:EAX la EBX => EAX <- catul, EDX <- restul

        add dl, 48 ; transform cifra in caracter (in rest am ultima cifra din numar)
        dec edi 
        mov [text + edi], dl ; pun in text cifrele numarului de la sfarsit

        test eax, eax ; verific daca EAX = 0
        jnz Repeta

        mov esi, 0 ; index-ul sirului text

    ; afisez textul conform formatului
    Afisare:
        push ecx ; salvez contorul de cifre pentru ca mi-l modifica fprintf

        ; afisez caracter cu caracter
        push dword [text + esi]
        push dword format_afisare
        push dword [file_descriptor]
        call [fprintf]
        add esp, 3*4

        inc esi
        pop ecx ; dau pop la contor
        loop Afisare

        ; inchid fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:
	    push dword 0 
	    call [exit] 