            INCLUDE 'derivative.inc'
            XREF MCU_init

            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack
			XDEF init_LCD, write_entern, lcd_temp, second_line,write_req,write_equal,write_period,write_actual,lcd_pwm,fivems_delay,reset_cursor,lcd_temp_92,write_Heating_to,write_Cooling_to,write_error,lcd_temp_mark
			XDEF write_A, write_B, write_C, write_D, write_E, write_F, write_0, write_1, write_2, write_3, write_4, write_5, write_6, write_7, write_8, write_9,write_space,write_req,write_actual,write_slash,write_colon,write_pound,write_star
			XDEF write_month,write_date,write_year,write_hour,write_min,write_sec,lcd_date_time,clear_display,write_TEC_state,write_T92,write_KatT,write_Mode_ABC,write_Enter_Tset,write_Enter_10_40C,write_TEC_function,write_1_Heat_0_Cool,write_Target_Temp,write_Holding_at
			XDEF write_Time_in_seconds,write_Enter_0_180,write_Heating_t,write_Cooling_t,write_B_TEC_off,write_A_TEC_off,write_overtemp
			XREF mainLoop, hundreds, tens, ones, tenths, state,seconds_write,
			XREF seconds,minutes,hours,date,month,year,temp_write
			
; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition
	;ORG $150
	cntr1:		DS.B 1
	cntr2:  	DS.B 1
	highbyte:	DS.B 1
	lowbyte:	DS.B 1
; code section
MyCode:     SECTION

main:

init_LCD:
			mov #13,cntr1			;Power On
			mov #238,cntr2
			JSR fivems_delay		;15ms delay
			JSR fivems_delay
			JSR fivems_delay
			   
			LDA #%11111111			
            STA PTADD				;set data direction for for 0-7 in port A to an output
            LDA #%11110000			;set RS and R/W to 0
            STA PTAD 
            JSR fivems_delay		
			JSR bus_output
			LDA #%00111000			;Function Set Command (8-bit Interface)
			STA PTBD
			JSR EN_clock
			
			JSR fivems_delay		;wait at least 4.1 ms
			
			LDA #%00111000			;Funtion Set Command (8-Bit Interface)
			STA PTBD
			JSR EN_clock
			
			JSR fivems_delay		;wait more than 100 us
			
			LDA #%00111000			;Funtion Set Command (8-Bit Interface)
			STA PTBD
			JSR EN_clock
			
			JSR fivems_delay
			
			LDA #%00101000			;Function Set: Sets interface to 4-bit
			STA PTBD
			JSR EN_clock
			
			JSR fivems_delay
			
			LDA #%00101000			;Step 1: Function Set
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
			LDA #%10001000			;N = 1 (2 lines) F = 0 (font set)
			STA PTBD
			JSR EN_clock
			
			JSR fivems_delay
			
			LDA #%00001000			;Step 2: Display Off
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
			LDA #%10001000		
			STA PTBD
			JSR EN_clock
			
			JSR fivems_delay
			
			LDA #%00001000			;Step 3: Clear Display
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
			LDA #%00011000		
			STA PTBD
			JSR EN_clock
			
			JSR fivems_delay
			
			LDA #%00001000			;Step 4: Entry Mode Set
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
			LDA #%01101000			;I/D = 1 (Cursor/Blink moves to the right)  S = 0 (Shifting of entire display is not performed)
			STA PTBD
			JSR EN_clock
			
			JSR fivems_delay
			
			LDA #%00001000			;Step 5: Display On
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
			LDA #%11111000			;C = 1 (Cursor ON) B = 1 (Blink ON)
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
				
			LDA #%11110010			;set RS to 1 (to start writing characters)
            STA PTAD
            RTS 
            
clear_display:
			BCLR 1, PTAD
			LDA #%00001000			;Step 3: Clear Display
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
			LDA #%00011000		
			STA PTBD
			JSR EN_clock
			
			JSR fivems_delay
			BSET 1, PTAD
			RTS
reset_cursor:
			BCLR 1, PTAD
			LDA #%10001000			
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
			LDA #%00001000		
			STA PTBD
			JSR EN_clock
			
			JSR fivems_delay
			BSET 1, PTAD
			RTS
second_line:
			BCLR 1, PTAD
			LDA #%11001000			;go to second line
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
			LDA #%00001000		
			STA PTBD
			JSR EN_clock
			BSET 1, PTAD
			
			
			JSR fivems_delay	
			RTS
			
lcd_pwm:		
			LDA tens				;write tens place
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA tens
			NSA
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			JSR write_period
			
			LDA ones				;write ones place
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA ones
			NSA
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			RTS
 ****************************************************** Write Subroutines ****************************************************************************
