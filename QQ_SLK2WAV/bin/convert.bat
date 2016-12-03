@echo off
setlocal ENABLEDELAYEDEXPANSION

REM ���ӳ��� call:convert "��ת���ļ�" "ת������Ŀ��·��"
:convert
cd /d "%~dp1"
set/p=^|	����ת��: "%~1" ^> <nul

REM ������ʼ��
for %%a in (yuanFile tempFile newWavFileName fileTargetPath convertFailFileList) do set %%a=
set "fileTargetPath=%~2"
set "convertFailFileList=%~3"
set "yuanFile=%~1"
for /f "delims=" %%a in ("%yuanFile%") do (
	set "newWavFileName=%%~na.%outputFormat%"
	set "tempFile=%%~na"
)
set "tempFile=%tempFile: =%"

REM �ļ�ǰ�ڴ���
call:fileSizeTrue 50 "%~1"
if "%errorlevel%"=="0" (
	echo= #���ļ�,������
	call:writeErrorLog ���ļ� "%~1"
	exit/b 1
)

call:checkFileHeader "%~1"
if "%errorlevel%"=="0" (
	set tempFileSlk2Pcm=%~1
	set tempFilePcm2Wav=%~1.pcm
	goto passSplit
) else if "%errorlevel%"=="1" (
	echo= #�ļ�ͷ��Ϣ����,������
	call:writeErrorLog �ļ����ʹ���	"%~1"
	exit/b 1
) else if "%errorlevel%"=="2" (
	echo= # AMR��ʽΪͨ�ø�ʽ,������
	REM ����ֱ�ӿ���Դ�ļ���Ŀ��·��
	if not exist "%fileTargetPath%" md "%fileTargetPath%"
	copy "%~1" "%fileTargetPath%\%newWavFileName%.amr">nul 2>nul
	call:writeErrorLog ͨ����Ƶ��ʽ	"%~1"
	exit/b 1
)
REM �ü������ļ�ͷ
call:GetFileSplitSize "%yuanFile%"
if not "%errorlevel%"=="0" (
	echo= #ת��ʧ��,�����ļ�Ȩ�޲���
	call:writeErrorLog �޷���Ȩ��	"%~1"
)
:passSplit

REM slk2pcmת��
call:slk2pcm "%tempFileSlk2Pcm%" "%tempFilePcm2Wav%"
if not "%errorlevel%"=="0" (
	set kbps=16000
	set tempFilePcm2Wav=%yuanFile%
	goto passSlk2Pcm
)
REM pcm2wavת��
set kbps=
set kbps=44100
:passSlk2Pcm
if not exist "%fileTargetPath%" md "%fileTargetPath%"
call:pcm2wav %kbps% "%tempFilePcm2Wav%" "%fileTargetPath%\%newWavFileName%"
if not "%errorlevel%"=="0" (
	echo= #ת��ʧ��,����ָ���ļ��������ʹ���
	call:writeErrorLog �ļ��������	"%~1"
	call:DeleteTempFile
	exit/b 1
)

REM �ж��Ƿ�����ִ�гɹ�
call:fileSizeTrue %formatMinSize% "%fileTargetPath%\%newWavFileName%"
if "%errorlevel%"=="0" if "%kbps%"=="44100" (
	set kbps=16000
	set tempFilePcm2Wav=%yuanFile%
	goto passSlk2Pcm
)
if "%errorlevel%"=="0" (
	if exist "%fileTargetPath%\%newWavFileName%" del /f /q "%fileTargetPath%\%newWavFileName%"
	echo= #ת��ʧ��,δ֪����
	call:writeErrorLog δ֪����	"%~1"
	call:DeleteTempFile
	exit/b 1
)

echo= ת���ɹ�
call:DeleteTempFile
exit/b 0

REM ����ļ��ļ�ͷ���Ƿ�ΪQQ�����ļ� call:checkFileHeader file
REM 	����ֵ��1 - ָ���ļ�����, 2 - AMR�ļ�, 3 - slk��Ҫ�����ֽ� 0 - slk��������ֽ�
:checkFileHeader
set fileHeaderTemp=
set /p fileHeaderTemp=<"%~1"
if not defined fileHeaderTemp exit/b 1
if /i "%fileHeaderTemp:~0,5%"=="#!AMR" exit/b 2
if /i "%fileHeaderTemp:~0,10%"=="#!SILK_V3" exit/b 3
if /i "%fileHeaderTemp:~0,9%"=="#!SILK_V3" exit/b 0
exit/b 1


REM �ļ�ǰ�ڴ���(ȥ���׸��ֽ�) call:GetFileSplitSize "%yuanFile%"
:GetFileSplitSize
REM ��ȡ�ļ����ڲü�����
set fileSize=0
for  %%a in ("%~1") do set /a fileSize=%%~za+1
set tempFileSlk2Pcm=%tempFile%_ab
set tempFilePcm2Wav=%tempFile%_ab.pcm

REM �����ļ�Ϊ˫���ĳ���
copy "%~1" "%~1_2" 0>nul 1>nul 2>nul
if not "%errorlevel%"=="0" exit/b %errorlevel%
copy /b "%~1"+"%~1_2" "%~1_3" 0>nul 1>nul 2>nul
if not "%errorlevel%"=="0" exit/b %errorlevel%
split -b %fileSize% "%~1_3" %tempFile%_ 0>nul 1>nul 2>nul
if not "%errorlevel%"=="0" exit/b %errorlevel%
exit/b 0

REM �жϽ���Ƿ�Ϊ���ļ� call:fileSizeTrue size file
REM   ����ֵ��0 - ��, 1 - �ǿ�
:fileSizeTrue
if not exist "%~2" exit/b 0
for %%a in ("%~2") do (
	if %%~za leq %~1 exit/b 0
)
exit/b 1

REM ɾ����ʱ�ļ� call:DeleteTempFile
:DeleteTempFile
for %%a in ("%yuanFile%_2","%yuanFile%_3","%tempFile%_aa" "%tempFile%_ab" "%tempFile%_ab.pcm" "%yuanFile%.pcm") do if exist "%%~a" del /f /q "%%~a"
exit/b 0

REM slk2pcmת�� call:slk2pcm inputFile outputFile
:slk2pcm
slk2pcm.exe "%~1" "%~2" -Fs_API 44100 0>nul 1>nul 2>nul
exit/b %errorlevel%

REM pcm2wavת�� call:pcm2wav ������ inputFile outputFile
:pcm2wav
if exist "%~3" del /f /q "%~3"
pcm2wav.exe -f s16le -ar %~1 -ac 1 -i "%~2" -ar 44100 -ac 2 -f %outputFormat% "%~3" 0>nul 1>nul 2>nul
exit/b %errorlevel%

REM ������־д�� �������� �����ļ�
:writeErrorLog
if not defined convertFailFileList exit/b

REM д������ļ�ͷ
if not exist "%convertFailFileList%" echo=#ת��������־>"%convertFailFileList%"

REM д���������
echo=	"%~2"	%~1>>"%convertFailFileList%"
exit/b
