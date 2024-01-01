bits 32
global start

extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

; Se dau un nume de fisier si un text (definite in segmentul de date). 
; Textul contine litere mici, litere mari, cifre si caractere speciale. 
; Sa se transforme toate literele mari din textul dat in litere mici. 
; Sa se creeze un fisier cu numele dat si sa se scrie textul obtinut in fisier.
segment data use32 class=data
    nume_fisier db "ex14.txt", 0
    mod_acces db "w", 0 ; am deschis fisierul ca sa scriem in el


    text db "A!be1CE1da!R", 0 ; textul pe care-l modificam ca sa-l scriem in fisier
    l equ $-text
    text_nou times l db 0
    descriptor dd -1 ; variabila in care salvam descriptorul fisierului (pt a face referire la fisier)

segment code use32 class=code
    start:
        ; apelam fopen pentru a creea fisierul
        ; functia va returna in EAX descriptorul sau 0 in caz de eroare
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 2*4 ; eliberam parametrii de pe stiva

        mov [descriptor], eax ; salvam valoarea returnata de fopen in variabila descriptor

        cmp eax, 0 ; verificam daca functia fopen a creat cu succes fisierul (EAX != 0)
        je Final

        mov ecx, l ; punem in ecx lungimea sirului pentru loop
        mov esi, 0 ; initializam index-ul sirului
        jecxz Sfarsit

        Repeta:
            mov al, [text + esi] ; punem caracter cu caracter in AL din sir
            mov dl, 'a'-'A' ; punem diferenta dintre a si A pentru a modifica din litera mare in litera mica prin ADD
            mov bl, 64      
            mov bh, 91      ; punem in BL si BH 64 si 91, adica primul caracter din fata lui 'A' si primul caracter de dupa 'Z' ca sa verificam
                            ; daca litera e litera MARE
            cmp al, bl      ; comparam mai intai cu BL
            jbe Nu_e_litera ; daca caracterul din AL este mai mic decat 'A', atunci sarim peste
            
            cmp al, bh      ; comparam si cu BH daca caracterul din AL este mai mare sau egal cu 'A'
            jae Nu_e_litera_mare ; daca caracterul din AL este mai mare decat 'Z', atunci sarim peste

            add al, dl      ; daca litera din AL este mare, atunci adaugam 32 si o facem litera MICA


        Nu_e_litera_mare:
        Nu_e_litera:        
            mov [text_nou + esi], al ; adaugam caracterul modificat/nemodificat in sirul rezultat
            inc esi         ; incrementam index-ul sirului
        loop Repeta
                

    Sfarsit:
        ; scriem textul in fisierul deschis folosind fprintf
        push dword text_nou
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