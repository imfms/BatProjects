@echo off&setlocal enabledelayedexpansion
echo=�������û���,���Ժ�  :)

set version=20151230
set project=F_Ms-Teacher_Server

cd /d "%~dp0"
for %%a in (fms.ini fms2.ini fms4.ini random.bat) do if not exist "%myfiles%\%%a" copy "%myfiles%\%%a_bak" "%myfiles%\%%a">nul

REM ������ϵͳ�汾
for /f "tokens=2" %%b in ('for /f "tokens=2 delims=[]" %%a in ^('ver'^) do @echo=%%a') do set osver=%%b
if "%osver:~0,6%"=="5.1.26" (
	set os=WinXP
) else if "%osver:~0,6%"=="6.1.76" (
	set os=Win7
) else set os=Other
REM ���ϵͳ������λ����
if /i "%PROCESSOR_IDENTIFIER:~0,3%"=="x86" (set osw=32) else set osw=64

REM ������ϵͳ�汾�Ƿ��Ǻϣ�������ʾ�˳�
if /i "%os%"=="Other" (
	start mshta vbscript:msgbox^("���δ�ڵ�ǰ�汾ϵͳ���в��ԣ�����ʱ���ܻ��д�����",64,"��ʾ"^)^(window.close^)
)

REM ��ȡ�Լ���PID����д��%appdata%\fms7.fms
if exist "%appdata%\fms7.fms" (
	for /f "usebackq" %%a in ("%appdata%\fms7.fms") do (
		(for /f "tokens=2 delims=," %%A in ('tasklist /v /nh /fo csv') do @echo=%%~A)|findstr "\<%%a\>">nul
		if "!errorlevel!"=="0" (
			start mshta vbscript:msgbox^("�������ظ�����",64,"��ʾ"^)^(window.close^)
			exit
		)
	)
	attrib -r -s -h "%appdata%\fms7.fms">nul
)
:writepid2fms7
if exist "%appdata%\fms7.fms" del /f /q "%appdata%\fms7.fms"
for /f %%a in ('"%myfiles%\random.bat" aA0@ 32') do title %%a&set title=%%a
(for /f "tokens=2 delims=," %%a in ('tasklist /v /nh /fo csv^|findstr "\<%title%\>"') do @echo=%%~a)>"%appdata%\fms7.fms"
set pidcheck=0
for /f "usebackq delims=" %%a in ("%appdata%\fms7.fms") do set /a pidcheck+=1
if %pidcheck% gtr 1 goto writepid2fms7
attrib +r +s +h "%appdata%\fms7.fms">nul

title F_Ms-��ѧ�������ض� %version%
color 0a
mode con cols=57 lines=23
set oldfilename=%0
echo=�������û���,���Ժ�  :)

REM ������л���
set yuandir=%cd%
call:checkrunfolder

REM ���ø�����
set serveraddress=imfms.vicp.net
set ftppassword=EDC6C50DC634B4A565FD19D2496D2013
set screensharepassword=BCAA681D4FEA0CC76B427AAF38AF9CA4
set screenshareadminpassword=ACD1EEAD1248DC0BCC013496A99456A9

if not exist config md Config

REM �����ļ�����ݷ�ʽ,��ע�����������·�����������ֵ������desktop
for /f "tokens=3,* skip=2" %%a in ('reg query "hkcu\software\microsoft\windows\currentversion\explorer\shell folders" /v desktop') do (
	if "%%~b"=="" (set desktop=%%a) else set desktop=%%a %%b
)

REM ��ȡ���Ŀ¼�����ļ������û�������
if exist "%appdata%\fms2.fms" for /f "usebackq delims=" %%i in ("%appdata%\fms2.fms") do set jfrootdir=%%i
set path=%path%;%jfrootdir%

REM ��������������
if /i "%~1"=="StartUp" (
	call:wipedata StartUp
	exit
)

if not exist config\F_Ms-Teacher_TeacherPassword.ini if not exist config\getCloudPWDA_Data.fms (
	ping -n 2 %serveraddress% >nul 2>nul&&(
		echo=���ڴ��ƶ˻�ȡ����...
		pagedown %serveraddress%/F_Ms-Teacher_TeacherPassword.ini config\F_Ms-Teacher_TeacherPassword.ini
	)
	echo=Yes>config\getCloudPWDA_Data.fms
)
if exist config\F_Ms-Teacher_TeacherPassword.ini (
	for /f "tokens=1,2 delims= " %%a in (config\F_Ms-Teacher_TeacherPassword.ini) do (
		set teacherpassword=%%a
		set teacherpasswordwei=%%b
	)
) else (
	set teacherpassword=940D26BE0A635AFA0C9F9AB0FD9945AC
	set teacherpasswordwei=10
)

REM ��⿪��cmd��������
reg query hkcu\console /v loadconime|findstr 0x0>nul
if "%errorlevel%"=="0" (
	echo=>config\chineseon.fms
	call:chineseinput
	if exist config\chineseon.fms del config\chineseon.fms /f /q
	exit
)
if exist config\chineseon.bat del config\chineseon.bat /f /q

REM ������֤
for /f "tokens=2" %%i in ('mode^|findstr ��') do set /a center=%%i/2
for /l %%i in (1,1,%center%) do set space=!space! 
title F_Ms-��ѧ���� - ����������
:reinputpwd
call:noechopwd %teacherpasswordwei% reinputpwdshow
for /f %%a in ('for /f %%i in ^('md5 -d"%pwd%"'^) do @md5 -d%%i') do if /i "%%a"=="%teacherpassword%" (
	cls
	goto beginrun
) else goto reinputpwd
exit

:beginrun
REM ��������
title F_Ms-��ѧ�������ض� %version%

REM �����Ŀ����ʦ
echo=
echo= ____________________F_Ms-��ѧ����______________________
if exist config\localobject.fms for /f "delims=" %%a in (config\localobject.fms) do if not "%%~a"=="" goto writelocalteacher
:writelocalobject
if defined localobject set localobject=
echo=
set /p localobject=���������������������Ŀ����:
if defined localobject (
	set localobject=%localobject: =%
	set localobject=%localobject:\=%
)
if "%localobject%"=="" goto writelocalobject
echo=%localobject% >config\localobject.fms
:writelocalteacher
if exist config\localteacher.fms for /f "delims=" %%a in (config\localteacher.fms) do if not "%%~a"=="" goto writelocaldataover
if defined localteacher set localteacher=
echo=
set /p localteacher=���������������������뽲ʦ����:
if defined localteacher (
	set localteacher=%localteacher: =%
	set localteacher=%localteacher:\=%
)
if "%localteacher%"=="" goto writelocalteacher
echo=%localteacher% >config\localteacher.fms
call:tips �༶��Ŀ����ʦ��Ϣ¼�����
:writelocaldataover

REM ����Ŀ¼����
if not exist ftp md Ftp\Download;Ftp\Upload;ftp\FileSend;Ftp\CommandSend;ftp\ShutLog;ftp\FirstConnect
call:tips ����Ŀ¼������

REM �رձ��������ܿض�
call:addclientoffini

REM ����ip��ֵ����lip,���θ�ֵ��lip2,���ظ�ֵ��lipdg,��⵱ǰ����״��
:getip_restart
for /f "tokens=3,4" %%a in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (
	if "%%b"=="" (
		echo=��⵽����û�з��䵽ip^(δ�����κ�����^)����������������...
		pause>nul
		goto getip_restart
	) else (
		set lip=%%b
		if not "%%a"=="" set lipdg=%%a
		goto getip_over
	)
)
:getip_over
for /f "tokens=1,2,3,4 delims=." %%a in ("%lip%") do set lip2=%%a.%%b.%%c&set lip3=%%d
call:tips ���������ȡ���

REM ѡ���ܿ�����
if exist config\chooseclient.fms goto chooseclientover
:chooseclient
call:ip_userwrite_checkright ���ÿ�������IP�� �����������������IP��
if "%userwriteinputresult%"=="0" (
	echo=��ȷ���ܿ�IP����Ϊ %lip2%.%userwriteinput:"=% ��
	echo=	#�ܿ�IP���������������ܿ�
	choice /n /m "����������Y-�ǣ�N-��"
	if not "!errorlevel!"=="1" goto chooseclient
	set chooseclient=%userwriteinput%
	echo=%userwriteinput%>config\chooseclient.fms
) else (
	goto chooseclient
)
:chooseclientover

REM ��������������ü���
if not exist config\sendnum.fms echo=0 >config\sendnum.fms
call:tips ������ʼ������
reg query "hklm\software\xlight ftp" >nul 2>nul
if not "%errorlevel%"=="0" regedit /s ftpserver\reg.reg
reg query "hklm\system\currentcontrolset\services\xlight ftp server" /v imagepath >nul 2>nul
if not "%errorlevel%"=="0" sc create "Xlight FTP Server" binpath= "%cd%\ftpserver\xlight.exe -runservice" start= demand displayname= "Xlight FTP Server" type= own>nul
reg query "hklm\system\currentcontrolset\services\xlight ftp server" /v type|findstr /i 0x110>nul
if not "%errorlevel%"=="0" reg add "hklm\system\currentcontrolset\services\xlight ftp server" /v Type /t reg_dword /d 0x110 /f >nul 2>nul
call:tips ���������������
for %%a in (localobject localteacher) do (
	if not defined %%a (
		for /f "delims=" %%b in (config\%%a.fms) do set %%a=%%b
	)
)

REM FTP&html&�ļ�ͬ�����������ļ�����
for %%a in (ftpserver\ftpd.users ftpdserver\ftpd.user2 tongbu\mirrordir.ini html\index.html) do if not exist "%%~a_bak" copy "%%~a" "%%~a_bak">nul
REM FTP&html&�ļ�ͬ�����������ļ�·�������޸�
if not exist config\ftpsetting.fms (
	strrpc /i "ForTemp" "%lip2%." /s:ftpserver\ftpd.users /c
	strrpc /i "ForTemp" "%lip2%." /s:ftpserver\ftpd.users2 /c
	strrpc /i "c:\Program Files\F_Ms-Teacher" "%cd%" /s:ftpserver\ftpd.users /c
	strrpc /i "c:\Program Files\F_Ms-Teacher" "%cd%" /s:ftpserver\ftpd.users2 /c
	strrpc /i "C:\Program Files\F_Ms-Teacher" "%cd%" /s:tongbu\mirrordir.ini /c
	strrpc /i "����" "%localobject%" /s:html\index.html /c
	strrpc /i "��" "%localteacher%" /s:html\index.html /c
	strrpc /i "192.168.0" "%lip2%" /s:ftpserver\ftpd.users /c
	strrpc /i "192.168.0" "%lip2%" /s:ftpserver\ftpd.users2 /c
	copy ftpserver\ftpd.users ftpserver\ftpd.users1>nul
)

REM ��ӽ�ѧ����������������
reg add hkcu\software\microsoft\windows\currentversion\run /v F_Ms-Teacher /d "\"%~dp0%~nx0\" StartUp" /f>nul 2>nul

