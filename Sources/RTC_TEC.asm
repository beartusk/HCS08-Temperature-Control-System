            INCLUDE 'derivative.inc'
            XREF MCU_init

            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack	
			XREF mainLoop, init_LCD, lcd_temp, read_keypad, second_line, write_space, pwm_read, final_temp, tenths
			XDEF RTC_write, RTC_read, TEC_read, Convert_LM92_temp
			XDEF seconds,minutes,hours,date,month,year,Convert_LM92_temp
			
			
			
temp_data_2: SECTION  SHORT         ; Insert here your data definition
	ORG $110
	mask: 		DS.B 1
	mask_2:		DS.B 1
	send: 		DS.B 1
	seconds:	DS.B 1
	minutes: 	DS.B 1
	hours: 		DS.B 1
	date: 		DS.B 1
	month: 		DS.B 1
	year: 		DS.B 1
	read_data:  DS.B 1
	send_data:  DS.B 1
	loop_value:   DS.B 1
	loop_value_2: DS.B 1
	TEMP_MSB:	DS.B 1
	TEMP_LSB: 	DS.B 1


MyCode:     SECTION
main:

*********************************************** Initialization **************************************************

start_condition:
	BSET 2, PTAD	
	BSET 3, PTAD
	NOP
	BCLR 2, PTAD
	NOP
	NOP
	NOP
	BCLR 3, PTAD
	;BRA RTC_init
	RTS
	
Slave_address_w_RTC:
	LDA #$D0					;send the starting slave address to the slave 1101000 with 0 as R/W
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	RTS
	
Slave_address_r_RTC:
	LDA #$D1					;send the starting slave address to the slave 1101000 with 1 as R/W
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	RTS
	
Slave_address_w_TEC:
	LDA #$90					;send the starting slave address to the slave 1001000 with 0 as R/W
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	RTS
	
Slave_address_r_TEC:
	LDA #$91					;send the starting slave address to the slave 1001000 with 1 as R/W
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	RTS
	
check_acknowledge:
	BCLR 3, PTAD
	BCLR 2, PTADD
	NOP
	BSET 3, PTAD
	;BRSET 2, PTAD, check_acknowledge
	BCLR 3, PTAD
	BSET 2, PTADD
	RTS
	
check_not_acknowledge:
	BCLR 3, PTAD
	BSET 2, PTAD
	BSET 3, PTAD
	;BRSET 2, PTAD, check_acknowledge
	BCLR 3, PTAD
	BCLR 2, PTAD
	RTS
	
send_acknowledge:
	BCLR 3,  PTAD
	BCLR 2, PTAD
	BSET 3, PTAD
	;BRSET 2, PTAD, check_acknowledge
	BCLR 3, PTAD
	RTS 
	
stop_condition:
	BSET 3, PTAD
	NOP
	BSET 2, PTAD
	RTS
	
*********************************************** Write RTC ***************************************************************	
RTC_write:
	LDA #0
	STA seconds
	STA minutes
	STA hours
	STA date
	STA month
	STA year
	JSR start_condition			;Start
	JSR Slave_address_w_RTC	

	LDA #$00					;send seconds (0-59) to 00H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	LDA seconds
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR stop_condition
	
	JSR start_condition			;Start
	JSR Slave_address_w_RTC
	
	LDA #$01					;send minutes (0-59) to 01H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	LDA minutes
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR stop_condition
	
	JSR start_condition			;Start
	JSR Slave_address_w_RTC
	
	LDA #$02					;send hours   (0-23) to 02H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	LDA hours
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR stop_condition
	
	JSR start_condition			;Start
	JSR Slave_address_w_RTC
	
	LDA #$04					;send date    (1-31) to 04H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	LDA date
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR stop_condition
	
	JSR start_condition			;Start
	JSR Slave_address_w_RTC
	
	LDA #$05					;send month   (1-12) to 05H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	LDA month
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR stop_condition
	
	JSR start_condition			;Start
	JSR Slave_address_w_RTC
	
	LDA #$06					;send year    (0-99) to 06H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	LDA year
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	
	JSR stop_condition
	
	RTS
	
send_loop_init:
	LDA #%10000000
	STA mask
	LDA #8
	STA loop_value
	BRA send_loop
	
send_loop:
	LDA send_data
	AND mask
	BNE send_one
	BEQ send_zero

mask_decr:
	LDA mask
	LSRA
	STA mask
	LDA loop_value
	DECA
	STA loop_value
	BNE send_loop
	RTS
	
send_one:
	BSET 2, PTAD
	NOP
	BSET 3, PTAD
	NOP
	BCLR 3, PTAD
	BRA mask_decr

send_zero:
	BCLR 2, PTAD
	NOP
	BSET 3, PTAD
	NOP
	BCLR 3, PTAD
	BRA mask_decr	
	
