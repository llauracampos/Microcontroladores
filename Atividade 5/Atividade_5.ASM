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
		A1  ;NUMERADOR
		C1  ;C�PIA DE A QUE FUTURAMENTE VAI GUARDAR O VALOR DO RESTO
		C2
		C3
		C4
		B1  ;C�PIA DO VALOR DO DENOMINADOR
		D1  ;C�PIA DO VALOR DO DENOMINADOR
		X   ;RESULTADO DA PARTE INTEIRA
		Y   ;RESULTADO DA PARTE DECIMAL
		Y2  
		DECIMAL  ;RESULTADO DA MULTIPLICA��O DO RESTO POR 10
		MULTI	;RESULTADO DA MULTIPLICA��O 
		MULTI2
		ADR_TEMP
		RES1
		DELAY_1
		DELAY_2
		LIGADO
		DESLIGADO
		P_10
		FLAG
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
	
;*********************************************************************************
;* TODAS AS SUBROTINAS DESCRITAS ABAIXO, DIZEM RESPEITO � DIVIS�O COM DUAS CASAS *
;* DECIMAIS, PARA QUE SE POSSA OBTER A PORCENTAGEM DO DUTY CICLE. COMO A PORCEN- *
;* TAGEM PODE SER DESCRITA COMO (X/Y) * 100, NESTA SE��O FOI FEITA A DIVIS�O DO  *
;* VALOR DIGITAL DA TENS�O CONVERTIDA, POR 255, QUE REPRESENTA O VALOR M�XIMO DE *
;* TENS�O. A PARTE DECIMAL DESSE RESULTADO FOI GUARDADA EM UMA VAIR�VEL E POSTE- *
;* RIORMENTE MULTIPLICADA POR 10, RESULTANDO NO VALOR DA PORCENTAGEM.            *
;*********************************************************************************
	

RESULTADO_DECIMAL   ;DIVIDE O RESTO DA PRIMEIRA DIVIS�O POR 25
	MOVLW	.25  ;COLOCA UMA C�PIA DO VALOR DO DENOMINADOR DIVIDIDO POR 10, PARA QUE N�O HAJA ESTOURO NO CARRY
	SUBWF	C1	;SUBTRAI 25 DE C1, QUE � O RESTO DA DIVIS�O
	BTFSS	STATUS, C   ;TESTA SE AP�S A SUBTRA��O HOUVE UM CARRY   
	RETURN  ;SE HOUVE, RETORNA O RESULTADO
	INCF	Y   ;SOMA 1 � VARIV�VEL DO RESULTADO DECIMAL, Y
	GOTO	RESULTADO_DECIMAL

RESULTADO_DECIMAL2   ;DIVIDE O RESTULTADO DA VSEGUNDA DIVIS�O POR 3
	MOVLW	.3  
	SUBWF	C2	;SUBTRAI O VALOR DE C2, QUE � O RESTO DA SEGUNDA DIVIS�O
	BTFSS	STATUS, C   ;TESTA SE AP�S A SUBTRA��O HOUVE UM CARRY   
	RETURN	;SE HOUVE, RETORNA O RESULTADO
	INCF	Y2   ;SOMA 1 � VARIV�VEL DO RESULTADO DECIMAL, Y2, QUE ARMAZENA A SEGUNDA CASA DECIMAL
	GOTO	RESULTADO_DECIMAL2

	
MULTIPLICA  ;MULTIPLICA��O DO DENOMINADOR PELO RESULTADO DA DIVIS�O
	MOVFW B1    ;COLOCA B1 NO WORK, PARA SERVIR DE CONTADOR
	BTFSC STATUS, Z	;TESTA SE B1 � 0
	RETURN	;QUANDO B1 � 0 A FUN��O � RETORNADA
	MOVFW X	;MOVE O RESULTADO DA DIVIS�O, X, PARA O WORK
	ADDWF MULTI ;SOMA X � MULTI
	DECF B1	;DECREMENTA O CONTADOR B1
	GOTO MULTIPLICA

MULTIPLICA2  ;MULTIPLICA��O DO DENOMINADOR FRACION�RIO PELO RESULTADO DA DIVIS�O
	MOVLW B1    ;COLOCA B1 NO WORK, PARA SERVIR DE CONTADOR
	BTFSC STATUS, Z	;TESTA SE B1 � 0
	RETURN	;QUANDO B1 � 0 A FUN��O � RETORNADA
	MOVFW Y	;MOVE O RESULTADO DA DIVIS�O, Y, PARA O WORK
	ADDWF MULTI2 ;SOMA Y � MULTI2
	DECF B1	;DECREMENTA O CONTADOR B1
	GOTO MULTIPLICA2
		
