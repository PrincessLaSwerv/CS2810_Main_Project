; Simulate time puncher
;
;       
.ORIG x3000
       
       AND   R1, R1, #0 ; Clear R1
       AND   R2, R2, #0 ; Clear R2
       LD    R3, ASCII ; Load ASCII difference
       
START  LEA   R0, PROMPT_START ; Load prompt for start time
       TRAP  x22               ; Display prompt
       TRAP  x23               ; Request keyboard input for start time
       STR   R0, START_TIME    ; Store start time input in memory ; THIS IS NOT WORKING
       ; SHOULD STORE THE INPUT FROM USER INTO START_TIME BLOCK

       LEA   R0, PROMPT_END   ; Load prompt for end time
       TRAP  x22               ; Display prompt
       TRAP  x23               ; Request keyboard input for end time
       STR   R0, END_TIME      ; Store end time input in memory  ; THIS IS NOT WORKING 
       ; SHOULD STORE THE INPUT FROM USER INTO END_TIME BLOCK


       ; BELOW IS TESTING TO MAKE SURE WE ARE ABLE TO PULL STORED INPUTS
       LEA R0, START_TIME ;
       TRAP X22
       LEA R0, END_TIME ;
       TRAP X22

       ; BELOW IS WHERE WE ARE STARTING PREPERATION FOR CALCULATION 
       ; PROBABLY WON'T WORK NORMALLY SINCE THEY ARE GOING TO INPUT AS TIME FORMAT
       LDR   R1, START_TIME   ; Load start time input into R1 
       NOT   R1, R1           ; Should negate start time so we can add them
       ADD   R1, R1, #1       ; 2's complement adjustment
       ADD   R1, R1, R3       ; Adjust for ASCII conversion

       LDR   R2, END_TIME     ; Load end time
       NOT   R2, R2           ; Negate end time
       ADD   R2, R2, #1       ; 2's complement adjustment
       ADD   R2, R2, R3       ; Adjust for ASCII conversion


       LD    R6, START_TIME   ; Load start time
       LD    R7, END_TIME     ; Load end time
       ADD   R1, R7, R6       ; Calculate total time
       TRAP  x21              ; Display total time

       BRnzp EXIT             ; Exit the program
       

ERROR  LEA   R0, ERRORMSG ; load error message
       TRAP  X22      ; Output error message
       BRnzp AGAIN


ASCII  .FILL x0020
START_TIME .BLKW 1
END_TIME   .BLKW 1
PROMPT_START .STRINGZ "Enter start time (HH:MM): "
PROMPT_END   .STRINGZ "Enter end time (HH:MM): "
ERRORMSG .STRINGZ "Not a valid input"
EXIT  TRAP  x25      ; Halt
.END