****************************************************** Read RTC ******************************************************************
RTC_read:
	JSR start_condition			;Start
	JSR Slave_address_w_RTC	

	LDA #$00					;send seconds (0-59) to 00H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR start_condition
	JSR Slave_address_r_RTC
	JSR read_data_loop_init
	LDA read_data
	STA seconds
	JSR check_not_acknowledge
	JSR stop_condition
	
	JSR start_condition			;Start
	JSR Slave_address_w_RTC
	
	LDA #$01					;send minutes (0-59) to 01H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR start_condition
	JSR Slave_address_r_RTC
	JSR read_data_loop_init
	LDA read_data
	STA minutes
	JSR check_not_acknowledge
	JSR stop_condition
	
	JSR start_condition			;Start
	JSR Slave_address_w_RTC
	
	LDA #$02					;send hours   (0-23) to 02H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR start_condition
	JSR Slave_address_r_RTC
	JSR read_data_loop_init
	LDA read_data
	STA hours
	JSR check_not_acknowledge
	JSR stop_condition
	
	JSR start_condition			;Start
	JSR Slave_address_w_RTC
	
	LDA #$04					;send date    (1-31) to 04H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR start_condition
	JSR Slave_address_r_RTC
	JSR read_data_loop_init
	LDA read_data
	STA date
	JSR check_not_acknowledge
	JSR stop_condition
	
	JSR start_condition			;Start
	JSR Slave_address_w_RTC
	
	LDA #$05					;send month   (1-12) to 05H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR start_condition
	JSR Slave_address_r_RTC
	JSR read_data_loop_init
	LDA read_data
	STA month
	JSR check_not_acknowledge
	JSR stop_condition
	
	JSR start_condition			;Start
	JSR Slave_address_w_RTC
	
	LDA #$06					;send year    (0-99) to 06H
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	JSR start_condition
	JSR Slave_address_r_RTC
	JSR read_data_loop_init
	LDA read_data
	STA year
	JSR check_not_acknowledge
	JSR stop_condition
	
	RTS
	
read_data_loop_init:
	LDA #%10000000
	STA mask_2
	LDA #8
	STA loop_value_2
	LDA #$00
	STA read_data
	BCLR 2, PTADD
	BRA read_data_loop
	
read_data_loop:
	BSET 3, PTAD
	JSR TEN_NOP_DELAY
	BRSET 2, PTAD, read_one
	BRCLR 2, PTAD, read_zero 
	
read_one:
	BCLR 3, PTAD
	LDA #$FF
	AND mask_2
	ORA read_data
	STA read_data
	BRA mask_2_decr
	
read_zero:
	BCLR 3, PTAD
	LDA #$00
	AND mask_2
	ORA read_data
	STA read_data
	BNE mask_2_decr
	
mask_2_decr:	
	LDA mask_2
	LSRA
	STA mask_2
	LDA loop_value_2
	DECA
	STA loop_value_2
	BNE read_data_loop
	BSET 2, PTADD
	RTS

		
**************************************************** LM92 READ ********************************************************************

TEC_read:
	JSR start_condition			;Start
	JSR Slave_address_w_TEC	

	LDA #$00					;send pointer $00 for read only Temperature
	STA send_data
	JSR send_loop_init
	JSR check_acknowledge
	
	JSR start_condition			;repeated start
	
	JSR Slave_address_r_TEC
	
	JSR read_data_loop_init
	LDA read_data
	STA TEMP_MSB
	
	JSR send_acknowledge
	
	JSR read_data_loop_init
	LDA read_data
	STA TEMP_LSB
	JSR check_not_acknowledge
	
	JSR stop_condition
	
	RTS

Convert_LM92_temp:
	LDA TEMP_LSB			;REWORK CONVERSIONS, LOAD 16bits into H:X and shift 3 times
	LSRA					;convert low byte to actual temperature
	LSRA					;One LSB = 0.0625 C.....therefore Temp = LSB/16
	LSRA					;Logical Shift Right 3 times to account for status bits in LM92 temperature register
	STA final_temp			;000XXXXX is LSB
	
	LDA TEMP_MSB
	LSLA
	LSLA
	LSLA
	LSLA
	LSLA					;XXX00000
	ORA final_temp
	STA final_temp			;XXXXXXXX bit 7 - bit 0
	
	LDA TEMP_MSB
	LSRA
	LSRA
	LSRA
	STA final_temp+1
	
	
	
	
	
	
	
	
	LDHX final_temp+1
	LDX #16				;Load X with 16 to divide
	LDA final_temp
	DIV
	STA final_temp
	LDA #0				;Load final_temp+1 high byte with 0
	STA final_temp+1
	
	PSHH				;
	PULA
	LDX #5
	MUL
	LDHX #$08
	DIV
	ADD #48
	STA tenths
	
	RTS
	
TEN_NOP_DELAY:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RTS
NOP
END
