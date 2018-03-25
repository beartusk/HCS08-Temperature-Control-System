            INCLUDE 'derivative.inc'
            XREF MCU_init

            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack	
			XREF mainLoop, init_LCD, lcd_temp, read_keypad, second_line,write_space,write_colon,write_period,delay_loop,lcd_pwm,lcd_temp_92
			XDEF ADC_init, temp_read, n, m, hundreds, tens, ones, tenths, pwm_read,date_time_write_init, state, seconds_write, final_temp, temp_write,seconds_write,seconds_temp_write
			XREF seconds,minutes,hours,date,month,year,seconds_temp
			XREF write_slash,lcd_date_time
			
; variable/data section
temp_data: SECTION SHORT
	ORG $90
	cur_counts:  DS.B 1
	hundreds:  DS.B 1
	tens:  DS.B 1
	ones:  DS.B 1
	tenths:  DS.B 1
	INTACC1: DS.B 4
	INTACC2: DS.B 4
	ext_temp: DS.B 2
	total_temp: DS.B 2
	count_temp: DS.B 2
	final_temp: DS.B 2
	cntr1:	DS.B 1
	cntr2:  DS.B 1
	n: DS.B 1
	m: DS.B 1
	state: DS.B 1
	pwm: DS.B 1
	data: DS.B 1
; code section
MyCode:     SECTION

main:


****************************************************** Initialization **********************************************************************
ADC_init:
			;internal sensor ADCH = 11010
			;external sensor ADCH = 00010
			LDA #%00100001
			STA ADCSC1
			LDA #%00000000
			STA ADCSC2
			LDA #%00000010
			STA APCTL1
			LDA #0
			STA total_temp
			STA total_temp+1
			RTS
			
			
			
pwm_read:
			JSR delay_loop
			JSR delay_loop
			JSR delay_loop
			LDA #%00100001		
			STA ADCSC1
			JSR check_coco
			LDA ADCRL		
			STA pwm
			LDHX #%00000000
			LDX #8
			
			DIV
			STA pwm
			JSR pwm_write
			RTS
			
pwm_write:
			LDHX #%00000000
			LDX #10
			LDA pwm
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA ones
			PULA
			
			LDHX #0
			LDX #10
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA tens
			PULA
			
			
			JSR lcd_pwm
			
			RTS
			
************************************************* Date & Time *****************************************************
date_time_write_init:
			LDA month
			AND #%00001111
			ADD #48
			STA ones
			LDA month 
			NSA
			AND #%00001111
			ADD #48
			STA tens
			JSR lcd_date_time
					
			JSR write_slash
			
			LDA date
			AND #%00001111
			ADD #48
			STA ones
			LDA date 
			NSA
			AND #%00001111
			ADD #48
			STA tens
			JSR lcd_date_time
			
			JSR write_slash
			
			LDA year
			AND #%00001111
			ADD #48
			STA ones
			LDA year 
			NSA
			AND #%00001111
			ADD #48
			STA tens
			JSR lcd_date_time
			
			JSR second_line
			
			LDA hours
			AND #%00001111
			ADD #48
			STA ones
			LDA hours 
			NSA
			AND #%00001111
			ADD #48
			STA tens
			JSR lcd_date_time
			
			JSR write_colon
			
			LDA minutes
			AND #%00001111
			ADD #48
			STA ones
			LDA minutes 
			NSA
			AND #%00001111
			ADD #48
			STA tens
			JSR lcd_date_time
			
			JSR write_colon
			
			LDA seconds
			AND #%00001111
			ADD #48
			STA ones
			LDA seconds 
			NSA
			AND #%00001111
			ADD #48
			STA tens
			JSR lcd_date_time
			
			RTS
			
date_time_write:
			LDA data
			LDHX #$00
			LDX #10
			LDA data
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA ones
			PULA
			
			LDHX #0
			LDX #10
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA tens
			PULA
			
			JSR lcd_date_time
			
			RTS		
				