write:
			LDA highbyte
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
			LDA lowbyte
			STA PTBD
			JSR EN_clock
			JSR fivems_delay
			RTS
***************************** Phrases ***********************************
***************************** Menu A ************************************
write_Enter_Tset:
			JSR write_E
			JSR write_n
			JSR write_t
			JSR write_e
			JSR write_r
			JSR write_space
			JSR write_T
			JSR write_s
			JSR write_e
			JSR write_t
			JSR write_question_mark
			RTS
			
write_Enter_10_40C:
			JSR write_E
			JSR write_n
			JSR write_t
			JSR write_e
			JSR write_r
			JSR write_space
			JSR write_1
			JSR write_0
			JSR write_dash
			JSR write_4
			JSR write_0
			JSR write_space
			JSR write_C
			RTS
			
write_Heating_to:
			JSR write_H
			JSR write_e
			JSR write_a
			JSR write_t
			JSR write_i
			JSR write_n
			JSR write_g
			JSR write_space
			JSR write_t
			JSR write_o
			JSR write_space
			RTS
			
write_Cooling_to:
			JSR write_C
			JSR write_o
			JSR write_o
			JSR write_l
			JSR write_i
			JSR write_n
			JSR write_g
			JSR write_space
			JSR write_t
			JSR write_o
			JSR write_space
			RTS 
			
write_A_TEC_off:
			JSR write_A
			JSR write_colon
			JSR write_T
			JSR write_E
			JSR write_C
			JSR write_space
			JSR write_off
			RTS
			
***************************** Menu B ************************************
write_TEC_function:
			JSR write_T
			JSR write_E
			JSR write_C
			JSR write_space
			JSR write_f
			JSR write_u
			JSR write_n
			JSR write_c
			JSR write_t
			JSR write_i
			JSR write_o
			JSR write_n
			JSR write_question_mark
			RTS
write_1_Heat_0_Cool:
			JSR write_1
			JSR write_dash
			JSR write_H
			JSR write_e
			JSR write_a
			JSR write_t
			JSR write_comma
			JSR write_space
			JSR write_0
			JSR write_dash
			JSR write_C
			JSR write_o
			JSR write_o
			JSR write_l
			RTS
write_Time_in_seconds:
			JSR write_T
			JSR write_i
			JSR write_m
			JSR write_e
			JSR write_space
			JSR write_i
			JSR write_n
			JSR write_space
			JSR write_s
			JSR write_e
			JSR write_c
			JSR write_o
			JSR write_n
			JSR write_d
			JSR write_s
			JSR write_question_mark
			RTS
write_Enter_0_180:
			JSR write_E
			JSR write_n
			JSR write_t
			JSR write_e
			JSR write_r
			JSR write_space
			JSR write_0
			JSR write_dash
			JSR write_1
			JSR write_8
			JSR write_0
			JSR write_space
			RTS
write_Heating_t:
			JSR write_H
			JSR write_e
			JSR write_a
			JSR write_t
			JSR write_i
			JSR write_n
			JSR write_g
			JSR write_space
			JSR write_t
			JSR write_equal
			RTS
write_Cooling_t:
			JSR write_C
			JSR write_o
			JSR write_o
			JSR write_l
			JSR write_i
			JSR write_n
			JSR write_g
			JSR write_space
			JSR write_t
			JSR write_equal
			RTS
write_B_TEC_off:
			JSR write_B
			JSR write_colon
			JSR write_T
			JSR write_E
			JSR write_C
			JSR write_space
			JSR write_off
			RTS						

***************************** Menu C ************************************
write_Target_Temp:
			JSR write_T
			JSR write_a
			JSR write_r
			JSR write_g
			JSR write_e
			JSR write_t
			JSR write_space
			JSR write_T
			JSR write_e
			JSR write_m
			JSR write_p
			JSR write_question_mark
			RTS
write_Holding_at:
			JSR write_H
			JSR write_o
			JSR write_l
			JSR write_d
			JSR write_i
			JSR write_n
			JSR write_g
			JSR write_space
			JSR write_a
			JSR write_t
			RTS
write_overtemp:
			JSR write_O
			JSR write_V
			JSR write_E
			JSR write_R
			JSR write_T
			JSR write_E
			JSR write_M
			JSR write_P
			JSR write_colon
			JSR write_T
			JSR write_E
			JSR write_C
			JSR write_space
			JSR write_O
			JSR write_F
			JSR write_F
			RTS						

************************** Other Phrases ************************************
write_error:
			JSR write_e
			JSR write_r
			JSR write_r
			JSR write_o
			JSR write_r
			JSR write_space
