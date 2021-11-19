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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_ON & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		PRESS
		TEMP
		TENSAO
		
		

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
	MOVLW	B'00000001' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00000001'
	MOVWF	ANSEL 
	MOVLW	B'00001111'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW   B'00000001'
	MOVWF	ADCON0
	MOVLW	B'00000000'
	MOVWF	CMCON

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

; OS LIMITES DE TENSÃO ADOTADOS PARA A ATIVIDADE FORAM 0V E 5V.
	
DESLIGA ; LABEL QUE DESABILITA AS FUNÇÕES DOS REGISTRADORES PARA UM MENOR CONSUMO DE ENERGIA.
	BANK1				
	MOVLW	B'00000000' 
	MOVWF	TRISIO	; DESABILITA TODAS AS PORTAS COMO ENTRADA.	
	MOVLW	B'00000000'
	MOVWF	ANSEL ; DESABILITA AS ENTRADAS ANALÓGICAS.
	BANK0
	MOVLW   B'00000000' ; DESABILITA A CONVERSÃO.
	MOVWF	ADCON0
	
DORME	; LABEL QUE DESLIGARÁ TODOS OS LEDS E ADORMECERÁ O MICROCONTROLADOR NO COMEÇO DO PROGRAMA E APÓS CADA VERIFICAÇÃO.
	BCF	GPIO, GP1   ; DESLIGA O LED GP1.
	BCF	GPIO, GP2   ; DESLIGA O LED GP2.
	BCF	GPIO, GP4   ; DESLIGA O LED GP4.
	BCF	GPIO, GP5   ; DESLIGA O LED GP5.
    	SLEEP	; ADORMECE O MICROCONTROLADOR POR 2S.
	NOP ; FUNÇÃO ADOTADA PARA MELHOR VISUALIZAÇÃO DO TEMPO ADORMECIDO NO STOPWATCH;
	
LIGA	; LABEL QUE HABILITA AS FUNÇÕES DOS REGISTRADORES APÓS O MICROCONTROLADOR "ACORDAR".
	BANK1				
	MOVLW	B'00000001' 
	MOVWF	TRISIO	; HABILITA O GP0 COMO ENTRADA.		
	MOVLW	B'00000001' 
	MOVWF	ANSEL	; HABILITA A ENTRADA ANALÓGICA.
	BANK0
	MOVLW   B'00000001'
	MOVWF	ADCON0	; HABILITA A CONVERSÃO.
	

; COMO O WDT TEM UM PERÍODO DE TEMPO NOMINAL DE 18 MS, FOI ADICIONADO UM PRE-SCALER DE 1:128,
; PARA QUE A CONTAGEM NO MODO SLEEP SEJA DE 2S (2,20S APROXIMADAMENTE), COMO PEDE A ESPECIFICAÇÃO.
	
MAIN
	BSF	ADCON0, 1 ; HABILITA O INÍCIO DA CONVERSÃO DE TENSÃO.
	
CONVERTE_TENSAO  ; LABEL UTILIZADA PARA GERAR OS CICLOS DE MÁQUINAS NECESSÁRIOS PARA TERMINAR A CONVERSÃO
	BTFSC	ADCON0, 1   
	GOTO	CONVERTE_TENSAO ; PERMANECE NA LABEL ENQUANTO A CONVERSÃO NÃO É FINALIZADA.
	GOTO	COMPARA_MENOR_2	; PASSA PARA A PRÓXIMA LABEL QUANDO A CONVERSÃO É FINALIZADA.

COMPARA_MENOR_2	; COMPARA SE O VALOR DE TENSÃO INSERIDO EM GP0 É MENOR QUE 2V.
	MOVF	ADRESH, W   ; COLOCA O VALOR DA TENSÃO OBTIDO NA CONVERSÃO NO WORK.
	MOVWF	TENSAO	; GUARDA NA VARIÁVEL TENSAO.
	MOVLW	.102	; SUBTRAI 102 (VALOR DE 2V CONVERTIDO) DA TENSÃO OBTIDA NO GP0.
	SUBWF	TENSAO, W
	BTFSC	STATUS, C  ; VERIFICA SE A TENSÃO É MENOR OU MAIOR QUE A REFERÊNCIA (2V).
	GOTO	COMPARA_MENOR_3	; SE A TENSÃO FOR MAIOR QUE 2V, SERÁ REALIZADO O PRÓXIMO TESTE (SE É MENOR QUE 3V).
	GOTO	LIGA_GP1    ; SE A TENSÃO FOR MENOR QUE 2V, SERÁ ENCAMINHADO PARA A LABEL QUE LIGA O LED GP1.