REM ʱ��ͬ������
tasklist|findstr /i "\<timesync.exe\>">nul 2>nul
if not "%errorlevel%"=="0" start "" "timesync" -s
REM if not exist config\timetongbu.fms (
	REM for /f "tokens=4" %%a in ('netstat -ano^|findstr /i "\<UDP\>"^|findstr ":123"') do taskkill /f /im %%a>nul 2>nul
	REM reg add HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient /v SpecialPollInterval /t reg_dword /d 0x12c /f>nul 2>nul
	REM reg add hklm\system\currentcontrolset\services\w32time\config /t REG_DWORD /v announceflags /d 0x5 /f>nul 2>nul
	REM reg add HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters /v Type /d NTP /f>nul 2>nul
	REM reg add HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer /v enabled /t reg_dword /d 0x1 /f>nul 2>nul
	REM reg add HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters /v NtpServer /d 202.120.2.101 /f>nul 2>nul
	REM sc query w32time|find /i "running">nul
	REM if "!errorlevel!"=="0" (
		REM net stop w32time>nul
		REM net start w32time>nul
	REM ) else (
		REM net start w32time>nul
	REM )
	REM w32tm /config /update /manualpeerlist:ntp.fudan.edu.cn /syncfromflags:manual>nul
	REM start mshta vbscript:createobject^("wscript.shell"^).run^("w32tm.exe /resync",0^)^(window.close^)
	REM echo=>config\timetongbu.fms
REM )
call:tips ʱ��ͬ�����

REM �����ƴ���Ŀ¼
if not exist ftp\ClientTempDir (
	md ftp\ClientTempDir
	for /l %%i in (1,1,255) do (
		md ftp\ClientTempDir\%lip2%.%%i
	)
)
call:tips �ƴ���Ŀ¼����ʼ�����

if not exist config\screenshareservice.fms (
	ftpserver\tightvncserver.exe -reinstall -silent
	regedit /s ftpserver\tightvnc_reg.reg
	echo=>config\ScreenShareService.fms
)

REM ����������������ļ�����������
for /f "tokens=5" %%a in ('netstat -ano^|findstr "\<0.0.0.0:80\>"') do (
	for /f "tokens=1 delims=," %%b in ('tasklist /v /nh /fo csv^|findstr "\<%%~a\>"') do if /i "%%~b"=="http.exe" (
		goto checkport52125
	) else (
		taskkill /f /im %%a>nul
	)
)
start mshta vbscript:createobject("wscript.shell").run("http.exe html 80",0)(window.close)
:httpserverpidwrite
netstat -ano|findstr "\<0.0.0:80\>">nul
if "!errorlevel!"=="0" (
	for /f "tokens=5" %%a in ('netstat -ano^|findstr "\<0.0.0.0:80\>"') do echo=%%a>config\httpserverpid.fms
) else (
	ping -n 2 127.0>nul
	goto httpserverpidwrite
)
call:tips Web������״��������
:checkport52125
for /f "tokens=5" %%a in ('netstat -ano^|findstr "\<0.0.0.0:52125\>"') do (
	for /f "tokens=1 delims=," %%b in ('tasklist /v /nh /fo csv^|findstr "\<%%~a\>"') do if /i "%%~b"=="xlight.exe" (
		goto checkport52125over
	) else (
		taskkill /f /im %%a>nul
	)
)
sc start "xlight ftp server">nul
echo=>config\serverlocalconfig.fms
call:tips ������״��������
:checkport52125over

REM ���ƶ˻�ȡ���ο�
if not exist ftp\commandsend\ProgramKuUpdate.rar if not exist config\getCloudKu_Data.fms (
	ping -n 2 %serveraddress% >nul 2>nul&&(
		call:tips ���ڴ��ƶ˻�ȡ���ο��ļ�
		pagedown %serveraddress%/F_Ms-Teacher_ProgramKu.rar ftp\commandsend\ProgramKuUpdate.rar
	)
	echo=Yes>config\getCloudKu_Data.fms
)

REM ��������֤md5��֤д��
if exist config\servercheckrightmd5.fms goto servercheckrightmd5over
call:tips ������֤��������֤�ļ�
:servercheckrightmd5
for %%a in (servercheckrightmd5temp servercheckrightmd5) do if defined %%a set %%a=
for /f %%a in ('md5 -dF_Ms%lip%L_Xm') do if "%%~a"=="" (goto servercheckrightmd5) else set servercheckrightmd5temp=%%~a
for /f %%a in ('md5 -dL_Xm%servercheckrightmd5temp%F_Ms') do if "%%~a"=="" (goto servercheckrightmd5) else set servercheckrightmd5=%%~a
echo=%servercheckrightmd5%>config\servercheckrightmd5.fms
:servercheckrightmd5over

REM д�����������Ŀָ����ʦ����֤�ļ�
for %%a in (localobject localteacher chooseclient servercheckrightmd5) do (
	if not defined %%a (
		for /f "delims=" %%b in (config\%%a.fms) do set %%a=%%b
	)
)
if exist ftp\commandsend\servercheckright.fms for /f "tokens=1,2,3,4" %%a in (ftp\commandsend\servercheckright.fms) do if /i "%%~a"=="%servercheckrightmd5%" if /i "%%~b"=="%chooseclient%" if /i "%%~c"=="%localobject%" if /i "%%~d"=="%localteacher%" goto writeservercheckrightover
echo=%servercheckrightmd5% %chooseclient% %localobject% %localteacher% >ftp\commandsend\ServerCheckRight.fms
:writeservercheckrightover
call:tips ��������֤������


REM ������ǰip��ʾ
if not exist config\firststartserver.fms (
	REM �������汳��
	call:changelocalscreen
	
	call:flashmessage tips2 ��ӭ����%localteacher%��ʦ ��ѧ�������ض˿����ɹ�
	start "" "teacherhelp.exe"
	echo=>config\firststartserver.fms
)

call:createdesktopfileserverlnk

REM �������漰�û������ж�
:reshow
cls&set programgroup=reshow
set key1=
call:createdesktopfileserverlnk
if not defined chooseclient for /f "delims=" %%a in (config\chooseclient.fms) do set chooseclient=%%a
echo=
echo= ____________________F_Ms-��ѧ����______________________
echo=
call:echotips
echo=                       1.�������
echo=                       2.�������
echo=
echo=                       3.��Ϣ����
echo=                       4.�ļ�����
echo=                       5.�رջ���
echo=                       6.��Ļ����
echo=
echo=                       7.��������
echo=                       8.�����̳�
echo=
echo= _______________________________________________________
echo=   L.��ʱ����������  C.���Ŀ�������  E.�رղ�ֹͣ������
echo=
set /p key1=�����������������ţ��س�ȷ�ϣ�
if "%key1%"=="" (goto %programgroup%) else set key1=%key1:~0,1%
if /i "%key1%"=="l" goto lockserver
if /i "%key1%"=="e" (
	echo=ע�⣡����������ᵼ�������ܿض�ʧȥ���Ʋ������������
	choice /n /m "���������Ƿ�ȷ��? Y-�ǣ�N-��"
	if "!errorlevel!"=="1" (
		call:noechopwd %teacherpasswordwei% reinputpwdshow exitserver
		REM ��֤���������Ƿ���ȷ
		for /f %%a in ('for /f %%i in ^('md5 -d!pwd!'^) do @md5 -d%%i') do if "%%~a"=="%teacherpassword%" (
			call:wipedata
			start /min cmd /c start /wait mshta vbscript:msgbox^("��ѧ�������������˳��������ܿض��ϴ��ļ���Ҫ�����ɴӵ��ȷ���󵯳����ļ����н��ܿض��ϴ����ݿ��������豸��Ŀ¼",64,"��ʾ"^)^(window.close^)^&start /max explorer "%cd%\ftpbackup"
			call:flashmessage tips2 �ټ���%localteacher%��ʦ ��ӭ�´�ʹ��
			exit /b
		) else (
			set tips=�����������������
			goto %programgroup%
		)
	) else (
		goto %programgroup%
	)
)
if /i "%key1%"=="c" (
	call:ip_userwrite_checkright ��ǰ��������Ϊ��"%lip2%.!chooseclient:"=!" ԭ���������ڼ������������Ż��������
	if "!userwriteinputresult!"=="0" (
		choice /n /m "ȷ�Ͻ��ܿ��������Ϊ%lip2%.!userwriteinput:"=!?Y-�ǣ�N-��"
		if not "!errorlevel!"=="1" (
			set tips=�û���ȡ���޸Ŀ�������
			goto reshow
		)
		call:noechopwd %teacherpasswordwei% reinputpwdshow chooseclient
		for /f %%a in ('for /f %%i in ^('md5 -d"!pwd!"'^) do @md5 -d%%i') do if /i not "%%a"=="%teacherpassword%" (
			set tips=�����������������
			goto reshow
		)
		set chooseclient=!userwriteinput!
		echo=!userwriteinput!>config\chooseclient.fms
		for %%a in (localobject localteacher chooseclient servercheckrightmd5) do (
			if not defined %%a (
				for /f "delims=" %%b in (config\%%a.fms) do set %%a=%%b
			)
		)
		echo=!servercheckrightmd5! !chooseclient! !localobject! !localteacher! >ftp\commandsend\ServerCheckRight.fms
		set tips=�ѳɹ����Ŀ�������IP��Ϊ��%lip2%.!chooseclient:"=!
	)
	goto %programgroup%
)
if "%key1%"=="1" goto programcontrolmenu
if "%key1%"=="2" goto unopenurlmenu
if "%key1%"=="3" goto messagesend
if "%key1%"=="4" goto fileupdownmenu
if "%key1%"=="5" goto shutdownclient
if "%key1%"=="6" goto screenshare
if "%key1%"=="7" goto othermenu
if "%key1%"=="8" start "" "teacherhelp.exe"
if defined key1 goto %programgroup%

