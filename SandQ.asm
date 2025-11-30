
STACK_SEG    SEGMENT

STACK_SEG    ENDS
;---------------------------------------------

DATA_SEG    SEGMENT
    
    TEAM_CREW           DB 'Team Members :',0DH, 0AH
                        DB '      1- Engy Eid Abdelfatah',0DH, 0AH
                        DB '      2- Engy Alaa Fikry',0DH, 0AH
                        DB '      3- Basma Nabil Mohammed', 0DH, 0AH ,'$'
                        
                        
    ANOTHER_OP_MSG      DB 0DH, 0AH,'Press any key to try another operation $'
    CONTINUE_MSG        DB 0DH, 0AH,'Press any key to start the program $'              
    MSG_TITLE           DB 0DH, 0AH,'                       === Stack & Queue Simulator ===', 0DH, 0AH,0DH, 0AH, '$'
    MSG_SELECT          DB 0DH, 0AH,'Select (1: Stack | 2: Queue | 0: Exit): ', '$'
    MSG_INVALID         DB 0DH, 0AH, '*** Invalid choice. Try again. ***', 0DH, 0AH, '$'
    

    MSG_STACK_MENU      DB 0DH, 0AH, 'Stack Operations: ', 0DH, 0AH ,0DH, 0AH
                        DB '1. PUSH'
                        DB '                                  2. POP', 0DH, 0AH
                        DB '3. LENGTH',
                        DB '                               4. DISPLAY Stack', 0DH, 0AH
                        DB '5. MIN', 
                        DB '                                  6. MAX', 0DH, 0AH
                        DB '7. SUM', 
                        DB '                                  8. Back to Main Menu', 0DH, 0AH
                        DB '9. Exit Program', 0DH, 0AH,0DH, 0AH
                        DB 'Enter Choice: ', '$'
    

    MSG_QUEUE_MENU      DB 0DH, 0AH, 'Queue Operations: ', 0DH, 0AH,0DH, 0AH
                        DB '1. ENQUEUE'
                        DB '                              2. DEQUEUE', 0DH, 0AH
                        DB '3. LENGTH'
                        DB '                               4. DISPLAY Queue', 0DH, 0AH
                        DB '5. MIN'
                        DB '                                  6. MAX', 0DH, 0AH
                        DB '7. SUM'
                        DB '                                  8. Back to Main Menu', 0DH, 0AH
                        DB '9. Exit Program', 0DH, 0AH,0DH, 0AH
                        DB 'Enter Choice: ', '$'
                        

    MSG_PROMPT          DB 0DH, 0AH,'Enter a digit: ', '$'
    MSG_SUCCESS         DB 0DH, 0AH, '*** Operation Succeeeded.', 0DH, 0AH, '$'
    MSG_OVERFLOW        DB 0DH, 0AH, '*** Invalid Operation. full. ***', 0DH, 0AH, '$'
    MSG_UNDERFLOW       DB 0DH, 0AH, '*** Invalid Operation. empty. ***', 0DH, 0AH, '$'
    MSG_LEN             DB 0DH, 0AH, '*** Current Length: ', '$'
    MSG_DISPLAY         DB 0DH, 0AH, '*** Content: ', '$'
    MSG_EMPTY           DB 0DH, 0AH, '*** EMPTY','$'
    MSG_REMOVED         DB 0DH, 0AH, '*** Removed element: ', '$'
    
   
    MSG_MIN_RESULT      DB 0DH, 0AH, '*** Minimum Value: ', '$'
    MSG_MAX_RESULT      DB 0DH, 0AH, '*** Maximum Value: ', '$'
    MSG_SUM_RESULT      DB 0DH, 0AH, '*** Total Sum: ', '$'
    

    NL                  DB 0DH, 0AH, '$'
    

    DS_TYPE             DB 0            
    MAX_SIZE            EQU 100          
     
    STACK_ARRAY         DB MAX_SIZE DUP(0) 
    STACK_COUNT         DB 0            

     
    QUEUE_ARRAY         DB MAX_SIZE DUP(0) 
    QUEUE_COUNT         DB 0            
    QUEUE_HEAD          DB 0            
    QUEUE_TAIL          DB 0            
    
    
    TEMP_CHAR           DB 0           
DATA_SEG    ENDS    
;---------------------------------------------
CODE_SEG    SEGMENT     

