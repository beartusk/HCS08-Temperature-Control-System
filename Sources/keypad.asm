            INCLUDE 'derivative.inc'
            XREF MCU_init


            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack
			XDEF read_keypad, delay_loop,update,press_pound
			XREF mainLoop, debounce, temp_read, init_LCD, ext_conv, n, m, write_entern, second_line,write_actual
			XREF write_A, write_B, write_C, write_D, write_E, write_F, write_0, write_1, write_2, write_3, write_4, write_5, write_6, write_7, write_8, write_9,write_period,seconds
			XREF init_pwm, set_pwm0,set_pwm1,set_pwm2,set_pwm3,set_pwm4, state, Run,read_TEC,clear_display,RTC_read,write_TEC_state,TEC_read,Convert_LM92_temp,write_T92,write_KatT,seconds_write,write_pound,write_star
; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition
	;ORG $170
	cntr2:	DS.B 1
	cntr3:	DS.B 1
	cntr4:	DS.B 1
	update: DS.B 1
	col_mask: DS.B 1

	col1: DS.B 1
	col2: DS.B 1
	col3: DS.B 1
	col4: DS.B 1
	press_pound: DS.B 1

; code section
MyCode:     SECTION
main:

col_read:            
            JSR bus_input
            JSR Y3_setup   
            BCLR 3,PTBD
            LDA PTBD			;AND PTBD with 11110000 so that only D0,D1,D2,D3 are left
            AND col_mask
            ORA #%00001000
            STA PTBD    
            BSET 3,PTBD
            JSR bus_output
            
                                       	              
            RTS   
row_input:	
            JSR Y2_setup ;
            BCLR 3,PTBD
            BSET 3,PTBD
            RTS	
row1_input:	
			JSR bus_output
			LDA #%11101000		;send 1110 into the bus
			STA PTBD
			JSR row_input
			RTS            		
row2_input:
			JSR bus_output
			LDA #%11011000		;send 1101 into the bus
			STA PTBD
			JSR row_input
			RTS
row3_input:
			JSR bus_output
			LDA #%10111000		;send 1011 into the bus
			STA PTBD
			JSR row_input
			RTS
row4_input:
			JSR bus_output
			LDA #%01111000		;send 0111 into the bus
			STA PTBD
			JSR row_input
			RTS
bus_input:
			LDA #$0F			;set data direction for for 4-7 in port B to an input
            STA PTBDD          
			RTS
bus_output:
            LDA #$ff			;set data direction for for 0-7 in port B to an output
            STA PTBDD
            RTS
Y2_setup:   
			BCLR 0,PTBD                	
            BSET 1,PTBD			;set up Y2 as a Low
            BCLR 2,PTBD
            RTS         
Y3_setup:
			BSET 0,PTBD			;set up Y3 as a low
			BSET 1,PTBD     
			BCLR 2,PTBD       			
            RTS                 
read_keypad:	
			LDA #15
			STA n
			mov #83,cntr2
            mov #83,cntr3
            mov #83,cntr4
			mov #%11111000, col_mask			
			mov #%11101000, col4	;set up column compare values
			mov #%11011000, col3
			mov #%10111000, col2
			mov #%01111000, col1	 			                       
            JSR row1_input           
            JSR col_read          
            JSR row1_check
            
            JSR row2_input
            JSR col_read          
            JSR row2_check
            
            JSR row3_input
            JSR col_read           
            JSR row3_check
            
            JSR row4_input	
            JSR col_read           
            JSR row4_check
            LDA n
            SUB #15
            BMI end_keypad
			BRA read_keypad
end_keypad:
			RTS
