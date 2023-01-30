;--------------------------------------------------------------
; @file Parcial2_Ej2
; @brief Segundo ejercicio Parcial2
; @date 30/01/23
; @author Sebastián Antonio Arca Vértiz
; @frecuency 4 Mhz
; @version MPLAB X IDE v6.00
;------------------------------------------------------------------
PROCESSOR 18F57Q84
#include "config.inc"   /config statements should precede project file includes./
#include <xc.inc>
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main 
    
PSECT ISRVectLowPriority0,class=CODE,reloc=2
ISRVectLowPriority0:
    BTFSS   PIR1,0,0	; ¿Se ha producido la INT0?
    GOTO    Exit0
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
    CALL Secuencia5
Exit0:
    RETFIE
    
PSECT ISRVectHighPriority1,class=CODE,reloc=2
ISRVectHighPriority1:
    BTFSS   PIR6,0,0	; ¿Se ha producido la INT1?
    GOTO    Exit1
    BCF	    PIR6,0,0	; limpiamos el flag de INT1
    CALL    Apagado
Exit1:
    RETFIE

PSECT ISRVectHighPriority,class=CODE,reloc=2
ISRVectHighPriority:
    BTFSS   PIR10,0,0	; ¿Se ha producido la INT2?
    GOTO    Exit2
Leds_Off:
    BCF	    PIR10,0,0	; limpiamos el flag de INT2
    CALL Secuencia
Exit2:
    RETFIE

PSECT udata_acs
contador1:  DS 1	    
contador2:  DS 1
offset:	    DS 1
counter:    DS 1
    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0_INT1_INT2,1
    
    Loop1:
    BTG LATF,3,0
    CALL   Delay_250ms
    CALL   Delay_250ms
    BTG LATF,3,0
    GOTO Loop1

Config_OSC:
    ;Configuracion del Oscilador Interno a una frecuencia de 4MHz
    BANKSEL OSCCON1
    MOVLW   0x60    ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02    ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
    
Config_Port:	
    ;Config Led
    BANKSEL PORTF
    CLRF    PORTF,1	
    BSF	    LATF,3,1
    CLRF    ANSELF,1	
    BCF	    TRISF,3,1
    
    ;Config User Button
    BANKSEL PORTA
    CLRF    PORTA,1	
    CLRF    ANSELA,1	
    BSF	    TRISA,3,1
    BSF     LATA,3,1
    BSF	    WPUA,3,1
    
    ;Config Ext Button
    BANKSEL PORTB
    CLRF    PORTB,1	
    CLRF    ANSELB,1	
    BSF	    TRISB,4,1	
    BSF	    WPUB,4,1
    
    BANKSEL PORTF
    CLRF    PORTF,1	
    CLRF    ANSELF,1	
    BSF	    TRISF,2,1	
    BSF	    WPUF,2,1
    
    ;Config PORTC
    BANKSEL PORTC  
    CLRF PORTC,0
    CLRF ANSELC,0
    RETURN
    
Config_PPS:
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	; INT0 --> RA3
    
    ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0xC
    MOVWF   INT1PPS,1	; INT1 --> RB4
    
    ;Config INT2
    BANKSEL INT2PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1	; INT2 --> RF2
    
    RETURN
    
;   Secuencia para configurar interrupcion:
;    1. Definir prioridades
;    2. Configurar interrupcion
;    3. Limpiar el flag
;    4. Habilitar la interrupcion
;    5. Habilitar las interrupciones globales
Config_INT0_INT1_INT2:
    ;Configuracion de prioridades
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 -- Habilitamos las prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1    ; IPR1<INT0IP> = 0 -- INT0 de baja prioridad
    BSF	IPR6,0,1    ; IPR6<INT1IP> = 0 -- INT1 de alta prioridad
    BSF IPR10,0,1   ; IPR10<INT2P> = 1 -- INT2 de alta prioridad
    
    ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Config INT2
    BCF	INTCON0,2,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR10,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext2
    
    ;Habilitacion de interrupciones
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN


Delay_250ms:		    ; 2Tcy -- Call
    MOVLW   250		    ; 1Tcy -- k2
    MOVWF   contador2,0	    ; 1Tcy
; T = (6 + 4k)us	    1Tcy = 1us
Ext_Loop:		    
    MOVLW   249		    ; 1Tcy -- k1
    MOVWF   contador1,0	    ; 1Tcy
Int_Loop:
    NOP			    ; k1*Tcy
    DECFSZ  contador1,1,0   ; (k1-1)+ 3Tcy
    GOTO    Int_Loop	    ; (k1-1)*2Tcy
    DECFSZ  contador2,1,0
    GOTO    Ext_Loop
    RETURN		    ; 2Tcy
    
Secuencia:
    CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CLRF LATC,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CLRF LATC,0
    RETURN
    
  Secuencia5:
      CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CLRF LATC,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CLRF LATC,0
       CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CLRF LATC,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CLRF LATC,0
       CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CLRF LATC,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CLRF LATC,0
       CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CLRF LATC,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CLRF LATC,0
       CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CLRF LATC,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BCF    LATC,1,0
    BSF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BSF    LATC,5,0
    BCF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BCF    LATC,0,0
    BSF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BSF    LATC,6,0
    BCF    LATC,7,0
    CALL   Delay_250ms
    CLRF   TRISC,0
    BSF    LATC,0,0
    BCF    LATC,1,0
    BCF    LATC,2,0
    BCF    LATC,3,0
    BCF    LATC,4,0
    BCF    LATC,5,0
    BCF    LATC,6,0
    BSF    LATC,7,0
    CLRF LATC,0

 RETURN
    
    
   Apagado:
    CLRF   TRISC,0
    BSF    LATC,0,0
    BSF    LATC,1,0
    BSF    LATC,2,0
    BSF    LATC,3,0
    BSF    LATC,4,0
    BSF    LATC,5,0
    BSF    LATC,6,0
    BSF    LATC,7,0
    RETURN
    
End resetVect


