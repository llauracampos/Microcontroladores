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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
	MOVLW	B'00000010' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	MOVLW	B'00010010'	
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'10101101'
	MOVWF	VRCON	
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00010100'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
;********************************************************************************
;* OS DADOS REFERENTES � ATIVIDADE S�O:                                         *
;*                                                                              *
;* TEMPERATURA M�NIMA = 24 E TEMPERATURA M�XIMA = 29                            *
;*                                                                              *
;* DESSE MODO, DE ACORDO COM A F�RMULA INDICADA NO PDF, AS TENS�ES M�NIMA E M�- *
;* XIMA S�O 1,44V E 2,865V, RESPECTIVAMENTE.                                    *
;*                                                                              *
;* DE ACORDO COM OS C�CULOS PARA IDENTIFICAR SE O VRR SERIA SETADO PARA LOW RAN-*
;* GE OU HIGH RANGE FORAM ENCONTRADOS OS SEGUINTES RESULTADOS PARA A TENS�O DE  *
;* REFER�NCIA:                                                                  *
;*                                                                              *
;* CVREF(TENS�O M�NIMA) -> HIGH RANGE = 1.40625, PARA UM VALOR DE VR = 1        *
;* CVREF(TENS�O M�NIMA) -> LOW RANGE = 1.45833, PARA UM VALOR DE VR = 7         *
;* COMO A DIFEREN�A ENTRE A TENS�O M�NIMA CALCULADA E A TENS�O RESULTANTE NO    *
;* LOW RANGE FOI MENOR, ELE FOI ADOTADO, ASSIM COMO O VALOR 7 PARA O VR.         *
;*                                                                              *
;* CVREF(TENS�O M�XIMA) -> HIGH RANGE = 2.8125, PARA UM VALOR DE VR = 10        *
;* CVREF(TENS�O M�XIMA) -> LOW RANGE = 2.8650, PARA UM VALOR DE VR = 13         *
;* COMO A DIFEREN�A ENTRE A TENS�O M�XIMA CALCULADA E A TENS�O RESULTANTE NO    *
;* LOW RANGE FOI MENOR, ELE FOI ADOTADO, ASSIM COMO O VALOR 13 PARA O VR.        *
;********************************************************************************

	
;********************************************************************************	
;* A LABEL "MANTEM_MAXIMA", TEM COMO OBJETIVO VERIFICAR SE A TENS�O INSERIDA EM *
;* UM NOVO EST�MULO FOI MAIOR QUE A TENS�O DE REFER�NCIA, QUANDO A REFER�NCIA � * 
;* A TEMPERATURA M�XIMA.                                                        *
;********************************************************************************
	
MANTEM_MAXIMA 
	BTFSS	CMCON, COUT ; TESTA SE O BIT COUT, OU SEJA, A SAIDA DO COMPARADOR EST� EM 1. COMO A SA�DA FOI CONFIGURADA COMO INVERSORA, QUANDO ESTA MUDA PARA 1 INDICA QUE A TENS�O INSERIDA � MAIOR QUE A TENS�O DE REFER�NCIA.
	GOTO	MANTEM_MAXIMA ; CASO A TENS�O INSERIDA N�O SEJA MAIOR QUE A DE REFER�NCIA, O PROGRAMA RETORNAR� PARA A LABEL.
	GOTO	LIGA_COMPRESSOR ; CASO A TENS�O INSERIDA SEJA MAIOR QUE A DE REFER�NCIA, O PROGRAMA SER� ENCAMINHADO PARA A LABEL DE LIGAR O COMPRESSOR.

;********************************************************************************	
;* A LABEL "MANTEM_MINIMA", TEM COMO OBJETIVO VERIFICAR SE A TENS�O INSERIDA EM *
;* UM NOVO EST�MULO FOI MENOR QUE A TENS�O DE REFER�NCIA, QUANDO A REFER�NCIA � * 
;* A TEMPERATURA M�NIMA.                                                        *
;********************************************************************************	
	