MAIN PROC FAR  
    ASSUME SS:STACK_SEG ,CS:CODE_SEG,DS:DATA_SEG
    MOV AX, DATA_SEG
    MOV DS, AX
    
    LEA DX,TEAM_CREW
    MOV AH, 09h
    INT 21h
    
    LEA DX,CONTINUE_MSG
    MOV AH, 09h
    INT 21h
    
    MOV AH, 01h
    INT 21h
    
    LEA DX, MSG_TITLE
    CALL PRINT_STRING
    
MAIN_MENU_LOOP:
    LEA DX, MSG_SELECT
    CALL PRINT_STRING
    
    CALL READ_CHAR
    
    CMP AL, '0'
    JE EXIT_PROGRAM     
    
    CMP AL, '1'
    JE SELECT_STACK     
    
    CMP AL, '2'
    JE SELECT_QUEUE     
    
    LEA DX, MSG_INVALID
    CALL PRINT_STRING
    JMP MAIN_MENU_LOOP

SELECT_STACK:
    MOV DS_TYPE, 1      
    CALL STACK_MENU_LOOP
    JMP MAIN_MENU_LOOP

SELECT_QUEUE:
    MOV DS_TYPE, 2      
    CALL QUEUE_MENU_LOOP
    JMP MAIN_MENU_LOOP

EXIT_PROGRAM:   
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

;-------------------------------------
PRINT_STRING PROC
    PUSH AX
    PUSH DX
    MOV AH, 09h
    INT 21h
    POP DX
    POP AX
    RET
PRINT_STRING ENDP

;-------------------------------------
PRINT_NL PROC
    PUSH AX
    PUSH DX
    LEA DX, NL
    CALL PRINT_STRING
    POP DX
    POP AX
    RET
PRINT_NL ENDP

;-------------------------------------
READ_CHAR PROC
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV AH, 01h
    INT 21h
    
    CALL PRINT_NL

    POP DX
    POP CX
    POP BX
    RET
READ_CHAR ENDP
;--------------------------------------

PRINT_WORD_DECIMAL PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV AX, BX            
    MOV CX, 0             
    MOV BX, 10            

DIVIDE_LOOP:
    XOR DX, DX            
    DIV BX                
    PUSH DX               
    INC CX                
    
    CMP AX, 0             
    JNE DIVIDE_LOOP       

PRINT_LOOP:
    POP DX                
    ADD DL, '0'           
    MOV AH, 02h           
    INT 21h
    LOOP PRINT_LOOP
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_WORD_DECIMAL ENDP

;-----------------------------------------
PRINT_ANOTHER_OP_MSG PROC

    LEA DX,ANOTHER_OP_MSG
    CALL PRINT_STRING
    
    MOV AH, 01h
    INT 21h
    RET
PRINT_ANOTHER_OP_MSG ENDP

;-----------------------------------------
GET_INPUT_ITEM PROC
    PUSH AX
    PUSH DX
    LEA DX, MSG_PROMPT
    CALL PRINT_STRING
    
    CALL READ_CHAR      
    
    CMP AL, '0'
    JL INVALID_INPUT
    CMP AL, '9'
    JG INVALID_INPUT
    
    MOV TEMP_CHAR, AL   
    CLC                   
    JMP INPUT_EXIT

INVALID_INPUT:
    STC                   
    
INPUT_EXIT:
    POP DX
    POP AX
    RET
GET_INPUT_ITEM ENDP

;---------------------------------------------
STACK_MENU_LOOP PROC
    PUSH AX
    PUSH BX
    
STACK_NEXT:
    LEA DX, MSG_STACK_MENU
    CALL PRINT_STRING
    
    CALL READ_CHAR
    
    CMP AL, '1'
    JE S_PUSH
    CMP AL, '2'
    JE S_POP
    CMP AL, '3'
    JE S_LEN
    CMP AL, '4'
    JE S_DISPLAY
    
    CMP AL, '5'
    JE S_MIN_MAX_SUM
    CMP AL, '6'
    JE S_MIN_MAX_SUM
    CMP AL, '7'
    JE S_SUM_STACK      
    
    CMP AL, '8' 
    JE S_BACK_TO_MAIN 
    CMP AL, '9' 
    JE S_EXIT_PROGRAM 
    
    LEA DX, MSG_INVALID
    CALL PRINT_STRING
    JMP STACK_NEXT
    
