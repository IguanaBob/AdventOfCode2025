@echo off

echo Advent of Code 2025 - Day 2, Part A
echo Copyright 2025 Jonathan Hull

REM set FILE=input.txt
set FILE=sample.txt
set DEBUG=1

set /a TOTAL=0

setlocal enableDelayedExpansion
for /f "tokens=* delims=," %%L in (%FILE%) do (
  if "%DEBUG%"=="1" echo Line: %%L
  for %%I in (%%L,=%) do (
    set ID=%%I
    for /f "tokens=1,2 delims=-" %%A in ("!ID!") do (
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

echo TOTAL: !TOTAL!
endlocal
goto :eof

:strlen StrVar
  setlocal EnableDelayedExpansion
  set "s=%~1"
  set "len=0"
  :strlen_loop
  if defined s (
    set "s=!s:~1!"
    set /a len+=1
    goto :strlen_loop
  )
  endlocal & set "slen=%len%"
goto :eof

:checkIfValidId
  setlocal EnableDelayedExpansion
  if "%DEBUG%"=="1" echo Checking %1 for validity
  call :checkForOddIdLen %1
  endlocal
goto :eof

:checkIdRange
  setlocal EnableDelayedExpansion
  if "%DEBUG%"=="1" echo Checking %1 to %2
  set /a pos=%1
  :checkidloop
  if !pos! LEQ %2 (
    echo Checking !pos!
    call :checkIfValidId !pos!
    set /a pos=!pos!+1"
    goto checkidloop
  )
  endlocal
goto :eof

:checkForOddIdLen
  setlocal EnableDelayedExpansion
  if "%DEBUG%"=="1" echo Check if %1 string length is odd
  call :strlen %1
  call set /a "idLen=%%slen%%"
  echo len: !idLen!
  set /a result=!idLen! %% 2
  if "!result!"=="0" echo EVEN
  if not "!result!"=="0" echo ODD
  endlocal
goto :eof