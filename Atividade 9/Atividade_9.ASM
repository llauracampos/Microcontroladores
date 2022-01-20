;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      MARÇO DE 2021                              *
;*                 BASEADO NO EXEMPLO DO LIVRO                     *
;*           Desbravando o PIC. David José de Souza                *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
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
		
		
		

		;COLOQUE AQUI SUAS NOVAS VARIÁVEIS
		;NÃO ESQUEÇA COMENTÁRIOS ESCLARECEDORES

	ENDC			;FIM DO BLOCO DE DEFINIÇÃO DE VARIÁVEIS

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES
	
	BCF	GPIO, GP0   ; QUANDO A PORTA É REQUISITADA, A PORTA GP0 PASSA 18MS EM NÍVEL LÓGICO BAIXO, PARA GARANTIR A REQUISIÇÃO DO SINAL.
	CALL	DELAY_18MS
	BSF	GPIO, GP0   ; APÓS ESSE TEMPO, A PORTA É COLOCADA EM NÍVEL LÓGICO ALTO E SERÁ FEITA A MEDIÇÃO DA TENSÃO ANALÓGICA INSERIDA EM GP1.
	GOTO	FUNÇAO_ESCRAVO
	
FUNÇAO_ESCRAVO
	CALL	DESABILITA_ECONOMIA ; A ECONOMIA DE ENERGIA É DESABILITADA.
	BSF	ADCON0, 1 ; HABILITA O INÍCIO DA CONVERSÃO DE TENSÃO.
	
CONVERTE_TENSAO  ; LABEL UTILIZADA PARA GERAR OS CICLOS DE MÁQUINAS NECESSÁRIOS PARA TERMINAR A CONVERSÃO
	BTFSC	ADCON0, 1   
	GOTO	CONVERTE_TENSAO ; PERMANECE NA LABEL ENQUANTO A CONVERSÃO NÃO É FINALIZADA.
	GOTO	FUNÇAO_ESCRAVO_2 ; PASSA PARA A PRÓXIMA LABEL QUANDO A CONVERSÃO É FINALIZADA.
	
FUNÇAO_ESCRAVO_2
	BANK1				
	MOVLW	B'00000010' ; TRANSFORMA A PORTA GP0 EM SAÍDA, PARA RECEBER OS DADOS DA CONVERSÃO.
	MOVWF	TRISIO
	BANK0
	BCF	GPIO, GP0   ; MANTÉM A PORTA EM NÍVEL LÓGICO BAIXO POR 80US, INDICANDO QUE FOI DETECTADO O SINAL DE PARTIDA.
	CALL	DELAY_80US
	BSF	GPIO, GP0   ; EM SEGUIDA, MANTÉM A PORTA EM NÍVEL LÓGICO ALTO POR 80US, PARA QUE HAJA UMA PREPARAÇÃO PARA O ENVIO DOS DADOS.
	CALL	DELAY_80US

TRANSFERENCIA
	MOVLW	.8 ; É MOVIDO UM LITERAL 8 PARA UM CONTADOR, CHAMADO "BITS", PARA QUE TODOS OS BITS DO RESULTADO DO ADRESH SEJAM PERCORRIDOS.
	MOVWF	BITS
TRANSF
	MOVLW	.1  
	SUBWF	BITS ; É SUBTRAIDO 1 DA VARIÁVEL BITS.
	BTFSC	STATUS, C
	GOTO	TESTE	; CASO A CONTAGEM AINDA NÃO SEJA MENOR QUE ZERO, SERÁ FEITO O TESTE DE QUAL BIT SERÁ AVALIADO.
	GOTO	TERMINOU ; CASO SEJA MENOR QUE ZERO, SERÁ ENCAMINHADO PARA A LABEL DE FINALIZAÇÃO DO PROCESSO.
	
