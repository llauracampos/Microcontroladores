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
		DELAY_18
		DELAY_26
		DELAY_50
		DELAY_70
		DELAY_80
		DL_18
		DL_26
		DL_50
		DL_70
		DL_80
		CONT
		BITS
		
		
		

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
	
	BCF	GPIO, GP0   ; QUANDO A PORTA � REQUISITADA, A PORTA GP0 PASSA 18MS EM N�VEL L�GICO BAIXO, PARA GARANTIR A REQUISI��O DO SINAL.
	CALL	DELAY_18MS
	BSF	GPIO, GP0   ; AP�S ESSE TEMPO, A PORTA � COLOCADA EM N�VEL L�GICO ALTO E SER� FEITA A MEDI��O DA TENS�O ANAL�GICA INSERIDA EM GP1.
	GOTO	FUN�AO_ESCRAVO
	
FUN�AO_ESCRAVO
	CALL	DESABILITA_ECONOMIA ; A ECONOMIA DE ENERGIA � DESABILITADA.
	BSF	ADCON0, 1 ; HABILITA O IN�CIO DA CONVERS�O DE TENS�O.
	
CONVERTE_TENSAO  ; LABEL UTILIZADA PARA GERAR OS CICLOS DE M�QUINAS NECESS�RIOS PARA TERMINAR A CONVERS�O
	BTFSC	ADCON0, 1   
	GOTO	CONVERTE_TENSAO ; PERMANECE NA LABEL ENQUANTO A CONVERS�O N�O � FINALIZADA.
	GOTO	FUN�AO_ESCRAVO_2 ; PASSA PARA A PR�XIMA LABEL QUANDO A CONVERS�O � FINALIZADA.
	
FUN�AO_ESCRAVO_2
	BANK1				
	MOVLW	B'00000010' ; TRANSFORMA A PORTA GP0 EM SA�DA, PARA RECEBER OS DADOS DA CONVERS�O.
	MOVWF	TRISIO
	BANK0
	BCF	GPIO, GP0   ; MANT�M A PORTA EM N�VEL L�GICO BAIXO POR 80US, INDICANDO QUE FOI DETECTADO O SINAL DE PARTIDA.
	CALL	DELAY_80US
	BSF	GPIO, GP0   ; EM SEGUIDA, MANT�M A PORTA EM N�VEL L�GICO ALTO POR 80US, PARA QUE HAJA UMA PREPARA��O PARA O ENVIO DOS DADOS.
	CALL	DELAY_80US

TRANSFERENCIA
	MOVLW	.8 ; � MOVIDO UM LITERAL 8 PARA UM CONTADOR, CHAMADO "BITS", PARA QUE TODOS OS BITS DO RESULTADO DO ADRESH SEJAM PERCORRIDOS.
	MOVWF	BITS
TRANSF
	MOVLW	.1  
	SUBWF	BITS ; � SUBTRAIDO 1 DA VARI�VEL BITS.
	BTFSC	STATUS, C
	GOTO	TESTE	; CASO A CONTAGEM AINDA N�O SEJA MENOR QUE ZERO, SER� FEITO O TESTE DE QUAL BIT SER� AVALIADO.
	GOTO	TERMINOU ; CASO SEJA MENOR QUE ZERO, SER� ENCAMINHADO PARA A LABEL DE FINALIZA��O DO PROCESSO.
	
TESTE
	MOVLW	.7  
	SUBWF	BITS, W	; CASO O CONTADOR ESTEJA EM 7,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_7	; O PROGRAMA REALIZAR� A TRANSFERENCIA DO BIT 7.
	MOVLW	.6
	SUBWF	BITS, W	; CASO O CONTADOR ESTEJA EM 6,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_6 ; O PROGRAMA REALIZAR� A TRANSFERENCIA DO BIT 6.
	MOVLW	.5
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 5,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_5 ; O PROGRAMA REALIZAR� A TRANSFERENCIA DO BIT 5.
	MOVLW	.4
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 4,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_4 ; O PROGRAMA REALIZAR� A TRANSFERENCIA DO BIT 4.
	MOVLW	.3
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 3,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_3 ; O PROGRAMA REALIZAR� A TRANSFERENCIA DO BIT 3.
	MOVLW	.2
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 2,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_2 ; O PROGRAMA REALIZAR� A TRANSFERENCIA DO BIT 2.
	MOVLW	.1
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 1,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_1 ; O PROGRAMA REALIZAR� A TRANSFERENCIA DO BIT 1.
	MOVLW	.0
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 0,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_0 ; O PROGRAMA REALIZAR� A TRANSFERENCIA DO BIT 0.
	
TRANSFERENCIA_7
	BTFSS	ADRESH, 7   ; VERIFICA SE O BIT 7 � 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
TRANSFERENCIA_6   
	BTFSS	ADRESH, 6   ; VERIFICA SE O BIT 6 � 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
