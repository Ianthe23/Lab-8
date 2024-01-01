bits 32
global start

extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

; Se dau un nume de fisier si un text (definite in segmentul de date). 
; Textul contine litere mici, litere mari, cifre si caractere speciale.
; Sa se inlocuiasca toate caracterele speciale din textul dat cu caracterul 'X'. 
; Sa se creeze un fisier cu numele dat si sa se scrie textul obtinut in fisier.

segment data use32 class=data

    file_name db "ex15.txt", 0
    file_mode db "w", 0
    
    format_afisare db "%s", 0
    file_descriptor dd -1

    text db "Ana, Maria, Alex au 4 pisici!", 0
    l equ $-text
    text_nou times l db 0

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

        mov ecx, l ; pun in ECX lungimea textului
        mov esi, 0 ; indexul textului

    Repeta:
        mov al, [text + esi] ; pun in AL caracterul curent

        ; VERIFIC DACA ACEST CARACTER NU E LITERA, NICI CIFRA, NICI NULL

        mov bl, 0 ; NULL

        cmp al, bl
        je NuCaractSpec ; daca e caracterul NULL, doar il adaug pe el

        mov bl, 48 ; '0'
        mov bh, 57 ; '9'

        cmp al, bl
        jae VerifCifra ; daca e mai mare sau egal decat '0', e posibil sa fie cifra deci verific in continuare

        jmp Continua1 ; altfel continui cu verificarea celorlalte criterii

    VerifCifra:
        cmp al, bh
        jbe NuCaractSpec ; daca e si mai mic sau egal decat '9', atunci doar adaug caracterul

    Continua1:
        mov bl, 65 ; 'A'
        mov bh, 90 ; 'Z'

        cmp al, bl
        jae VerifLiteraMare ; daca e mai mare sau egal decat 'A', e posibil sa fie litera mare deci verific in continuare

        jmp Continua2 ; altfel continui cu verificarea celorlalte criterii

    VerifLiteraMare:
        cmp al, bh
        jbe NuCaractSpec ; daca e si mai mic sau egal decat 'Z', atunci doar adaug caracterul

    Continua2:
        mov bl, 97 ; 'a'
        mov bh, 122 ; 'z'

        cmp al, bl
        jae VerifLiteraMica ; daca e mai mare sau egal decat 'a', e posibil sa fie litera mica deci verific in continuare

        jmp Continua3

    VerifLiteraMica:
        cmp al, bh
        jbe NuCaractSpec ; daca e si mai mic sau egal decat 'z', atunci doar adaug caracterul

    Continua3:
        ; altfel clar e CARACTER SPECIAL si il modific cu 'X'
        mov al, 88 
        mov [text_nou + esi], al
        jmp Increase ; dau increase la index 

    NuCaractSpec:
        ; nu modific caracterul
        mov [text_nou + esi], al

    Increase:
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