DIVIDE ; INICIALMENTE � REALIZADA UMA LIMPEZA DE TODAS AS VARI�VEIS, PARA QUE N�O HAJA ERROS NAS REPETI��ES DO LA�O 
	CLRF	X   
	CLRF	Y   
	CLRF	Y2
	CLRF	DECIMAL  
	CLRF	MULTI	
	CLRF	MULTI2

DIVIDE_LOOP ;LOOP ONDE OCORRE A PRIMEIRA DIVIS�O SOLICITADA
	SUBWF	A1  ;SUBTRAI O VALOR DO DENOMINADOR, QUE EST� NO WORK, DE A1
	BTFSS	STATUS, C   ;TESTA SE AP�S A SUBTRA��O HOUVE UM CARRY
	GOTO	DIVIDE_MENOR	
	INCF	X   ;SOMA 1 � VARIV�VEL DO RESULTADO INTEIRO, X
	GOTO	DIVIDE_LOOP 

DIVIDE_MENOR
	MOVWF	B1  ;TRANSFERE O VALOR DO WORK (DENOMINADOR) PARA B1
	CALL	MULTIPLICA  ;CHAMA A FUN��O MULTIPLICA
	MOVFW	MULTI	;COLOCA O RESULTADO DA FUN��O MULTIPLICA NO WORK
	SUBWF	C1  ;SUBTRAI MULTI DE C1, RESULTANDO NO RESTO DA DIVIS�O 
	BTFSC	STATUS, Z   ;TESTA SE O RESTO � 0
	GOTO	RESULTADO_FINAL	;VAI DIRETO PARA DIVIDE_FINAL
	CALL	RESULTADO_DECIMAL   ;CHAMA A FUN��O RESULTADO_DECIMAL
	GOTO	DIVIDE_MENOR2

DIVIDE_MENOR2
	MOVLW	.25 ; ATRIBUI 25 COMO O DENOMINADOR DA SEGUNDA DIVIS�O
	MOVWF	B1  ;TRANSFERE O VALOR DO WORK (DENOMINADOR) PARA B1
	CALL	MULTIPLICA2  ;CHAMA A FUN��O MULTIPLICA2
	MOVFW	MULTI2	;COLOCA O RESULTADO DA FUN��O MULTIPLICA2 NO WORK
	SUBWF	C2  ;SUBTRAI MULTI DE C2, RESULTANDO NO RESTO DA SEGUNDA DIVIS�O
	BTFSC	STATUS, Z   ;TESTA SE O RESTO � 0
	GOTO	RESULTADO_FINAL1	;VAI DIRETO PARA DIVIDE_FINAL
	MOVFW	C2
	MOVWF	C4
	CALL	RESULTADO_DECIMAL2   ;CHAMA A FUN��O RESULTADO_DECIMAL2
	GOTO	RESULTADO_FINAL1
	
RESULTADO_FINAL ; RESULTADO PARA O CASO DA TENS�O CORRESPONDER A 100%, VISTO QUE OS DEMAIS RESULTADOS �SO CONSIDERAM AS CASAS DECIMAIS
	MOVLW	.100
	MOVWF	RES1
	RETURN
	
RESULTADO_FINAL1 
	MOVLW	.10
	MOVWF	B1
	
RES_F1 ; MULTIPLICA��O DO RESULTADO ENCONTRADO EM Y POR 10, RESULTANDO NA DEZENA DA PORCENTAGEM
	MOVFW B1    
	BTFSC STATUS, Z	
	GOTO RESULTADO_FINAL2	
	MOVFW Y	
	ADDWF RES1 
	DECF B1	
	GOTO RES_F1

RESULTADO_FINAL2 ; SOMA O RESULTADO ENCONTRADO EM Y2, RESULTANDO NA UNIDADE DA PORCENTAGEM
	MOVFW	Y2
	ADDWF	RES1
	GOTO	TESTE_FINAL

TESTE_FINAL ; CORRE��O DO CALCULO PARA VALORES FECHADOS, NECESS�RIO DEVIDO � APROXIMA��O DE 25.5 PARA 25 NA SEGUNDA DIVIS�O
	MOVLW	.5 ; A CORRE��O OCORRE PARA VALORES COM O SEGUNDO RESTO MENOR OU IGUAL A 5
	SUBWF	C4, W
	BTFSC	STATUS, C
	GOTO	ROTINA_FINAL_1
	GOTO	ROTINA_FINAL_2
	
ROTINA_FINAL_1 
	RETURN

ROTINA_FINAL_2 ; CASO O VALOR SEJA MENOR OU IGUAL A 5, � SUBTRAIDO 1 DO VALOR DA PORCENTAGEM
	MOVLW	.1
	SUBWF	RES1
	RETURN
	
	



