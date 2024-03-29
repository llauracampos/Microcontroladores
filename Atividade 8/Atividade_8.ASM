;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      MAR�O DE 2021                              *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David Jos� de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_ON & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		PRESS
		TEMP
		TENSAO
		
		

		;COLOQUE AQUI SUAS NOVAS VARI�VEIS
		;N�O ESQUE�A COMENT�RIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINI��O DE VARI�VEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER�O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000001' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	MOVLW	B'00000001'
	MOVWF	ANSEL 
	MOVLW	B'00001111'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW   B'00000001'
	MOVWF	ADCON0
	MOVLW	B'00000000'
	MOVWF	CMCON

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

; OS LIMITES DE TENS�O ADOTADOS PARA A ATIVIDADE FORAM 0V E 5V.
	
DESLIGA ; LABEL QUE DESABILITA AS FUN��ES DOS REGISTRADORES PARA UM MENOR CONSUMO DE ENERGIA.
	BANK1				
	MOVLW	B'00000000' 
	MOVWF	TRISIO	; DESABILITA TODAS AS PORTAS COMO ENTRADA.	
	MOVLW	B'00000000'
	MOVWF	ANSEL ; DESABILITA AS ENTRADAS ANAL�GICAS.
	BANK0
	MOVLW   B'00000000' ; DESABILITA A CONVERS�O.
	MOVWF	ADCON0
	
DORME	; LABEL QUE DESLIGAR� TODOS OS LEDS E ADORMECER� O MICROCONTROLADOR NO COME�O DO PROGRAMA E AP�S CADA VERIFICA��O.
	BCF	GPIO, GP1   ; DESLIGA O LED GP1.
	BCF	GPIO, GP2   ; DESLIGA O LED GP2.
	BCF	GPIO, GP4   ; DESLIGA O LED GP4.
	BCF	GPIO, GP5   ; DESLIGA O LED GP5.
    	SLEEP	; ADORMECE O MICROCONTROLADOR POR 2S.
	NOP ; FUN��O ADOTADA PARA MELHOR VISUALIZA��O DO TEMPO ADORMECIDO NO STOPWATCH;
	
LIGA	; LABEL QUE HABILITA AS FUN��ES DOS REGISTRADORES AP�S O MICROCONTROLADOR "ACORDAR".
	BANK1				
	MOVLW	B'00000001' 
	MOVWF	TRISIO	; HABILITA O GP0 COMO ENTRADA.		
	MOVLW	B'00000001' 
	MOVWF	ANSEL	; HABILITA A ENTRADA ANAL�GICA.
	BANK0
	MOVLW   B'00000001'
	MOVWF	ADCON0	; HABILITA A CONVERS�O.
	

; COMO O WDT TEM UM PER�ODO DE TEMPO NOMINAL DE 18 MS, FOI ADICIONADO UM PRE-SCALER DE 1:128,
; PARA QUE A CONTAGEM NO MODO SLEEP SEJA DE 2S (2,20S APROXIMADAMENTE), COMO PEDE A ESPECIFICA��O.
	
MAIN
	BSF	ADCON0, 1 ; HABILITA O IN�CIO DA CONVERS�O DE TENS�O.
	
CONVERTE_TENSAO  ; LABEL UTILIZADA PARA GERAR OS CICLOS DE M�QUINAS NECESS�RIOS PARA TERMINAR A CONVERS�O
	BTFSC	ADCON0, 1   
	GOTO	CONVERTE_TENSAO ; PERMANECE NA LABEL ENQUANTO A CONVERS�O N�O � FINALIZADA.
	GOTO	COMPARA_MENOR_2	; PASSA PARA A PR�XIMA LABEL QUANDO A CONVERS�O � FINALIZADA.

COMPARA_MENOR_2	; COMPARA SE O VALOR DE TENS�O INSERIDO EM GP0 � MENOR QUE 2V.
	MOVF	ADRESH, W   ; COLOCA O VALOR DA TENS�O OBTIDO NA CONVERS�O NO WORK.
	MOVWF	TENSAO	; GUARDA NA VARI�VEL TENSAO.
	MOVLW	.102	; SUBTRAI 102 (VALOR DE 2V CONVERTIDO) DA TENS�O OBTIDA NO GP0.
	SUBWF	TENSAO, W
	BTFSC	STATUS, C  ; VERIFICA SE A TENS�O � MENOR OU MAIOR QUE A REFER�NCIA (2V).
	GOTO	COMPARA_MENOR_3	; SE A TENS�O FOR MAIOR QUE 2V, SER� REALIZADO O PR�XIMO TESTE (SE � MENOR QUE 3V).
	GOTO	LIGA_GP1    ; SE A TENS�O FOR MENOR QUE 2V, SER� ENCAMINHADO PARA A LABEL QUE LIGA O LED GP1.

