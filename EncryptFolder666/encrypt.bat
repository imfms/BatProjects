@echo off
setlocal ENABLEDELAYEDEXPANSION
cd /d "%~dp0"

REM ��������
:: �ļ������
set "dirLevel=50"
set "rootDir=encrypt"

REM �����ʼ��
set "encryptString="
if not exist "%rootDir%" md "%rootDir%"

set "localLevel=0"

REM Ŀ¼����
for /l %%a in (1,1,%dirLevel%) do (
	call:random encryptString
	echo=!encryptString!
	call:createDir %rootDir%\!encryptString! %dirLevel%
)


goto end

:random
:: call:random var
:: ��������ַ���var
set "%1=!random!!random!!random!!random!!random!!random!!random!!random!"
exit/b

:createDir
:: call:createDir dir dirLevel
:: �����㼶Ŀ¼
for /l %%A in (1,1,%~2) do (
	call:random encryptString
	echo=	!encryptString!
	md "%~1\!encryptString!"
	echo=%~1\!encryptString!>"%~1\!encryptString!\!encryptString!"
)
exit/b

:end