write_Mode_ABC:
			JSR write_M
			JSR write_o
			JSR write_d
			JSR write_e
			JSR write_colon
			JSR write_space
			JSR write_A
			JSR write_comma
			JSR write_B
			JSR write_comma
			JSR write_C
			JSR write_question_mark
			RTS
write_TEC_state:
			JSR write_T
			JSR write_E
			JSR write_C
			JSR write_space
			JSR write_s
			JSR write_t
			JSR write_a
			JSR write_t
			JSR write_e
			JSR write_colon
			JSR write_space
			JSR write_space
			LDA state
			CBEQA #0, write_off
			CBEQA #1, write_heat
			CBEQA #2, write_cool
			RTS
write_off:
			JSR write_o
			JSR write_f
			JSR write_f
			JSR write_space
			RTS
write_heat:
			JSR write_h
			JSR write_e
			JSR write_a
			JSR write_t
			JSR write_space
			RTS
write_cool:
			JSR write_c
			JSR write_o
			JSR write_o
			JSR write_l
			JSR write_space
			RTS
write_T92:
			JSR write_T
			JSR write_9
			JSR write_2
			JSR write_colon
			JSR write_space
			JSR temp_write
			JSR write_space
			RTS	
write_KatT:
			JSR write_K
			JSR write_at
			JSR write_T
			JSR write_equal
			;JSR write_space
			;JSR write_space
			;JSR write_space
			RTS	
write_month:
			JSR write_M
			JSR write_o
			JSR write_n
			JSR write_t
			JSR write_h
			JSR write_equal
			RTS
write_date:
			JSR write_D
			JSR write_a
			JSR write_t
			JSR write_e
			JSR write_equal
			RTS
write_year:
			JSR write_Y
			JSR write_e
			JSR write_a
			JSR write_r
			JSR write_equal
			RTS
write_hour:
			JSR write_H
			JSR write_o
			JSR write_u
			JSR write_r
			JSR write_equal
			RTS
write_min:
			JSR write_M
			JSR write_i
			JSR write_n
			JSR write_u
			JSR write_t
			JSR write_e
			JSR write_s
			JSR write_equal
			RTS
write_sec:
			JSR write_S
			JSR write_e
			JSR write_c
			JSR write_o
			JSR write_n
			JSR write_d
			JSR write_s
			JSR write_equal
			RTS
write_req:
			JSR write_Rr
			JSR write_e
			JSR write_q
			JSR write_space
			JSR write_O
			JSR write_u
			JSR write_t
			JSR write_equal
			RTS
write_actual:
			JSR write_A
			JSR write_c
			JSR write_t
			JSR write_u
			JSR write_a
			JSR write_l
			JSR write_space
			JSR write_O
			JSR write_u
			JSR write_t
			JSR write_equal
			RTS
write_entern:          
            JSR write_E
            JSR write_n
            JSR write_t
            JSR write_e
            JSR write_r
            JSR write_space
            JSR write_n
            JSR write_colon
            JSR write_space
			RTS
**************************** Characters ***************************************
write_dash:
			MOV #%00101000, highbyte
			MOV #%11011000, lowbyte
			JSR write
			RTS
write_period:
			MOV #%00101000, highbyte
			MOV #%11101000, lowbyte
			JSR write
			RTS
write_space:
			MOV #%00101000, highbyte
			MOV #%00001000, lowbyte
			JSR write
			RTS
write_equal:
			MOV #%00111000, highbyte
			MOV #%11011000, lowbyte
			JSR write
			RTS				
write_colon:
			MOV #%00111000, highbyte
			MOV #%10101000, lowbyte
			JSR write
			RTS
write_slash:
			MOV #%00101000, highbyte
			MOV #%11111000, lowbyte
			JSR write
			RTS
write_at:
			MOV #%01001000, highbyte
			MOV #%00001000, lowbyte
			JSR write
			RTS
write_comma:
			MOV #%00101000, highbyte
			MOV #%11001000, lowbyte
			JSR write
			RTS
write_question_mark:
			MOV #%00111000, highbyte
			MOV #%11111000, lowbyte
			JSR write
			RTS
write_pound:
			MOV #%00101000, highbyte
			MOV #%00111000, lowbyte
			JSR write
			RTS
write_star:
			MOV #%00101000, highbyte
			MOV #%10101000, lowbyte
			JSR write
			RTS
************************************************** Lowercase ******************************************************
write_a:
			MOV #%01101000, highbyte
			MOV #%00011000, lowbyte
			JSR write
			RTS
