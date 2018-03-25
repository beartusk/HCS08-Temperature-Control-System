            INCLUDE 'derivative.inc'
            XREF MCU_init

; export symbols
            XDEF _Startup, main
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
                    
            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack
			XDEF cntr1, mainLoop, onoff, debounce, PTBD_TEMP, PTBDD_TEMP,seconds_temp,C_Hold,C_temp,temp_tens,temp_ones
			XREF read_keypad, init_LCD, ADC_init, write_entern,write_req,init_pwm,RTC_write,RTC_read,read_date,read_time, TEC_read,write_TEC_state,write_T92,write_KatT,write_space,n,press_pound,final_temp,write_Heating_to,write_Cooling_to,write_error,lcd_temp
			XREF date_time_write_init, fivems_delay,clear_display, second_line,state,Convert_LM92_temp,seconds_write,update, reset_cursor,write_Mode_ABC,write_Enter_Tset,write_Enter_10_40C,write_TEC_function,write_1_Heat_0_Cool,write_Target_Temp
			XREF ones, tens, lcd_temp_mark, delay_loop,seconds,minutes,seconds_temp_write
			XREF write_Time_in_seconds,write_Enter_0_180,write_Heating_t,write_Cooling_t,write_B_TEC_off,write_A_TEC_off
; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition
	;ORG $70
	onoff:  DS.B 1
	cntr1:	DS.B 1
	PTBD_TEMP: DS.B 1
	PTBDD_TEMP: DS.B 1
	debounce: DS.B 1
	previous_state: DS.B 1
	press_value: DS.B 1
	temp_ones: DS.B 1
	temp_tens: DS.B 1
	A_temp: DS.B 1
	A_tens: DS.B 1
	A_ones: DS.B 1
	B_time_h: DS.B 1
	B_time_t: DS.B 1
	B_time_o: DS.B 1
	B_time_total: DS.B 1
	B_state: DS.B 1
	cntr5: DS.B 1
	cntr6: DS.B 1
	cntr7: DS.B 1
	seconds_temp: DS.B 1
	C_temp: DS.B 1
	C_Hold: DS.B 1

; code section
MyCode:     SECTION
main:
_Startup:
            LDHX   #__SEG_END_SSTACK ; initialize the stack pointer
            TXS	
            CLI						; enable interrupts	
            CLRA
            LDA #$53 				;disable watchdog
            STA SOPT1
            
            LDA #%11111111			;set data direction for for 0-7 in port A to an output
            STA PTADD
            MOV #0, onoff
            JSR init_LCD
            
			mov #83,cntr5
            mov #83,cntr6
            mov #83,cntr7
            
            LDA #%00001000		;clear LED's
            STA PTBD
            BCLR 3, PTBD
            BSET 3, PTBD
            LDA #%00001001
            STA PTBD
            BCLR 3, PTBD
            BSET 3, PTBD
            BCLR 0, PTBD
            ;JSR write_req
            ;JSR ADC_init
            LDA #0
            STA state
            JSR    MCU_init			; Call generated device initialization function 									
mainLoop: 
			LDA #0
			STA C_Hold
			JSR TEC_read
			JSR Convert_LM92_temp
			LDA #0
			STA press_pound
			JSR clear_display
			JSR second_line
			JSR write_T92
			JSR reset_cursor
			JSR write_Mode_ABC
Read_ABC:
			JSR read_keypad
			LDA n
			STA press_value
			JSR read_keypad
			LDA press_pound
			CBEQA #0, mainLoop
			LDA press_value
			CBEQA #10, A_select
			CBEQA #11, B_select1
			CBEQA #12, C_select1
			BRA mainLoop
			
B_select1:
			JMP B_select
C_select1:
			JMP C_select
************************************************* A **************************************************
A_select:
			LDA #0
			STA press_pound
			JSR clear_display
			JSR write_Enter_Tset
			JSR second_line
			JSR write_Enter_10_40C
			JSR read_keypad
			JSR A_keypad_errorcheck
			LDA n
			STA temp_tens
			JSR read_keypad
			JSR A_keypad_errorcheck
			LDA n 
			STA temp_ones
			JSR read_keypad
			LDA press_pound
			CBEQA #0, A_error
			BRA A_calc
