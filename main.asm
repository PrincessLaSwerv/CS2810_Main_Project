; Simulate time puncher
; When you see a '^' it is a comment reffering to the line above
;       
.ORIG x3050
       
       AND   R1, R1, #0 ; Clear R1
       AND   R2, R2, #0 ; Clear R2
       LD    R3, ASCII ; Load ASCII difference
       
START  LEA   R0, PROMPT_START ; Load prompt for start time
       TRAP  x22               ; Display prompt
       TRAP  x23               ; Request keyboard input for start time
       ;ADD   R1, R0, #0       ; Store input into R1
       ST   R0, START_TIME    ; Store R1 into the START_TIME BLOCK
       ; ^ SHOULD STORE THE INPUT FROM USER INTO START_TIME BLOCK

       LEA   R0, PROMPT_END   ; Load prompt for end time
       TRAP  x22               ; Display prompt
       TRAP  x23               ; Request keyboard input for end time
       ;ADD   R1, R0, #0    ;
       ST   R0, END_TIME      ; Store end time input in memory  ; THIS IS NOT WORKING 
       ; ^ SHOULD STORE THE INPUT FROM USER INTO END_TIME BLOCK


       ; BELOW IS TESTING TO MAKE SURE WE ARE ABLE TO PULL STORED INPUTS
       ;LEA   R0, START_TIME ; Load address of start time
       ;TRAP  x22            ; Display address
       ; ^ above will dispaly the input character
       
       ;LD    R0, START_TIME ; Load content of start time
       ;TRAP  x22            ; Display content
       ; ^ this displays ascii characters of the input so its just question marks
       
       ;LEA   R0, END_TIME ; Load address of end time
       ;TRAP  x22          ; Display address
       ; ^ above will dispaly the input character
       
       
       ;LD    R0, END_TIME ; Load content of end time
       ;TRAP  x22          ; Display content
       ; ^ this displays ascii characters of the input so its just question marks


       ; BELOW IS WHERE WE ARE STARTING PREPERATION FOR CALCULATION 
       ; PROBABLY WON'T WORK NORMALLY SINCE THEY ARE GOING TO INPUT AS TIME FORMAT
       
       ; RIGHT NOW JUST TRYING TO GET THE R2, TO BE SUBTRACTED TO R1 CORRECTLY AND OUTPUT A NUMBER
       LD   R1, START_TIME   ; Load start time input into R1 
       NOT   R1, R1           ; Should negate start time so we can add them
       ADD   R1, R1, #1       ; 2's complement adjustment
       ADD   R1, R1, R3       ; Adjust for ASCII conversion
       

       LD   R2, END_TIME     ; Load end time
       NOT   R2, R2           ; Negate end time
       ADD   R2, R2, #1       ; 2's complement adjustment
       ADD   R2, R2, R3       ; Adjust for ASCII conversion


       ADD   R1, R2, R1       ; Calculate R2 - R1
       ; Convert the result back to ASCII characters
       ADD  R0, R1, #0         ; Copy the result to R0
       ; ^NOT SURE IF WE SHOULD ADD ASCII TO IT INSTEAD OF JUST 0 MAYBE SOMETHING TO TRY
       TRAP x21                ; Display the result

       BRnzp EXIT             ; Exit the program
       

ERROR  LEA   R0, ERRORMSG ; load error message
       TRAP  X22      ; Output error message
       
EXIT   TRAP X25   ; HALT


ASCII  .FILL x0020
START_TIME .BLKW 2
END_TIME   .BLKW 2
PROMPT_START .STRINGZ "Enter start time (HH:MM): "
PROMPT_END   .STRINGZ "Enter end time (HH:MM): "
ERRORMSG .STRINGZ "Not a valid input"
.END
