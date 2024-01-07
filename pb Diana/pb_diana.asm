bits 32
global start

extern exit, fopen, fclose, fscanf, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll

; Se da un fisier text. Sa se citeasca continutul fisierului, sa se determine cifra cu cea mai mare frecventa 
; si sa se afiseze acea cifra impreuna cu frecventa acesteia. Numele fisierului text este definit in segmentul de date.

segment data use32 class=data
    file_name db "pb_Diana.txt", 0
    file_mode db "r", 0

    caracter resd 1
    cifra dd 0
    frecventa dd 0
    sir times 10 dd 0

    format_citire db "%c", 0
    format_afisare db "cifra = %d, frecventa = %d", 0
    file_descriptor dd -1

segment code use32 class=code
    start:

        push dword file_mode
        push dword file_name
        call [fopen]
        add esp, 2*4

        cmp eax, 0
        je final

        mov [file_descriptor], eax

    Citire:
        push dword caracter
        push dword format_citire
        push dword [file_descriptor]
        call [fscanf]
        add esp, 3*4

        cmp eax, 1
        jne Continua

        mov al, byte [caracter]
        mov bl, '0'
        
        cmp al, bl
        jb Citire

        mov bl, '9'
        cmp al, bl
        ja Citire

        sub al, '0' ; EAX = cifra
        mov bl, 4
        mul bl ; EAX = 4 * cifra
        add byte [sir + eax], 1
        jmp Citire

    Continua:
        mov esi, 0
        mov ecx, 10

    Repeta:
        mov eax, [sir + esi]
        mov ebx, [frecventa]

        cmp eax, ebx
        jb NuFrecv

        mov [frecventa], eax
        mov eax, esi
        mov edx, 0
        mov ebx, 4
        div ebx ; EAX <- catul 

        mov [cifra], eax

    NuFrecv:
        add esi, 4
        loop Repeta

    Iesire:
        ; afisez cifra si frecventa
        push dword [frecventa]
        push dword [cifra]
        push dword format_afisare
        call [printf]
        add esp, 3*4

        ; inchid fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:
	    push dword 0 
	    call [exit] 