A_error:
			LDA #0
			STA press_pound
			JSR clear_display
			JSR write_Enter_Tset
			JSR write_error
			JSR second_line
			JSR write_Enter_10_40C
			JSR read_keypad
			JSR A_keypad_errorcheck
			LDA n
			STA temp_tens
			JSR read_keypad
			JSR A_keypad_errorcheck
			LDA n 
			STA temp_ones
			JSR read_keypad
			LDA press_pound
			CBEQA #0, A_error
			BRA A_calc
			
A_keypad_errorcheck:
			LDA n
			CBEQA #10, A_error
			CBEQA #11, A_error
			CBEQA #12, A_error
			CBEQA #13, A_error
			CBEQA #14, A_error
			RTS			
			
A_calc:
			LDA temp_tens
			LDX #10
			MUL
			ADD temp_ones
			STA A_temp
			LDA A_temp
			SUB #10
			BMI A_error
			LDA A_temp
			SUB #40
			BPL A_error
			BRA A_heat_or_cool
			
A_heat_or_cool:
			JSR clear_display
			JSR TEC_read
			JSR Convert_LM92_temp
			LDA final_temp
			SUB A_temp
			BMI A_heat
			BPL A_cool
			BRA A_error
A_heat:			
			LDA #1
			STA state
			JSR reset_cursor
			JSR write_Heating_to
			LDA temp_tens
			ADD #48
			STA tens
			LDA temp_ones
			ADD #48
			STA ones
			JSR lcd_temp_mark
			JSR TEC_read
			JSR Convert_LM92_temp
			JSR delay_loop2
			JSR second_line
			JSR write_T92
			LDA final_temp
			CBEQ A_temp, A_off1
			BRA A_heat
			
A_cool:			
			JSR TEC_read
			JSR Convert_LM92_temp
			LDA #2
			STA state
			JSR reset_cursor
			JSR write_Cooling_to
			LDA temp_tens
			ADD #48
			STA tens
			LDA temp_ones
			ADD #48
			STA ones
			JSR lcd_temp_mark
			JSR TEC_read
			JSR Convert_LM92_temp
			JSR delay_loop2
			JSR second_line
			JSR write_T92
			LDA final_temp
			CBEQ A_temp, A_off1
			BRA A_cool
A_off1:
			JSR clear_display
			BRA A_off2
A_off2:
			LDA #0
			STA state
			JSR TEC_read
			JSR Convert_LM92_temp
			JSR reset_cursor
			JSR write_A_TEC_off
			JSR second_line
			JSR write_T92
			JSR read_keypad
			BRA A_off2
************************************************* B **************************************************
B_select:
			LDA #0
			STA press_pound
			JSR clear_display
		    JSR write_TEC_function
		    JSR second_line
		    JSR write_1_Heat_0_Cool
		    JSR read_keypad
		    LDA n
		    SUB #2
		    BPL B_error
		    LDA n
		    STA B_state
		    JSR read_keypad
		    LDA press_pound
			CBEQA #0, B_error
		    BRA B_time
B_error:
			LDA #0
			STA press_pound
			JSR clear_display
		    JSR write_TEC_function
		    JSR write_error
		    JSR second_line
		    JSR write_1_Heat_0_Cool
		    JSR read_keypad
		    LDA n
		    SUB #2
		    BPL B_error
		    LDA n
		    STA B_state
		    JSR read_keypad
		    LDA press_pound
			CBEQA #0, B_error
		    BRA B_time			
B_time:
			LDA #0
			STA press_pound
			JSR clear_display
			JSR write_Time_in_seconds
			JSR second_line
			JSR write_Enter_0_180
			JSR read_keypad				;1st digit (hundreds)
			LDA n
			SUB #10
			BPL B_time_error
			LDA n 
			STA B_time_h
			JSR read_keypad				;2nd digit (tens)
			LDA press_pound
			CBEQA #1, B_time_1dig_send
			LDA n 
			SUB #10
			BPL B_time_error
			LDA n
			STA B_time_t
			JSR read_keypad				;3rd digit (ones)
			LDA press_pound
			CBEQA #1, B_time_2dig_send
			LDA n
			SUB #10
			BPL B_time_error
			LDA n 
			STA B_time_o
			JSR read_keypad
			LDA press_pound
			CBEQA #0, B_time_error
			BRA B_time_3dig_send
				