date_time_write_sec_min:
			LDA data
			AND #%00001111
			

time_write:
			;MOV #%00000000, total_temp
			;MOV #%00000000, ext_temp
			LDA final_temp
			;LDA#%00100010
			;STA ADCSC1
			;JSR check_coco
			;LDA ADCRL
			;STA cur_counts
			
			
			LDHX final_temp+1
			LDX #10
			LDA final_temp
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA ones
			PULA
			
			LDHX #0
			LDX #10
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA tens
			PULA
			
			LDHX #0	
			LDX #10		
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA hundreds  ;00110000
			PULA
			
			JSR lcd_temp
			
			RTS
			
seconds_write:		
			LDA seconds
			AND #%00001111
			ADD #48
			STA ones
			LDA seconds 
			NSA
			AND #%00001111
			ADD #48
			STA tens
			
			JSR lcd_date_time
			
			RTS

seconds_temp_write:		
			LDA seconds_temp
			LDHX #0
			LDX #10
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA ones
			PULA
			
			LDHX #0
			LDX #10
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA tens
			PULA
			
			LDHX #0	
			LDX #10		
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA hundreds  ;00110000
			PULA
			JSR lcd_temp
			
			RTS

			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
****************************************************** Internal And External Temperature Readings ***********************************************************
temp_read:
			LDA #0
			STA total_temp
			STA total_temp+1
			JSR init_LCD
			JSR ext_conv
			JSR temp_write
			
			JSR write_space
			
			LDA final_temp
			ADD #17
			STA final_temp
			LDA #1
			STA final_temp+1
			JSR temp_write
			
			LDA m
			STA n
			LDA #0
			STA total_temp
			STA total_temp+1
			
			JSR second_line
			
			JSR int_conv
			JSR temp_write
			
			JSR write_space
			
			LDA final_temp
			ADD #17
			STA final_temp
			LDA #1
			STA final_temp+1
			JSR temp_write
			
			
			JMP read_keypad
ext_conv:
			LDA #%00100010		
			STA ADCSC1
			JSR check_coco
			LDA ADCRL		
			STA ext_temp		;store voltage in ext_temp once the conversion is complete
			ADD total_temp		;modify to do 16bit by 8 bit division!! store lower 8 in A and upper 8 in H
			STA total_temp
			LDA total_temp+1
			ADC #0
			STA total_temp+1
			DBNZ n, ext_conv
			
			LDA total_temp		;159 - 1.1*counts
			LDHX total_temp+1
			LDX m				;divide the total of all read-in voltages by n
			DIV
			STA INTACC1			;average voltage is stored in INTACC1
			
			LDA #0
			STA INTACC1+1
			STA INTACC1+2
			STA INTACC1+3
			STA INTACC2+1
			STA INTACC2+2
			STA INTACC2+3
			LDA #11				;multiply by 11
			STA INTACC2
			JSR UMULT16
			
			LDA INTACC1+1
			LDHX INTACC1
			LDX #10
			DIV
			STA count_temp 
			LDA #159
			SUB count_temp
			STA final_temp
			LDA #0
			STA final_temp+1
			RTS
			
int_conv:
			LDA #%00111010		
			STA ADCSC1
			JSR check_coco
			LDA ADCRL		
			STA ext_temp		;store voltage in ext_temp once the conversion is complete
			ADD total_temp		;modify to do 16bit by 8 bit division!! store lower 8 in A and upper 8 in H
			STA total_temp
			LDA total_temp+1
			ADC #0
			STA total_temp+1
			DBNZ n, int_conv
			
			LDA total_temp		
			LDHX total_temp+1
			LDX m				;divide the total of all read-in voltages by m
			DIV
								;10(44 - 3(counts)/4)
			LDX #3				
			MUL					;multiply by 3
			LDX #4
			DIV					;divide by 4
			STA m
			LDA #43
			SUB	m				;subtract from 44
			
			LDX #10
			MUL					;multiply by 10
			STA final_temp
			LDA #0
			STA final_temp+1
			RTS			
			