TRANSFERENCIA_5
	BTFSS	ADRESH, 5   ; VERIFICA SE O BIT 5 � 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
TRANSFERENCIA_4
	BTFSS	ADRESH, 4   ; VERIFICA SE O BIT 4 � 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM

TRANSFERENCIA_3
	BTFSS	ADRESH, 3   ; VERIFICA SE O BIT 3 � 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM

TRANSFERENCIA_2
	BTFSS	ADRESH, 2   ; VERIFICA SE O BIT 2 � 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
TRANSFERENCIA_1
	BTFSS	ADRESH, 1   ; VERIFICA SE O BIT 1 � 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
TRANSFERENCIA_0
	BTFSS	ADRESH, 0   ; VERIFICA SE O BIT 0 � 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
ZERO	; CASO O BIT EM QUEST�O SEJA ZERO,
	BCF	GPIO, GP0   ; A PORTA GP0 PERMANECE EM N�VEL L�GICO BAIXO POR 50US.
	CALL	DELAY_50US
	BSF	GPIO, GP0   ; EM SEGUIDA, A PORTA GP0 PERMANECE EM N�VEL ALTO BAIXO POR 26US.
	CALL	DELAY_26US
	GOTO	TRANSF	; RETORNA PARA O LOOP DE TRANSFERENCIA, PARA VERIFICAR SE AINDA H� OUTRO BIT PARA SER TRANSFERIDO.
	
UM	; CASO O BIT EM QUEST�O SEJA UM,
	BCF	GPIO, GP0   ; A PORTA GP0 PERMANECE EM N�VEL L�GICO BAIXO POR 50US.
	CALL	DELAY_50US
	BSF	GPIO, GP0   ; EM SEGUIDA, A PORTA GP0 PERMANECE EM N�VEL ALTO BAIXO POR 70US.
	CALL	DELAY_70US
	GOTO	TRANSF	; RETORNA PARA O LOOP DE TRANSFERENCIA, PARA VERIFICAR SE AINDA H� OUTRO BIT PARA SER TRANSFERIDO.
	
TERMINOU
	BCF	GPIO, GP0   ; QUANDO A TRSNSFERENCIA � FINALIZADA, A PORTA GP0 PASSA 50US EM N�VEL L�GICO BAIXO, PARA CONFIRMAR QUE A TRSNSMISS�O ACABOU.
	CALL	DELAY_50US
	BSF	GPIO, GP0   ; EM SEGUIDA, A PORTA � MANDADA PARA N�VEL L�GICO ALTO.
	BANK1				
	MOVLW	B'00000011' ; A PORTA GP0 VOLTA A SER DEFINIDA COMO UMA ENTRADA.
	MOVWF	TRISIO
	BANK0	; � HABILITADA NOVAMENTE A ECONOMIA DE ENERGIA.
	MOVLW	B'00000000'
	MOVWF	ADCON0	; DESABILITA A CONVERS�O.
	MOVLW	B'00000000'
	MOVWF	CMCON	; DESABILITA O COMPARADOR.
	BCF	INTCON, GPIF ; TAMB�M � LIMPA A FLAG DE INTERRUP��O PELAS PORTAS, PARA QUE POSSA SER GERADA UMA NOVA INTERRUP��O.
	BCF	INTCON, GPIE
	GOTO	SAI_INT	; � ENCAMINHADO PARA A SA�DA DA INTERRUP��O.

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

;********************************************************************************
;* LABEL QUE REPRESENTA O DELAY DE 18MS (18000US). O LOOP RERALIZA UMA CONTA    *
;* APROXIMADA DESSE VALOR. O LABEL DO DELAY CONSISTE EM UM LOOP PARA A CONTAGEM *
;* DO VALOR 248 E OUTRO LOOP QUE FAZ ESSE ANTERIOR SER REPETIDO 251 VEZES (ANTES* 
;* DA REPETI��O A VARI�VEL QUE GUARDA O VALOR 248 � REINICIADA). AS REPETI��ES  *
;* S�O FEITAS POR MEIO DE SUCESSIVAS SUBTRA��ES PARA A CONTAGEM. AS REPETI��ES	*
;* DOS LOOPS MULTIPLICADAS PELAS INSTRU��ES PRESENTES EM CADA UM DELES, RESULTA *
;* EM 180377US.	                                                                *
;********************************************************************************	

DELAY_18MS 			
	MOVLW	.184
	MOVWF	DL_18 
D_18
	MOVLW	.18
	MOVWF	DELAY_18
PRE_18
	MOVLW	.1  
	SUBWF	DELAY_18
	BTFSS	STATUS, Z
	GOTO	PRE_18
	GOTO	POS_18
POS_18
	MOVLW	.1  
	SUBWF	DL_18
	BTFSS	STATUS, Z
	GOTO	D_18
	RETURN
	