row1_check:
			LDA PTBD		            
            CMP col1					;Compare to 0111 0000 to see if the first column was pressed (1,4,7,*)
            BEQ pressA				
            CMP col2					;Compare to 1011 0000 to see if the first column was pressed (2,5,8,0)
            BEQ pressB  			
            CMP col3					;Compare to 1101 0000 to see if the first column was pressed (3,6,9,#)
            BEQ pressC
            CMP col4					;Compare to 1110 0000 to see if the first column was pressed (A,B,C,D)
            BEQ pressD
            STA PTBD
            RTS
pressA: 
			JSR write_A
			LDA #10
			STA n
			;LDA #%10100000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS
pressB: 
			JSR write_B
			LDA #11
			STA n
			;LDA #%10110000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS               
pressC:
			JSR write_C
			LDA #12
			STA n
			;LDA #%11000000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS
pressD:
			JSR write_D
			LDA #13
			STA n
			;LDA #%11010000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS           
row2_check:
			LDA PTBD		            
            CMP col1					;Compare to 0111 0000 to see if the first column was pressed (1,4,7,*)
            BEQ press3				
            CMP col2					;Compare to 1011 0000 to see if the first column was pressed (2,5,8,0)
            BEQ press6 			
            CMP col3					;Compare to 1101 0000 to see if the first column was pressed (3,6,9,#)
            BEQ press9
            CMP col4					;Compare to 1110 0000 to see if the first column was pressed (A,B,C,D)
            BEQ presspound
            STA PTBD
            RTS
press3:
			LDA #3
			STA n
			JSR write_3
			;LDA #%00110000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS
press6:
			LDA #6
			STA n
			JSR write_6
			;LDA #%01100000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS
press9:
			LDA #9
			STA n
			JSR write_9
			;LDA #%10010000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS
presspound:
			JSR write_pound
			LDA #1
			STA press_pound
			LDA #14
			STA n
			;LDA #%11110000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS
row3_check:
			LDA PTBD		            
            CMP col1					;Compare to 0111 0000 to see if the first column was pressed (1,4,7,*)
            BEQ press2				
            CMP col2					;Compare to 1011 0000 to see if the first column was pressed (2,5,8,0)
            BEQ press5  			
            CMP col3					;Compare to 1101 0000 to see if the first column was pressed (3,6,9,#)
            BEQ press8
            CMP col4					;Compare to 1110 0000 to see if the first column was pressed (A,B,C,D)
            BEQ press0
            STA PTBD
            RTS
press2:
			LDA #2
			STA n
			JSR write_2
			;LDA #%00101000
			;STA PTBD
			;BCLR 3,PTBD
			;BSET 3,PTBD
			;LDA #%00001000
			;STA PTBD
			JSR delay_loop	
			RTS
press5:
			LDA #5
			STA n
			JSR write_5
			;LDA #%01010000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS
press8:
			LDA #8
			STA n
			JSR write_8
			;LDA #%10000000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS
press0:            
			LDA #0
			STA n
			JSR write_0
			;BCLR 4, PTBD
			;BCLR 5, PTBD
			;BCLR 3,PTBD
			;BSET 3,PTBD
			JSR delay_loop	
			RTS
row4_check:
			LDA PTBD		            
            CMP col1					;Compare to 0111 0000 to see if the first column was pressed (1,4,7,*)
            BEQ press1				
            CMP col2					;Compare to 1011 0000 to see if the first column was pressed (2,5,8,0)
            BEQ press4  			
            CMP col3					;Compare to 1101 0000 to see if the first column was pressed (3,6,9,#)
            BEQ press7
            CMP col4					;Compare to 1110 0000 to see if the first column was pressed (A,B,C,D)
            BEQ pressstar
            STA PTBD
            RTS

press1:
			LDA #1
			STA n
			JSR write_1
			;LDA #1
			;STA state
			;LDA #%00011000
			;STA PTBD
			;BCLR 3,PTBD
			;BSET 3,PTBD
			;LDA #%00001000
			;STA PTBD
			JSR delay_loop	
			RTS
press4:
			LDA #4
			STA n
			JSR write_4
			;LDA #%01000000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS
press7:
			LDA #7
			STA n
			JSR write_7
			;LDA #%01110000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			JSR delay_loop	
			RTS
pressstar:
			JSR write_star
			LDA #0
			STA state
			JSR delay_loop	
			JMP mainLoop
			;JSR write_E
			;LDA #%11100000
			;STA PTBD
			;BSET 3,PTBD
			;BCLR 3,PTBD
			
			;RTS		
delay_loop:
loop2:		
			DBNZ cntr2,loop3
			mov #83,cntr2
			bra	done_loop
loop3:
			DBNZ cntr3,loop4
			mov #83,cntr3
			bra	loop2
loop4:
			DBNZ cntr4,loop4
			mov #83,cntr4
			bra	loop3
done_loop:
			RTS

NOP
END