B_time_1dig_send:
			JMP B_time_1dig 
B_time_2dig_send:
			JMP B_time_2dig
B_time_3dig_send:			
			JMP B_time_3dig
B_time_error:		
			LDA #0
			STA press_pound
			JSR clear_display
			JSR write_Time_in_seconds
			JSR write_error
			JSR second_line
			JSR write_Enter_0_180
			JSR read_keypad				;1st digit (hundreds)
			LDA n
			SUB #10
			BPL B_time_error
			LDA n 
			STA B_time_h
			JSR read_keypad				;2nd digit (tens)
			LDA press_pound
			CBEQA #1, B_time_1dig
			LDA n 
			SUB #10
			BPL B_time_error
			LDA n
			STA B_time_t
			JSR read_keypad				;3rd digit (ones)
			LDA press_pound
			CBEQA #1, B_time_2dig
			LDA n
			SUB #10
			BPL B_time_error
			LDA n 
			STA B_time_o
			JSR read_keypad
			LDA press_pound
			CBEQA #0, B_time_error
			BRA B_time_3dig
B_time_error_send:
			BRA B_time_error	
B_time_1dig:
			LDA B_time_h
			STA B_time_total
			BRA B_heat_or_cool
B_time_2dig:
			LDA B_time_h
			LDX #10
			MUL
			ADD B_time_t
			STA B_time_total
			BRA B_heat_or_cool
B_time_3dig:	
			LDA B_time_h
			LDX #100
			MUL
			ADD B_time_o
			STA B_time_total
			LDA B_time_t
			LDX #10
			MUL
			ADD B_time_total
			STA B_time_total
			LDA B_time_total
			SUB #181
			BPL B_time_error_send
			BRA B_heat_or_cool
B_heat_or_cool:
			JSR RTC_write
			JSR RTC_read
			JSR clear_display
			LDA B_state
			CBEQA #0, B_cool
			CBEQA #1, B_heat
			BRA B_heat_or_cool
B_heat:
			LDA #1
			STA state
			JSR TEC_read
			JSR Convert_LM92_temp
			JSR RTC_read
			JSR B_seconds_conv
			JSR delay_loop2
			JSR reset_cursor
			JSR write_Heating_t
			JSR B_calc_seconds
			JSR seconds_temp_write
			JSR second_line
			JSR write_T92
			LDA B_time_total
			CBEQ seconds_temp, B_off
			BRA B_heat
B_cool:
			LDA #2
			STA state
			JSR TEC_read
			JSR Convert_LM92_temp
			JSR RTC_read
			JSR B_seconds_conv
			JSR delay_loop2
			JSR reset_cursor
			JSR write_Cooling_t
			JSR B_calc_seconds
			JSR seconds_temp_write
			JSR second_line
			JSR write_T92
			LDA B_time_total
			CBEQ seconds_temp, B_off
			BRA B_cool	
B_off:
			LDA #0
			STA state	
			JSR clear_display
			JSR write_B_TEC_off
			JSR second_line
			JSR write_T92
			JSR read_keypad
			BRA B_off
B_calc_seconds:
			LDA minutes
			LDX #60
			MUL
			ADD seconds_temp
			STA seconds_temp
			RTS
B_seconds_conv:
			LDA #0
			STA seconds_temp
			LDA seconds
			AND #%00001111
			STA seconds_temp
			LDA seconds
			NSA
			AND #%00001111
			LDX #10
			MUL 
			ADD seconds_temp
			STA seconds_temp
			RTS
			
************************************************* C **************************************************		    	
C_select:
			LDA #0
			STA press_pound
			JSR clear_display
			JSR write_Target_Temp
			JSR second_line
			JSR write_Enter_10_40C
			JSR read_keypad
			JSR C_keypad_errorcheck
			LDA n
			STA temp_tens
			JSR read_keypad
			JSR C_keypad_errorcheck
			LDA n 
			STA temp_ones
			JSR read_keypad
			LDA press_pound
			CBEQA #0, C_error
			BRA C_calc
			
