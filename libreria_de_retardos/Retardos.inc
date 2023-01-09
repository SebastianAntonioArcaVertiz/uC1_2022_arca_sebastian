;--------------------------------------------------------------
; @file Retardos.inc
; @brief Libreria de retardos para proximas implementaciones
; @date 09/01/23
; @author Sebastián Antonio Arca Vértiz
; @frecuency 4 Mhz
; @version MPLAB X IDE v6.00
;------------------------------------------------------------------
    
PSECT udata_acs
contador1: DS 1  ;reserva 1 byte en acces
contador2: DS 1 ;reserva 1 byte en acces
    
PSECT code
 
;Comenzamos con los retardos de microsegundos, aplicamos la fórmula T= 6+4k, donde T es el tiempo, y k, el valor de w
 ; 10 us
 
Delay_10us:        ;2 tyc (llamados desde un call) 
    MOVLW  1            ;  1 tyv
    MOVWF  contador1,0     ;  1 tyc
Loop_10us:   
    NOP                      ;  1 tyc (Proviene de k*tyc)
    DECFSZ contador1,1,0        ;  3 tyc (proviene de k-1 + 3 tyc)
    GOTO   Loop_10us          ;  0 tyc  (si es que llega aquí usaríamos (k-2)*2 tyc)
    RETURN                   ;  2 tyc
    
 ; 25 us
    
Delay_25us:        ;2 tyc (llamados desde un call) 
    MOVLW  5            ;  1 tyv
    MOVWF  contador1,0     ;  1 tyc
Loop_25us:   
    NOP                      ;  5 tyc (Proviene de k*tyc)
    DECFSZ contador1,1,0        ;  7 tyc (proviene de k-1 + 3 tyc)
    GOTO   Loop_25us          ;  6 tyc  (si es que llega aquí usaríamos (k-2)*2 tyc)
    RETURN                   ;  2 tyc
    
; 50 us
    
Delay_50us:        ;2 tyc (llamados desde un call) 
    MOVLW  11            ;  1 tyv
    MOVWF  contador1,0     ;  1 tyc
Loop_50us:   
    NOP                      ;  11 tyc (Proviene de k*tyc)
    DECFSZ contador1,1,0        ;  13 tyc (proviene de k-1 + 3 tyc)
    GOTO   Loop_50us          ;  18 tyc  (si es que llega aquí usaríamos (k-2)*2 tyc)
    RETURN                   ;  2 tyc
                                  
                                  
 ; 100 us
    
Delay_100us:        ;2 tyc (llamados desde un call) 
    MOVLW  24           ;  1 tyv
    MOVWF  contador1,0     ;  1 tyc
Loop_100us:   
    NOP                      ;  24 tyc (Proviene de k*tyc)
    DECFSZ contador1,1,0        ;  26 tyc (proviene de k-1 + 3 tyc)
    GOTO   Loop_100us          ;  44 tyc  (si es que llega aquí usaríamos (k-2)*2 tyc)
    RETURN                   ;  2 tyc
                                  

      
 ; 200 us
    
Delay_200us:        ;2 tyc (llamados desde un call) 
    MOVLW  49           ;  1 tyv
    MOVWF  contador1,0     ;  1 tyc
Loop_200us:   
    NOP                      ;  49 tyc (Proviene de k*tyc)
    DECFSZ contador1,1,0        ;  51 tyc (proviene de k-1 + 3 tyc)
    GOTO   Loop_200us          ;  94 tyc  (si es que llega aquí usaríamos (k-2)*2 tyc)
    RETURN                   ;  2 tyc
                                  

 
 ; 250 us
    
Delay_250us:        ;2 tyc (llamados desde un call) 
    MOVLW  61           ;  1 tyv
    MOVWF  contador1,0     ;  1 tyc
Loop_250us:   
    NOP                      ;  61 tyc (Proviene de k*tyc)
    DECFSZ contador1,1,0        ;  63 tyc (proviene de k-1 + 3 tyc)
    GOTO   Loop_250us          ;  118 tyc  (si es que llega aquí usaríamos (k-2)*2 tyc)
    RETURN                   ;  2 tyc
                                  
    
