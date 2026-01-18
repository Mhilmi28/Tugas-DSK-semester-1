; Simple Calculator untuk emu8086 - FIXED VERSION
; Support hasil 2 digit (0-18) dan hasil negatif
; Langsung bisa di-compile dan run di emu8086

.model small
.stack 100h

.data
    msg1 db 'Masukkan angka pertama (0-9): $'
    msg2 db 13,10,'Pilih operasi (+/-): $'
    msg3 db 13,10,'Masukkan angka kedua (0-9): $'
    msg_hasil db 13,10,'Hasil: $'
    msg_negatif db '-$'
    
.code
main proc
    ; Inisialisasi data segment
    mov ax, @data
    mov ds, ax
    
    ; Tampilkan pesan 1
    mov ah, 09h
    lea dx, msg1
    int 21h
    
    ; Baca angka pertama
    mov ah, 01h
    int 21h
    sub al, 30h         ; Konversi ASCII ke angka
    mov bl, al          ; Simpan di BL
    
    ; Tampilkan pesan operasi
    mov ah, 09h
    lea dx, msg2
    int 21h
    
    ; Baca operasi
    mov ah, 01h
    int 21h
    mov cl, al          ; Simpan operasi di CL
    
    ; Tampilkan pesan 2
    mov ah, 09h
    lea dx, msg3
    int 21h
    
    ; Baca angka kedua
    mov ah, 01h
    int 21h
    sub al, 30h         ; Konversi ASCII ke angka
    mov bh, al          ; Simpan di BH
    
    ; Cek operasi
    cmp cl, '+'
    je tambah
    cmp cl, '-'
    je kurang
    jmp selesai
    
tambah:
    add bl, bh          ; BL = BL + BH
    jmp tampilkan
    
kurang:
    sub bl, bh          ; BL = BL - BH
    jmp cek_negatif
    
cek_negatif:
    ; Cek apakah hasil negatif
    test bl, 80h        ; Cek bit sign
    jz tampilkan        ; Jika positif, langsung tampilkan
    
    ; Jika negatif, tampilkan tanda minus
    mov ah, 09h
    lea dx, msg_hasil
    int 21h
    
    mov ah, 09h
    lea dx, msg_negatif
    int 21h
    
    ; Ubah jadi positif (2's complement)
    neg bl
    jmp tampilkan_angka
    
tampilkan:
    ; Tampilkan "Hasil: "
    mov ah, 09h
    lea dx, msg_hasil
    int 21h
    
tampilkan_angka:
    ; Cek apakah hasil >= 10 (2 digit)
    cmp bl, 10
    jl satu_digit
    
    ; Hasil 2 digit (10-18)
    mov al, bl
    mov ah, 0
    mov cl, 10
    div cl              ; AL = hasil/10 (puluhan), AH = hasil%10 (satuan)
    
    ; Tampilkan digit puluhan
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h
    
    ; Tampilkan digit satuan
    mov dl, ah
    add dl, 30h
    mov ah, 02h
    int 21h
    
    jmp selesai
    
satu_digit:
    ; Hasil 1 digit (0-9)
    add bl, 30h         ; Konversi ke ASCII
    mov ah, 02h
    mov dl, bl
    int 21h
    
selesai:
    ; Newline
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; Exit ke DOS
    mov ah, 4Ch
    int 21h
    
main endp
end main