REM ��Ļ���� ʹ�÷�����goto screenshare
:screenshare
sc query "tvnserver"|findstr /i "\<RUNNING\>">nul
if "%errorlevel%"=="0" (
	if not exist config\screenshareon.fms echo=>config\screenshareon.fms
) else (
	for %%a in (screenshareon screenshareb2cc screenshareb2c) do if exist config\%%a.fms del /f /q config\%%a.fms
	if exist config\screenshareon.fms del /f /q config\screenshareon.fms
)
set key12=&set programgroup=screenshare
for %%a in (screenshareip screenshareip2 screenshareip3 localscreenshare screenshareconnect screenshareallreday) do if defined %%a set %%a=
for %%A in (screensharec2cc screensharec2c screenshareb2ccontrol screensharec2ccontrol) do if exist config\%%A.fms for /f "delims=" %%a in (config\%%A.fms) do set localscreenshare=%%a
cls
echo=
echo= _______________________��Ļ����________________________
echo=
call:echotips
if exist config\screenshareon.fms (
	if exist config\screenshareb2cc.fms (
		echo=    1.�رչ�������Ļ��ָ���ܿض�[ǿ��]^(�ѿ���^)
	) else echo=    1.��������Ļ��ָ���ܿض�[ǿ��]^(δ����^)
) else echo=    1.��������Ļ��ָ���ܿض�[ǿ��]^(δ����^)
if exist config\screenshareon.fms (
	if exist config\screenshareb2c.fms (
		echo=    2.�رչ�������Ļ��ָ���ܿض�[����]^(�ѿ���^)
	) else echo=    2.��������Ļ��ָ���ܿض�[����]^(δ����^)
) else echo=    2.��������Ļ��ָ���ܿض�[����]^(δ����^)
echo=
if exist config\screensharec2cc.fms (
	echo=    3.�رչ���ָ���ܿض���Ļ�������ܿض�[ǿ��]^(�ѿ���^)
) else echo=    3.����ָ���ܿض���Ļ�������ܿض�[ǿ��]^(δ����^)
if exist config\screensharec2c.fms (
	echo=    4.�رչ���ָ���ܿض���Ļ�������ܿض�[����]^(�ѿ���^)
) else echo=    4.����ָ���ܿض���Ļ�������ܿض�[����]^(δ����^)
echo=
if exist config\screenshareb2ccontrol.fms (
	echo=    5.�رձ���Զ��Э��ָ���ܿض�^(�ѿ���^)
) else echo=    5.����Զ��Э��ָ���ܿض�^(δ����^)
if exist config\screensharec2ccontrol.fms (
	echo=    6.�ر�ָ���ܿض�Զ��Э��ָ�������ܿض�^(�ѿ���^)
) else echo=    6.ָ���ܿض�Զ��Э��ָ�������ܿض�^(δ����^)
if defined localscreenshare (
	echo=
	echo=    7.���ӵ���ǰ������Ļ��Զ��Э���ܿض�:%localscreenshare%
)
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p key12=������ţ�
if "%key12%"=="" (goto %programgroup%) else set key12=%key12:~0,1%
if "%key12%"=="0" goto reshow
if "%key12%"=="1" (
	for %%a in (screenshareb2c screensharec2cc screensharec2c screenshareb2ccontrol screensharec2ccontrol) do if exist config\%%a.fms set screenshareallreday=screenshareallreday
	if defined screenshareallreday (
		set tips=��ǰ������Ļ������������Ҫ�����µ���Ļ��������֮ǰ��رյ�ǰ��Ļ��������
		goto %programgroup%
	)
	if exist config\screenshareb2cc.fms (
		choice /n /m ��ȷ��Ҫȡ��������Ļ������?Y-�ǣ�N-��
		if not "!errorlevel!"=="1" goto %programgroup%
		echo=��Ļ�������ڹر�...
		net stop tvnserver>nul
		for %%a in (screenshareon screenshareb2cc) do if exist config\%%a.fms del /f /q config\%%a.fms
		set tips=ȡ����Ļ����ɹ����ܿض˽���30�����Զ��Ͽ�����
	) else (
		if defined programbody set programbody=
		call:ip_userwrite_checkright ������Ļǿ�ƹ�����ܿض� �����뱻ǿ�ƽ�����Ļ�����ܿض�IPβֵ
		if not defined userwriteinputresult goto %programgroup%
		if "!userwriteinputresult!"=="1" goto %programgroup%
		if not "!userwriteinputresult!"=="0" goto %programgroup%
		choice /n /m ��ȷ��Ҫǿ�ƹ�������Ļ��?Y-�ǣ�N-��
		if not "!errorlevel!"=="1" goto %programgroup%
		echo=��Ļ�������ڿ���...
		net start tvnserver>nul
		set programbody=%lip%
		call:commandsend2 screenshare !programbody! !userwriteinput! con
		for %%a in (screenshareon screenshareb2cc) do if not exist config\%%a.fms echo=>config\%%a.fms
		set tips=������Ļ����ɹ����ܿض˽�½������
		call:flashmessage tips2 �����ѱ�������Ļ���� ��΢Ц:��
	)
)
if "%key12%"=="2" (
	for %%a in (screenshareb2cc screensharec2cc screensharec2c screenshareb2ccontrol screensharec2ccontrol) do if exist config\%%a.fms set screenshareallreday=screenshareallreday
	if defined screenshareallreday (
		set tips=��ǰ������Ļ������������Ҫ�����µ���Ļ��������֮ǰ��رյ�ǰ��Ļ��������
		goto %programgroup%
	)
	if exist config\screenshareb2c.fms (
		choice /n /m ��ȷ��Ҫȡ��������Ļ������?Y-�ǣ�N-��
		if not "!errorlevel!"=="1" goto %programgroup%
		echo=��Ļ�������ڹر�...
		net stop tvnserver>nul
		for %%a in (screenshareon screenshareb2c) do if exist config\%%a.fms del /f /q config\%%a.fms
		set tips=ȡ����Ļ����ɹ�
	) else (
		if defined programbody set programbody=
		call:ip_userwrite_checkright ������Ļ������ܿض� �����������Ļ�����ܿض�IP
		if not defined userwriteinputresult goto %programgroup%
		if "!userwriteinputresult!"=="1" goto %programgroup%
		if not "!userwriteinputresult!"=="0" goto %programgroup%
		choice /n /m ��ȷ��Ҫ��������Ļ��?Y-�ǣ�N-��
		if not "!errorlevel!"=="1" goto %programgroup%
		echo=��Ļ�������ڿ���...
		net start tvnserver>nul
		set programbody=%lip%
		call:commandsend2 screenshare !programbody! !userwriteinput!
		for %%a in (screenshareon screenshareb2c) do if not exist config\%%a.fms echo=>config\%%a.fms
		set tips=������Ļ����ɹ����ܿض˽�½������
		call:flashmessage tips2 �����ѱ�������Ļ���� ��΢Ц:��
	)
)
if "%key12%"=="3" (
	for %%a in (screenshareb2cc screenshareb2c screensharec2c screenshareb2ccontrol screensharec2ccontrol) do if exist config\%%a.fms set screenshareallreday=AllReady
	if defined screenshareallreday (
		set tips=��ǰ������Ļ������������Ҫ�����µ���Ļ��������֮ǰ��رյ�ǰ��Ļ��������
		goto %programgroup%
	)
	if exist config\screensharec2cc.fms (
		for /f "delims=" %%a in (config\screensharec2cc.fms) do (
			choice /n /m ��ȷ��Ҫȡ��%%a��Ļ������?Y-�ǣ�N-��
			if not "!errorlevel!"=="1" goto %programgroup%
			if defined programbody set programbody=
			echo=������%%a���͹ر���Ļ��������...
			set programbody=unscreenshare
			call:commandsend2 screenshare !programbody! %%a
			for %%a in (screenshareon screensharec2cc) do if exist config\%%a.fms del /f /q config\%%a.fms
			set tips=�ɹ���%%a���͹ر���Ļ��������
		)
	) else (
		if defined programbody set programbody=
		call:ip_userwrite_checkright ����ָ���ܿض���Ļ��ָ���ܿض� ������Ҫ������Ļ��IPβֵ #check1 checkconnect
		if not defined userwriteinputresult goto %programgroup%
		if "!userwriteinputresult!"=="1" goto %programgroup%
		if not "!userwriteinputresult!"=="0" goto %programgroup%
		set screenshareip=%lip2%.!userwriteinput!
		call:ip_userwrite_checkright ����ָ���ܿض���Ļ��ָ���ܿض� �����뱻ǿ�ƽ�����Ļ�����IPβֵ
		if not defined userwriteinputresult goto %programgroup%
		if "!userwriteinputresult!"=="1" goto %programgroup%
		if not "!userwriteinputresult!"=="0" goto %programgroup%
		choice /n /m ��ȷ��Ҫǿ�ƹ����ܿض�!screenshareip:"=!����Ļ��?Y-�ǣ�N-��
		if not "!errorlevel!"=="1" goto %programgroup%
		echo=��Ļ�������ڿ���...
		set programbody=!screenshareip:"=!
		call:commandsend2 screenshare !programbody! !userwriteinput! con
		if not exist config\screenshareon.fms echo=>config\screenshareon.fms
		if not exist config\screensharec2cc.fms echo=!programbody!>config\screensharec2cc.fms
		call:screenshareconnect ���Ƿ���Ҫ���ӵ��ܿض˹�����Ļ!programbody!?Y-�ǣ�N-�� !programbody! view
		set tips=����!programbody:"=!�ܿض���Ļǿ�ƹ���ɹ���ָ���ܿض˽�½������
	)
)
if "%key12%"=="4" (
	for %%a in (screenshareb2cc screenshareb2c screensharec2cc screenshareb2ccontrol screensharec2ccontrol) do if exist config\%%a.fms set screenshareallreday=screenshareallreday
	if defined screenshareallreday (
		set tips=��ǰ������Ļ������������Ҫ�����µ���Ļ��������֮ǰ��رյ�ǰ��Ļ��������
		goto %programgroup%
	)
	if exist config\screensharec2c.fms (
		for /f "delims=" %%a in (config\screensharec2c.fms) do (
			choice /n /m ��ȷ��Ҫȡ��%%a��Ļ������?Y-�ǣ�N-��
			if not "!errorlevel!"=="1" goto %programgroup%
			if defined programbody set programbody=
			echo=������%%a���͹ر���Ļ��������...
			set programbody=unscreenshare
			call:commandsend2 screenshare !programbody! %%a
			for %%a in (screenshareon screensharec2c) do if exist config\%%a.fms del /f /q config\%%a.fms
			set tips=�ɹ���%%a���͹ر���Ļ��������
		)
	) else (
		if defined programbody set programbody=
		call:ip_userwrite_checkright ����ָ���ܿض���Ļ��ָ���ܿض� ������Ҫ������Ļ��IPβֵ #check1 checkconnect
		if not defined userwriteinputresult goto %programgroup%
		if "!userwriteinputresult!"=="1" goto %programgroup%
		if not "!userwriteinputresult!"=="0" goto %programgroup%
		set screenshareip=%lip2%.!userwriteinput!
		call:ip_userwrite_checkright ����ָ���ܿض���Ļ��ָ���ܿض� �����뱻������Ļ�����IPβֵ
		if not defined userwriteinputresult goto %programgroup%
		if "!userwriteinputresult!"=="1" goto %programgroup%
		if not "!userwriteinputresult!"=="0" goto %programgroup%
		choice /n /m ��ȷ��Ҫǿ�ƹ����ܿض�!screenshareip:"=!����Ļ��?Y-�ǣ�N-��
		if not "!errorlevel!"=="1" goto %programgroup%
		echo=��Ļ�������ڿ���...
		set programbody=!screenshareip:"=!
		call:commandsend2 screenshare !programbody! !userwriteinput!
		if not exist config\screenshareon.fms echo=>config\screenshareon.fms
		if not exist config\screensharec2c.fms echo=!programbody!>config\screensharec2c.fms
		call:screenshareconnect ���Ƿ���Ҫ���ӵ��ܿض˹�����Ļ!programbody!?Y-�ǣ�N-�� !programbody! view
		set tips=����!programbody:"=!�ܿض���Ļ����ɹ���ָ���ܿض˽�½������
	)
)
if "%key12%"=="5" (
	for %%a in (screenshareb2cc screenshareb2c screensharec2cc screensharec2c screensharec2ccontrol) do if exist config\%%a.fms set screenshareallreday=AllReady
	if defined screenshareallreday (
		set tips=��ǰ������Ļ������������Ҫ�����µ���Ļ��������֮ǰ��رյ�ǰ��Ļ��������
		goto %programgroup%
	)
	if exist config\screenshareb2ccontrol.fms (
		for /f "delims=" %%a in (config\screenshareb2ccontrol.fms) do (
			choice /n /m ��ȷ��Ҫ�رն�%%a��Զ��Э����?Y-�ǣ�N-��
			if not "!errorlevel!"=="1" goto %programgroup%
			if defined programbody set programbody=
			echo=������%%a���͹ر�Զ��Э������...
			set programbody=unscreenshare
			call:commandsend2 screenshare !programbody! %%a
			for %%a in (screenshareb2ccontrol) do if exist config\%%a.fms del /f /q config\%%a.fms
			set tips=�ɹ���%%a���͹ر�Զ��Э������
		)
	) else (
		if defined programbody set programbody=
		call:ip_userwrite_checkright ���ܿض˷���Զ��Э�� ������ҪԶ�̿����ܿض�IPβֵ #check1 checkconnect
		if not defined userwriteinputresult goto %programgroup%
		if "!userwriteinputresult!"=="1" goto %programgroup%
		if not "!userwriteinputresult!"=="0" goto %programgroup%
		choice /n /m ��ȷ��ҪԶ��Э���ܿض�%lip2%.!userwriteinput:"=!��?Y-�ǣ�N-��
		if not "!errorlevel!"=="1" goto %programgroup%
		echo=��Ļ�������ڿ���...
		set programbody=%lip2%.!userwriteinput:"=!
		call:commandsend2 screenshare !programbody! !programbody!
		if not exist config\screenshareb2ccontrol.fms echo=!programbody!>config\screenshareb2ccontrol.fms
		call:screenshareconnect #nochoose !programbody! control
		set tips=Զ��Э���ܿض�!programbody!����ͳɹ��������������´���
	)
)
if "%key12%"=="6" (
	for %%a in (screenshareb2cc screenshareb2c screensharec2cc screensharec2c screenshareb2ccontrol) do if exist config\%%a.fms set screenshareallreday=AllReady
	if defined screenshareallreday (
		set tips=��ǰ������Ļ������������Ҫ�����µ���Ļ��������֮ǰ��رյ�ǰ��Ļ��������
		goto %programgroup%
	)
	if exist config\screensharec2ccontrol.fms (
		for /f "delims=" %%a in (config\screensharec2ccontrol.fms) do (
			choice /n /m ��ȷ��Ҫ�ر�ָ���ͻ��˶�%%a��Զ��Э����?Y-�ǣ�N-��
			if not "!errorlevel!"=="1" goto %programgroup%
			if defined programbody set programbody=
			echo=������%%a���͹ر�Զ��Э������...
			set programbody=unscreenshare
			call:commandsend2 screenshare !programbody! %%a
			for %%a in (screensharec2ccontrol) do if exist config\%%a.fms del /f /q config\%%a.fms
			set tips=�ɹ���%%a���͹ر�Զ��Э������
		)
	) else (
		if defined programbody set programbody=
		call:ip_userwrite_checkright ָ���ܿض����ܿض˷���Զ��Э�� ������Э�����ܿض�IPβֵ #check1 checkconnect
		if not defined userwriteinputresult goto %programgroup%
		if "!userwriteinputresult!"=="1" goto %programgroup%
		if not "!userwriteinputresult!"=="0" goto %programgroup%
		set screenshareip=%lip2%.!userwriteinput:"=!
		set screenshareip3=!userwriteinput!
		call:ip_userwrite_checkright ָ���ܿض����ܿض˷���Զ��Э�� �����뱻Э������IPβֵ #check1 checkconnect
		if not defined userwriteinputresult goto %programgroup%
		if "!userwriteinputresult!"=="1" goto %programgroup%
		if not "!userwriteinputresult!"=="0" goto %programgroup%
		set screenshareip2=%lip2%.!userwriteinput:"=!
		if "!screenshareip!"=="!screenshareip2!" (
			echo=����Э����IP�뱻Э����IP��ͬ��������
			pause>nul
			goto %programgroup%
		)
		choice /n /m ��ȷ��Ҫ!screenshareip!Э��!screenshareip2!��?Y-�ǣ�N-��
		if not "!errorlevel!"=="1" goto %programgroup%
		echo=��Ļ�������ڿ���...
		set programbody=!screenshareip2!
		call:commandsend2 screenshare !programbody! !screenshareip3! control
		if not exist config\screensharec2ccontrol.fms echo=!programbody!>config\screensharec2ccontrol.fms
		call:screenshareconnect ���Ƿ���Ҫ���ӵ��ܿض˹�����Ļ!programbody!?Y-�ǣ�N-�� !programbody! view
		set tips=�ܿض�!screenshareip2!Զ��Э��!screenshareip!����ͳɹ�
	)
)
if "%key12%"=="7" (
	if defined localscreenshare (
		if exist config\screenshareb2ccontrol.fms (
			start vncviewer.exe !localscreenshare!:52122 /shared /notoolbar /password %screenshareadminpassword% /nostatus /autoreconnect 5
		) else start vncviewer.exe !localscreenshare!:52122 /shared /viewonly /notoolbar /password %screensharepassword% /nostatus /autoreconnect 5
	)
)
if defined key12 goto %programgroup%

