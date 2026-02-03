; Simple Calculator untuk emu8086
; UI Simpel dan Clean

.model small
.stack 100h
.data
    ; UI Elements
    garis db '================================================$'
    judul db '           KALKULATOR SEDERHANA$'
    
    ; Input Messages
    pesan1 db 'Angka 1 (0-9)     > $'
    pesan2 db 'Operasi (+,-,*,/) > $'
    pesan3 db 'Angka 2 (0-9)     > $'
    
    ; Output Messages
    hasil db 'Hasil             > $'
    ulang db 'Ulang? (Y/N)      > $'
    
    ; Error Messages
    salah_op db 'ERROR - Operator salah$'
    salah_bagi db 'ERROR - Tidak bisa bagi nol$'
    
    ; Goodbye
    selesai db '       Terima kasih telah menggunakan$'
    
    ; Symbol
    negatif db '-$'
    
.code
mulai proc
    mov ax, @data
    mov ds, ax
    
awal:
    ; Clear screen
    mov ah, 00h
    mov al, 03h
    int 10h
    
    ; Set color
    mov ah, 06h
    mov al, 00h
    mov bh, 1Fh
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    
    ; Newline
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Print header
    mov ah, 09h
    mov dx, offset garis
    int 21h
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    mov ah, 09h
    mov dx, offset judul
    int 21h
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    mov ah, 09h
    mov dx, offset garis
    int 21h
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Input angka 1
    mov ah, 09h
    mov dx, offset pesan1
    int 21h
    
    mov ah, 01h
    int 21h
    sub al, 30h
    mov bl, al
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Input operator
    mov ah, 09h
    mov dx, offset pesan2
    int 21h
    
    mov ah, 01h
    int 21h
    mov cl, al
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Input angka 2
    mov ah, 09h
    mov dx, offset pesan3
    int 21h
    
    mov ah, 01h
    int 21h
    sub al, 30h
    mov bh, al
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Process calculation
    mov dh, 0
    
    cmp cl, '+'
    je tambah
    cmp cl, '-'
    je kurang
    cmp cl, '*'
    je kali
    cmp cl, '/'
    je bagi
    
    mov dh, 1
    jmp tampil
    
tambah:
    add bl, bh
    jmp tampil
    
kurang:
    sub bl, bh
    jmp tampil
    
kali:
    mov al, bl
    mul bh
    mov bl, al
    jmp tampil
    
bagi:
    cmp bh, 0
    je bagi_nol
    mov al, bl
    mov ah, 0
    div bh
    mov bl, al
    jmp tampil
    
bagi_nol:
    mov dh, 2
    jmp tampil
    
tampil:
    ; Print line
    mov ah, 09h
    mov dx, offset garis
    int 21h
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Check error
    cmp dh, 1
    je error1
    cmp dh, 2
    je error2
    
    ; Print result label
    mov ah, 09h
    mov dx, offset hasil
    int 21h
    
    ; Check negative
    test bl, 80h
    jz positif
    
    ; Print minus
    mov ah, 09h
    mov dx, offset negatif
    int 21h
    
    neg bl
    
positif:
    ; Print number
    mov al, bl
    cmp al, 10
    jl satu_digit
    
    ; Dua digit
    mov ah, 0
    mov cl, 10
    div cl
    
    push ax
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h
    pop ax
    
    mov dl, ah
    add dl, 30h
    mov ah, 02h
    int 21h
    jmp lanjut
    
satu_digit:
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h
    jmp lanjut
    
error1:
    mov ah, 09h
    mov dx, offset salah_op
    int 21h
    jmp lanjut
    
error2:
    mov ah, 09h
    mov dx, offset salah_bagi
    int 21h
    
lanjut:
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    mov ah, 09h
    mov dx, offset garis
    int 21h
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Ask continue
    mov ah, 09h
    mov dx, offset ulang
    int 21h
    
    mov ah, 01h
    int 21h
    
    cmp al, 'Y'
    je awal
    cmp al, 'y'
    je awal
    cmp al, 'N'
    je keluar
    cmp al, 'n'
    je keluar
    jmp awal
    
keluar:
    ; Clear screen
    mov ah, 00h
    mov al, 03h
    int 10h
    
    ; Set color
    mov ah, 06h
    mov al, 00h
    mov bh, 1Fh
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Goodbye
    mov ah, 09h
    mov dx, offset garis
    int 21h
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    mov ah, 09h
    mov dx, offset selesai
    int 21h
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    mov ah, 09h
    mov dx, offset garis
    int 21h
    
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Exit
    mov ah, 4Ch
    int 21h
    
mulai endp
end mulai