MANTEM_MINIMA
	BTFSS	CMCON, COUT ; TESTA SE O BIT COUT, OU SEJA, A SAIDA DO COMPARADOR CONTINUA EM 1. COMO A SA�DA FOI CONFIGURADA COMO INVERSORA, QUANDO ESTA MUDA PARA 0 INDICA QUE A TENS�O INSERIDA � MENOR QUE A TENS�O DE REFER�NCIA.
	GOTO	DESLIGA_COMPRESSOR ; CASO A TENS�O INSERIDA SEJA MAIOR QUE A DE REFER�NCIA, O PROGRAMA RETORNAR� PARA A LABEL.	
	GOTO	MANTEM_MINIMA ; CASO A TENS�O INSERIDA SEJA MENOR QUE A DE REFER�NCIA, O PROGRAMA SER� ENCAMINHADO PARA A LABEL DE DESLIGAR O COMPRESSOR.

;********************************************************************************	
;* A LABEL "REF_MAX", TEM COMO OBJETIVO MUDAR A TENS�O DE REFER�NCIA DO COMPARA-*
;* DOR. COMO ANTERIORMENTE A TENS�O DE REFE�NCIA ERA A M�NIMA, E FOI IDENTIFICA-*
;* DA UMA TENS�O DE ENTRADA MENOR, O COMPRESSOR � DESLIGADO E A NOVA TENS�O DE  *
;* REFER�NCIA � A M�XIMA.                                                       *
;********************************************************************************	
	
REF_MAX
	BANK1 
	MOVLW	B'10101101' ; � MOVIDO O VALOR 13 PARA VR, REFER�NTE � TENS�O M�XIMA (DE ACORDO COM A TEMPERATURA M�XIMA).
	MOVWF	VRCON
	BANK0
	GOTO	MANTEM_MAXIMA ; AP�S ALTERAR O VALOR DE VR NO REGISTRADOR VRCON, � ENCAMINHADO PARA A LABEL QUE VERIFICA SE A TENS�O INSERIDA � MAIOR QUE A DE REFER�NCIA.

;********************************************************************************	
;* A LABEL "REF_MIN", TEM COMO OBJETIVO MUDAR A TENS�O DE REFER�NCIA DO COMPARA-*
;* DOR. COMO ANTERIORMENTE A TENS�O DE REFE�NCIA ERA A M�XIMA, E FOI IDENTIFICA-*
;* DA UMA TENS�O DE ENTRADA MAIOR, O COMPRESSOR � LIGADO E A NOVA TENS�O DE     *
;* REFER�NCIA � A M�NIMA.                                                       *
;********************************************************************************
	
REF_MIN
	BANK1
	MOVLW	B'10100111' ; � MOVIDO O VALOR 7 PARA VR, REFER�NTE � TENS�O M�NIMA (DE ACORDO COM A TEMPERATURA M�NIMA).
	MOVWF	VRCON
	BANK0
	GOTO	MANTEM_MINIMA ; AP�S ALTERAR O VALOR DE VR NO REGISTRADOR VRCON, � ENCAMINHADO PARA A LABEL QUE VERIFICA SE A TENS�O INSERIDA � MENOR QUE A DE REFER�NCIA.

LIGA_COMPRESSOR
	BSF	GPIO, GP2 ; O PINO GP2, QUE INDICA O ESTADO DO COMPRESSOR, SER� COLOCADO EM 1, INDICANDO QUE A TEMPERATURA INSERIDA EXCEDEU A TENS�O DE REFER�NCIA M�XIMA, LOGO O COMPRESSOR SER� LIGADO.
	GOTO	REF_MIN ; AP�S LIGAR O COMPRESSOR, O PROGRAMA SER� ENCAMINHADO PARA A LABEL QUE MUDA A TENS�O DE REFER�NCIA PARA A M�NIMA.
	
DESLIGA_COMPRESSOR
	BCF	GPIO, GP2 ; O PINO GP2, QUE INDICA O ESTADO DO COMPRESSOR, SER� COLOCADO EM 0, INDICANDO QUE A TEMPERATURA INSERIDA FOI MENOR QUE A TENS�O DE REFER�NCIA M�NIMA, LOGO O COMPRESSOR SER� DESLIGADO.
	GOTO	REF_MAX ; AP�S DESLIGAR O COMPRESSOR, O PROGRAMA SER� ENCAMINHADO PARA A LABEL QUE MUDA A TENS�O DE REFER�NCIA PARA A M�XIMA.
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
;CERTO