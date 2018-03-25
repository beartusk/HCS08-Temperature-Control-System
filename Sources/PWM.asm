            INCLUDE 'derivative.inc'
            XREF MCU_init

            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack	
			XREF mainLoop, init_LCD, lcd_temp, read_keypad, second_line,write_space,pwm_read
			XDEF init_pwm, set_pwm0,set_pwm1,set_pwm2,set_pwm3,set_pwm4
			
main:

init_pwm:
			bclr 5, TPMSC
			BSET 3, TPMSC
			lda #%00101000
			sta TPMC0SC
			lda #$01
			sta TPMMODH
			lda #$00
			sta TPMMODL
			RTS
set_pwm0:	
			lda #$00
			sta TPMC0VH
			lda #$00
			sta TPMC0VL
			JSR pwm_read
			RTS					
set_pwm1:
			lda #$00
			sta TPMC0VH
			lda #$46
			sta TPMC0VL
			JSR pwm_read
			RTS
set_pwm2:
			lda #$00
			sta TPMC0VH
			lda #$69
			sta TPMC0VL
			JSR pwm_read
			RTS
set_pwm3:
			lda #$00
			sta TPMC0VH
			lda #$7A
			sta TPMC0VL
			JSR pwm_read
			RTS
set_pwm4:
			lda #$00
			sta TPMC0VH
			lda #$86
			sta TPMC0VL
			JSR pwm_read
			RTS


NOP
END