temp_write:
			;MOV #%00000000, total_temp
			;MOV #%00000000, ext_temp
			LDA final_temp
			;LDA#%00100010
			;STA ADCSC1
			;JSR check_coco
			;LDA ADCRL
			;STA cur_counts
			
			
			LDHX #0
			LDX #10
			LDA final_temp
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA ones
			PULA
			
			LDHX #0
			LDX #10
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA tens
			PULA
			
			LDHX #0	
			LDX #10		
			DIV
			PSHA
			PSHH
			PULA
			ADD #48
			STA hundreds  ;00110000
			PULA
			
			JSR lcd_temp_92
			
			RTS
check_coco:
			BRCLR 7, ADCSC1, check_coco
			RTS
*********************************************************************************************************************************************************


************************************************************ Signed 16 x 16 Multiply ********************************************************************
SMULT16:    EQU     *			
            PSHX                        ;save x-reg			
            PSHA                        ;save accumulator
            PSHH                        ;save h-reg	
            AIS     #-1                 ;reserve 1 byte of temp. storage		
            CLR     1,SP                ;clear storage for result sign
            BRCLR   7,INTACC1,TST2      ;check multiplier sign bit and negate
                                        ;(two's complement) if set
            NEG     INTACC1+1           ;two's comp multiplier LSB                                        
            BCC     NOSUB1              ;check for borrow from zero                                        
            NEG     INTACC1             ;two's comp multiplier MSB                                        
            DEC     INTACC1             ;decrement MSB for borrow                                        
            BRA     MPRSIGN             ;finished                                        
NOSUB1:     NEG     INTACC1             ;two's comp multiplier MSB (no borrow)                                        
MPRSIGN:    INC     1,SP                ;set sign bit for negative number                                        
TST2:       BRCLR   7,INTACC2,MLTSUB    ;check multiplicand sign bit and negate                                        
                                        ;(two's complement) if set              
            NEG     INTACC2+1           ;two's comp multiplicand LSB                                        
			BCC     NOSUB2              ;check for borrow from zero                                        
            NEG     INTACC2             ;two's comp multiplicand MSB                                        
            DEC     INTACC2             ;decrement MSB for borrow                                        
            BRA     MPCSIGN             ;finished                                        
NOSUB2:     NEG     INTACC2             ;two's comp multiplicand MSB (no borrow)                                        
MPCSIGN:    INC     1,SP                ;set or clear sign bit                                        
MLTSUB:     JSR     UMULT16             ;multiply INTACC1 by INTACC2                                        
            LDA     1,SP                ;load sign bit                                        
            CMP     #1                  ;check for negative                                        
            BNE     DONE                ;exit if answer is positive,                                        
                                        ;otherwise two's complement result                                        
            LDX     #3                  ;                                        
COMP:        COM     INTACC1,X           ;complement a byte of the result
            DECX                        ;point to next byte to be complemented
            BPL     COMP                ;loop until all four bytes of result
                                        ;have been complemented
            LDA     INTACC1+3           ;get result LSB
            ADD     #1                  ;add a "1" for two's comp
            STA     INTACC1+3           ;store new value
            LDX     #2                  ;
TWSCMP:      LDA     INTACC1,X           ;  add any carry from the previous
            ADC     #0                  ;  addition to the next three bytes
            STA     INTACC1,X           ;  of the result and store the new
            DECX                        ;  values            
            BPL     TWSCMP              ;            
DONE:        AIS     #1                  ;deallocate temp storage on stack            
            PULH                        ;restore h-reg            
            PULA                        ;restore accumulator            
            PULX                        ;restore x-reg            
            RTS                         ;return            
********************************************************************************************************************************************************           
            
            
            
            
            
********************************************************* Unsigned 16 x 16 Multiply ********************************************************************                         
UMULT16     				EQU     *            
							PSHA                        ;save acc            
							PSHX                        ;save x-reg            
							PSHH                        ;save h-reg            
							AIS     #-6                 ;reserve six bytes of temporary
                            							;storage on stack            
                            CLR     6,SP                ;zero storage for multiplication carry
*                        
*Multiply (INTACC1:INTACC1+1) by INTACC2+1
*            
							LDX     INTACC1+1           ;load x-reg w/multiplier LSB
				            LDA     INTACC2+1           ;load acc w/multiplicand LSB
				            MUL                         ;multiply            
				            STX     6,SP                ;save carry from multiply            
				            STA     INTACC1+3           ;store LSB of final result            
				            LDX     INTACC1             ;load x-reg w/multiplier MSB            
				            LDA     INTACC2+1           ;load acc w/multiplicand LSB            
				            MUL                         ;multiply            
				            ADD     6,SP                ;add carry from previous multiply            
				            STA     2,SP                ;store 2nd byte of interm. result 1.            
				            BCC     NOINCA              ;check for carry from addition            
				            INCX                        ;increment MSB of interm. result 1.
NOINCA      				STX     1,SP                ;store MSB of interm. result 1.            
							CLR     6,SP                ;clear storage for carry
*
*     Multiply (INTACC1:INTACC1+1) by INTACC2
*            
							LDX     INTACC1+1           ;load x-reg w/multiplier LSB            
							LDA     INTACC2             ;load acc w/multiplicand MSB            
							MUL                         ;multiply            
							STX     6,SP                ;save carry from multiply            
							STA     5,SP                ;store LSB of interm. result 2.            
							LDX     INTACC1             ;load x-reg w/multiplier MSB            
							LDA     INTACC2             ;load acc w/multiplicand MSB            
							MUL                         ;multiply            
							ADD     6,SP                ;add carry from previous multiply            
							STA     4,SP                ;store 2nd byte of interm. result 2.            
							BCC     NOINCB              ;check for carry from addition            
							INCX                        ;increment MSB of interm. result 2.
NOINCB      				STX     3,SP                ;store MSB of interm. result 2.                            
*                            
*     Add the intermediate results and store the remaining three bytes of the
*     final value in locations INTACC1:INTACC1+2.
*                            
            				LDA     2,SP                ;load acc with 2nd byte of 1st result            
            				ADD     5,SP                ;add acc with LSB of 2nd result            
            				STA     INTACC1+2           ;store 2nd byte of final result            
            				LDA     1,SP                ;load acc with MSB of 1st result            
            				ADC     4,SP                ;add w/ carry 2nd byte of 2nd result            
            				STA     INTACC1+1           ;store 3rd byte of final result            
            				LDA     3,SP                ;load acc with MSB from 2nd result            
            				ADC     #0                  ;add any carry from previous addition            
            				STA     INTACC1             ;store MSB of final result                            
*
*     Reset stack pointer and recover original register values
*                            
            				AIS     #6                  ;deallocate the six bytes of local                                        
            											;storage            
            				PULH                        ;restore h-reg            
            				PULX                        ;restore x-reg            
            				PULA                        ;restore accumulator            
            				RTS                         ;return                            
****************************************************************************************************************************                            


       
        
bus_input:
			LDA #$0F			;set data direction for for 4-7 in port B to an input
            STA PTBDD          
			RTS
bus_output:
            LDA #$ff			;set data direction for for 0-7 in port B to an output
            STA PTBDD
            RTS			
fivems_delay:
loop1:		
			DBNZ cntr1,loop2
			mov #13,cntr1
			bra	done_loop
loop2:
			DBNZ cntr2,loop2
			mov #238,cntr2
			bra	loop1
done_loop:
			RTS

NOP
END




