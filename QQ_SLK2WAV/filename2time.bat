@echo off

set version=20161203
title �����ļ���Ϊ�䴴��ʱ�� ^| F_Ms - %version% ^| f-ms.cn
color 0a

if "%1"=="" (
	echo=#�����߿��Խ�Ŀ¼�е��ļ������޸�Ϊ���ļ��Ĵ���ʱ��
	echo=
	echo=	�������ڸ���΢�ŵ�����������ļ�����
	echo=
	echo=#����: δָ��Ŀ¼, ��Ŀ¼�϶��������򼴿�
	pause
	exit/b 0
) else if not exist "%~1" (
	echo=#�����߿��Խ�Ŀ¼�е��ļ������޸�Ϊ���ļ��Ĵ���ʱ��
	echo=
	echo=	�������ڸ���΢�ŵ�����������ļ�����
	echo=
	echo=#����: ָ��Ŀ¼������
	echo=	"%~1"
	pause
	exit/b 0
)

echo=#���ڸ���
echo=

REM ���ļ�
if not exist "%~1\" (
	call:fileName2Time "%~1"
) else for /r "%~1\" %%a in (*) do if exist "%%~a" call:fileName2Time "%%~a"

echo=
echo=#�������
pause>nul

::-------------------------------------�ӳ���-------------------------------------::
goto end

REM �޸�ָ���ļ���Ϊ���ļ���ʱ��
REM call:fileName2Time File
:fileName2Time

call:getFileTime "%~1"

set fileTimeName=%fileTimeName%_%random%%random%

REM ��ȡ�ļ���չ��
set fileExName=
for %%B in ("%~1") do set fileExName=%%~xB
if defined fileExName (
	set fileTimeName=%fileTimeName%%fileExName%
)

REM ִ���ļ�������
echo=^| "%~1" -^> %fileTimeName%
ren "%~1" %fileTimeName%

exit/b 0


REM ��ȡ�ļ�ʱ��
REM call:getFileTime File
:getFileTime
 
set fileTimeName=
for %%A in ("%~1") do (
	set "fileTimeName=%%~tA"
)
set fileTimeName=%fileTimeName: =%
set fileTimeName=%fileTimeName::=%
set fileTimeName=%fileTimeName:/=%
exit/b 0

:end