TESTE
	MOVLW	.7  
	SUBWF	BITS, W	; CASO O CONTADOR ESTEJA EM 7,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_7	; O PROGRAMA REALIZARÁ A TRANSFERENCIA DO BIT 7.
	MOVLW	.6
	SUBWF	BITS, W	; CASO O CONTADOR ESTEJA EM 6,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_6 ; O PROGRAMA REALIZARÁ A TRANSFERENCIA DO BIT 6.
	MOVLW	.5
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 5,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_5 ; O PROGRAMA REALIZARÁ A TRANSFERENCIA DO BIT 5.
	MOVLW	.4
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 4,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_4 ; O PROGRAMA REALIZARÁ A TRANSFERENCIA DO BIT 4.
	MOVLW	.3
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 3,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_3 ; O PROGRAMA REALIZARÁ A TRANSFERENCIA DO BIT 3.
	MOVLW	.2
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 2,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_2 ; O PROGRAMA REALIZARÁ A TRANSFERENCIA DO BIT 2.
	MOVLW	.1
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 1,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_1 ; O PROGRAMA REALIZARÁ A TRANSFERENCIA DO BIT 1.
	MOVLW	.0
	SUBWF	BITS, W ; CASO O CONTADOR ESTEJA EM 0,
	BTFSC	STATUS, Z
	GOTO	TRANSFERENCIA_0 ; O PROGRAMA REALIZARÁ A TRANSFERENCIA DO BIT 0.
	
TRANSFERENCIA_7
	BTFSS	ADRESH, 7   ; VERIFICA SE O BIT 7 É 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
TRANSFERENCIA_6   
	BTFSS	ADRESH, 6   ; VERIFICA SE O BIT 6 É 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
TRANSFERENCIA_5
	BTFSS	ADRESH, 5   ; VERIFICA SE O BIT 5 É 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
TRANSFERENCIA_4
	BTFSS	ADRESH, 4   ; VERIFICA SE O BIT 4 É 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM

TRANSFERENCIA_3
	BTFSS	ADRESH, 3   ; VERIFICA SE O BIT 3 É 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM

TRANSFERENCIA_2
	BTFSS	ADRESH, 2   ; VERIFICA SE O BIT 2 É 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
TRANSFERENCIA_1
	BTFSS	ADRESH, 1   ; VERIFICA SE O BIT 1 É 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
TRANSFERENCIA_0
	BTFSS	ADRESH, 0   ; VERIFICA SE O BIT 0 É 1 OU 0 E ENCAMINHA PARA A LABEL QUE FAZ O TRATAMENTO PARA CADA CASO.
	GOTO	ZERO
	GOTO	UM
	
ZERO	; CASO O BIT EM QUESTÃO SEJA ZERO,
	BCF	GPIO, GP0   ; A PORTA GP0 PERMANECE EM NÍVEL LÓGICO BAIXO POR 50US.
	CALL	DELAY_50US
	BSF	GPIO, GP0   ; EM SEGUIDA, A PORTA GP0 PERMANECE EM NÍVEL ALTO BAIXO POR 26US.
	CALL	DELAY_26US
	GOTO	TRANSF	; RETORNA PARA O LOOP DE TRANSFERENCIA, PARA VERIFICAR SE AINDA HÁ OUTRO BIT PARA SER TRANSFERIDO.
	
UM	; CASO O BIT EM QUESTÃO SEJA UM,
	BCF	GPIO, GP0   ; A PORTA GP0 PERMANECE EM NÍVEL LÓGICO BAIXO POR 50US.
	CALL	DELAY_50US
	BSF	GPIO, GP0   ; EM SEGUIDA, A PORTA GP0 PERMANECE EM NÍVEL ALTO BAIXO POR 70US.
	CALL	DELAY_70US
	GOTO	TRANSF	; RETORNA PARA O LOOP DE TRANSFERENCIA, PARA VERIFICAR SE AINDA HÁ OUTRO BIT PARA SER TRANSFERIDO.
	
