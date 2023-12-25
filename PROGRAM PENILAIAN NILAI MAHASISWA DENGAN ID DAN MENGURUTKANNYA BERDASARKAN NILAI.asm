include 'emu8086.inc'

JMP START

DATA SEGMENT 
    N      DW      ?                                                              
    MARKS  DB 1000 DUP (?)  ; 1000 ADALAH JUMLAH MAKSIMUM MAHASISWA
    ID     DB 1000 DUP (?)
	         
	MSG1   DB 'MASUKKAN JUMLAH MAHASISWA (tidak boleh lebih dari 1000): ', 0
	MSG2   DB 0Dh, 0Ah, 0Dh, 0Ah, 'MASUKKAN ID MAHASISWA: ', 0
	MSG3   DB 0Dh, 0Ah, 0Dh, 0Ah, 'MASUKKAN NILAI MAHASISWA: ', 0    
	HR     DB 0Dh, 0Ah, 0Dh, 0Ah, '*******************NILAI MAHASISWA YANG DIURUTKAN***********************', 0
	MSG4   DB 0Dh, 0Ah, 0Dh, 0Ah, 'ID: ', 09H, 'NILAI:', 0                                
DATA ENDS  

CODE SEGMENT
    ASSUME DS:DATA CS:CODE     

START:  
    MOV AX, DATA
    MOV DS, AX                    
	   
    DEFINE_SCAN_NUM           
    DEFINE_PRINT_STRING 
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS
        
    ; BACA JUMLAH MAHASISWA
    LEA SI, MSG1
    CALL PRINT_STRING                                                        
    CALL SCAN_NUM
    MOV N, CX
    
    ; BACA ID MAHASISWA
    LEA SI, MSG2
    CALL PRINT_STRING
    MOV SI, 0
LOOP1:  
    CALL SCAN_NUM 
    MOV ID[SI], CL
    INC SI  
    PRINT 0AH        
    PRINT 0DH        
    CMP SI, N 
    JNE LOOP1
        
    ; BACA NILAI MAHASISWA
    LEA SI, MSG3
    CALL PRINT_STRING
    MOV SI, 0
LOOP2:  
    CALL SCAN_NUM 
    MOV MARKS[SI], CL
    INC SI  
    PRINT 0AH        
    PRINT 0DH        
    CMP SI, N 
    JNE LOOP2  
        
    ; URUTKAN BERDASARKAN NILAI MENGGUNAKAN BUBBLE SORT 
    DEC N            
    MOV CX, N 
OUTER:   
    MOV SI, 0 
INNER:   
    MOV  AL, MARKS[SI]
    MOV  DL, ID[SI]
    INC  SI
    CMP  MARKS[SI], AL
    JB   SKIP
    XCHG AL, MARKS[SI]
    MOV  MARKS[SI-1], AL
    XCHG DL, ID[SI]
    MOV  ID[SI-1], DL  
    
SKIP:   
    CMP  SI, CX
    JL   INNER 
    LOOP OUTER
    
    INC N                   
    
    ; CETAK TABEL ID DAN NILAI SETELAH DIURUTKAN
    LEA SI, HR   
    CALL PRINT_STRING
    LEA SI, MSG4
    CALL PRINT_STRING
    PRINT 0AH            
    PRINT 0DH            
	   
    MOV SI, 0
LOOP3:  
    MOV AX, 0
    MOV AL, ID[SI]     
    CALL PRINT_NUM_UNS    
    PRINT 09H            
    MOV AL, MARKS[SI]
    CALL PRINT_NUM_UNS
    PRINT 0AH            
    PRINT 0DH            
    INC SI 
    CMP SI, N 
    JNE LOOP3
       
CODE ENDS

END START
ret