COMPARA_MENOR_3 ; COMPARA SE O VALOR DE TENS�O INSERIDO EM GP0 � MENOR QUE 3V.
	MOVF	ADRESH, W   ; COLOCA O VALOR DA TENS�O OBTIDO NA CONVERS�O NO WORK.
	MOVWF	TENSAO	; GUARDA NA VARI�VEL TENSAO.
	MOVLW	.153	; SUBTRAI 153 (VALOR DE 3V CONVERTIDO) DA TENS�O OBTIDA NO GP0.
	SUBWF	TENSAO, W
	BTFSC	STATUS, C   ; VERIFICA SE A TENS�O � MENOR OU MAIOR QUE A REFER�NCIA (3V).
	GOTO	COMPARA_MENOR_4	; SE A TENS�O FOR MAIOR QUE 3V, SER� REALIZADO O PR�XIMO TESTE (SE � MENOR QUE 4V).
	GOTO	LIGA_GP2    ; SE A TENS�O FOR MENOR QUE 3V, SER� ENCAMINHADO PARA A LABEL QUE LIGA O LED GP2.

COMPARA_MENOR_4	; COMPARA SE O VALOR DE TENS�O INSERIDO EM GP0 � MENOR QUE 4V.
	MOVF	ADRESH, W   ; COLOCA O VALOR DA TENS�O OBTIDO NA CONVERS�O NO WORK.
	MOVWF	TENSAO	; GUARDA NA VARI�VEL TENSAO.
	MOVLW	.204	; SUBTRAI 204 (VALOR DE 4V CONVERTIDO) DA TENS�O OBTIDA NO GP0.
	SUBWF	TENSAO, W
	BTFSC	STATUS, C   ; VERIFICA SE A TENS�O � MENOR OU MAIOR QUE A REFER�NCIA (4V).
	GOTO	LIGA_GP5    ; SE A TENS�O FOR MAIOR QUE 4V, SER� ENCAMINHADO PARA A LABEL QUE LIGA O LED GP5.
	GOTO	LIGA_GP4    ; SE A TENS�O FOR MENOR QUE 4V, SER� ENCAMINHADO PARA A LABEL QUE LIGA O LED GP4.

LIGA_GP1
	BSF	GPIO, GP1 ; LIGA O LED GP1.
	GOTO	DESLIGA	; ENCAMINHA O PROGRAMA PARA A LABEL QUE DESABILITA AS FUN��ES DOS REGISTRADORES PARA POUPAR ENERGIA E EM SEGUIDA PARA A LABEL QUE DESLIGA OS LEDS E ADORMECE O MICROCONTROLADOR.
	
LIGA_GP2
	BSF	GPIO, GP2   ; LIGA O LED GP2.
	GOTO	DESLIGA	; ENCAMINHA O PROGRAMA PARA A LABEL QUE DESABILITA AS FUN��ES DOS REGISTRADORES PARA POUPAR ENERGIA E EM SEGUIDA PARA A LABEL QUE DESLIGA OS LEDS E ADORMECE O MICROCONTROLADOR.

LIGA_GP4
	BSF	GPIO, GP4   ; LIGA O LED GP4.
	GOTO	DESLIGA	; ENCAMINHA O PROGRAMA PARA A LABEL QUE DESABILITA AS FUN��ES DOS REGISTRADORES PARA POUPAR ENERGIA E EM SEGUIDA PARA A LABEL QUE DESLIGA OS LEDS E ADORMECE O MICROCONTROLADOR.
	
LIGA_GP5
	BSF	GPIO, GP5 ; LIGA O LED GP5.
	GOTO	DESLIGA	; ENCAMINHA O PROGRAMA PARA A LABEL QUE DESABILITA AS FUN��ES DOS REGISTRADORES PARA POUPAR ENERGIA E EM SEGUIDA PARA A LABEL QUE DESLIGA OS LEDS E ADORMECE O MICROCONTROLADOR.

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	END