write_b:
			MOV #%01101000, highbyte
			MOV #%00101000, lowbyte
			JSR write
			RTS
write_c:
			MOV #%01101000, highbyte
			MOV #%00111000, lowbyte
			JSR write
			RTS		
write_d:
			MOV #%01101000, highbyte
			MOV #%01001000, lowbyte
			JSR write
			RTS					
write_e:
			MOV #%01101000, highbyte
			MOV #%01011000, lowbyte
			JSR write
			RTS
write_f:
			MOV #%01101000, highbyte
			MOV #%01101000, lowbyte
			JSR write
			RTS
write_g:
			MOV #%01101000, highbyte
			MOV #%01111000, lowbyte
			JSR write
			RTS
write_h:
			MOV #%01101000, highbyte
			MOV #%10001000, lowbyte
			JSR write
			RTS
write_i:
			MOV #%01101000, highbyte
			MOV #%10011000, lowbyte
			JSR write
			RTS	
write_j:
			MOV #%01101000, highbyte
			MOV #%10101000, lowbyte
			JSR write
			RTS	
write_k:
			MOV #%01101000, highbyte
			MOV #%10111000, lowbyte
			JSR write
			RTS			
write_l:
			MOV #%01101000, highbyte
			MOV #%11001000, lowbyte
			JSR write
			RTS
write_m:
			MOV #%01101000, highbyte
			MOV #%11011000, lowbyte
			JSR write
			RTS
write_n:
			MOV #%01101000, highbyte
			MOV #%11101000, lowbyte
			JSR write
			RTS
write_o:
			MOV #%01101000, highbyte
			MOV #%11111000, lowbyte
			JSR write
			RTS	
write_p:
			MOV #%01111000, highbyte
			MOV #%00001000, lowbyte
			JSR write
			RTS	
write_q:
			MOV #%01111000, highbyte
			MOV #%00011000, lowbyte
			JSR write
			RTS			
write_r:
			MOV #%01111000, highbyte
			MOV #%00101000, lowbyte
			JSR write
			RTS
write_s:
			MOV #%01111000, highbyte
			MOV #%00111000, lowbyte
			JSR write
			RTS			
write_t:
			MOV #%01111000, highbyte
			MOV #%01001000, lowbyte
			JSR write
			RTS
write_u:
			MOV #%01111000, highbyte
			MOV #%01011000, lowbyte
			JSR write
			RTS	
write_v:
			MOV #%01111000, highbyte
			MOV #%01101000, lowbyte
			JSR write
			RTS	
write_w:
			MOV #%01111000, highbyte
			MOV #%01111000, lowbyte
			JSR write
			RTS	
write_x:
			MOV #%01111000, highbyte
			MOV #%10001000, lowbyte
			JSR write
			RTS	
write_y:
			MOV #%01111000, highbyte
			MOV #%10011000, lowbyte
			JSR write
			RTS	
write_z:
			MOV #%01111000, highbyte
			MOV #%10101000, lowbyte
			JSR write
			RTS	

************************************************** Uppercase ******************************************************


write_A:
			MOV #%01001000, highbyte
			MOV #%00011000, lowbyte
			JSR write
			RTS
write_B:
			MOV #%01001000, highbyte
			MOV #%00101000, lowbyte
			JSR write
			RTS
write_C:
			MOV #%01001000, highbyte
			MOV #%00111000, lowbyte
			JSR write
			RTS
write_D:
			MOV #%01001000, highbyte
			MOV #%01001000, lowbyte
			JSR write
			RTS
write_E:
			MOV #%01001000, highbyte
			MOV #%01011000, lowbyte
			JSR write
			RTS
write_F:
			MOV #%01001000, highbyte
			MOV #%01101000, lowbyte
			JSR write
			RTS
write_G:
			MOV #%01001000, highbyte
			MOV #%01111000, lowbyte
			JSR write
			RTS
write_H:
			MOV #%01001000, highbyte
			MOV #%10001000, lowbyte
			JSR write
			RTS
write_I:
			MOV #%01001000, highbyte
			MOV #%10011000, lowbyte
			JSR write
			RTS
write_J:
			MOV #%01001000, highbyte
			MOV #%10101000, lowbyte
			JSR write
			RTS
write_K:
			MOV #%01001000, highbyte
			MOV #%10111000, lowbyte
			JSR write
			RTS
write_L:
			MOV #%01001000, highbyte
			MOV #%11001000, lowbyte
			JSR write
			RTS
write_M:
			MOV #%01001000, highbyte
			MOV #%11011000, lowbyte
			JSR write
			RTS