; 500 us
    
Delay_500us:        ;2 tyc (llamados desde un call) 
    MOVLW  124          ;  1 tyv
    MOVWF  contador1,0     ;  1 tyc
Loop_500us:   
    NOP                      ;  124 tyc (Proviene de k*tyc)
    DECFSZ contador1,1,0        ;  126 tyc (proviene de k-1 + 3 tyc)
    GOTO   Loop_500us          ;  244 tyc  (si es que llega aquí usaríamos (k-2)*2 tyc)
    RETURN                   ;  2 tyc
    
;Comenzamos con los retardos de milisegundos, para ello utilizaremos dos contadores y dos loop, uno que realice los cálculos y otro que lo expresará en milisegundos.
    
 ; 1 ms
 
    Delay_1ms:  ;2 tyc (llamados desde un call)
    MOVLW 1      ; 1 tcy
    MOVWF  contador2,0     ;1 tcy
    Ext_Loop_1ms:
    MOVLW 249     ;1 tcy
    MOVWF contador1,0   ;1 tcy
    Int_Loop_1ms:
    NOP     ;249 tcy (proviene de k*tcy)
    DECFSZ contador1,1,0  ;251 tcy (proviene de k2(k-1)+3tcy)
    GOTO Int_Loop_1ms  ;496 tcy (proviene de k2(k-1)*2tcy)
    DECFSZ contador2,1,0 ;3 tcy (proviene de k2(k-1)+3tcy, hablando del k del contador 2)
    GOTO Ext_Loop_1ms ;0tcy (si es que llega aquí usaríamos k2(k-1)*2 tyc)
    RETURN ;2tcy
 