REM ��Ļ����ѯ���Ƿ����� ʹ�÷�����call:screenshareconnect choice��ʾ���� ����IP view|control
:screenshareconnect
if "%~1"=="" goto :eof
if "%~2"=="" goto :eof
if "%~1"=="#nochoose" (
	ping -n 6 127.0.0.1>nul
	goto screenshareconnect2
)
choice /n /m %~1
if not "!errorlevel!"=="1" goto :eof
ping -n 6 127.0.0.1>nul
:screenshareconnect2
portqry -n %~2 -e 52122 -q
if "!errorlevel!"=="0" (
	if "%~3"=="" start vncviewer.exe %~2:52122 /shared /viewonly /notoolbar /password %screensharepassword% /nostatus /autoreconnect 5
	if /i "%~3"=="view" start vncviewer.exe %~2:52122 /shared /viewonly /notoolbar /password %screensharepassword% /nostatus /autoreconnect 5
	if /i "%~3"=="control" start vncviewer.exe %~2:52122 /shared /notoolbar /password %screenshareadminpassword% /nostatus /autoreconnect 5
) else (
	set /a screenshareconnect+=1
	echo=��!screenshareconnect!�γ�����������
	if !screenshareconnect! gtr 5 (set tips=���ӳ�ʱ) else goto screenshareconnect2
)
goto :eof

REM ������ƽ����жϽ���
:programcontrolmenu
cls
set key12=&set programgroup=programcontrolmenu
echo=
echo= _______________________�������________________________
echo=
call:echotips
if exist config\gamecontrol.fms (
	echo=               1.������γ�����Ϸ���^(������^)
) else (
	echo=               1.���γ�����Ϸ���^(δ����^)
)
if exist config\mediacontrol.fms (
	echo=               2.������γ�����Ƶ���^(������^)
) else (
	echo=               2.���γ�����Ƶ���^(δ����^)
)
if exist config\musiccontrol.fms (
	echo=               3.������γ����������^(������^)
) else (
	echo=               3.���γ����������^(δ����^)
)
if exist config\chatcontrol.fms (
	echo=               4.������γ����������^(������^)
) else (
	echo=               4.���γ����������^(δ����^)
)
if exist config\browsercontrol.fms (
	echo=               5.������γ�����������^(������^)
) else (
	echo=               5.���γ�����������^(δ����^)
)
echo=
echo=               6.����ָ������
echo=               7.�������ָ������
echo=
echo=               8.�����ܿض�ָ������
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p key12=������ţ�
if "%key12%"=="" (goto %programgroup%) else set key12=%key12:~0,1%
if "%key12%"=="0" goto reshow
if "%key12%"=="1" (
	if exist config\gamecontrol.fms (
		del config\gamecontrol.fms /f /q
		call:commandsend gamecontrol off
		set tips=�ɹ�������γ�����Ϸ���
	) else (
		echo=>config\gamecontrol.fms
		call:commandsend gamecontrol on
		set tips=�ɹ����γ�����Ϸ���
	)
)
if "%key12%"=="2" (
	if exist config\mediacontrol.fms (
		del config\mediacontrol.fms /f /q
		call:commandsend mediacontrol off
		set tips=�ɹ�������γ�����Ƶ���
	) else (
		echo=>config\mediacontrol.fms
		call:commandsend mediacontrol on
		set tips=�ɹ����γ�����Ƶ���
	)
)

if "%key12%"=="3" (
	if exist config\musiccontrol.fms (
		del config\musiccontrol.fms /f /q
		call:commandsend musiccontrol off
		set tips=�ɹ�������γ����������
	) else (
		echo=>config\musiccontrol.fms
		call:commandsend musiccontrol on
		set tips=�ɹ����γ����������
	)
)
if "%key12%"=="4" (
	if exist config\chatcontrol.fms (
		del config\chatcontrol.fms /f /q
		call:commandsend chatcontrol off
		set tips=�ɹ�������γ����������
	) else (
		echo=>config\chatcontrol.fms
		call:commandsend chatcontrol on
		set tips=�ɹ����γ����������
	)
)
if "%key12%"=="5" (
	if exist config\browsercontrol.fms (
		del config\browsercontrol.fms /f /q
		call:commandsend browsercontrol off
		set tips=�ɹ�������γ�����������
	) else (
		echo=>config\browsercontrol.fms
		call:commandsend browsercontrol on
		set tips=�ɹ����γ�����������
	)
)
if "%key12%"=="6" goto programcontroljia
if "%key12%"=="7" goto programcontroljian
if "%key12%"=="8" goto killprocess
if "%key12%"=="9" goto %programgroup%
if defined key12 goto %programgroup%

REM �ļ��ϴ����ط���˵�
:fileupdownmenu
fc /b ftpserver\ftpd.users2 ftpserver\ftpd.users>nul
if "%errorlevel%"=="0" (echo=>config\uploadfiledownload.fms) else if exist config\uploadfiledownload.fms del config\uploadfiledownload.fms /f /q
cls
set key12=&set programgroup=fileupdownmenu
echo=
echo= _______________________�ļ�����________________________
echo=
call:echotips
echo=                 1.�򿪹��ܿض�����Ŀ¼
echo=                 2.�򿪹��ܿض��ϴ�Ŀ¼
echo=                 3.���ܿض��ƴ���Ŀ¼
echo=
echo=                 4.�ļ����͵��ܿض�����
echo=                 5.�ļ����Ͳ�ִ��
echo=
if exist config\uploadfiledownload.fms (
	echo=                 6.��ֹ�ܿض��ϴ����ļ�������^(������^)
) else (
	echo=                 6.�����ܿض��ϴ����ļ�������^(�ѽ�ֹ^)
)
echo=                 7.�ļ�ͬ������
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p key12=������ţ�
if "%key12%"=="" (goto %programgroup%) else set key12=%key12:~0,1%
if "%key12%"=="0" goto reshow
if "%key12%"=="1" explorer "%cd%\ftp\download"
if "%key12%"=="2" explorer "%cd%\ftp\upload"
if "%key12%"=="3" goto clientclouddir
if "%key12%"=="4" goto filesend
if "%key12%"=="5" goto filesendrun
if "%key12%"=="6" (
	if not exist config\uploadfiledownload.fms (
		copy ftpserver\ftpd.users2 ftpserver\ftpd.users>nul
		echo=���ڿ��������Ժ�...
		call:resetftpserver
		set tips=�ɹ������ܿض��ϴ�Ŀ¼��������
	) else (
		copy ftpserver\ftpd.users1 ftpserver\ftpd.users>nul
		echo=���ڽ�ֹ�����Ժ�...
		call:resetftpserver
		set tips=�ɹ��ر��ܿض��ϴ�Ŀ¼��������
	)
)
if "%key12%"=="7" (
	start "" tongbu\mirrordir.exe
	set tips=�ѳɹ����ļ�ͬ�����֣���ע���³��򴰿�
	goto reshow
	
)
if "%key12%"=="8" goto %programgroup%
if "%key12%"=="9" goto %programgroup%
if defined key12 goto %programgroup%

