PROCESSOR 18F57Q84
#include "config.inc" /config statements should precede project file includes./
#include <xc.inc>
#include "Retardos.inc"

    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT CODE
 
Main:
    CALL Config_OSC,1
    CALL Button
    CALL Puertoc
    CALL Circulo
    NOP
Circulo:
    BTFSS PORTA,3,1
    goto Par_Impar
    Off:
    BCF TRISE,1,0
    BCF LATE,1,0
    BCF TRISE,1,0
    BCF LATE,1,0
    BCF TRISC,0,0
    BCF LATC,0,0
    BCF TRISC,1,0
    BCF LATC,1,0
    BCF TRISC,2,0
    BCF LATC,2,0
    BCF TRISC,3,0
    BCF LATC,3,0
    BCF TRISC,4,0
    BCF LATC,4,0
    BCF TRISC,5,0
    BCF LATC,5,0
    BCF TRISC,6,0
    BCF LATC,6,0
    BCF TRISC,7,0
    BCF LATC,7,0
    GOTO Circulo
   Par_Impar:
    BCF TRISE,1,0
    BSF LATE,1,0
    BCF TRISE,1,0
    BCF LATE,0,0
    BCF TRISC,0,0
    BCF LATC,0,0
    BCF TRISC,1,0
    BSF LATC,1,0
    BCF TRISC,2,0
    BCF LATC,2,0
    BCF TRISC,3,0
    BCF LATC,3,0
    BCF TRISC,4,0
    BCF LATC,4,0
    BCF TRISC,5,0
    BCF LATC,5,0
    BCF TRISC,6,0
    BCF LATC,6,0
    BCF TRISC,7,0
    BCF LATC,7,0
    BTFSS PORTA,3,1
    GOTO Circulo
    CALL Delay_250ms,1
    CALL Delay_250ms,1
    BCF TRISC,0,0
    BCF LATC,0,0
    BCF TRISC,1,0
    BCF LATC,1,0
    BCF TRISC,2,0
    BCF LATC,2,0
    BCF TRISC,3,0
    BSF LATC,3,0
    BCF TRISC,4,0
    BCF LATC,4,0
    BCF TRISC,5,0
    BCF LATC,5,0
    BCF TRISC,6,0
    BCF LATC,6,0
    BCF TRISC,7,0
    BCF LATC,7,0
    BTFSS PORTA,3,1
    GOTO Circulo
    CALL Delay_250ms,1
    CALL Delay_250ms,1
    BCF TRISC,0,0
    BCF LATC,0,0
    BCF TRISC,1,0
    BCF LATC,1,0
    BCF TRISC,2,0
    BCF LATC,2,0
    BCF TRISC,3,0
    BSF LATC,3,0
    BCF TRISC,4,0
    BCF LATC,4,0
    BCF TRISC,5,0
    BCF LATC,5,0
    BTFSS PORTA,3,1
    GOTO Circulo
    BCF TRISC,6,0
    BCF LATC,6,0
    BCF TRISC,7,0
    BCF LATC,7,0
    BTFSS PORTA,3,1
    GOTO Circulo
    CALL Delay_250ms,1
    CALL Delay_250ms,1
    BCF TRISC,0,0
    BCF LATC,0,0
    BCF TRISC,1,0
    BCF LATC,1,0
    BCF TRISC,2,0
    BCF LATC,2,0
    BCF TRISC,3,0
    BCF LATC,3,0
    BCF TRISC,4,0
    BCF LATC,4,0
    BCF TRISC,5,0
    BSF LATC,5,0
    BCF TRISC,6,0
    BCF LATC,6,0
    BCF TRISC,7,0
    BCF LATC,7,0
    BTFSS PORTA,3,1
    GOTO Circulo
    CALL Delay_250ms,1
    CALL Delay_250ms,1
    BCF TRISC,0,0
    BCF LATC,0,0
    BCF TRISC,1,0
    BCF LATC,1,0
    BCF TRISC,2,0
    BCF LATC,2,0
    BCF TRISC,3,0
    BCF LATC,3,0
    BCF TRISC,4,0
    BCF LATC,4,0
    BCF TRISC,5,0
    BCF LATC,5,0
    BCF TRISC,6,0
    BCF LATC,6,0
    BCF TRISC,7,0
    BSF LATC,7,0
    BTFSS PORTA,3,1
    GOTO Circulo
    CALL Delay_250ms,1
    CALL Delay_250ms,1
    BCF TRISE,0,0
    BSF LATE,0,0
    BCF TRISE,1,0
    BCF LATE,1,0
    BCF TRISC,0,0
    BSF LATC,0,0
    BCF TRISC,1,0
    BCF LATC,1,0
    BCF TRISC,2,0
    BCF LATC,2,0
    BCF TRISC,3,0
    BCF LATC,3,0
    BCF TRISC,4,0
    BCF LATC,4,0
    BCF TRISC,5,0
    BCF LATC,5,0
    BCF TRISC,6,0
    BCF LATC,6,0
    BCF TRISC,7,0
    BCF LATC,7,0
    BTFSS PORTA,3,1
    GOTO Circulo
    CALL Delay_250ms,1
    BCF TRISC,0,0
    BCF LATC,0,0
    BCF TRISC,1,0
    BCF LATC,1,0
    BCF TRISC,2,0
    BSF LATC,2,0
    BCF TRISC,3,0
    BCF LATC,3,0
    BCF TRISC,4,0
    BCF LATC,4,0
    BCF TRISC,5,0
    BCF LATC,5,0
    BCF TRISC,6,0
    BCF LATC,6,0
    BCF TRISC,7,0
    BCF LATC,7,0
    BTFSS PORTA,3,1
    GOTO Circulo
    CALL Delay_250ms,1
    BCF TRISC,0,0
    BCF LATC,0,0
    BCF TRISC,1,0
    BCF LATC,1,0
    BCF TRISC,2,0
    BCF LATC,2,0
    BCF TRISC,3,0
    BCF LATC,3,0
    BCF TRISC,4,0
    BSF LATC,4,0
    BCF TRISC,5,0
    BCF LATC,5,0
    BCF TRISC,6,0
    BCF LATC,6,0
    BCF TRISC,7,0
    BCF LATC,7,0
    BTFSS PORTA,3,1
    GOTO Circulo
    CALL Delay_250ms,1
    BCF TRISC,0,0
    BCF LATC,0,0
    BCF TRISC,1,0
    BCF LATC,1,0
    BCF TRISC,2,0
    BCF LATC,2,0
    BCF TRISC,3,0
    BCF LATC,3,0
    BCF TRISC,4,0
    BCF LATC,4,0
    BCF TRISC,5,0
    BCF LATC,5,0
    BCF TRISC,6,0
    BSF LATC,6,0
    BCF TRISC,7,0
    BCF LATC,7,0
    BTFSS PORTA,3,1
    GOTO Circulo
    CALL Delay_250ms,1
    GOTO Par_Impar
 Button:
    BANKSEL PORTA
    CLRF PORTA,1
    CLRF ANSELA,1
    BSF TRISA,3,1
    BSF LATA,3,1
    BSF WPUA,3,1
    RETURN
Config_OSC:
    BANKSEL OSCCON1
    MOVLW 0x60
    MOVWF OSCCON1,1
    MOVLW 0x02
    MOVWF OSCFRQ,1
    RETURN
 Puertoc:
    BANKSEL PORTC  
    CLRF PORTC,0
    CLRF ANSELC,0
    RETURN
    

     
    



 
END resetVect