S_PUSH:
    CALL PUSH_STACK_PROC
    JMP STACK_NEXT
S_POP:
    CALL POP_STACK_PROC
    JMP STACK_NEXT
S_LEN:
    CALL DISPLAY_LEN_PROC
    JMP STACK_NEXT
S_DISPLAY:
    CALL DISPLAY_DS_PROC
    JMP STACK_NEXT
    

S_MIN_MAX_SUM:
    CMP AL, '5'
    JE S_MIN
    CMP AL, '6'
    JE S_MAX
    JMP STACK_NEXT

S_MIN:
    CALL FIND_MIN_PROC
    JMP STACK_NEXT
S_MAX:
    CALL FIND_MAX_PROC
    JMP STACK_NEXT
S_SUM_STACK:
    CALL CALCULATE_SUM_PROC 
    JMP STACK_NEXT
    
S_BACK_TO_MAIN:
    POP BX
    POP AX
    RET 
    
S_EXIT_PROGRAM:
    MOV AH, 4Ch
    INT 21h
STACK_MENU_LOOP ENDP

;----------------------------------------------------
QUEUE_MENU_LOOP PROC
    PUSH AX
    PUSH BX
    
QUEUE_NEXT:
    LEA DX, MSG_QUEUE_MENU
    CALL PRINT_STRING
    
    CALL READ_CHAR
    
    CMP AL, '1'
    JE Q_ENQUEUE
    CMP AL, '2'
    JE Q_DEQUEUE
    CMP AL, '3'
    JE Q_LEN
    CMP AL, '4'
    JE Q_DISPLAY
    
    CMP AL, '5'
    JE Q_MIN_MAX_SUM
    CMP AL, '6'
    JE Q_MIN_MAX_SUM
    CMP AL, '7'
    JE Q_SUM_QUEUE      
    
    CMP AL, '8' 
    JE Q_BACK_TO_MAIN
    CMP AL, '9' 
    JE Q_EXIT_PROGRAM
    
    LEA DX, MSG_INVALID
    CALL PRINT_STRING
    JMP QUEUE_NEXT
    
Q_ENQUEUE:
    CALL ENQUEUE_PROC
    JMP QUEUE_NEXT
Q_DEQUEUE:
    CALL DEQUEUE_PROC
    JMP QUEUE_NEXT
Q_LEN:
    CALL DISPLAY_LEN_PROC
    JMP QUEUE_NEXT
Q_DISPLAY:
    CALL DISPLAY_DS_PROC
    JMP QUEUE_NEXT

Q_MIN_MAX_SUM:
    CMP AL, '5'
    JE Q_MIN
    CMP AL, '6'
    JE Q_MAX
    JMP QUEUE_NEXT
    
Q_MIN:
    CALL FIND_MIN_PROC
    JMP QUEUE_NEXT
Q_MAX:
    CALL FIND_MAX_PROC
    JMP QUEUE_NEXT
Q_SUM_QUEUE:
    CALL CALCULATE_SUM_PROC 
    JMP QUEUE_NEXT

Q_BACK_TO_MAIN:
    POP BX
    POP AX
    RET
    
Q_EXIT_PROGRAM:
    MOV AH, 4Ch
    INT 21h
QUEUE_MENU_LOOP ENDP

;-----------------------------------------
PUSH_STACK_PROC PROC
    PUSH AX
    PUSH BX
    PUSH SI
    
    MOV AL, STACK_COUNT 
    CMP AL, MAX_SIZE
    JAE PUSH_OVERFLOW
    
    CALL GET_INPUT_ITEM
    JC PUSH_INVALID 
    
    LEA SI, STACK_ARRAY 
    MOV BL, STACK_COUNT 
    MOV BH, 0
    ADD SI, BX
    
    MOV AL, TEMP_CHAR
    MOV [SI], AL
    INC STACK_COUNT     
    
    LEA DX, MSG_SUCCESS
    CALL PRINT_STRING
    CALL DISPLAY_DS_PROC
    JMP PUSH_EXIT
    
PUSH_OVERFLOW:
    LEA DX, MSG_OVERFLOW
    CALL PRINT_STRING
    CALL PRINT_ANOTHER_OP_MSG
    
    
    JMP PUSH_EXIT