REM �������ܲ˵�
:othermenu
sc query "xlight ftp server"|findstr /i "\<RUNNING\>">nul
if not "%errorlevel%"=="0" (
	if exist "config\serverlocalconfig.fms" del "config\serverlocalconfig.fms" /f /q
) else (
	echo=>"config\serverlocalconfig.fms"
)
cls
set key12=&set programgroup=othermenu
echo=
echo= _______________________��������________________________
echo=
call:echotips
REM if exist config\shutudisk.fms (
	REM echo=                 1.ȡ����ֹ���ƶ�����^(�ѿ���^)
REM ) else (
	REM echo=                 1.��ֹ���ƶ�����^(δ����^)
REM )
REM echo=
echo=                 1.�鿴���ӹ����ܿض�IP
echo=                 2.�鿴����������־
echo=
echo=                 3.���ָ���ܿض��ܿ�
echo=                 4.ftp����������
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p key12=������ţ�
if "%key12%"=="" (goto %programgroup%) else set key12=%key12:~0,1%
if "%key12%"=="0" goto reshow
REM if "%key12%"=="1" (
	REM if exist config\shutudisk.fms (
		REM del config\shutudisk.fms /f /q
		REM call:commandsend shutudisk off
		REM set tips=�ɹ�ȡ����ֹU�̹���
	REM ) else (
		REM echo=>config\shutudisk.fms
		REM call:commandsend shutudisk on
		REM set tips=�ɹ���ֹU�̹���
	REM )
REM )
if "%key12%"=="1" (
	dir /b ftp\firstconnect|findstr fms||set tips=�����ܿض�����&&goto %programgroup%
	if exist config\connectedclient.fms del config\connectedclient.fms /f /q
	cls&echo=                     ���ӹ����ܿض�IP&echo=
	for /f "delims=" %%i in ('dir /b ftp\firstconnect') do echo=    IP:  %lip2%.%%~ni         �ո����һҳ���س�����һ��>>config\ConnectedClient.fms
	type config\ConnectedClient.fms|sort|more&echo=                  ---�����������---&pause>nul
)
if "%key12%"=="2" (
	if exist run.log (
		copy run.log "%temp%\">nul
		start /max notepad.exe "%temp%\run.log"
		goto reshow
	) else (
		set tips=����δ�����͹�����
		goto %programgroup%
	)
)
if "%key12%"=="3" (
	goto cuttheclient
)
if "%key12%"=="4" (
	if not exist config\serverlocalconfig.fms (
		set tips=Ftp����������ֻ���ڷ��������������ʹ��
	) else (
		start ftpserver\xlight.exe
		set tips=�ɹ���Ftp���������ƣ���ע���´���
		goto reshow
	)
)
if "%key12%"=="5" goto %programgroup%
if "%key12%"=="6" goto %programgroup%
if "%key12%"=="7" goto %programgroup%
if "%key12%"=="8" goto %programgroup%
if "%key12%"=="9" goto %programgroup%
if defined key12 goto %programgroup%

REM ���ӽ�ֹ���г���
:programcontroljia
cls&set programgroup=
set programgroup=programcontroljia&set programbody=&set quchuyinhao=
echo=
echo= ___________________ָ�������ֹ����____________________
echo=
echo=              ��������Ҫ��ֹ���еĳ�������
echo=      ��һ�����������������������֮���ÿո����
echo=         ������������ո�����Ӣ��������ס������
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p programbody=��������
set quchuyinhao=%programbody%
echo=%quchuyinhao%|find """">nul
if "%errorlevel%"=="0" set quchuyinhao=%quchuyinhao:"=%
if "%quchuyinhao%"=="0" goto reshow
if "%quchuyinhao%"=="" (goto %programgroup%) else call:commandsend %programgroup% %programbody%
set tips=�ɹ����ͽ�ֹ�������%programbody%
goto reshow

REM ���ٽ�ֹ���г���
:programcontroljian
cls&set programgroup=
set programgroup=programcontroljian&set programbody=&set quchuyinhao=
echo=
echo= ____________________��������ֹ����___________________
echo=
echo=            ��������Ҫ�����ֹ���еĳ�������
echo=      ��һ�����������������������֮���ÿո����
echo=         ������������ո�����Ӣ��������ס������
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p programbody=��������
set quchuyinhao=%programbody%
echo=%quchuyinhao%|find """">nul
if "%errorlevel%"=="0" set quchuyinhao=%quchuyinhao:"=%
if "%quchuyinhao%"=="0" goto reshow
if "%quchuyinhao%"=="" (goto %programgroup%) else call:commandsend %programgroup% %programbody%
set tips=�ɹ����ͽ����ֹ�������%programbody%
goto reshow

