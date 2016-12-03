@echo off
setlocal ENABLEDELAYEDEXPANSION
set "path=%path%;%~dp0\bin"
set version=20161203
title QQ_SLK2WAV QQ��Ƶ�ļ�slkתwav�������� ^| F_Ms - %version% ^| f-ms.cn

REM �����ʽ����
if /i "%~1"=="/mp3" (
	REM MP3
	set "outputFormat=mp3"
	set "formatMinSize=1"
	shift/1
) else if /i "%~1"=="/wav" (
	REM DEFAULT WAV
	set "outputFormat=wav"
	set "formatMinSize=40000"
	shift/1
) else (
	REM WAV
	set "outputFormat=wav"
	set "formatMinSize=40000"
)

REM �ж����л���
if "%~1"=="" (
	echo=#���
	echo=		 QQ_SLK2WAV
	echo=
	echo=     ��Ѷqq������Ƶ�ļ�slkתwav��������
	echo=  ���ߣ�F_Ms ^| ���ͣ�f-ms.cn ^| �汾��%version%
	echo=
	echo=#ʹ�÷�����
	echo=	��Ҫת����QQ������Ƶ�ļ�^(.slk^)���ļ���
	echo=	   �϶����������ļ��ϼ���^(�Ǳ�����^)
	pause>nul
	exit/b
) else if not exist "%~1" if not exist "%~1\" (
	echo=#���
	echo=		 QQ_SLK2WAV
	echo=
	echo=     ��Ѷqq������Ƶ�ļ�slkתwav��������
	echo=  ���ߣ�F_Ms ^| ���ͣ�f-ms.cn ^| �汾��%version%
	echo=
	echo=#���棺
	echo=	ָ���ļ����ļ��в�����
	pause>nul
	exit/b
)

color 0a
echo=
echo=#���
echo=
echo=		 QQ_SLK2WAV
echo=
echo=     ��Ѷqq������Ƶ�ļ�slkתwav��������
echo=
echo=	  -ʹ�õ��ĵ����������й���-
echo=	      split(textutils)
echo=	  SilkDecoder(��ԭ������Ϣ)
echo=	  FFmpeg (FFmpegDevelopers)
echo=	             ����
echo=
echo=  ���ߣ�F_Ms ^| ���ͣ�f-ms.cn ^| �汾��%version%
echo=
echo=#ת����ʼ
echo=

REM ���ļ�ת��
if not exist "%~1\" (
	REM ��ת��·������ΪԴ�ļ�·�������ļ�����
	set "descDir=%~dpnx1"
	set "errorListFile=%~1.convert_error_infor.txt"
	
	call convert.bat "%~1" "!descDir!_after_convert" "!errorListFile!"
	
	if "%~2"=="/fast" shift/2
	goto convertEnd
)

REM ���ȫ·���н�ȡ��·������
set "baseDir=%~1"
if not "%baseDir:~-1%"=="\" set "baseDir=%baseDir%\"

REM ת�����Ŀ¼
set "descDir=%~1"
if "%descDir:~-1%"=="\" set "descDir=%descDir:~0,-1%"
set "descDir=%descDir%_after_convert\"

REM ת��������Ϣ·��
set "errorListFile=%baseDir:~0,-1%.convert_error_list.txt"

REM Ŀ¼����ת��
for /r "%~1\" %%a in (*) do if exist "%%~a" (
	REM ��װ��·������Ϊԭ·�������ļ�����,��������ļ�����ƴ�ϵ����ļ�����
	set "targetDir=%%~dpa"
	set "targetDir=!targetDir:%baseDir%=!"
	
	if /i "%~2"=="/FAST" (
		echo=	-^> %%~a
		start /min cmd /c convert.bat "%%~a" "%descDir%!targetDir!" "%errorListFile%"
	) else call convert.bat "%%~a" "%descDir%!targetDir!" "%errorListFile%"
	
)

:convertEnd

REM ����ģʽ
if /i not "%~2"=="/FAST" (
	REM ����д�����־��򿪴�����־
	if exist "%errorListFile%" start "" "%errorListFile%"
	
	echo=#ת������
	echo=
) else (
	echo=#������������, ���ע��̨
	echo=
)
pause>nul

exit/b