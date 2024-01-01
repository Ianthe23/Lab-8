bits 32
global start

extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

; Se da numele unui fisier si un numar pe cuvant scris in memorie. 
; Sa se scrie cifrele hexazecimale ale acestui numar ca text in fisier, fiecare cifra pe o linie separata.

segment data use32 class=data
    file_name db "ex23.txt", 0
    file_mode db "w", 0

    numar dw 1234 ; 04D2h
    l equ 4
    text times l db 0 ; ex: 04D2 ca sir de caractere
    catul dd 0
    restul dd 0

    format_afisare db "%c", 10, 0 ; 10 semnifica caract. new line
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

        mov edi, 0 ; indexul pentru text
        mov ecx, 2 ; un word are 2 bytes, deci setez ecx 2 pt ca lucrez pe octetii cuvantului
        mov esi, numar ; pun in sirul sursa numarul
        ; in memorie, 04D2h va fi D2 04 
        inc esi ; de aceea incrementez esi sa dau load mai intai la primul octet ( 04 )
        std ; si setez DF = 1 ca sa decrementeze esi-ul si sa pot da load la D2

    Repeta:
        ; AX <- octetul respectiv ( D2 de ex)
        ; dupa impartire la 10h, AL <- D (catul), AH <- 2 (restul)
        mov ax, 0
        mov bl, 16 ; 10h
        lodsb
        div bl

        mov bh, 9

        ; verific daca restul e litera 
        cmp ah, bh
        ja LiteraRest

        ; daca nu e litera, adaug 48 pentru codul ascii al cifrelor
        add ah, 48
        jmp Cat        

    LiteraRest:
        add ah, 55 ; altfel adaug 55 pt codul ascii al literelor mari

    ; aceeasi poveste insa pentru cat
    Cat:
        cmp al, bh
        ja LiteraCat

        add al, 48
        jmp Adaugare

    LiteraCat:
        add al, 55
        
    ; adaug catul si restul in text
    Adaugare:
        mov [text + edi], al
        inc edi

        mov [text + edi], ah
        inc edi

        loop Repeta

    mov ecx, 4 ; afisez 4 caractere, fiecare pe un rand
    mov esi, 0 ; indexul sirului de caractere text

    Afisare:
        push ecx ; salvez ecx-ul pentru loop

        ; afisez caracterul
        push dword [text + esi]
        push dword format_afisare
        push dword [file_descriptor]
        call [fprintf]
        add esp, 3*4

        inc esi ; cresc indexul sirului
        pop ecx ; dau pop la ecx pentru loop
        loop Afisare

        ; inchid fisierul
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    final:
	    push dword 0 
	    call [exit] 