write_N:
			MOV #%01001000, highbyte
			MOV #%11101000, lowbyte
			JSR write
			RTS
write_O:
			MOV #%01001000, highbyte
			MOV #%11111000, lowbyte
			JSR write
			RTS	
write_P:
			MOV #%01011000, highbyte
			MOV #%00001000, lowbyte
			JSR write
			RTS
write_Q:
			MOV #%01011000, highbyte
			MOV #%00011000, lowbyte
			JSR write
			RTS
write_R:
write_Rr:
			MOV #%01011000, highbyte
			MOV #%00101000, lowbyte
			JSR write
			RTS
write_S:
			MOV #%01011000, highbyte
			MOV #%00111000, lowbyte
			JSR write
			RTS	
write_T:
			MOV #%01011000, highbyte
			MOV #%01001000, lowbyte
			JSR write
			RTS	
write_U:
			MOV #%01011000, highbyte
			MOV #%01011000, lowbyte
			JSR write
			RTS			
write_V:
			MOV #%01011000, highbyte
			MOV #%01101000, lowbyte
			JSR write
			RTS	
write_W:
			MOV #%01011000, highbyte
			MOV #%01111000, lowbyte
			JSR write
			RTS	
write_X:
			MOV #%01011000, highbyte
			MOV #%10001000, lowbyte
			JSR write
			RTS										
write_Y:
			MOV #%01011000, highbyte
			MOV #%10011000, lowbyte
			JSR write
			RTS
write_Z:
			MOV #%01011000, highbyte
			MOV #%10101000, lowbyte
			JSR write
			RTS	
write_0:
			MOV #%00111000, highbyte
			MOV #%00001000, lowbyte
			JSR write
			RTS
write_1:
			MOV #%00111000, highbyte
			MOV #%00011000, lowbyte
			JSR write
			RTS
write_2:
			MOV #%00111000, highbyte
			MOV #%00101000, lowbyte
			JSR write
			RTS
write_3:
			MOV #%00111000, highbyte
			MOV #%00111000, lowbyte
			JSR write
			RTS
write_4:
			MOV #%00111000, highbyte
			MOV #%01001000, lowbyte
			JSR write
			RTS
write_5:
			MOV #%00111000, highbyte
			MOV #%01011000, lowbyte
			JSR write
			RTS
write_6:
			MOV #%00111000, highbyte
			MOV #%01101000, lowbyte
			JSR write
			RTS
write_7:
			MOV #%00111000, highbyte
			MOV #%01111000, lowbyte
			JSR write
			RTS
write_8:
			MOV #%00111000, highbyte
			MOV #%10001000, lowbyte
			JSR write
			RTS
write_9:
			MOV #%00111000, highbyte
			MOV #%10011000, lowbyte
			JSR write
			RTS
********************************************** TEC LCD Setup ***********************************************************************************


********************************************** Date & Time ***********************************************************************************

lcd_date_time:
			LDA tens				;write tens place
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA tens
			NSA
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			LDA ones				;write ones place
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA ones
			NSA
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			RTS

***************************************************************************************************************************
lcd_temp_mark:
			LDA tens				;write tens place
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA tens
			NSA
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			LDA ones				;write ones place
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA ones
			NSA
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			RTS
lcd_temp:
			LDA hundreds			;write hundreds place
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA hundreds
			NSA
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			LDA tens				;write tens place
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA tens
			NSA
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			LDA ones				;write ones place
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA ones
			NSA
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			RTS
lcd_temp_92:
			LDA tens				;write tens place
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA tens
			NSA
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			LDA ones				;write ones place
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA ones
			NSA
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			JSR write_period
			
			LDA tenths				;write tenths place
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			LDA tenths
			NSA
			AND #%11111000
			ORA #%00001000
			STA PTBD
			;JSR temp_setup
			JSR EN_clock
			JSR fivems_delay
			
			RTS
temp_setup:
			BSET 3, PTBD
			BCLR 2, PTBD
			BCLR 1, PTBD
			BCLR 0, PTBD
			RTS

EN_clock:
			BSET 3,PTBD
			BCLR 0,PTBD			;set up Y4 as a low
			BCLR 1,PTBD	
			BSET 2,PTBD			;EN = 1
			BCLR 3,PTBD
			BSET 3,PTBD		   
			BCLR 2,PTBD         ;EN = 0	   
			RTS			
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
			LDA cntr1
			DECA
			STA cntr1
			BNE loop2
			mov #13,cntr1
			bra	done_loop
loop2:
			LDA cntr2 
			DECA
			STA cntr2
			BNE loop2
			mov #238,cntr2
			bra	loop1
done_loop:
			RTS

NOP
END




