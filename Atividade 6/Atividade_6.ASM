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

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000010' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00010010'	
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'10101101'
	MOVWF	VRCON	
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00010100'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
;********************************************************************************
;* OS DADOS REFERENTES À ATIVIDADE SÃO:                                         *
;*                                                                              *
;* TEMPERATURA MÍNIMA = 24 E TEMPERATURA MÁXIMA = 29                            *
;*                                                                              *
;* DESSE MODO, DE ACORDO COM A FÓRMULA INDICADA NO PDF, AS TENSÕES MÍNIMA E MÁ- *
;* XIMA SÃO 1,44V E 2,865V, RESPECTIVAMENTE.                                    *
;*                                                                              *
;* DE ACORDO COM OS CÁCULOS PARA IDENTIFICAR SE O VRR SERIA SETADO PARA LOW RAN-*
;* GE OU HIGH RANGE FORAM ENCONTRADOS OS SEGUINTES RESULTADOS PARA A TENSÃO DE  *
;* REFERÊNCIA:                                                                  *
;*                                                                              *
;* CVREF(TENSÃO MÍNIMA) -> HIGH RANGE = 1.40625, PARA UM VALOR DE VR = 1        *
;* CVREF(TENSÃO MÍNIMA) -> LOW RANGE = 1.45833, PARA UM VALOR DE VR = 7         *
;* COMO A DIFERENÇA ENTRE A TENSÃO MÍNIMA CALCULADA E A TENSÃO RESULTANTE NO    *
;* LOW RANGE FOI MENOR, ELE FOI ADOTADO, ASSIM COMO O VALOR 7 PARA O VR.         *
;*                                                                              *
;* CVREF(TENSÃO MÁXIMA) -> HIGH RANGE = 2.8125, PARA UM VALOR DE VR = 10        *
;* CVREF(TENSÃO MÁXIMA) -> LOW RANGE = 2.8650, PARA UM VALOR DE VR = 13         *
;* COMO A DIFERENÇA ENTRE A TENSÃO MÁXIMA CALCULADA E A TENSÃO RESULTANTE NO    *
;* LOW RANGE FOI MENOR, ELE FOI ADOTADO, ASSIM COMO O VALOR 13 PARA O VR.        *
;********************************************************************************

	
;********************************************************************************	
;* A LABEL "MANTEM_MAXIMA", TEM COMO OBJETIVO VERIFICAR SE A TENSÃO INSERIDA EM *
;* UM NOVO ESTÍMULO FOI MAIOR QUE A TENSÃO DE REFERÊNCIA, QUANDO A REFERÊNCIA É * 
;* A TEMPERATURA MÁXIMA.                                                        *
;********************************************************************************
	
MANTEM_MAXIMA 
	BTFSS	CMCON, COUT ; TESTA SE O BIT COUT, OU SEJA, A SAIDA DO COMPARADOR ESTÁ EM 1. COMO A SAÍDA FOI CONFIGURADA COMO INVERSORA, QUANDO ESTA MUDA PARA 1 INDICA QUE A TENSÃO INSERIDA É MAIOR QUE A TENSÃO DE REFERÊNCIA.
	GOTO	MANTEM_MAXIMA ; CASO A TENSÃO INSERIDA NÃO SEJA MAIOR QUE A DE REFERÊNCIA, O PROGRAMA RETORNARÁ PARA A LABEL.
	GOTO	LIGA_COMPRESSOR ; CASO A TENSÃO INSERIDA SEJA MAIOR QUE A DE REFERÊNCIA, O PROGRAMA SERÁ ENCAMINHADO PARA A LABEL DE LIGAR O COMPRESSOR.

;********************************************************************************	
;* A LABEL "MANTEM_MINIMA", TEM COMO OBJETIVO VERIFICAR SE A TENSÃO INSERIDA EM *
;* UM NOVO ESTÍMULO FOI MENOR QUE A TENSÃO DE REFERÊNCIA, QUANDO A REFERÊNCIA É * 
;* A TEMPERATURA MÍNIMA.                                                        *
;********************************************************************************	
	