TERMINOU
	BCF	GPIO, GP0   ; QUANDO A TRSNSFERENCIA É FINALIZADA, A PORTA GP0 PASSA 50US EM NÍVEL LÓGICO BAIXO, PARA CONFIRMAR QUE A TRSNSMISSÃO ACABOU.
	CALL	DELAY_50US
	BSF	GPIO, GP0   ; EM SEGUIDA, A PORTA É MANDADA PARA NÍVEL LÓGICO ALTO.
	BANK1				
	MOVLW	B'00000011' ; A PORTA GP0 VOLTA A SER DEFINIDA COMO UMA ENTRADA.
	MOVWF	TRISIO
	BANK0	; É HABILITADA NOVAMENTE A ECONOMIA DE ENERGIA.
	MOVLW	B'00000000'
	MOVWF	ADCON0	; DESABILITA A CONVERSÃO.
	MOVLW	B'00000000'
	MOVWF	CMCON	; DESABILITA O COMPARADOR.
	BCF	INTCON, GPIF ; TAMBÉM É LIMPA A FLAG DE INTERRUPÇÃO PELAS PORTAS, PARA QUE POSSA SER GERADA UMA NOVA INTERRUPÇÃO.
	BCF	INTCON, GPIE
	GOTO	SAI_INT	; É ENCAMINHADO PARA A SAÍDA DA INTERRUPÇÃO.

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

;********************************************************************************
;* LABEL QUE REPRESENTA O DELAY DE 18MS (18000US). O LOOP RERALIZA UMA CONTA    *
;* APROXIMADA DESSE VALOR. O LABEL DO DELAY CONSISTE EM UM LOOP PARA A CONTAGEM *
;* DO VALOR 248 E OUTRO LOOP QUE FAZ ESSE ANTERIOR SER REPETIDO 251 VEZES (ANTES* 
;* DA REPETIÇÃO A VARIÁVEL QUE GUARDA O VALOR 248 É REINICIADA). AS REPETIÇÕES  *
;* SÃO FEITAS POR MEIO DE SUCESSIVAS SUBTRAÇÕES PARA A CONTAGEM. AS REPETIÇÕES	*
;* DOS LOOPS MULTIPLICADAS PELAS INSTRUÇÕES PRESENTES EM CADA UM DELES, RESULTA *
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
;* QUE CONTA AS REPETIÇÕES DAS INSTRUÇÕES CITADAS. CONSIDERNADO A CHAMADA DA    *
;* FUNÇÃO E SUA EXECUÇÃO, É RESULTANTE UM DELAY DE 25US.                        *
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
;* QUE CONTA AS REPETIÇÕES DAS INSTRUÇÕES CITADAS. CONSIDERNADO A CHAMADA DA    *
;* FUNÇÃO E SUA EXECUÇÃO, É RESULTANTE UM DELAY DE 50US.                        *
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
;* QUE CONTA AS REPETIÇÕES DAS INSTRUÇÕES CITADAS. CONSIDERNADO A CHAMADA DA    *
;* FUNÇÃO E SUA EXECUÇÃO, É RESULTANTE UM DELAY DE 70US.                        *
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
;* QUE CONTA AS REPETIÇÕES DAS INSTRUÇÕES CITADAS. CONSIDERNADO A CHAMADA DA    *
;* FUNÇÃO E SUA EXECUÇÃO, É RESULTANTE UM DELAY DE 80US.                        *
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
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
; GP0 = PORTA TRANSMISSORA DE DADOS
; GP1 = ENTRADA DA TENSÃO ANALÓGICA

HABILITA_ECONOMIA	; SÃO DESLIGADAS ALGUMAS FUNÇÕES DO PROGRAMA, PARA A ECONOMIA DE ENERGIA PELA PRIMEIRA VEZ.
	BANK0
	MOVLW	B'00000000' ; DESABILITA A CONVERSÃO.
	MOVWF	ADCON0
	MOVLW	B'00000000' ; DESABILITA O COMPARADOR.
	MOVWF	CMCON
	
MAIN
	NOP ; O PROGRAMA FICARÁ EM LOOP NA MAIN, AGUARDANDO UMA REQUISIÇÃO PARA EFETUAR A TRANSFERENCIA DE DADSO.
	GOTO	MAIN	; NESTE CASO, A REQUISIÇÃO SE DÁ POR UMA TROCA DE PORTA DO PINO GP0.
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END