;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				
	MOVLW	B'00010000' 
	MOVWF	TRISIO		
	MOVLW	B'00011000'
	MOVWF	ANSEL
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	
	MOVLW	B'00000000'
	MOVWF	INTCON		
	BANK0
	MOVLW	B'00001101'
	MOVWF	ADCON0
	MOVLW	B'00000111'
	MOVWF	CMCON		

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN 
	MOVLW	B'00000000' ; � ZERADO O VALOR DO BIT ADRESH DO REGISTRADOR DE MESMO NOME, PARA QUE O PROGRAMA SEMPRE INICIE 	
	MOVWF	ADRESH ; UMA NOVA CONTAGEM COM ESSA VARI�VEL ZERADA
	BSF	ADCON0, 1 ; INDICA QUE COMECAR� A OCORRER UMA NOVA CONVERS�O
	
TESTE ; LABEL UTILIZADA PARA GERAR OS CICLOS DE M�QUINAS NECESS�RIOS PARA TERMINAR A CONVERS�O
	BTFSC	ADCON0, 1
	GOTO	TESTE 	

TESTE_1 ; LABEL UTILIZADA PARA TESTAR SE A CONVERS�O FEITA � A MESMA DA ANTERIOR, PARA QUE N�O SEJA NECESS�RIO REPETIR OS CALCULOS DE PORCENTAGEM DO DUTY CICLE
	MOVF	ADRESH, W 
	SUBWF	ADR_TEMP, W ; VERIFICA SE O NOVO VALOR PRESENTE EM ADRESH � IGUAL AO ANTERIOR, ARMAZENADO EM UMA VARI�VEL TEMPOR�RIA
	BTFSS	STATUS, Z
	GOTO	CALCULO_DUTY_CICLE ; CASO N�O SEJA IGUAL, INDICA QUE � NECESS�RIO REALIZAR O CALCULO PARA O DUTY CICLE
	GOTO	TESTE_ZERO ; CASO SEJA IGUAL, VERIFICAR� SE O VALOR � 0V, 5V, OU QUALQUER OUTRA FRA��O QUE MANTER� OS LEDS PISCANDO NA FREQU�NCIA INDICADA
	
TESTE_ZERO ; TESTA SE A TENS�O INSERIDA � 0V
	MOVLW	.0 
	SUBWF	C3, W 
	BTFSS	STATUS, Z 
	GOTO	TESTE_CINCO ; CASO N�O SEJA, TESTA SE A TENS�O INSERIDA � 5V
	GOTO	LED_DESLIGADO ; CASO SEJA, � ENCAMINHADO PARA A LABEL DE MANTER O LED DESLIGADO

TESTE_CINCO ; TESTA SE A TENS�O INSERIDA � 5V
	MOVLW	.255 
	SUBWF	C3, W 
	BTFSS	STATUS, Z 
	GOTO	LED_LIGA ; CASO N�O SEJA, COMO J� FOI CONFIRMADO QUE A TENS�O INSERIDA CONTINUA SENDO IGUAL A ANTERIOR, � ENCAMINHADO DIRETO PARA A LABEL DE LIGAR O LED, N�O SENDO NECESS�RIO REPETIR OS C�LCULOS
	GOTO	LED_LIGADO ; CASO SEJA, � ENCAMINHADO PARA A LABEL DE MANTER O LED LIGADO

CALCULO_DUTY_CICLE ; LABEL QUE ENCAMINHA OS VALORES OBTIDOS NA CONVERS�O DA TENS�O PARA A ROTINA QUE CALCULAR� O VALOR DO DUTY CICLE
	BCF	GPIO, GP0 ; A TODO COME�O DE UMA NOVA TENS�O, O LED GP0 � DESLIGADO
	CLRF	RES1 ; � LIMPA A VARI�VEL QUE GURADAR� O VALOR DA PORCENTAGEM DO DUTY CICLE
	MOVF	ADRESH, W
	MOVWF	A1  ;GUARDA VALOR DO NUMERADOR 
	MOVWF	C1  ;C�PIA DE A1
	MOVWF	C2  ;C�PIA DE A1
	MOVWF	C3  ;C�PIA DE A1
	MOVLW	.255 ;VALOR DO DENOMINADOR 
	CALL	DIVIDE	;CHAMA A ROTINA DE DIVIS�O
	GOTO	TESTE_0

TESTE_0 ; TESTA SE A TENS�O � 0V, CASO ELA N�O TENHA SIDO IDENTIFICADA COMO UMA TENS�O REPETIDA
	MOVLW	.0 
	SUBWF	C3, W 
	BTFSS	STATUS, Z 
	GOTO	TESTE_5 ; CASO N�O SEJA, TESTA SE A TENS�O INSERIDA � 5V
	GOTO	LED_DESLIGADO ; CASO SEJA, � ENCAMINHADO PARA A LABEL DE MANTER O LED DESLIGADO