REM ɱ����
:killprocess
cls&set programgroup=
set programgroup=killprocess&set programbody=&set quchuyinhao=
echo=
echo= ____________________�����ܿض˽���_____________________
echo=
echo=             ��������Ҫ�����ܿض˵Ľ�������
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p programbody=��������
echo=%programbody%|find """">nul
if "%errorlevel%"=="0" set programbody=%programbody:"=%
if "%programbody%"=="" goto %programgroup%
set programbody=%programbody:"=%
if "%programbody%"=="0" goto reshow
echo=%programbody%|findstr /i "\<cmd.exe\>">nul
if "%errorlevel%"=="0" (
	echo=�ݲ�֧�ֽ����˽���
	pause
	goto %programgroup%
)
set programbody="%programbody%"
call:ip_userwrite_checkright �����ܿض˽��� %programbody%
if not defined userwriteinputresult goto %programgroup%
if "%userwriteinputresult%"=="1" goto %programgroup%
if not "%userwriteinputresult%"=="0" goto %programgroup%
call:localtime
call:commandsend2 %programgroup% %programbody% %userwriteinput% %localtime%
set tips=�ɹ����ͽ����������%programbody% %lip2%.%userwriteinput:"=%
goto reshow

REM �ļ����͵��ܿض�
:filesend
cls&set programgroup=
set programgroup=filesend&set programbody=
echo=
echo= _________________�����ļ����ܿض�����__________________
echo=
echo=        ��ֱ�ӽ���Ҫ���͵��ļ�����˴���,�س�ȷ��
echo=       һ��ֻ�ܷ���һ���ļ����ļ��з��ͻ���ʾѹ��
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p programbody=�뽫�����͵��ļ��Ϸŵ��˴���
if ^"%programbody%^"=="" goto %programgroup%
if ^"%programbody%^"=="0" goto reshow
for /f "usebackq delims=" %%a in ('%programbody%') do set programbody="%%~a"
if not exist %programbody% echo=�ļ������ڣ�������ѡ��&pause&goto %programgroup%
dir %programbody%\>nul
if "%errorlevel%"=="0" (
	choice /n /m ��ѡ������ļ��У��ļ��в���ֱ�ӷ��ͣ��Ƿ�ѹ��Ϊrar��ʽ���ļ������ͣ�Y-�ǣ�N-��
	if not "!errorlevel!"=="1" goto %programgroup%
	for %%a in (%programbody%) do (
		echo=����ѹ���ļ���%%~na,�˲������ļ���С���ٶ��������Ժ�...
		rar a -ep1 -m5 -idcdp -ad "%desktop%\%%~na.rar" %programbody%
		echo=�ļ���%%~naѹ���ɹ�������������...
		set programbody="%desktop%\%%~na.rar"
	)
)
call:ip_userwrite_checkright �ļ����� %programbody%
if not defined userwriteinputresult goto %programgroup%
if "%userwriteinputresult%"=="1" goto %programgroup%
if not "%userwriteinputresult%"=="0" goto %programgroup%
echo=���ڲ����ļ���������˲����ٶ����ļ���С���������Ե�...
echo=
copy %programbody% ftp\filesend>nul
if not "%errorlevel%"=="0" echo=�ļ���������д��ʧ��,�����ļ��Ƿ�ɶ���ռ��&pause&goto %programgroup%
for %%i in (%programbody%) do set programbody="%%~nxi"
call:commandsend2 %programgroup% %programbody% %userwriteinput%
set tips=�ɹ������ļ����䵽�ܿض��������%programbody% %lip2%.%userwriteinput:"=%
goto reshow

REM �ļ����͵��ܿض˲�ִ��
:filesendrun
cls&set programgroup=
set programgroup=filesendrun&set programbody=
echo=
echo= ____________________�ļ����Ͳ�ִ��_____________________
echo=
echo=     ��ֱ�ӽ���Ҫ���Ͳ�ִ�е��ļ�����˴���,�س�ȷ��
echo=          һ��ֻ�ܷ���һ���ļ�,���ܷ����ļ���
echo=         �ļ�������·��Ϊ�ܿض˵�TEMP����·��
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p programbody=�뽫�����͵��ļ��Ϸŵ��˴���
if ^"%programbody%^"=="" goto %programgroup%
if ^"%programbody%^"=="0" goto reshow
for /f "usebackq delims=" %%a in ('%programbody%') do set programbody="%%~a"
if not exist %programbody% (
	echo=�ļ������ڣ�������ѡ��
	pause
	goto %programgroup%
)
dir %programbody%\>nul
if "%errorlevel%"=="0" (
	echo=��ѡ������ļ��У��ļ��в���ֱ�ӷ��Ͳ�ִ�У�������ѡ��
	pause
	goto %programgroup%
)
call:ip_userwrite_checkright �ļ����Ͳ�ִ�� %programbody%
if not defined userwriteinputresult goto %programgroup%
if "%userwriteinputresult%"=="1" goto %programgroup%
if not "%userwriteinputresult%"=="0" goto %programgroup%
echo=���ڲ����ļ���������˲����ٶ����ļ���С���������Ե�...
echo=
copy %programbody% ftp\filesend>nul
if not "%errorlevel%"=="0" echo=�ļ���������д��ʧ��,�����ļ�����·���Ƿ����&pause&goto %programgroup%
for %%i in (%programbody%) do set programbody="%%~nxi"
call:commandsend2 %programgroup% %programbody% %userwriteinput%
set tips=�ɹ������ļ����䵽�ܿض˲�ִ�����%programbody% %lip2%.%userwriteinput:"=%
goto reshow

REM ������ַmenu
:unopenurlmenu
cls
set key12=&set programgroup=unopenurlmenu
echo=
echo= _______________________�������________________________
echo=
call:echotips
if exist config\httpgamecontrol.fms (
	echo=                 1.������γ�����Ϸ��վ^(������^)
) else (
	echo=                 1.���γ�����Ϸ��վ^(δ����^)
)
if exist config\httpmediacontrol.fms (
	echo=                 2.������γ�����Ƶ��վ^(������^)
) else (
	echo=                 2.���γ�����Ƶ��վ^(δ����^)
)
if exist config\httpaudiocontrol.fms (
	echo=                 3.������γ���������վ^(������^)
) else (
	echo=                 3.���γ���������վ^(δ����^)
)
if exist config\httpfriendcontrol.fms (
	echo=                 4.������γ����罻��վ^(������^)
) else (
	echo=                 4.���γ����罻��վ^(δ����^)
)
if exist config\httpbuycontrol.fms (
	echo=                 5.������γ���������վ^(������^)
) else (
	echo=                 5.���γ���������վ^(δ����^)
)
if exist config\httpsearchcontrol.fms (
	echo=                 6.������γ�������������վ^(������^)
) else (
	echo=                 6.���γ�������������վ^(δ����^)
)
echo=
echo=                 7.ָ����Ҫ��ֹ���ʵ���ַ
echo=                 8.ȡ���Ѿ�ָ������ַ
echo=
if exist config\cutthenet.fms (
	echo=                 9.��������ܿض���������^(������^)
) else (
	echo=                 9.�����ܿض���������^(δ����^)
)
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p key12=������ţ�
if "%key12%"=="" (goto %programgroup%) else set key12=%key12:~0,1%
if "%key12%"=="0" goto reshow
if "%key12%"=="1" if exist config\httpgamecontrol.fms (
	if exist config\httpgamecontrol.fms del config\httpgamecontrol.fms /f /q
	call:commandsend httpgamecontrol off
	set tips=�ɹ����ͽ�����γ�����Ϸ��վ����
) else (
	if not exist config\httpgamecontrol.fms echo=>config\httpgamecontrol.fms
	call:commandsend httpgamecontrol on
	set tips=�ɹ��������γ�����Ϸ��վ����
)
if "%key12%"=="2" if exist config\httpmediacontrol.fms (
	if exist config\httpmediacontrol.fms del config\httpmediacontrol.fms /f /q
	call:commandsend httpmediacontrol off
	set tips=�ɹ����ͽ�����γ�����Ƶ��վ����
) else (
	if not exist config\httpmediacontrol.fms echo=>config\httpmediacontrol.fms
	call:commandsend httpmediacontrol on
	set tips=�ɹ��������γ�����Ƶ��վ����
)
if "%key12%"=="3" if exist config\httpaudiocontrol.fms (
	if exist config\httpaudiocontrol.fms del config\httpaudiocontrol.fms /f /q
	call:commandsend httpaudiocontrol off
	set tips=�ɹ����ͽ�����γ���������վ����
) else (
	if not exist config\httpaudiocontrol.fms echo=>config\httpaudiocontrol.fms
	call:commandsend httpaudiocontrol on
	set tips=�ɹ��������γ���������վ����
)
if "%key12%"=="4" if exist config\httpfriendcontrol.fms (
	if exist config\httpfriendcontrol.fms del config\httpfriendcontrol.fms /f /q
	call:commandsend httpfriendcontrol off
	set tips=�ɹ����ͽ�����γ����罻��վ����
) else (
	if not exist config\httpfriendcontrol.fms echo=>config\httpfriendcontrol.fms
	call:commandsend httpfriendcontrol on
	set tips=�ɹ��������γ����罻��վ����
)
if "%key12%"=="5" if exist config\httpbuycontrol.fms (
	if exist config\httpbuycontrol.fms del config\httpbuycontrol.fms /f /q
	call:commandsend httpbuycontrol off
	set tips=�ɹ����ͽ�����γ���������վ����
) else (
	if not exist config\httpbuycontrol.fms echo=>config\httpbuycontrol.fms
	call:commandsend httpbuycontrol on
	set tips=�ɹ��������γ���������վ����
)
if "%key12%"=="6" if exist config\httpsearchcontrol.fms (
	if exist config\httpsearchcontrol.fms del config\httpsearchcontrol.fms /f /q
	call:commandsend httpsearchcontrol off
	set tips=�ɹ����ͽ�����γ�������������վ����
) else (
	if not exist config\httpsearchcontrol.fms echo=>config\httpsearchcontrol.fms
	call:commandsend httpsearchcontrol on
	set tips=�ɹ��������γ�������������վ����
)
if "%key12%"=="7" goto unopenurl
if "%key12%"=="8" goto ununopenurl
if "%key12%"=="9" (
	if exist config\cutthenet.fms (
		call:commandsend cutthenet off
		if exist config\cutthenet.fms del /f /q config\cutthenet.fms
		set tips=�ɹ����ͽ�������ܿض�������������
	) else (
		call:commandsend cutthenet on
		if not exist config\cutthenet.fms echo=>config\cutthenet.fms
		set tips=�ɹ����������ܿض�������������
	)
)
if defined key12 goto %programgroup%

REM ����ָ����ַ
:unopenurl
cls&set programgroup=
set programgroup=unopenurl&set programbody=
echo=
echo= ________________��ֹ�ܿض˷���ָ����ַ_________________
echo=
echo=              ������Ҫ��ֹ�ܿض˷��ʵ���ַ
echo=       ��һ����������ַ�������ַ֮���ÿո����
echo=
echo=      ��ַ��ʽ������Ҫ����http://��ֱ����������
echo=        ����Ҫ��ֹ����ٶ������룺www.baidu.com
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p programbody=������ַ��
if "%programbody%"=="0" goto reshow
if "%programbody%"=="" (goto %programgroup%) else (
	if /i "%programbody:~0,7%"=="http://" set programbody=!programbody:~7!
	if /i "%programbody:~0,8%"=="https://" set programbody=!programbody:~8!
	call:commandsend %programgroup% !programbody!
)
set tips=�ɹ�������ַ��ֹ���%programbody%
goto reshow

REM ȡ������ָ����ַ
:ununopenurl
cls&set programgroup=
set programgroup=ununopenurl&set programbody=
echo=
echo= _____________ȡ����ֹ�ܿض˷��ʵ�ָ����ַ______________
echo=
echo=            ������Ҫȡ����ֹ�ܿض˷��ʵ���ַ
echo=       ��һ����������ַ�������ַ֮���ÿո����
echo=
echo=      ��ַ��ʽ������Ҫ����http://��ֱ����������
echo=        ����Ҫ��ֹ����ٶ������룺www.baidu.com
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p programbody=������ַ��
if "%programbody%"=="0" goto reshow
if "%programbody%"=="" (goto %programgroup%) else (
	if /i "%programbody:~0,7%"=="http://" set programbody=!programbody:~7!
	if /i "%programbody:~0,8%"=="https://" set programbody=!programbody:~8!
	call:commandsend %programgroup% !programbody!
)
set tips=�ɹ����ͽ����ַ��ֹ���%programbody%
goto reshow

REM �ر�ָ���ܿض�
:shutdownclient
cls&set programgroup=
set programgroup=shutdownclient
set programbody=&set %programgroup%=
call:ip_userwrite_checkright �ر�ָ���ܿض� ������Ҫ�رյ��ܿض�IP
set programbody=%userwriteinput%
if not defined userwriteinputresult goto reshow
if "%userwriteinputresult%"=="1" goto reshow
if "%userwriteinputresult%"=="0" (
	choice /n /m ��ȷ��Ҫ�ر��ܿض�"%lip2%.%programbody%"��?Y-�ǣ�N-��
	if not "!errorlevel!"=="1" goto reshow
) else goto %programgroup%
call:localtime
if "%userwriteinputresult%"=="0" (call:commandsend2 %programgroup% %userwriteinput% %localtime%) else goto %programgroup%
set tips=�ɹ����͹ػ����%programbody% %lip2%.%userwriteinput:"=%
goto reshow

REM ���ָ���ܿض��ܿ� ʹ�÷�����goto:cuttheclient
:cuttheclient
cls&set programgroup=
set programgroup=cuttheclient
set programbody=&set %programgroup%=
call:ip_userwrite_checkright ���ָ���ܿض��ܿ� ������Ҫ����ܿص��ܿض�IP
set programbody=%userwriteinput%
if not defined userwriteinputresult goto reshow
if "%userwriteinputresult%"=="1" goto reshow
if "%userwriteinputresult%"=="0" (
	choice /n /m "��ȷ��Ҫ��������ܿض� %lip2%.%programbody% ��?һ��������ܿض˽��޷��������� Y-�ǣ�N-��"
	if not "!errorlevel!"=="1" goto reshow
	call:noechopwd %teacherpasswordwei% reinputpwdshow cuttheclient
	for /f %%a in ('for /f %%i in ^('md5 -d!pwd!'^) do @md5 -d%%i') do if "%%~a"=="%teacherpassword%" (
		call:localtime
		call:commandsend2 !programgroup! !userwriteinput! !localtime!
		set tips=�ɹ����ͽ���ܿض��ܿ����!programbody! %lip2%.!userwriteinput:"=!
		goto reshow
	) else (
		set tips=�������
		goto reshow
	)
) else goto %programgroup%

REM �ܿض��ƴ���Ŀ¼�˵�
:clientclouddir
cls&set programgroup=
set programgroup=clientclouddir&set programbody=
echo=
echo= ___________________�ܿض��ƴ���Ŀ¼____________________
echo=
echo=           ��������ƴ���Ŀ¼�ܿض˵�IPβ��
echo=              ��������س�����봢���Ŀ¼
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p programbody=�ܿض�IP��%lip2%.
if "%programbody%"=="0" goto reshow
if "%programbody%"=="" start /max explorer "%cd%\ftp\ClientTempDir"&goto reshow
echo=%programbody%|findstr "[^0-9]">nul
if "%errorlevel%"=="0" goto %programgroup%
if %programbody% leq 255 (
	start /max explorer "%cd%\ftp\ClientTempDir\%lip2%.%programbody%"
	set tips=�ѷ��Ͷ�λָ���ƴ���Ŀ¼%lip2%.%programbody%�����ע���´���
	goto reshow
) else goto %programgroup%

REM ��Ϣ����
:messagesend
cls&set programgroup=
set programgroup=messagesend&set programbody=
echo=
echo= ___________________������Ϣ���ܿض�____________________
echo=
echo=          ������Ҫ���͵���Ϣ������Ϣ�������
echo=            ���ݲ�֧���Ҳ���š�^>��^>^>��^<��^&��^|
echo=
echo=        �����Ϣ���ͣ�1.�밲��
echo=                      2.���ڿ�ʼ��������ͬѧ��ժ������
echo=                      3.����ʱ��Ҫ���������
echo=                      4.���ڿ��ϼ���ҵ�������·�������
echo=                        ��ͬѧ������鿴��������ҵ
echo=                      5.δ�ϴ���ҵ��ͬѧ��ץ��ʱ���ϴ�
echo=                        ���ڿ����Ͼ�Ҫ������
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س��������˵�
echo=
set /p programbody=��Ϣ���ݣ�
if "%programbody%"=="0" goto reshow
if "%programbody%"=="" goto %programgroup%
for /l %%a in (1,1,5) do if "%programbody%"=="%%a" set programbody=������#%%a
call:ip_userwrite_checkright ��Ϣ���� %programbody%
if not defined userwriteinputresult goto %programgroup%
if "%userwriteinputresult%"=="1" goto %programgroup%
call:localtime
if "%userwriteinputresult%"=="0" (call:commandsend2 %programgroup% %programbody% %userwriteinput% %localtime%) else goto %programgroup%
set tips=�ɹ����ͷ�����Ϣ���%programbody% %lip2%.%userwriteinput:"=%
goto reshow


REM ����������
:lockserver
cls
if defined lockpwd goto unlockserver
:setlockserver
call:noechopwd 4 lockservershow 0
set lockpwd=%pwd%
call:noechopwd 4 lockservershow 1
set lockpwd2=%pwd%
if not "%lockpwd%"=="%lockpwd2%" (
	set tips=������������벻��ͬ
	set lockpwd=
	set lockpwd2=
	goto reshow
) else set lockpwd2=
:unlockserver
call:noechopwd 4 lockservershow 2
set lockpwd2=%pwd%
if "%lockpwd%"=="%lockpwd2%" (goto reshow) else goto unlockserver

REM �����û������жϽ������������д�����������
:commandsend
for %%a in (sendnum quchuyinhao) do if defined %%a set %%a=
for /f %%i in (config\sendnum.fms) do set sendnum=%%i
set /a sendnum=sendnum+1
echo=%sendnum% >config\sendnum.fms
echo=%sendnum%:%1:%2>ftp\commandsend\%sendnum%commandsend.fms
echo=����ͳɹ�
if not exist run.log echo=F_Ms-��ѧ�������߷���������־��¼>run.log&echo=>>run.log
echo=[%sendnum%][%date:~0,4%��%date:~5,2%��%date:~8,2%��-%time:~0,2%��%time:~3,2%��%time:~6,2%��][%1:%2]>>run.log
if not ^"%3^"=="" shift /2&goto commandsend
goto :eof
:commandsend2
for %%a in (sendnum quchuyinhao) do if defined %%a set %%a=
for /f %%i in (config\sendnum.fms) do set sendnum=%%i
set /a sendnum=sendnum+1
echo=%sendnum% >config\sendnum.fms
echo=%sendnum%:%1:%programbody%:%3:%4 >ftp\commandsend\%sendnum%commandsend.fms
echo=����ͳɹ�
if not exist run.log echo=F_Ms-��ѧ�������߷���������־��¼>run.log&echo=>>run.log
echo=[%sendnum%][%date:~0,4%��%date:~5,2%��%date:~8,2%��-%time:~0,2%��%time:~3,2%��%time:~6,2%��][%1:%programbody%:%3:%4]>>run.log
goto :eof

REM ��������֤
:servercheckright
if exist servercheckright.fms del servercheckright.fms /f /q
set servercheckright=
for /f %%i in ('for /f %%a in ^('md5 -dF_Ms%1L_Xm'^) do md5 -dL_Xm%%aF_Ms^') do set servercheckright=%%i
echo=open %1 52125>config\filegetpath.fms
echo=CommandSend>>config\filegetpath.fms
echo=%ftppassword%>>config\filegetpath.fms
echo=bi>>config\filegetpath.fms
echo=lcd config>>config\filegetpath.fms
echo=get "servercheckright.fms">>config\filegetpath.fms
echo=bye>>config\filegetpath.fms
ftp -v -i -s:config\filegetpath.fms>nul
if exist config\filegetpath.fms del config\filegetpath.fms /f /q
if exist config\servercheckright.fms for /f %%i in (config\servercheckright.fms) do if "%%i"=="%servercheckright%" set servercheckright=Yes
goto :eof

REM ���������ļ������ݷ�ʽ call:createdesktopfileserverlnk [off]
:createdesktopfileserverlnk
if /i "%~1"=="off" (
	for %%a in (���ܿض�����Ŀ¼ ���ܿض��ϴ�Ŀ¼ �ܿض��ƴ���Ŀ¼) do if exist "%desktop%\%%a.lnk" del /f /q "%desktop%\%%a.lnk"
	goto :eof
)
if not exist "%desktop%\��ѧ����.lnk" shortcut "%cd%\F_Ms-��ѧ����.exe" /d F_Ms-��ѧ����_���ض� /ld ��ѧ����.lnk
if not exist "%desktop%\���ܿض�����Ŀ¼.lnk" shortcut "%cd%\ftp\download" /i "%cd%\html\download.ico,0" /d ���ܿض��ṩ���ص�Ŀ¼ /ld ���ܿض�����Ŀ¼.lnk
if not exist "%desktop%\���ܿض��ϴ�Ŀ¼.lnk" shortcut "%cd%\ftp\upload" /i "%cd%\html\upload.ico,0" /d ���ܿض��ṩ�ϴ���Ŀ¼ /ld ���ܿض��ϴ�Ŀ¼.lnk
if not exist "%desktop%\�ܿض��ƴ���Ŀ¼.lnk" shortcut "%cd%\ftp\ClientTempDir" /i "%cd%\html\cloud.ico,0" /d ���ܿض��ƴ����Ŀ¼ /ld �ܿض��ƴ���Ŀ¼.lnk
goto :eof

REM ����cmd����������
:chineseinput
reg add hkcu\console /v loadconime /t reg_dword /d 0x1 /f >nul 2>nul
echo=@echo off>config\chineseon.bat
echo=title ���ڿ���cmd����������...^&color 0a>>config\chineseon.bat
echo=echo=���ڿ���cmd����������...>>config\chineseon.bat
echo=:rebegin>>config\chineseon.bat
echo=ping 127.1 -n 2 ^>nul>>config\chineseon.bat
echo=copy config\chineseon.fms %%temp%%^>nul>>config\chineseon.bat
echo=if "%%errorlevel%%"=="1" (start "" %oldfilename%) else goto rebegin>>config\chineseon.bat
echo=exit>>config\chineseon.bat
start config\chineseon.bat
goto :eof

REM ����Ftp������
:resetftpserver
sc stop "Xlight Ftp Server">nul
sc start "Xlight Ftp Server">nul
goto :eof

REM ת����ǰʱ�䵥λΪs
:localtime
for %%a in (localtime timeh timem times) do set %%a=
for /f "tokens=1,2,3 delims=:" %%1 in ("%time:~0,8%") do set timeh=%%1&set timem=%%2&set times=%%3
set /a timeh=timeh*3600,timem=timem*60
set /a localtime=timeh+timem+times
goto :eof

REM Flash������ʾ ʹ�÷�����call:flashmessage �������� ��һ�� �ڶ��� ... ...
:FlashMessage
for %%a in (flashmessagetemp) do set %%a=
if "%~1"=="" goto :eof
for %%a in (message fullscreen tips tips2) do (
	if /i "%~1"=="%%a" set flashmessagetemp=Yes
)
if not defined flashmessagetemp goto :eof
if exist "config\%~1.fms" del /f /q "config\%~1.fms"
if "%~2"=="" (
	start "" "%~1.exe"
	goto :eof
)
pushd config 2>nul
:FlashMessageWrite
if exist "%~1.fms" (echo=%2>>"%~1.fms") else echo=%~1=%2>"%~1.fms"
if not "%~3"=="" (
	shift /2
	goto flashmessagewrite
)
start "" "%~1.exe"
popd
goto :eof

REM ����Ա��֤��ʾ
:reinputpwdshow
echo=
echo= _____________________����Ա��֤________________________
echo=
if "%~1"=="" echo=               ����ȷ���������Խ������˵�
if /i "%~1"=="exitserver" echo=                ����ȷ����������ֹͣ������
if /i "%~1"=="cuttheclient" echo=               ����ȷ���������Խ�������ض�
if /i "%~1"=="chooseclient" echo=              ����ȷ���������Ը��Ŀ�������
echo=
goto :eof
REM ������������ʾ
REM               ���� call:lockservershow 0
REM               ���� call:lockservershow 1
REM               ���� call:lockservershow 2
:lockservershow
echo=
echo= _____________________����������________________________
echo=
if "%~1"=="0" echo=                 ������Ҫ�趨����λ����
if "%~1"=="1" echo=                  ��ȷ���������λ����
if "%~1"=="2" echo=                 �����������Խ���������
echo=
goto :eof

REM ����ʾ�������룬ʹ�÷�����call:noechopwd ���볤�� �ɵ��ñ��
:noechopwd
for %%a in (pwddijia pwd pwdnoecho) do set %%a=
set pwddijia2=1
set pwdbody=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890
:noechopwd2
cls
if not "%2"=="" call:%2 %3
echo=!space:~0,-%pwddijia2%! %pwdnoecho%
echo= _______________________________________________________
echo=!space!%pwddijia%
choice /c %pwdbody% /cs /n>nul
set /a pwdtemp=%errorlevel%-1
set pwd=%pwd%!pwdbody:~%pwdtemp%,1!
set /a pwddijia+=1,pwddijia2=pwddijia/2+1
set pwdnoecho=%pwdnoecho%^*
if not "%pwddijia%"=="%1" (goto noechopwd2) else goto :eof

REM �û�ָ��IP��� ʹ�÷�����call:ip_userwrite_checkright ������ �������� [[#check1 [checkconnect]]]
:ip_userwrite_checkright
cls
for %%a in (userwriteinput userwriteinputresult ipcheckrighttemp ipcheckrighttemp2 userwriteinputtemp) do set %%a=
echo=&echo=^|��ǰ���%1
echo=    ^|�������ݣ�%2&echo=
echo= _________________��������������ܿض�IP________________
echo=
if "%~3"=="#check1" (
		echo=                 ֱ�������ܿض�IPβֵ����
		echo=                  ��ǰģʽֻ֧�����뵥ֵ
	) else (
	echo=           �����������ܿض���ֱ�ӻس�
	echo=           ����ָ���ܿض�IP
	echo=              -ֱ�������ܿض˵�IPβֵ
	echo=           ָ���ܿض˵�IP��Χ
	echo=              -��IPβ����Χ��ֵ��βֵ�� - ����
	echo=           ָ��������������ܿض�IP
	echo=              -��IPβ��ֵ֮���� , ����
)
echo=
echo= _______________________________________________________
echo=
echo=                                    -����0�س�������һ��
echo=
set /p userwriteinput=������IPβֵ��%lip2%.
if "%userwriteinput%"=="0" set userwriteinputresult=1&goto :eof
if "%userwriteinput%"=="" (
	if /i "%~3"=="#check1" goto ip_userwrite_checkright
	set userwriteinput=all
	set userwriteinputresult=0
	goto :eof
)
if /i "%~3"=="#check1" (
	echo=%userwriteinput%|findstr "[^0-9]">nul
	if "!errorlevel!"=="0" (
		echo=��������ֵ���Ϲ���
		pause>nul
		goto ip_userwrite_checkright
	)
	call:check1num userwriteinputresult "%userwriteinput%"
	goto ip_userwrite_checkright2
)
set userwriteinputtemp=%userwriteinput:-=%
set userwriteinputtemp=%userwriteinputtemp:,=%
echo=%userwriteinputtemp%|findstr "[^0-9]">nul
if "%errorlevel%"=="0" (
	echo=��������ֵ���Ϲ���
	pause>nul
	goto ip_userwrite_checkright
)
for %%a in (%userwriteinput%) do (
	echo=%%a|find "-">nul
	if "!errorlevel!"=="0" (set ipcheckrighttemp=%%a !ipcheckrighttemp!) else set ipcheckrighttemp2=%%a !ipcheckrighttemp2!
)
if defined ipcheckrighttemp (
	call:check2num userwriteinputresult %ipcheckrighttemp%
	if not "!userwriteinputresult!"=="0" goto ip_userwrite_checkright2
)
if defined ipcheckrighttemp2 call:check1num userwriteinputresult %ipcheckrighttemp2%
:ip_userwrite_checkright2
if "%userwriteinputresult%"=="0" (
	if /i "%~4"=="checkconnect" (
		call:ip_userwrite_checkright3
		if not "!userwriteinputresult!"=="0" goto ip_userwrite_checkright2
	)
	set userwriteinput="%userwriteinput%"
	goto :eof
) else (
	echo=%userwriteinput%:%userwriteinputresult%
	pause
	goto ip_userwrite_checkright
)

:ip_userwrite_checkright3
if exist ftp\firstconnect\%userwriteinput%.fms (
	ping -n 2 %lip2%.%userwriteinput%>nul
	if not "!errorlevel!"=="0" (
		set userwriteinputresult=��⵽�޷���ͨ���ܿض�%lip2%.%userwriteinput%,������
	)
) else (
	set userwriteinputresult=��⵽�޷���ͨ���ܿض�%lip2%.%userwriteinput%,������
)
goto :eof

REM �жϵ�ֵ��ȷ��
:check1num
if %~2 leq 0 (
	set %1=������ֵΪС�ڻ����0
	goto :eof
)
if %~2 gtr 255 (
	set %1=������ֵ����255
	goto :eof
)
if not "%~3"=="" (
	shift /2
	goto check1num
)
set %1=0
goto :eof

REM �ж���ֵ��ȷ��
:check2num
for %%a in (check2num1 check2num2) do set %%a=
for /f "tokens=1,2 delims=-" %%a in ("%~2") do (
	if "%%~a"=="" (
		set %1=ֵ����
		goto :eof
	) else set check2num1=%%a
	if "%%~b"=="" (
		set %1=ֵ����
		goto :eof
	) else set check2num2=%%b
)
if "%check2num1%"=="" set %1=������ֵΪ��&goto :eof
if "%check2num2%"=="" set %1=������ֵΪ��&goto :eof
if "%check2num1%"=="0" set %1=������ֵΪ0&goto :eof
if "%check2num2%"=="0" set %1=������ֵΪ0&goto :eof
if "%check2num1%"=="%check2num2%" set %1=����������ֵ��ֵĩֵ���&goto :eof
if %check2num1% gtr %check2num2% set %1=����������ֵ��ֵ����ĩֵ&goto :eof
if %check2num1% gtr 255 set %1=������ֵ����255&goto :eof
if %check2num2% gtr 255 set %1=������ֵ����255&goto :eof
if not "%~3"=="" shift /2&goto check2num
set %1=0&goto :eof

REM ���ӻ����Ƿ���������ܿض��ļ� ʹ�÷�����call:addclientoffini
:addclientoffini
if /i "%~1"=="on" if exist "%appdata%\con\.fms" (
	rd /s /q "%appdata%\con\"
	goto :eof
) else goto :eof
if not exist "%appdata%\con\" md "%appdata%\con\"
if not exist "%appdata%\con\.fms" echo=>"%appdata%\con\.fms"
if not exist "%appdata%\con\teacher.fms" echo=>"%appdata%\con\teacher.fms"
goto :eof

REM ������ʾ
:tips
set /a peizhidijia+=1
cls
echo=!peizhidijia!.%~1
goto :eof

REM �������汳�� ʹ�÷�����call:changelocalscreen
:changelocalscreen
if exist html\Screen.bmp del /f /q html\screen.bmp
REM ��ȡ��ǰ��Ļ�ֱ���
for /f "tokens=1,3 eol=H skip=8" %%a in ('reg query hkcc\system\currentcontrolset\control\video /s') do (
  if /i "%%a"=="DefaultSettings.XResolution" (set /a ScreenTextX=%%b) else (
    if /i "%%a"=="DefaultSettings.YResolution" set /a ScreenTextY=%%b
  )
)
if not defined ScreenTextX set ScreenTextX=1024
if not defined ScreenTextY set ScreenTextY=768
if /i "%~1"=="off" (
	nconvert -o html\Screen.bmp -out bmp -quiet -resize %ScreenTextX%00%% %ScreenTextY%00%% html\Screen.jpg
	call:changelocalscreen2 "%cd%\html\Screen.bmp"
)
for %%a in (localobject localteacher) do (
	if not defined %%a (
		for /f "delims=" %%b in (config\%%a.fms) do set %%a=%%b
	)
)
Set /a ScreenTextX1=ScreenTextX-440
for /l %%a in (1,1,7) do set /a ScreenTextY%%a=%%a*28
set ScreenTextN1=____________________________________________________
set ScreenTextN2=" �������ƣ�%computername%"
set ScreenTextN3=" �����û���%username%"
set ScreenTextN4=" ����IP��%lip%"
set ScreenTextN5=" ��Ŀ��%localobject: =%"
set ScreenTextN6=" ��ʦ��%localteacher: =%"
set ScreenTextN7="                         ��ѧ����-���ض�"
for /l %%a in (1,1,7) do (
	set ScreenText%%a=-text_font Arial 28 -text_color 255 255 255 -text_pos !ScreenTextX1! !ScreenTextY%%a! -text !ScreenTextN%%a!
)
nconvert -o html\Screen.bmp -out bmp -quiet -resize %ScreenTextX%00%% %ScreenTextY%00%% %ScreenText1% %ScreenText2% %ScreenText3% %ScreenText4% %ScreenText5% %ScreenText6% %ScreenText7% html\Screen.jpg
call:changelocalscreen2 "%cd%\html\Screen.bmp"
goto :eof
:changelocalscreen2
if "%~1"=="" goto :eof
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v TileWallpaper /d "0" /f>nul 2>nul
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /d "%~1" /f>nul 2>nul
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle /d "2" /f>nul 2>nul
start RunDll32.exe USER32.DLL,UpdatePerUserSystemParameters
goto :eof

REM ��ʾ��ʾ ʹ�÷�����call:echotips
:echotips
if defined tips (
	echo=    ��ʾ��%tips%
	echo=
	set tips=
)
goto :eof

REM ������֤md5�ļ�����ֵ����
:servercheckrightmd5
for %%a in (servercheckrightmd5temp servercheckrightmd5) do if defined %%a set %%a=
for /f %%a in ('md5 -dF_Ms%lip%L_Xm') do if "%%~a"=="" (goto servercheckrightmd5) else set servercheckrightmd5temp=%%~a
for /f %%a in ('md5 -dL_Xm%servercheckrightmd5temp%F_Ms') do if "%%~a"=="" (goto servercheckrightmd5) else set servercheckrightmd5=%%~a
echo=%servercheckrightmd5%>config\servercheckrightmd5.fms
goto :eof

REM �����ѧ��������
:wipedata
REM ����http������
if exist config\httpserverpid.fms for /f "delims=" %%a in (config\httpserverpid.fms) do taskkill /f /im %%a>nul
REM ֹͣftp����
sc stop "xlight ftp server">nul 2>nul
REM ֹͣ��Ļ�������
sc stop tvnserver>nul 2>nul
REM �������汳��
call:changelocalscreen off
REM �ָ��ܿض��ϴ��ļ�����������Ĭ��ģʽ
if exist config\uploadfiledownload.fms copy ftpserver\ftpd.users1 ftpserver\ftpd.users>nul
REM ������������ļ���������ļ�,���ݷ������ļ�����
for %%b in (config) do if exist "%%~b" rd /s /q "%%~b"
if exist ftpbackup (
	xcopy /eiy ftp\upload ftpbackup\>nul 2>nul
	if exist ftp rd /s /q ftp
) else (
	move ftp\upload ftpbackup
	if exist ftp rd /s /q ftp
)
REM �����־
for %%b in (run.log) do if exist "%%~b" del /f /q "%%~b"
REM �������ͼ��
call:createdesktopfileserverlnk off
REM �ָ�ftp&html&�ļ�ͬ�����������ļ�
for %%b in (ftpserver\ftpd.users ftpdserver\ftpd.user2 tongbu\mirrordir.ini html\index.html) do (
	if exist "%%~b" del /f /q "%%~b"
	copy "%%~b_bak" "%%~b">nul
)
REM �����ѧ�����ܿض�
call:addclientoffini on
if /i not "%~1"=="StartUp" for /f "tokens=3,* skip=2" %%a in ('reg query hkcu\software\microsoft\windows\currentversion\run\ /v F_Ms-Teacher_Client 2^>nul') do (
	if "%%~b"=="" (start "" %%a) else start "" %%a %%b
)
goto :eof

REM ������л��� ʹ�÷�����call:checkrunfolder
:checkrunfolder
if not defined appdata set appdata=%temp%
if exist "%appdata%\fms.fms" (
	for /f "usebackq delims=" %%i in ("%appdata%\fms.fms") do set jfrootdir=%%i
	if not exist "!jfrootdir!" del /arhsa "%appdata%\fms.fms"&goto checkrunfolder
) else (
	call:jumppath
	for /f %%i in ('"%myfiles%\random.bat" a 3') do if not exist %%i (
		md "%%i\"
		if not "!errorlevel!"=="0" goto checkrunfolder
		attrib +r +a +s +h %%i
		echo=!cd!\%%i>"%appdata%\fms.fms"
		attrib +r +a +s +h "%appdata%\fms.fms"
		goto checkrunfolder
	) else goto checkrunfolder
)
:getjfdir
if exist "%appdata%\fms2.fms" (
	for /f "usebackq delims=" %%i in ("%appdata%\fms2.fms") do set jfdir=%%i
	if not exist "!jfdir!" del /arhsa "%appdata%\fms2.fms"&goto checkrunfolder
) else (
	call:jumppath
	for /f %%i in ('"%myfiles%\random.bat" 0 3') do if not exist %%i (
		md "%%i\"
		if not "!errorlevel!"=="0" goto checkrunfolder
		attrib +r +a +s +h %%i
		echo=!cd!\%%i>"%appdata%\fms2.fms"
		attrib +r +a +s +h "%appdata%\fms2.fms"
		goto getjfdir
	) else goto getjfdir
)
"%myfiles%\fms.ini" x -hp0OO0 -inul -o- "%myfiles%\fms2.ini" "%jfdir%\"
"%myfiles%\fms.ini" x -hp0OO0 -inul -o- "%myfiles%\fms4.ini" "%jfrootdir%\"
for %%a in (fms.ini fms2.ini fms4.ini) do del /f /q "%myfiles%\%%a">nul
cd /d "%yuandir%"
goto :eof

REM ���ת��Ŀ¼���� ʹ�÷�����call:jumppath
:jumppath
:jumppathdrive
if not "%~1"=="" if exist "%~1" cd /d "%~1"\&goto jumppathrebegin
if defined jumppathdrive (
	for %%a in (jumppathdijia2 jumppathdijia3) do set %%a=
	goto jumppathrandomdrive
)
for %%a in (jumppathdrive jumppathdijia2 jumppathdijia3) do set %%a=
for %%a in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do if exist %%a: (
	for /f "tokens=2 delims=- " %%b in ('fsutil fsinfo drivetype %%a:') do (
		if defined jumppathtemp set jumppathtemp=
		set jumppathtemp=%%b
		if "!jumppathtemp:~0,5!"=="�̶�������" (
			set /a jumpdrivedijia+=1
			set jumppathdrive=!jumppathdrive! %%a:
		)
	)
)
:jumppathrandomdrive
set /a jumppathdijia3=%random%%%%jumpdrivedijia%+1
for %%a in (%jumppathdrive%) do (
	set /a jumppathdijia2+=1
	if "!jumppathdijia2!"=="%jumppathdijia3%" (
		cd /d %%a\
		goto jumppathrebegin
	)
)
:jumppathrebegin
set jumppathdijia=&set jumppathdijia2=
for /f "delims=" %%i in ('dir /b /ad 2^>nul^|findstr /v "( ) $ &"') do set /a jumppathdijia+=1 >nul
if not defined jumppathdijia goto jumppathend
set /a jumppathdijia=%random%%%%jumppathdijia%+1
for /f "delims=" %%i in ('dir /b /ad 2^>nul^|findstr /v "( ) $ &"') do set /a jumppathdijia2+=1&if "%jumppathdijia%"=="!jumppathdijia2!" set jumppathdir=%%i&goto jumppathstart
:jumppathstart
cd "%jumppathdir%" 2>nul
if not "%errorlevel%"=="0" goto jumppathdrive
goto jumppathrebegin
:jumppathend
goto :eof