; 5 ms
    
    Delay_5ms:  ;2 tyc (llamados desde un call)
    MOVLW 5      ; 1 tcy
    MOVWF  contador2,0     ;1 tcy
    Ext_Loop_5ms:
    MOVLW 249     ;1 tcy
    MOVWF contador1,0   ;1 tcy
    Int_Loop_5ms:
    NOP     ;1245 tcy (proviene de k1*k2*tcy)
    DECFSZ contador1,1,0  ;1243 tcy (proviene de k2(k1-1)+3tcy)
    GOTO Int_Loop_5ms  ;2480 tcy (proviene de k2(k1-1)*2tcy)
    DECFSZ contador2,1,0 ;7 tcy (proviene de (k2-1)+3tcy, hablando del k del contador 2)
    GOTO Ext_Loop_5ms ;8 tcy (si es que llega aquí usaríamos (k2-1)*2 tyc)
    RETURN ;2tcy
    
    
  ;10 ms
  
    Delay_10ms:  ;2 tyc (llamados desde un call)
    MOVLW 10      ; 1 tcy
    MOVWF  contador2,0     ;1 tcy
    Ext_Loop_10ms:
    MOVLW 249     ;1 tcy
    MOVWF contador1,0   ;1 tcy
    Int_Loop_10ms:
    NOP     ;2490 tcy (proviene de k1*k2*tcy)
    DECFSZ contador1,1,0  ;2483 tcy (proviene de k2(k1-1)+3tcy)
    GOTO Int_Loop_10ms  ;4960 tcy (proviene de k2(k1-1)*2tcy)
    DECFSZ contador2,1,0 ;12 tcy (proviene de (k2-1)+3tcy, hablando del k del contador 2)
    GOTO Ext_Loop_10ms ;18 tcy (si es que llega aquí usaríamos (k2-1)*2 tyc)
    RETURN ;2tcy
    
  
  ;25 ms
  
    Delay_25ms:  ;2 tyc (llamados desde un call)
    MOVLW 25      ; 1 tcy
    MOVWF  contador2,0     ;1 tcy
    Ext_Loop_25ms:
    MOVLW 249     ;1 tcy
    MOVWF contador1,0   ;1 tcy
    Int_Loop_25ms:
    NOP     ;6225 tcy (proviene de k1*k2*tcy)
    DECFSZ contador1,1,0  ;6203 tcy (proviene de k2(k1-1)+3tcy)
    GOTO Int_Loop_25ms  ;12400 tcy (proviene de k2(k1-1)*2tcy)
    DECFSZ contador2,1,0 ;27 tcy (proviene de (k2-1)+3tcy, hablando del k del contador 2)
    GOTO Ext_Loop_25ms ;48 tcy (si es que llega aquí usaríamos (k2-1)*2 tyc)
    RETURN ;2tcy
    
   ;50 ms
  
    Delay_50ms:  ;2 tyc (llamados desde un call)
    MOVLW 50      ; 1 tcy
    MOVWF  contador2,0     ;1 tcy
    Ext_Loop_50ms:
    MOVLW 249     ;1 tcy
    MOVWF contador1,0   ;1 tcy
    Int_Loop_50ms:
    NOP     ;12450 tcy (proviene de k1*k2*tcy)
    DECFSZ contador1,1,0  ;12403 tcy (proviene de k2(k1-1)+3tcy)
    GOTO Int_Loop_50ms  ;24800 tcy (proviene de k2(k1-1)*2tcy)
    DECFSZ contador2,1,0 ;52 tcy (proviene de (k2-1)+3tcy, hablando del k del contador 2)
    GOTO Ext_Loop_50ms ;98 tcy (si es que llega aquí usaríamos (k2-1)*2 tyc)
    RETURN ;2tcy
    
    
    ;100 ms
  
    Delay_100ms:  ;2 tyc (llamados desde un call)
    MOVLW 100      ; 1 tcy
    MOVWF  contador2,0     ;1 tcy
    Ext_Loop_100ms:
    MOVLW 249     ;1 tcy
    MOVWF contador1,0   ;1 tcy
    Int_Loop_100ms:
    NOP     ;24900 tcy (proviene de k1*k2*tcy)
    DECFSZ contador1,1,0  ;24803 tcy (proviene de k2(k1-1)+3tcy)
    GOTO Int_Loop_100ms  ;49600 tcy (proviene de k2(k1-1)*2tcy)
    DECFSZ contador2,1,0 ;102 tcy (proviene de (k2-1)+3tcy, hablando del k del contador 2)
    GOTO Ext_Loop_100ms ;198 tcy (si es que llega aquí usaríamos (k2-1)*2 tyc)
    RETURN ;2tcy
    
    
    ;200 ms
  
    Delay_200ms:  ;2 tyc (llamados desde un call)
    MOVLW 200      ; 1 tcy
    MOVWF  contador2,0     ;1 tcy
    Ext_Loop_200ms:
    MOVLW 249     ;1 tcy
    MOVWF contador1,0   ;1 tcy
    Int_Loop_200ms:
    NOP     ;49800 tcy (proviene de k1*k2*tcy)
    DECFSZ contador1,1,0  ;49603 tcy (proviene de k2(k1-1)+3tcy)
    GOTO Int_Loop_200ms  ;99200 tcy (proviene de k2(k1-1)*2tcy)
    DECFSZ contador2,1,0 ;202 tcy (proviene de (k2-1)+3tcy, hablando del k del contador 2)
    GOTO Ext_Loop_200ms ;398 tcy (si es que llega aquí usaríamos (k2-1)*2 tyc)
    RETURN ;2tcy
    
    
    ;250 ms
  
    Delay_250ms:  ;2 tyc (llamados desde un call)
    MOVLW 250      ; 1 tcy
    MOVWF  contador2,0     ;1 tcy
    Ext_Loop_250ms:
    MOVLW 249     ;1 tcy
    MOVWF contador1,0   ;1 tcy
    Int_Loop_250ms:
    NOP     ;62250 tcy (proviene de k1*k2*tcy)
    DECFSZ contador1,1,0  ;62003 tcy (proviene de k2(k1-1)+3tcy)
    GOTO Int_Loop_250ms  ;124000 tcy (proviene de k2(k1-1)*2tcy)
    DECFSZ contador2,1,0 ;252 tcy (proviene de (k2-1)+3tcy, hablando del k del contador 2)
    GOTO Ext_Loop_250ms ;498 tcy (si es que llega aquí usaríamos (k2-1)*2 tyc)
    RETURN ;2tcy




