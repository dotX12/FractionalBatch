
ECHO OFF
SET "file_path=%1"

GOTO :get_max_decimal_len
GOTO :EOF

:get_max_decimal_len
SETLOCAL EnableDelayedExpansion
IF NOT EXIST "%file_path%" (
	ECHO File not found & GOTO OUT
)
FOR /F "skip=2" %%i IN ('FIND "." "%file_path%"') DO (
	CALL :len %%~i
)

GOTO :file_calculator %decimals_len%


:file_calculator
SETLOCAL EnableDelayedExpansion
IF NOT EXIST "%file_path%" (
	ECHO File not found & GOTO OUT
)

FOR /F "skip=2" %%b IN ('find "." "%file_path%"') DO (
	CALL :add_zeros %%b %decimals_len% RESULT
	CALL :calculator !RESULT! value
)
ECHO Calculation result - %calculator_value%
ENDLOCAL
GOTO :EOF

:slice
SET full_integer=%~1
SET decimal_part=%full_integer:*.=%
CALL SET whole_part=%%full_integer:.%decimal_part%=%%
SET %2=%whole_part%
SET %3=%decimal_part%

GOTO :EOF

:len
SET l=0
CALL :slice %1 whole_part decimal_part


:len_loop
SET x=!decimal_part:~%l%,1!
IF NOT DEFINED x (
	ENDLOCAL & CALL :set_max %l% & GOTO :EOF
)
SET /a l=%l%+1
GOTO :len_loop


:set_max
SET /a len = %1
IF %len% GTR %decimals_len% (
	SET /A decimals_len = %len%
)
GOTO :EOF


:add_zeros
CALL :slice %1 whole decimal

SET "integer=%decimal%"
SET /a count_zero=%2
SET "output_string=!integer!"

CALL :len %integer% len
SET /a start_for = %len%+1
FOR /L %%d IN (%start_for%, 1, %count_zero%) DO (
	SET output_string=!output_string!0)

SET %3=%whole%.%output_string%
GOTO :EOF


:calculator
SET "numA=%calculator_value%"
SET "numB=%1"
SET "fpA=%numA:.=%"
SET "fpB=%numB:.=%"


SET /A add=fpA+fpB
ECHO %numA% + %numB% = !add:~0,-%decimals_len%!.!add:~-%decimals_len%!
SET "value=!add:~0,-%decimals_len%!.!add:~-%decimals_len%!"
SET "calculator_value=%value%"

GOTO :EOF

:OUT
pause>nul