PUSH_INVALID:
    LEA DX, MSG_INVALID
    CALL PRINT_STRING
    CALL PRINT_ANOTHER_OP_MSG
    
PUSH_EXIT:
    
    POP SI
    POP BX
    POP AX
    RET
PUSH_STACK_PROC ENDP

;------------------------------------------------

POP_STACK_PROC PROC
    PUSH AX
    PUSH BX
    PUSH SI
    
    MOV AL, STACK_COUNT 
    CMP AL, 0
    JE POP_UNDERFLOW
    
    DEC STACK_COUNT     
    
    LEA SI, STACK_ARRAY 
    MOV BL, STACK_COUNT 
    MOV BH, 0
    ADD SI, BX
    
    MOV AL, [SI]
    MOV TEMP_CHAR, AL
     
    LEA DX, MSG_SUCCESS
    CALL PRINT_STRING
    
    LEA DX, MSG_REMOVED
    CALL PRINT_STRING 
    
    MOV DL, TEMP_CHAR
    MOV AH, 02h
    INT 21h
    CALL PRINT_NL
    
    CALL DISPLAY_DS_PROC
    JMP POP_EXIT
    
POP_UNDERFLOW:
    LEA DX, MSG_UNDERFLOW
    CALL PRINT_STRING
    CALL PRINT_ANOTHER_OP_MSG
    
POP_EXIT:
    
    POP SI
    POP BX
    POP AX
    RET
POP_STACK_PROC ENDP

;-------------------------------------------------

ENQUEUE_PROC PROC
    PUSH AX
    PUSH BX
    PUSH SI
    
    MOV AL, QUEUE_COUNT 
    CMP AL, MAX_SIZE
    JAE ENQ_OVERFLOW
    
    CALL GET_INPUT_ITEM
    JC ENQ_INVALID 
    
    LEA SI, QUEUE_ARRAY 
    MOV BL, QUEUE_TAIL  
    MOV BH, 0
    ADD SI, BX
    
    MOV AL, TEMP_CHAR
    MOV [SI], AL
    INC QUEUE_TAIL      
    INC QUEUE_COUNT     
    
    LEA DX, MSG_SUCCESS
    CALL PRINT_STRING
    CALL DISPLAY_DS_PROC
    JMP ENQ_EXIT
    
ENQ_OVERFLOW:
    LEA DX, MSG_OVERFLOW
    CALL PRINT_STRING
    CALL PRINT_ANOTHER_OP_MSG
    
    JMP ENQ_EXIT
    
ENQ_INVALID:
    LEA DX, MSG_INVALID
    CALL PRINT_STRING
    CALL PRINT_ANOTHER_OP_MSG
    
ENQ_EXIT:
    
    POP SI
    POP BX
    POP AX
    RET
ENQUEUE_PROC ENDP

;-------------------------------------------------

DEQUEUE_PROC PROC
    PUSH AX
    PUSH BX
    PUSH SI
    
    MOV AL, QUEUE_COUNT 
    CMP AL, 0
    JE DEQ_UNDERFLOW
    
    LEA SI, QUEUE_ARRAY 
    MOV BL, QUEUE_HEAD  
    MOV BH, 0
    ADD SI, BX
    
    MOV AL, [SI]
    MOV TEMP_CHAR, AL
    
    LEA DX, MSG_REMOVED
    CALL PRINT_STRING
    MOV DL, TEMP_CHAR
    MOV AH, 02h
    INT 21h
    CALL PRINT_NL
    
    INC QUEUE_HEAD      
    DEC QUEUE_COUNT     
    
    CMP QUEUE_COUNT, 0  
    JNE DEQ_NOT_EMPTY
    MOV QUEUE_HEAD, 0   ;reset head to first place
    MOV QUEUE_TAIL, 0   
    
DEQ_NOT_EMPTY:
    
    LEA DX, MSG_SUCCESS
    CALL PRINT_STRING
    CALL DISPLAY_DS_PROC
    JMP DEQ_EXIT
    
DEQ_UNDERFLOW:
    LEA DX, MSG_UNDERFLOW
    CALL PRINT_STRING
    CALL PRINT_ANOTHER_OP_MSG
    
DEQ_EXIT:
    
    POP SI
    POP BX
    POP AX
    RET
DEQUEUE_PROC ENDP

;--------------------------------------------------