;********************************************************************************
;* LABEL QUE REPRESENTA O DELAY DE 26. O LOOP RERALIZA UMA CONTA APROXIMADA DES-*
;* SE VALOR. O LABEL DO DELAY CONSISTE EM UM LOOP PARA A CONTAGEM DO VALOR 4,   * 
;* QUE CONTA AS REPETI��ES DAS INSTRU��ES CITADAS. CONSIDERNADO A CHAMADA DA    *
;* FUN��O E SUA EXECU��O, � RESULTANTE UM DELAY DE 25US.                        *
;********************************************************************************
	
DELAY_26US 			
	MOVLW	.4
	MOVWF	DELAY_26
PRE_26
	MOVLW	.1  
	SUBWF	DELAY_26
	BTFSS	STATUS, Z
	GOTO	PRE_26
	RETURN

;********************************************************************************
;* LABEL QUE REPRESENTA O DELAY DE 50. O LOOP RERALIZA UMA CONTA APROXIMADA DES-*
;* SE VALOR. O LABEL DO DELAY CONSISTE EM UM LOOP PARA A CONTAGEM DO VALOR 9,   * 
;* QUE CONTA AS REPETI��ES DAS INSTRU��ES CITADAS. CONSIDERNADO A CHAMADA DA    *
;* FUN��O E SUA EXECU��O, � RESULTANTE UM DELAY DE 50US.                        *
;********************************************************************************	
	
DELAY_50US 			
	MOVLW	.9
	MOVWF	DELAY_50
PRE_50
	MOVLW	.1  
	SUBWF	DELAY_50
	BTFSS	STATUS, Z
	GOTO	PRE_50
	RETURN

;********************************************************************************
;* LABEL QUE REPRESENTA O DELAY DE 70. O LOOP RERALIZA UMA CONTA APROXIMADA DES-*
;* SE VALOR. O LABEL DO DELAY CONSISTE EM UM LOOP PARA A CONTAGEM DO VALOR 13,  * 
;* QUE CONTA AS REPETI��ES DAS INSTRU��ES CITADAS. CONSIDERNADO A CHAMADA DA    *
;* FUN��O E SUA EXECU��O, � RESULTANTE UM DELAY DE 70US.                        *
;********************************************************************************	
	
DELAY_70US 			
	MOVLW	.13
	MOVWF	DELAY_70
PRE_70
	MOVLW	.1  
	SUBWF	DELAY_70
	BTFSS	STATUS, Z
	GOTO	PRE_70
	RETURN
	
;********************************************************************************
;* LABEL QUE REPRESENTA O DELAY DE 80. O LOOP RERALIZA UMA CONTA APROXIMADA DES-*
;* SE VALOR. O LABEL DO DELAY CONSISTE EM UM LOOP PARA A CONTAGEM DO VALOR 15,  * 
;* QUE CONTA AS REPETI��ES DAS INSTRU��ES CITADAS. CONSIDERNADO A CHAMADA DA    *
;* FUN��O E SUA EXECU��O, � RESULTANTE UM DELAY DE 80US.                        *
;********************************************************************************	
	
DELAY_80US 			
	MOVLW	.15
	MOVWF	DELAY_80
PRE_80
	MOVLW	.1  
	SUBWF	DELAY_80
	BTFSS	STATUS, Z
	GOTO	PRE_80
	RETURN
	
DESABILITA_ECONOMIA		
	BANK0
	MOVLW	B'00000101'
	MOVWF	ADCON0
	MOVLW	B'00000111'
	MOVWF	CMCON
	RETURN
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				
	MOVLW	B'00000011' 
	MOVWF	TRISIO		
	MOVLW	B'00010010'
	MOVWF	ANSEL
	MOVLW	B'00000011'
	MOVWF	OPTION_REG	
	MOVLW	B'10001000'
	MOVWF	INTCON	
	MOVLW	B'00000001'
	MOVWF	IOC
	BANK0
	MOVLW	B'00000101'
	MOVWF	ADCON0
	MOVLW	B'00000111'
	MOVWF	CMCON

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
; GP0 = PORTA TRANSMISSORA DE DADOS
; GP1 = ENTRADA DA TENS�O ANAL�GICA

HABILITA_ECONOMIA	; S�O DESLIGADAS ALGUMAS FUN��ES DO PROGRAMA, PARA A ECONOMIA DE ENERGIA PELA PRIMEIRA VEZ.
	BANK0
	MOVLW	B'00000000' ; DESABILITA A CONVERS�O.
	MOVWF	ADCON0
	MOVLW	B'00000000' ; DESABILITA O COMPARADOR.
	MOVWF	CMCON
	
MAIN
	NOP ; O PROGRAMA FICAR� EM LOOP NA MAIN, AGUARDANDO UMA REQUISI��O PARA EFETUAR A TRANSFERENCIA DE DADSO.
	GOTO	MAIN	; NESTE CASO, A REQUISI��O SE D� POR UMA TROCA DE PORTA DO PINO GP0.
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END