COMPARA_MENOR_3 ; COMPARA SE O VALOR DE TENSÃO INSERIDO EM GP0 É MENOR QUE 3V.
	MOVF	ADRESH, W   ; COLOCA O VALOR DA TENSÃO OBTIDO NA CONVERSÃO NO WORK.
	MOVWF	TENSAO	; GUARDA NA VARIÁVEL TENSAO.
	MOVLW	.153	; SUBTRAI 153 (VALOR DE 3V CONVERTIDO) DA TENSÃO OBTIDA NO GP0.
	SUBWF	TENSAO, W
	BTFSC	STATUS, C   ; VERIFICA SE A TENSÃO É MENOR OU MAIOR QUE A REFERÊNCIA (3V).
	GOTO	COMPARA_MENOR_4	; SE A TENSÃO FOR MAIOR QUE 3V, SERÁ REALIZADO O PRÓXIMO TESTE (SE É MENOR QUE 4V).
	GOTO	LIGA_GP2    ; SE A TENSÃO FOR MENOR QUE 3V, SERÁ ENCAMINHADO PARA A LABEL QUE LIGA O LED GP2.

COMPARA_MENOR_4	; COMPARA SE O VALOR DE TENSÃO INSERIDO EM GP0 É MENOR QUE 4V.
	MOVF	ADRESH, W   ; COLOCA O VALOR DA TENSÃO OBTIDO NA CONVERSÃO NO WORK.
	MOVWF	TENSAO	; GUARDA NA VARIÁVEL TENSAO.
	MOVLW	.204	; SUBTRAI 204 (VALOR DE 4V CONVERTIDO) DA TENSÃO OBTIDA NO GP0.
	SUBWF	TENSAO, W
	BTFSC	STATUS, C   ; VERIFICA SE A TENSÃO É MENOR OU MAIOR QUE A REFERÊNCIA (4V).
	GOTO	LIGA_GP5    ; SE A TENSÃO FOR MAIOR QUE 4V, SERÁ ENCAMINHADO PARA A LABEL QUE LIGA O LED GP5.
	GOTO	LIGA_GP4    ; SE A TENSÃO FOR MENOR QUE 4V, SERÁ ENCAMINHADO PARA A LABEL QUE LIGA O LED GP4.

LIGA_GP1
	BSF	GPIO, GP1 ; LIGA O LED GP1.
	GOTO	DESLIGA	; ENCAMINHA O PROGRAMA PARA A LABEL QUE DESABILITA AS FUNÇÕES DOS REGISTRADORES PARA POUPAR ENERGIA E EM SEGUIDA PARA A LABEL QUE DESLIGA OS LEDS E ADORMECE O MICROCONTROLADOR.
	
LIGA_GP2
	BSF	GPIO, GP2   ; LIGA O LED GP2.
	GOTO	DESLIGA	; ENCAMINHA O PROGRAMA PARA A LABEL QUE DESABILITA AS FUNÇÕES DOS REGISTRADORES PARA POUPAR ENERGIA E EM SEGUIDA PARA A LABEL QUE DESLIGA OS LEDS E ADORMECE O MICROCONTROLADOR.

LIGA_GP4
	BSF	GPIO, GP4   ; LIGA O LED GP4.
	GOTO	DESLIGA	; ENCAMINHA O PROGRAMA PARA A LABEL QUE DESABILITA AS FUNÇÕES DOS REGISTRADORES PARA POUPAR ENERGIA E EM SEGUIDA PARA A LABEL QUE DESLIGA OS LEDS E ADORMECE O MICROCONTROLADOR.
	
LIGA_GP5
	BSF	GPIO, GP5 ; LIGA O LED GP5.
	GOTO	DESLIGA	; ENCAMINHA O PROGRAMA PARA A LABEL QUE DESABILITA AS FUNÇÕES DOS REGISTRADORES PARA POUPAR ENERGIA E EM SEGUIDA PARA A LABEL QUE DESLIGA OS LEDS E ADORMECE O MICROCONTROLADOR.

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	END