DISPLAY_LEN_PROC PROC
    PUSH AX
    PUSH DX
    
    LEA DX, MSG_LEN
    CALL PRINT_STRING
    
    MOV AL, DS_TYPE
    CMP AL, 1
    JE DISPLAY_LEN_STACK
    JMP DISPLAY_LEN_QUEUE

DISPLAY_LEN_STACK:
    MOV BL, STACK_COUNT 
    JMP DISPLAY_LEN_CONTINUE

DISPLAY_LEN_QUEUE:
    MOV BL, QUEUE_COUNT 
    
DISPLAY_LEN_CONTINUE:
    MOV DL, BL          
    ADD DL, '0'         
    MOV AH, 02h        
    INT 21h
    
    CALL PRINT_NL
    
    CALL PRINT_ANOTHER_OP_MSG
    
    POP DX
    POP AX
    RET
DISPLAY_LEN_PROC ENDP

;----------------------------------------------

DISPLAY_DS_PROC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    
    MOV BL, DS_TYPE
    CMP BL, 1           
    JE SETUP_DISPLAY_STACK
    JMP SETUP_DISPLAY_QUEUE     

SETUP_DISPLAY_STACK:
    MOV AL, STACK_COUNT
    CMP AL, 0
    JE DS_EMPTY
    MOV CL, STACK_COUNT   
    MOV CH, 0
    LEA SI, STACK_ARRAY   
    MOV BL, STACK_COUNT
    DEC BL
    MOV BH, 0
    ADD SI, BX            
    JMP DISPLAY_START

SETUP_DISPLAY_QUEUE:
    MOV AL, QUEUE_COUNT
    CMP AL, 0
    JE DS_EMPTY
    MOV CL, QUEUE_COUNT   
    MOV CH, 0
    MOV BL, QUEUE_HEAD    
    MOV BH, 0
    LEA SI, QUEUE_ARRAY   
    ADD SI, BX
    JMP DISPLAY_START
    
DISPLAY_START:
    LEA DX, MSG_DISPLAY 
    CALL PRINT_STRING
    
    MOV BL, DS_TYPE
    CMP BL, 1           
    JE DISPLAY_STACK_LOOP_EXEC
    JMP DISPLAY_QUEUE_LOOP_EXEC     


DISPLAY_STACK_LOOP_EXEC:
    MOV DL, [SI]        
    MOV AH, 02h
    INT 21h             
    
    MOV DL, ' '         
    MOV AH, 02h
    INT 21h
    
    DEC SI             
    LOOP DISPLAY_STACK_LOOP_EXEC
    JMP DS_END_DISPLAY

DISPLAY_QUEUE_LOOP_EXEC:
    MOV DL, [SI]        
    MOV AH, 02h
    INT 21h             
    
    MOV DL, ' '         
    MOV AH, 02h
    INT 21h
    
    INC SI              
    LOOP DISPLAY_QUEUE_LOOP_EXEC
    JMP DS_END_DISPLAY

DS_EMPTY:
    LEA DX, MSG_EMPTY
    CALL PRINT_STRING

DS_END_DISPLAY:
    CALL PRINT_NL       
    CALL PRINT_ANOTHER_OP_MSG
    
    POP SI
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_DS_PROC ENDP


;-----------------------------------------------

CALCULATE_SUM_PROC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV AL, DS_TYPE
    CMP AL, 1
    JE SUM_SETUP_STACK

SUM_SETUP_QUEUE:
    MOV AL, QUEUE_COUNT   
    CMP AL, 0
    JE SUM_EMPTY
    
    MOV CL, QUEUE_COUNT  
    MOV CH, 0
    
    LEA SI, QUEUE_ARRAY
    MOV AL, QUEUE_HEAD    
    MOV AH, 0
    ADD SI, AX            
    JMP SUM_CONTINUE

SUM_SETUP_STACK:
    MOV AL, STACK_COUNT   
    CMP AL, 0
    JE SUM_EMPTY
    
    MOV CL, STACK_COUNT   
    MOV CH, 0
    
    LEA SI, STACK_ARRAY
    JMP SUM_CONTINUE
    
SUM_CONTINUE:
    
    XOR BX, BX              ;will hold the sum
    