TESTE_5 ; TESTA SE A TENS�O � 5V, CASO ELA N�O TENHA SIDO IDENTIFICADA COMO UMA TENS�O REPETIDA
	MOVLW	.255 
	SUBWF	C3, W 
	BTFSS	STATUS, Z 
	GOTO	CALCULO_LIGADO ; CASO N�O SEJA, ENCAMINHA PARA A LABEL QUE CALCULAR� OS PER�ODOS LIGADO E DESLIGADO DO LED
	GOTO	LED_LIGADO ; CASO SEJA, � ENCAMINHADO PARA A LABEL DE MANTER O LED LIGADO

LED_DESLIGADO ; MANT�M O LED LIGADO
	BCF	GPIO, GP0
	GOTO	TESTE_2

LED_LIGADO ; MANT�M O LED DESLIGADO
	BSF	GPIO, GP0
	GOTO	TESTE_2

TESTE_2 ; SALVA O VALOR DA TENS�O CONVERTIDA ATUAL, PARA COMPARA��O NA PR�XIMA REPETI��O
	MOVF	ADRESH, W
	MOVWF	ADR_TEMP
	GOTO	MAIN
	
CALCULO_LIGADO ; CALCULA A QUANTIDAE DE TEMPO QUE O LED PERMANECER� LIGADO E DESLIGADO DE ACORDO COM O DUTY CICLE CALCULADO
	MOVLW	.200 
	MOVWF	P_10
	MOVFW	RES1 
	ADDWF	RES1, W
	SUBWF	P_10, W ; � SUBTRAIDO O VALOR DA PORCENTAGEM * 2, DE 200 (POSTERIORMENTE SER� MULTIPLICADO POR 10 PARA ATINGIR O PER�ODO DOLICITADO, REFERENTE A FREQUENCIA DE 500HZ)
	MOVWF	DESLIGADO 
	SUBWF	P_10, W ; POSTERIORMENTE � SUBTRAIDO O VALOR OBTIDO ACIMA DE 200, OBTENDO O PER�ODO EM Q O LED FICAR� LIGADO E DESLIGADO
	MOVWF	LIGADO
		

LED_LIGA ; LABEL QUE ESTABELECE O LOOP DO LED, DETERMIANDO A PARTE DO PULSO QUE FICAR� EM "HIGH".
	BSF	GPIO, GP0 ; LIGA O LED
	CALL	DELAY_LIGA ; � CHAMADA A ROTINA DE DELAY PARA A PERMAN�NCIA DO LED ACESO.
	GOTO	LED_DESLIGA ; O LED SER� DESLIGASO NA PR�XIMA LABEL.
LED_DESLIGA ; LABEL QUE ESTABELECE O LOOP DO LED, DETERMIANDO A PARTE DO PULSO QUE FICAR� EM "LOW".
	BCF	GPIO, GP0 ; DESLIGA O LED
	CALL	DELAY_DESLIGA ; � CHAMADA A ROTINA DE DELAY PARA A PERMAN�NCIA DO LED APAGADO.
	GOTO	TESTE_2 

DELAY_LIGA ; PRIMEIRO DELAY, QUE REPRESENTA A PORCENTAGEM DETERMINADA PELO DUTY CICLE PARA O LED FICAR LIGADO
	MOVFW	LIGADO ; O CALCULO DO DELAY CONSISTE EM REPETIR 10 INSTRU��ES PELA QUANTIDADE DETERMINADA PELO DUTY CICLE, GUARDADA NA VARI�VEL LIGADO
	MOVWF	DELAY_1
D_L
	NOP
	NOP
	NOP
	NOP
	NOP
	MOVLW	.1  
	SUBWF	DELAY_1
	BTFSS	STATUS, Z
	GOTO	D_L
	RETURN
	
DELAY_DESLIGA ; SEGUNDO DELAY, QUE REPRESENTA A PORCENTAGEM DETERMINADA PELO DUTY CICLE PARA O LED FICAR LIGADO
	MOVFW	DESLIGADO ; O CALCULO DO DELAY CONSISTE EM REPETIR 10 INSTRU��ES PELA QUANTIDADE DETERMINADA PELO DUTY CICLE, GUARDADA NA VARI�VEL DESLIGADO
	MOVWF	DELAY_2
D_D
	NOP
	NOP
	NOP
	NOP
	NOP
	MOVLW	.1  
	SUBWF	DELAY_2
	BTFSS	STATUS, Z
	GOTO	D_D
	RETURN
	 	
FIM 
	GOTO	FIM
	;CORPO DA ROTINA PRINCIPAL

	GOTO	MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
;CERTO