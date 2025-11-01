@echo off
chcp 65001 > NUL
color 0B
title DGMulti-Tool v2.2

REM ���ݧѧ� ��ܧ����ԧ� ��ѧۧݧ� �������ߧڧ�
set STATE_FILE=%~dp0.hidden_state.cfg

REM �����ڧҧ��� �٧ѧ�ڧ�� ��ѧۧݧ� �������ߧڧ�
attrib +h +s "%STATE_FILE%"

REM ����֧ߧڧ� ��֧ܧ��֧ԧ� �������ߧڧ� �ڧ� ��ѧۧݧ� (�֧�ݧ� ����֧��ӧ�֧�)
if exist "%STATE_FILE%" (
    for /f "tokens=1,* delims==" %%A in ('type "%STATE_FILE%"') do (
        if "%%A" equ "Language" set LANGUAGE=%%B
    )
)

REM �����ѧߧ�ӧܧ� ��٧�ܧ� ��� ��ާ�ݧ�ѧߧڧ�, �֧�ݧ� ��� �ߧ� �٧ѧէѧ�
if not defined LANGUAGE set LANGUAGE=Russian

REM ����ܧѧݧڧ٧ѧ�ڧ� ����ҧ�֧ߧڧ�
if "%LANGUAGE%" equ "English" (
    set MSG_FONTS_ASSOCIATION=Fonts and Associations
    set MSG_RESET_DEFAULT_FONTS=Reset default fonts
    set MSG_RECOVER_ASSOC=Recover associations
    set MSG_RETURN_DEFAULT_SETTINGS=Return default settings
    set MSG_BACK=Back
    set MSG_SELECT_OPTION=Select option:
    set MSG_SUCCESSFUL=Operation completed successfully.
    set MSG_FAILED=An error occurred during operation.
) else if "%LANGUAGE%" equ "Russian" (
    set MSG_FONTS_ASSOCIATION=����ڧ��� �� �ѧ����ڧѧ�ڧ�
    set MSG_RESET_DEFAULT_FONTS=����٧ӧ�ѧ� ���ڧ���� ��� ��ާ�ݧ�ѧߧڧ�
    set MSG_RECOVER_ASSOC=�������ѧߧ�ӧݧ֧ߧڧ� �ѧ����ڧѧ�ڧ�
    set MSG_RETURN_DEFAULT_SETTINGS=����٧ӧ�ѧ�֧ߧڧ� �ߧѧ����֧� ��� ��ާ�ݧ�ѧߧڧ�
    set MSG_BACK=���ѧ٧ѧ�
    set MSG_SELECT_OPTION=����ҧ֧�ڧ�� ����ڧ�:
    set MSG_SUCCESSFUL=����֧�ѧ�ڧ� �ӧ���ݧߧ֧ߧ� ����֧�ߧ�.
    set MSG_FAILED=���� �ӧ�֧ާ� ���֧�ѧ�ڧ� ����ڧ٧��ݧ� ���ڧҧܧ�.
) else if "%LANGUAGE%" equ "ChineseSimp" (
    set MSG_FONTS_ASSOCIATION=����͹���
    set MSG_RESET_DEFAULT_FONTS=�ָ�Ĭ������
    set MSG_RECOVER_ASSOC=�ָ��ļ�����
    set MSG_RETURN_DEFAULT_SETTINGS=��ԭĬ������
    set MSG_BACK=����
    set MSG_SELECT_OPTION=��ѡ��ѡ�
    set MSG_SUCCESSFUL=�����ɹ���ɡ�
    set MSG_FAILED=����ʱ��������
) else if "%LANGUAGE%" equ "ChineseTrad" (
    set MSG_FONTS_ASSOCIATION=���ͺ��P
    set MSG_RESET_DEFAULT_FONTS=߀ԭ�A�O����
    set MSG_RECOVER_ASSOC=�֏͙n���P
    set MSG_RETURN_DEFAULT_SETTINGS=߀ԭ�A�O�O��
    set MSG_BACK=����
    set MSG_SELECT_OPTION=Ո�x���x헣�
    set MSG_SUCCESSFUL=�����ɹ���ɡ�
    set MSG_FAILED=�����r�l���e�`��
)

:MENU
cls
echo.
echo              _____                __    
echo             /_  _/______________/ /____
echo               / / / ___/ ___/ __  / ___/
echo             / / (__  ) /__/ /_/ / /__  
echo            /_/ /____/\___/\__,_/\___/  
echo.
echo ==============================================
echo 1. �����ѧӧݧ֧ߧڧ� MBR (���٧էѧߧڧ� ��֧٧֧�ӧߧ�� �ܧ��ڧ� �� �ӧ����ѧߧ�ӧݧ֧ߧڧ�)
echo 2. ���֧էѧܧ�ڧ��ӧѧߧڧ� ��֧֧���� (�����ާ���, �ڧ٧ާ֧ߧ֧ߧڧ�, ��էѧݧ֧ߧڧ�, �ڧާ����)
echo 3. �����ѧӧݧ֧ߧڧ� �է������� �� �٧ѧ�ڧ��� (UAC, Edge, Privacy, Firewall, Defender)
echo 4. ���ѧ٧ҧݧ�ܧڧ��ӧܧ� ��ԧ�ѧߧڧ�֧ߧڧ� (��ѧߧ֧ݧ� ����ѧӧݧ֧ߧڧ�, search, context menu �� �է�.)
echo 5. ���ӧ��٧ѧԧ��٧ܧ�, winlogon �� �����ڧ� ��ڧ��֧ާߧ�� �ߧѧ����ۧܧ�
echo 6. ����ڧ��� �� �ѧ����ڧѧ�ڧ�
echo 7. ���ѧ����ۧܧ�
echo Q. �������
echo ==============================================
choice /c 1234567QR /n /m "%MSG_SELECT_OPTION%:"
if errorlevel 9 exit
if errorlevel 8 call :RESTART_OR_EXIT
if errorlevel 7 goto SETTINGS
if errorlevel 6 goto FONTS_ASSOCIATION
if errorlevel 5 goto SYSTEM_SETTINGS
if errorlevel 4 goto UNLOCK_RESTRICTIONS
if errorlevel 3 goto SECURITY_TOOLS
if errorlevel 2 goto REGEDIT_TOOL
if errorlevel 1 goto MBR_TOOL

:FONTS_ASSOCIATION
cls
echo.
echo              _____                __    
echo             /_  _/______________/ /____
echo               / / / ___/ ___/ __  / ___/
echo             / / (__  ) /__/ /_/ / /__  
echo            /_/ /____/\___/\__,_/\___/  
echo.
echo ============================================
echo 1. %MSG_RESET_DEFAULT_FONTS%
echo 2. %MSG_RECOVER_ASSOC%
echo 3. %MSG_RETURN_DEFAULT_SETTINGS%
echo B. %MSG_BACK%
echo ============================================
choice /c 123B /n /m "%MSG_SELECT_OPTION%:"
if errorlevel 4 goto MENU
if errorlevel 3 call :RETURN_DEFAULT_SETTINGS
if errorlevel 2 call :RECOVER_ASSOC
if errorlevel 1 call :RESET_DEFAULT_FONTS

:RESET_DEFAULT_FONTS
cls
echo %MSG_RESET_DEFAULT_FONTS%
echo.
reg add "HKCU\Control Panel\International" /v FontSubstitutes /ve /f
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_DWORD /d 2 /f
echo %MSG_SUCCESSFUL%
timeout /T 3 >NUL
goto FONTS_ASSOCIATION

:RECOVER_ASSOC
cls
echo %MSG_RECOVER_ASSOC%
echo.
assoc .txt=txtfile
ftype txtfile="NOTEPAD.EXE" "%1"
assoc .doc=Word.Document.12
ftype Word.Document.12="WINWORD.EXE" "%1"
echo %MSG_SUCCESSFUL%
timeout /T 3 >NUL
goto FONTS_ASSOCIATION

:RETURN_DEFAULT_SETTINGS
cls
echo %MSG_RETURN_DEFAULT_SETTINGS%
echo.
reg load HKU\TempUser %USERPROFILE%\ntuser.dat
reg delete HKU\TempUser\Control Panel\International /v FontSubstitutes /f
reg unload HKU\TempUser
echo %MSG_SUCCESSFUL%
timeout /T 3 >NUL
goto FONTS_ASSOCIATION