C_keypad_errorcheck:
			LDA n
			CBEQA #10, C_error
			CBEQA #11, C_error
			CBEQA #12, C_error
			CBEQA #13, C_error
			CBEQA #14, C_error
			RTS			
			
C_calc:
			LDA temp_tens
			LDX #10
			MUL
			ADD temp_ones
			STA C_temp
			LDA C_temp
			SUB #10
			BMI C_error
			LDA C_temp
			SUB #40
			BPL C_error
			BRA C_heat_or_cool	
C_error:
			LDA #0
			STA press_pound
			JSR clear_display
			JSR write_Enter_Tset
			JSR write_error
			JSR second_line
			JSR write_Enter_10_40C
			JSR read_keypad
			JSR C_keypad_errorcheck
			LDA n
			STA temp_tens
			JSR read_keypad
			JSR C_keypad_errorcheck
			LDA n 
			STA temp_ones
			JSR read_keypad
			LDA press_pound
			CBEQA #0, C_error
			BRA C_calc		
C_heat_or_cool:
			JSR clear_display
			JSR TEC_read
			JSR Convert_LM92_temp
			LDA final_temp
			SUB C_temp
			BMI C_heat
			BPL C_cool
			BRA C_error
C_heat:		
			JSR TEC_read
			JSR Convert_LM92_temp	
			LDA #1
			STA state
			JSR reset_cursor
			JSR write_Heating_to
			LDA temp_tens
			ADD #48
			STA tens
			LDA temp_ones
			ADD #48
			STA ones
			JSR lcd_temp_mark
			JSR delay_loop2
			JSR second_line
			JSR write_T92
			LDA final_temp
			CBEQ C_temp, C_off1
			BRA C_heat
			
C_cool:			
			JSR TEC_read
			JSR Convert_LM92_temp
			LDA #2
			STA state
			JSR reset_cursor
			JSR write_Cooling_to
			LDA temp_tens
			ADD #48
			STA tens
			LDA temp_ones
			ADD #48
			STA ones
			JSR lcd_temp_mark
			JSR delay_loop2
			JSR second_line
			JSR write_T92
			LDA final_temp
			CBEQ C_temp, C_off1
			BRA C_cool		
C_off1:
			JSR clear_display
			BRA C_off2
C_off2:
			LDA #0
			STA state
			LDA #1
			STA C_Hold
			JSR read_keypad
			BRA C_off2
******************************************************************************************************
Restart:
			LDA state
			STA previous_state
			LDA #0
			STA seconds
			JSR RTC_write
			BRA Run_Pre
Run_Pre:
			JSR RTC_read
			LDA seconds
			AND #%00000001
			BNE clearupdate
			;BRSET 0, seconds, clearupdate
			LDA update
			CBEQA #1, update_no
			BRA Run
Run:					
			JSR RTC_read
			LDA seconds
			AND #%00000001
			BEQ update_yes
clearupdate:
			LDA #0
			STA update
update_no:
			JSR RTC_read
			JSR reset_cursor
			JSR write_TEC_state
			JSR second_line
			JSR write_T92
			JSR write_KatT
			JSR seconds_write
			JSR read_keypad
			JSR read_keypad
			JSR read_keypad
			JSR read_keypad
			JSR read_keypad
			LDA state
			CBEQ previous_state, Run_Pre
			BRA Restart

update_yes:
			JSR TEC_read
			JSR Convert_LM92_temp
			JSR RTC_read
			JSR reset_cursor
			JSR write_TEC_state
			JSR second_line
			JSR write_T92
			JSR write_KatT
			JSR seconds_write
			JSR read_keypad
			JSR read_keypad
			JSR read_keypad
			JSR read_keypad
			JSR read_keypad
			LDA #1
			STA update
			BRA Run_Pre	
			
			
delay_loop2:
loop2:		
			DBNZ cntr5,loop3
			mov #83,cntr5
			bra	done_loop
loop3:
			DBNZ cntr6,loop4
			mov #83,cntr6
			bra	loop2
loop4:
			DBNZ cntr7,loop4
			mov #20,cntr7
			bra	loop3
done_loop:
			mov #83,cntr5
            mov #83,cntr6
            mov #83,cntr7
			RTS
NOP
END




