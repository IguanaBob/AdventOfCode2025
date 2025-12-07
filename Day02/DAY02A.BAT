@echo off

REM This is my first "Working" version. It worked on the sample, but is very slow.
REM Now that I better understand batch I will re-write with more optimized logic.

echo Advent of Code 2025 - Day 2, Part A
echo Copyright 2025 Jonathan Hull
echo Thanks for tips from https://ss64.com/forum/strlen.html and https://ss64.com/nt/


set FILE=input.txt
REM set FILE=sample.txt
set /a DEBUG=1
set /a TOTAL=0
setlocal enableDelayedExpansion

for /f "tokens=* delims=," %%L in (%FILE%) do (
  if "%DEBUG%"=="1" echo Line: %%L
  for %%I in (%%L,=%) do (
    set ID_RANGE=%%I
    for /f "tokens=1,2 delims=-" %%A in ("!ID_RANGE!") do (
      set /a ID_start=%%A
      set /a ID_end=%%B
      
      call :strlen "!ID_start!"
      call set "p1len=%%slen%%"

      call :strlen "!ID_end!"
      call set "p2len=%%slen%%"

      if "%DEBUG%"=="1" echo ID: !ID_start!-!ID_end! !p1len!-!p2len!

      call :checkIdRange !ID_start! !ID_end!
    )
  )
)

echo FINAL TOTAL: !TOTAL!
endlocal
goto :eof

:strlen StrVar
  set "s=%~1"
  set /a len=0
  :strlen_loop
  if defined s (
    set "s=!s:~1!"
    set /a len+=1
    goto :strlen_loop
  )
  endlocal & set "slen=%len%"
goto :eof

:checkIfValidId
  if "%DEBUG%"=="1" echo Checking %1 for validity
  call :checkForOddIdLen %1
  if !VALID!==0 call :checkForRepeat %1
  if !VALID!==0 (
    if "%DEBUG%"=="1" echo INVALID
    endlocal
    goto :eof
  )
  if "%DEBUG%"=="1" echo VALID
  goto :eof

:checkIdRange
  if "%DEBUG%"=="1" echo Checking %1 to %2
  set /a pos=%1
  :checkidloop
  if !pos! LEQ %2 (
    if "%DEBUG%"=="1" echo Checking !pos!
    set /a VALID=0
    call :checkIfValidId !pos!
    if !VALID!==0 (
      set /a TOTAL=!TOTAL!+!pos!
      set /a pos=!pos!+10*!slen!/2
    )
    if !VALID!==1 (
      set /a pos=!pos!+1
    )
    if "%DEBUG%"=="1" echo Total: !TOTAL!
    goto checkidloop
  )
  goto :eof

:checkForOddIdLen
  if "%DEBUG%"=="1" echo Check if ID %1 length is odd
  call :strlen %1
  call set /a "idLen=%%slen%%"
  if "%DEBUG%"=="1" echo len: !idLen!
  set /a result=!idLen! %% 2
  if not "!result!"=="0" (
    if "%DEBUG%"=="1" echo ODD
    set /a VALID=1
    goto :eof
  )
  if "%DEBUG%"=="1" echo EVEN
  goto :eof

:checkForRepeat
  if "%DEBUG%"=="1" echo Check if ID %1 has repeat digits
  set "_test=%1"
  set /a "_halflen=!slen!/2"
  set "half1=!_test:~0,%_halflen%!"
  if "%DEBUG%"=="1" echo half1 !half1!
  set "half2=!_test:~%_halflen%!"
  if "%DEBUG%"=="1" echo half2 !half2!
  if "!half1!"=="!half2!" (
    if "%DEBUG%"=="1" echo REPEATS
    set /a VALID=0
    goto :eof
  )
  if "%DEBUG%"=="1" echo DOES NOT REPEAT
  set /a VALID=1
  goto :eof