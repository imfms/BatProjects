@echo off

if "%1"=="" (
	echo=#δָ��Ŀ¼
	pause
	exit/b 0
)

for /r "%~1\" %%a in (*) do if exist "%%~a" call:fileName2Time "%%~a"

echo=Over.
pause

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