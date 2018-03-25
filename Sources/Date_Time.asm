            INCLUDE 'derivative.inc'
            XREF MCU_init

            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack	
			XREF mainLoop, init_LCD, lcd_temp, read_keypad, second_line,write_space,pwm_read,clear_display
			XREF write_month,write_date,write_year,write_hour,write_min,write_sec,n
			XDEF read_date,read_time
			XREF seconds,minutes,hours,date,month,year
			
			
			
MY_DATE_TIME: SECTION  SHORT         ; Insert here your data definition
	;ORG $145
	month_t: 		DS.B 1
	date_t: 		DS.B 1
	year_t: 		DS.B 1
	hour_t: 		DS.B 1
	min_t: 		DS.B 1
	sec_t: 		DS.B 1


MyCode:     SECTION
main:

read_date:
	LDA #10
	STA n
	JSR clear_display
	JSR write_month
	JSR read_keypad
	LDA n 
	NSA
	STA month_t
	LDA #10
	STA n
	JSR read_keypad
	LDA n 
	ORA month_t
	STA month
	LDA #10
	STA n
	
	JSR clear_display
	JSR write_date
	JSR read_keypad
	LDA n 
	NSA
	STA date_t
	LDA #10
	STA n
	JSR read_keypad
	LDA n 
	ORA date_t
	STA date
	LDA #10
	STA n
	
	JSR clear_display
	JSR write_year
	JSR read_keypad
	LDA n 
	NSA
	STA year_t
	LDA #10
	STA n
	JSR read_keypad
	LDA n 
	ORA year_t
	STA year
	LDA #10
	STA n
	RTS
	
read_time:
	LDA #10
	STA n
	JSR clear_display
	JSR write_hour
	JSR read_keypad
	LDA n 
	NSA
	STA hour_t
	LDA #10
	STA n
	JSR read_keypad
	LDA n 
	ORA hour_t
	STA hours
	LDA #10
	STA n
	
	JSR clear_display
	JSR write_min
	JSR read_keypad
	LDA n 
	NSA
	STA min_t
	LDA #10
	STA n
	JSR read_keypad
	LDA n 
	ORA min_t
	STA minutes
	LDA #10
	STA n
	
	JSR clear_display
	JSR write_sec
	JSR read_keypad
	LDA n 
	NSA
	STA sec_t
	LDA #10
	STA n
	JSR read_keypad
	LDA n 
	ORA sec_t
	STA seconds
	LDA #10
	STA n
	RTS

NOP
END
