bits 32
global start

extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

; Se dau un nume de fisier si un text (definite in segmentul de date).
; Textul contine litere mici si spatii. Sa se inlocuiasca toate literele de pe pozitii pare cu numarul pozitiei.
; Sa se creeze un fisier cu numele dat si sa se scrie textul obtinut in fisier. 

segment data use32 class=data
    file_name db "ex20.txt", 0
    file_mode db "w", 0
            
    text db "ana nu vrea sa patineze", 0
    l equ $-text
    text_nou times 255 db 0

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
        mov esi, 0 ; indexul sirului text
        mov edi, 0 ; indexul sirului text_nou

    Repeta:
        mov al, [text + esi] ; pun caracterul curent in AL
        mov bl, 32 ; 'Space'

        cmp al, bl
        je NuPozPara ; verific daca este 'Space', iar daca nu e, atunci e litera

        mov ebx, esi ; daca e litera, pun pozitia in EBX

        shr ebx, 1 
        jc NuPozPara ; verific daca este pozitie para

        mov eax, esi ; pun pozitia in EAX
        mov ebx, 10 ; pun 10 in EBX ca sa-l impart pe EAX la 10 sa vad cate cifre are pozitia

        push ecx ; pun ECX-ul loop-ului pe stiva
        mov ecx, 0 ; in ECX voi salva acum numarul de cifre al pozitiei

        ; calculez nr de cifre al pozitiei
        NrCifre:
            mov edx, 0 ; lucrez pe EDX:EAX
            div ebx ; impart la 10

            inc ecx
            test eax, eax ; verific daca EAX e 0
            jnz NrCifre

        mov eax, esi ; pun iar pozitia in EAX
        add edi, ecx ; adun nr de cifre in EDI

        ; pun cifra cu cifra in textul nou (adica caracter cu caracter) de la sfarsitul numarului
        Repeta1:
            mov edx, 0 ; lucrez pe EDX:EAX         
            div ebx ; impart la 10          

            add dl, 48 ; DL + '0' - in EDX am restul, deci cifra pe care o transform in caracter  
            dec edi             
            mov [text_nou + edi], dl ; pun caracterul in textul nou

            test eax, eax  ; verific daca EAX e 0
            jnz Repeta1    
     
        add edi, ecx ; restaurez EDI-ul
        dec edi ; il dau decrease pt ca in eticheta Increase ii dau increase
        pop ecx ; restaurez ECX-ul
        jmp Increase

    NuPozPara:
        mov [text_nou + edi], al ; pun caracterul nemodificat in textul nou

    Increase:
        inc esi
        inc edi
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