MANTEM_MINIMA
	BTFSS	CMCON, COUT ; TESTA SE O BIT COUT, OU SEJA, A SAIDA DO COMPARADOR CONTINUA EM 1. COMO A SAÍDA FOI CONFIGURADA COMO INVERSORA, QUANDO ESTA MUDA PARA 0 INDICA QUE A TENSÃO INSERIDA É MENOR QUE A TENSÃO DE REFERÊNCIA.
	GOTO	DESLIGA_COMPRESSOR ; CASO A TENSÃO INSERIDA SEJA MAIOR QUE A DE REFERÊNCIA, O PROGRAMA RETORNARÁ PARA A LABEL.	
	GOTO	MANTEM_MINIMA ; CASO A TENSÃO INSERIDA SEJA MENOR QUE A DE REFERÊNCIA, O PROGRAMA SERÁ ENCAMINHADO PARA A LABEL DE DESLIGAR O COMPRESSOR.

;********************************************************************************	
;* A LABEL "REF_MAX", TEM COMO OBJETIVO MUDAR A TENSÃO DE REFERÊNCIA DO COMPARA-*
;* DOR. COMO ANTERIORMENTE A TENSÃO DE REFEÊNCIA ERA A MÍNIMA, E FOI IDENTIFICA-*
;* DA UMA TENSÃO DE ENTRADA MENOR, O COMPRESSOR É DESLIGADO E A NOVA TENSÃO DE  *
;* REFERÊNCIA É A MÁXIMA.                                                       *
;********************************************************************************	
	
REF_MAX
	BANK1 
	MOVLW	B'10101101' ; É MOVIDO O VALOR 13 PARA VR, REFERÊNTE À TENSÃO MÁXIMA (DE ACORDO COM A TEMPERATURA MÁXIMA).
	MOVWF	VRCON
	BANK0
	GOTO	MANTEM_MAXIMA ; APÓS ALTERAR O VALOR DE VR NO REGISTRADOR VRCON, É ENCAMINHADO PARA A LABEL QUE VERIFICA SE A TENSÃO INSERIDA É MAIOR QUE A DE REFERÊNCIA.

;********************************************************************************	
;* A LABEL "REF_MIN", TEM COMO OBJETIVO MUDAR A TENSÃO DE REFERÊNCIA DO COMPARA-*
;* DOR. COMO ANTERIORMENTE A TENSÃO DE REFEÊNCIA ERA A MÁXIMA, E FOI IDENTIFICA-*
;* DA UMA TENSÃO DE ENTRADA MAIOR, O COMPRESSOR É LIGADO E A NOVA TENSÃO DE     *
;* REFERÊNCIA É A MÍNIMA.                                                       *
;********************************************************************************
	
REF_MIN
	BANK1
	MOVLW	B'10100111' ; É MOVIDO O VALOR 7 PARA VR, REFERÊNTE À TENSÃO MÍNIMA (DE ACORDO COM A TEMPERATURA MÍNIMA).
	MOVWF	VRCON
	BANK0
	GOTO	MANTEM_MINIMA ; APÓS ALTERAR O VALOR DE VR NO REGISTRADOR VRCON, É ENCAMINHADO PARA A LABEL QUE VERIFICA SE A TENSÃO INSERIDA É MENOR QUE A DE REFERÊNCIA.

LIGA_COMPRESSOR
	BSF	GPIO, GP2 ; O PINO GP2, QUE INDICA O ESTADO DO COMPRESSOR, SERÁ COLOCADO EM 1, INDICANDO QUE A TEMPERATURA INSERIDA EXCEDEU A TENSÃO DE REFERÊNCIA MÁXIMA, LOGO O COMPRESSOR SERÁ LIGADO.
	GOTO	REF_MIN ; APÓS LIGAR O COMPRESSOR, O PROGRAMA SERÁ ENCAMINHADO PARA A LABEL QUE MUDA A TENSÃO DE REFERÊNCIA PARA A MÍNIMA.
	
DESLIGA_COMPRESSOR
	BCF	GPIO, GP2 ; O PINO GP2, QUE INDICA O ESTADO DO COMPRESSOR, SERÁ COLOCADO EM 0, INDICANDO QUE A TEMPERATURA INSERIDA FOI MENOR QUE A TENSÃO DE REFERÊNCIA MÍNIMA, LOGO O COMPRESSOR SERÁ DESLIGADO.
	GOTO	REF_MAX ; APÓS DESLIGAR O COMPRESSOR, O PROGRAMA SERÁ ENCAMINHADO PARA A LABEL QUE MUDA A TENSÃO DE REFERÊNCIA PARA A MÁXIMA.
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
;CERTO