; Simulate time puncher
; When you see a '^' it is a comment reffering to the line above
;       
.ORIG x3000
            AND   R1, R1, #0 ; Clear R1
            AND   R2, R2, #0 ; Clear R2
            LD    R3, CONVERT_ASC_TO_DEC ; Converts ASCII to Decimal within Register (#-48)
       
START       LEA   R0, PROMPT_START ; Load prompt for start time
            JSR   GET_CHAR
            ST    R2, Start_HH    ;Saving Start (HH:--) after return 
            ST    R5, Start_MM    ;Saving Start (--:MM) after return 

            LEA   R0, PROMPT_END   ; Load prompt for end time
            JSR   GET_CHAR
            ST    R2, End_HH    ;Saving End (HH:--) after return 
            ST    R5, End_MM    ;Saving End (--:MM) after return 
            
            

       
EXIT        TRAP X25   ; HALT

;__SubRoutine_________________________________________________________________________
GET_CHAR    PUTS
            GETC
            OUT
            ADD     R2,R0, #0   ; Store value into R2 
            ADD     R2,R2,R3    ; Converting to ASCII R2 = "A"
            GETC
            OUT
            ADD     R4,R0,#0    ; Store value into R3
            ADD     R4,R4,R3    ;Converting to ASCII R4 = "B"
            GETC
            OUT
            ADD     R5,R0, #0   ; Store value into R5
            ADD     R5,R5,R3    ; Converting to ASCII R5 = "C"
            GETC
            OUT
            ADD     R6,R0,#0    ; Store value into R6
            ADD     R6,R6,R3    ;Converting to ASCII R6 = "D"
            ;JSR     CONVERT_TENS_PLACE
        
            LD      R1, TEN
            ST      R4, SaveR4
            AND     R4,R4, #0   ;Clear R4
            
MULTITENA:
            ADD     R4,R4,R2   ;Add tens value to itself 10 times
            ADD     R1,R1, #-1  ;decreasing counter
            BRp     MULTITENA    ;Continue loop until 0
            
            AND     R2, R2, #0  ;Clear R2
            ADD     R2,R2,R4    ;Move R4 result back to R2 
            LD      R4, SaveR4  ;Loading original value for "B"
            ADD     R2 , R2 , R4 ;Adding "A" tens place and "B" result in R2 
            ;R2 Successfully holds the hour "(HH:--)" portion
            
            LD      R1, TEN
            AND     R4,R4, #0   ;Clear R4
MULTITENC:
            ADD     R4,R4,R5   ;Add tens value to itself 10 times
            ADD     R1,R1, #-1  ;decreasing counter
            BRp     MULTITENC    ;Continue loop until 0
            
            AND     R5, R5, #0  ;Clear R5
            ADD     R5,R5,R4    ;Move result to R5 
            ADD     R5, R5 , R6 ; Adding "C" and "D" together 
            ; R5 Successfully holds the minutes "(--:MM)" Portion
            RET
;_SubRoutine^^^________________________________________________________________________

CONVERT_ASC_TO_DEC  .FILL #-48
ASCII	            .FILL #48 
TEN                 .FILL  #10

START_TIME          .BLKW 2
END_TIME            .BLKW 2
PROMPT_START        .STRINGZ "Enter start time using military Time(HH:MM): "
PROMPT_END          .STRINGZ "\nEnter end time using military Time(HH:MM): "
ERRORMSG            .STRINGZ "Not a valid input"

SaveR1              .FILL   x0000
SaveR2              .FILL   x0000
SaveR3              .FILL   x0000
SaveR4              .FILL   x0000
SaveR5              .FILL   x0000
SaveR6              .FILL   x0000
Start_HH            .FILL   x0000
Start_MM            .FILL   x0000
End_HH              .FILL   x0000
End_MM              .FILL   x0000


            .END