SUM_LOOP:
    MOV AL, [SI]            
    SUB AL, '0'             ; Convert it to number
    
    MOV AH, 0               
    ADD BX, AX              
    
    INC SI                  
    LOOP SUM_LOOP
    

    LEA DX, MSG_SUM_RESULT
    CALL PRINT_STRING
    
    CALL PRINT_WORD_DECIMAL 
    CALL PRINT_NL
    JMP SUM_EXIT

SUM_EMPTY:
    LEA DX, MSG_UNDERFLOW
    CALL PRINT_STRING

SUM_EXIT:
    CALL PRINT_ANOTHER_OP_MSG
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
CALCULATE_SUM_PROC ENDP


;------------------------------------------------

FIND_MIN_PROC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    
    MOV AL, DS_TYPE
    CMP AL, 1
    JE MIN_SETUP_STACK

MIN_SETUP_QUEUE:
    MOV AL, QUEUE_COUNT
    CMP AL, 0
    JE MIN_MAX_EMPTY
    
    MOV CL, QUEUE_COUNT   
    MOV CH, 0
    LEA SI, QUEUE_ARRAY
    MOV BL, QUEUE_HEAD   
    MOV BH, 0
    ADD SI, BX
    JMP MIN_MAX_CONTINUE
    
MIN_SETUP_STACK:
    MOV AL, STACK_COUNT
    CMP AL, 0
    JE MIN_MAX_EMPTY
    
    MOV CL, STACK_COUNT   
    MOV CH, 0
    LEA SI, STACK_ARRAY   
    JMP MIN_MAX_CONTINUE
    
MIN_MAX_CONTINUE: 
    MOV AL, [SI]          
    INC SI                
    DEC CX               
    
    JZ MIN_MAX_FOUND 
    
MIN_LOOP:
    MOV BL, [SI]          
    
    CMP BL, AL
    JGE MIN_INNER_CONTINUE    
    
    MOV AL, BL           
    
MIN_INNER_CONTINUE:
    INC SI                
    LOOP MIN_LOOP
    
MIN_MAX_FOUND:
    LEA DX, MSG_MIN_RESULT
    CALL PRINT_STRING
    
    MOV DL, AL            
    MOV AH, 02h
    INT 21h              
    
    CALL PRINT_NL
    JMP MIN_MAX_EXIT

MIN_MAX_EMPTY:
    LEA DX, MSG_UNDERFLOW
    CALL PRINT_STRING

MIN_MAX_EXIT:
    CALL PRINT_ANOTHER_OP_MSG
    
    POP SI
    POP CX
    POP BX
    POP AX
    RET
FIND_MIN_PROC ENDP


;-------------------------------------------------

FIND_MAX_PROC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    
    MOV AL, DS_TYPE
    CMP AL, 1
    JE MAX_SETUP_STACK

MAX_SETUP_QUEUE:
    MOV AL, QUEUE_COUNT
    CMP AL, 0
    JE MAX_EMPTY
    
    MOV CL, QUEUE_COUNT   
    MOV CH, 0
    LEA SI, QUEUE_ARRAY
    MOV BL, QUEUE_HEAD    
    MOV BH, 0
    ADD SI, BX
    JMP MAX_CONTINUE
    
MAX_SETUP_STACK:
    MOV AL, STACK_COUNT
    CMP AL, 0
    JE MAX_EMPTY
    
    MOV CL, STACK_COUNT   
    MOV CH, 0
    LEA SI, STACK_ARRAY   
    JMP MAX_CONTINUE
    
MAX_CONTINUE: 
    
    MOV AL, [SI]          
    INC SI                
    DEC CX               
    
    JZ MAX_FOUND 
    
MAX_LOOP:
    MOV BL, [SI]          
    
    CMP BL, AL
    JLE MAX_INNER_CONTINUE   
    
    MOV AL, BL            
    
MAX_INNER_CONTINUE:
    INC SI                
    LOOP MAX_LOOP
    
MAX_FOUND:

    LEA DX, MSG_MAX_RESULT
    CALL PRINT_STRING
    
    MOV DL, AL            
    MOV AH, 02h
    INT 21h               
    
    CALL PRINT_NL
    JMP MAX_EXIT

MAX_EMPTY:
    LEA DX, MSG_UNDERFLOW
    CALL PRINT_STRING

MAX_EXIT:
    CALL PRINT_ANOTHER_OP_MSG
    
    POP SI
    POP CX
    POP BX
    POP AX
    RET
FIND_MAX_PROC ENDP
CODE_SEG ENDS
END MAIN