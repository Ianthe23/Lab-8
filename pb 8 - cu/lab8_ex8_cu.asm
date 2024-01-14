bits 32 
global start        

extern exit, fopen, fclose, fscanf, printf            
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll  
segment data use32 class=data
    file_name db "ex8.txt", 0
    file_mode db "r", 0
    
    caracter resd 1
    litera dd 0
    frecventa dd 0
    sir times 26 dd 0
    
    format_citire  db "%c", 0
    format_afisare db "litera = %c, frecventa = %d", 0
    file_descriptor db -1

segment code use32 class=code
    start:
        push dword file_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        cmp eax, 0
        je final
        
        mov [file_descriptor], eax
        
    citire:
        push dword caracter
        push dword format_citire
        push dword [file_descriptor]
        call [fscanf]
        add esp, 4*3
    
        cmp eax, 1
        jne continua
    
        mov al, byte [caracter]
        mov bl, 'A'
        
        cmp al, bl
        jb citire
        
        mov bl, 'Z'
        
        cmp al, bl
        ja citire
        
        sub al, 'A'
        mov bl, 4
        mul bl
        add byte[sir+eax], 1
        jmp citire
    
    continua:
        mov ecx, 26
        mov esi, 0
        
    repeta:
        mov eax, [sir+esi]
        mov ebx, [frecventa]
        
        cmp eax, ebx
        jb nu_frecventa
        
        mov [frecventa], eax
        mov eax, esi
        mov edx, 0
        mov ebx, 4
        div ebx
        
        ;add eax, 'A'
        add eax, 'A'
        mov [litera], eax
        
    nu_frecventa:
        add esi, 4
        loop repeta
        
    afisare:
    
        push dword [frecventa]
        push dword [litera]
        push dword format_afisare
        call [printf]
        add esp, 4*3
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
    
    final:
        push    dword 0      
        call    [exit]