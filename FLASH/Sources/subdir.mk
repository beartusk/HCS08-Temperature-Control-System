################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
ASM_SRCS += \
../Sources/ADC.asm \
../Sources/Date_Time.asm \
../Sources/LCD.asm \
../Sources/MCUinit.asm \
../Sources/PWM.asm \
../Sources/RTC_TEC.asm \
../Sources/keypad.asm \
../Sources/main.asm \

ASM_SRCS_QUOTED += \
"../Sources/ADC.asm" \
"../Sources/Date_Time.asm" \
"../Sources/LCD.asm" \
"../Sources/MCUinit.asm" \
"../Sources/PWM.asm" \
"../Sources/RTC_TEC.asm" \
"../Sources/keypad.asm" \
"../Sources/main.asm" \

OBJS += \
./Sources/ADC_asm.obj \
./Sources/Date_Time_asm.obj \
./Sources/LCD_asm.obj \
./Sources/MCUinit_asm.obj \
./Sources/PWM_asm.obj \
./Sources/RTC_TEC_asm.obj \
./Sources/keypad_asm.obj \
./Sources/main_asm.obj \

ASM_DEPS += \
./Sources/ADC_asm.d \
./Sources/Date_Time_asm.d \
./Sources/LCD_asm.d \
./Sources/MCUinit_asm.d \
./Sources/PWM_asm.d \
./Sources/RTC_TEC_asm.d \
./Sources/keypad_asm.d \
./Sources/main_asm.d \

OBJS_QUOTED += \
"./Sources/ADC_asm.obj" \
"./Sources/Date_Time_asm.obj" \
"./Sources/LCD_asm.obj" \
"./Sources/MCUinit_asm.obj" \
"./Sources/PWM_asm.obj" \
"./Sources/RTC_TEC_asm.obj" \
"./Sources/keypad_asm.obj" \
"./Sources/main_asm.obj" \

ASM_DEPS_QUOTED += \
"./Sources/ADC_asm.d" \
"./Sources/Date_Time_asm.d" \
"./Sources/LCD_asm.d" \
"./Sources/MCUinit_asm.d" \
"./Sources/PWM_asm.d" \
"./Sources/RTC_TEC_asm.d" \
"./Sources/keypad_asm.d" \
"./Sources/main_asm.d" \

OBJS_OS_FORMAT += \
./Sources/ADC_asm.obj \
./Sources/Date_Time_asm.obj \
./Sources/LCD_asm.obj \
./Sources/MCUinit_asm.obj \
./Sources/PWM_asm.obj \
./Sources/RTC_TEC_asm.obj \
./Sources/keypad_asm.obj \
./Sources/main_asm.obj \


# Each subdirectory must supply rules for building sources it contributes
Sources/ADC_asm.obj: ../Sources/ADC.asm
	@echo 'Building file: $<'
	@echo 'Executing target #1 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/ADC.args" -Objn"Sources/ADC_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/%.d: ../Sources/%.asm
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '

Sources/Date_Time_asm.obj: ../Sources/Date_Time.asm
	@echo 'Building file: $<'
	@echo 'Executing target #2 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/Date_Time.args" -Objn"Sources/Date_Time_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/LCD_asm.obj: ../Sources/LCD.asm
	@echo 'Building file: $<'
	@echo 'Executing target #3 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/LCD.args" -Objn"Sources/LCD_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/MCUinit_asm.obj: ../Sources/MCUinit.asm
	@echo 'Building file: $<'
	@echo 'Executing target #4 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/MCUinit.args" -Objn"Sources/MCUinit_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/PWM_asm.obj: ../Sources/PWM.asm
	@echo 'Building file: $<'
	@echo 'Executing target #5 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/PWM.args" -Objn"Sources/PWM_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/RTC_TEC_asm.obj: ../Sources/RTC_TEC.asm
	@echo 'Building file: $<'
	@echo 'Executing target #6 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/RTC_TEC.args" -Objn"Sources/RTC_TEC_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/keypad_asm.obj: ../Sources/keypad.asm
	@echo 'Building file: $<'
	@echo 'Executing target #7 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/keypad.args" -Objn"Sources/keypad_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/main_asm.obj: ../Sources/main.asm
	@echo 'Building file: $<'
	@echo 'Executing target #8 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/main.args" -Objn"Sources/main_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '


