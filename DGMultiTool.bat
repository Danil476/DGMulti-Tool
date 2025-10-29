@echo off
color 0B
title DGMulti-Tool v2.0

REM Флаг скрытого файла состояния
set STATE_FILE=%~dp0.hidden_state.cfg

REM Атрибуты защиты файла состояния
attrib +h +s "%STATE_FILE%"

REM Проверка окружения (WinRE или обычный режим)
IF DEFINED WINPE SET IN_WINRE=YES ELSE SET IN_WINRE=NO

REM Чтение текущего состояния из файла (если существует)
if exist "%STATE_FILE%" (
    for /f "tokens=1,* delims==" %%A in ('type "%STATE_FILE%"') do (
        if "%%A" equ "Firewall" set STATE_FIREWALL=%%B
        if "%%A" equ "UAC" set STATE_UAC=%%B
        if "%%A" equ "Edge" set STATE_EDGE=%%B
        rem Добавь остальные компоненты аналогично
    )
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
echo 1. Управление MBR (создание резервной копии и восстановление)
echo 2. Редактирование реестра (просмотр, изменение, удаление, импорт)
echo 3. Управление доступом и защитой (UAC, Edge, Privacy, Firewall, Defender)
echo 4. Разблокировка ограничений (панель управления, search, context menu и др.)
echo 5. Автозагрузка, winlogon и прочие системные настройки
echo Q. Выход
echo ==============================================
choice /c 12345QR /n /m "Ваш выбор:"
if errorlevel 7 exit
if errorlevel 6 call :RESTART_OR_EXIT
if errorlevel 5 goto SYSTEM_SETTINGS
if errorlevel 4 goto UNLOCK_RESTRICTIONS
if errorlevel 3 goto SECURITY_TOOLS
if errorlevel 2 goto REGEDIT_TOOL
if errorlevel 1 goto MBR_TOOL

:SYSTEM_SETTINGS
cls
echo.
echo              _____                __    
echo             /_  _/______________/ /____
echo               / / / ___/ ___/ __  / ___/
echo             / / (__  ) /__/ /_/ / /__  
echo            /_/ /____/\___/\__,_/\___/  
echo.
echo ============================================
echo 1. Настройки winlogon
echo 2. Автозапуск программ
echo 3. Планировщик задач
echo B. Назад
echo ============================================
choice /c 123B /n /m "Ваш выбор:"
if errorlevel 4 goto MENU
if errorlevel 3 call :TASK_SCHEDULER_SETUP
if errorlevel 2 call :AUTOLOAD_MANAGEMENT
if errorlevel 1 call :WINLOGON_SETTINGS

:WINLOGON_SETTINGS
cls
echo Настройки winlogon
echo.
echo Текущие настройки winlogon:
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | findstr /I "Userinit Shell"
echo.
echo Выбирите запись для изменения:
setlocal enabledelayedexpansion
set COUNT=0
for /f "skip=2 tokens=1,2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" ^| findstr /I "Userinit Shell"') do (
    set /a COUNT+=1
    echo !COUNT!. %%B %%C
    set "ITEM!COUNT!=%%B %%C"
)
endlocal
echo B. Назад
choice /c 123456789ABCDEFB /n /m "Ваш выбор:"
if errorlevel 16 goto SYSTEM_SETTINGS
if errorlevel 15 set CHOICE=F
if errorlevel 14 set CHOICE=E
if errorlevel 13 set CHOICE=D
if errorlevel 12 set CHOICE=C
if errorlevel 11 set CHOICE=B
if errorlevel 10 set CHOICE=A
if errorlevel 9 set CHOICE=9
if errorlevel 8 set CHOICE=8
if errorlevel 7 set CHOICE=7
if errorlevel 6 set CHOICE=6
if errorlevel 5 set CHOICE=5
if errorlevel 4 set CHOICE=4
if errorlevel 3 set CHOICE=3
if errorlevel 2 set CHOICE=2
if errorlevel 1 set CHOICE=1
call :MANAGE_ITEM_%CHOICE%

:MANAGE_ITEM_1
cls
echo Элемент: %ITEM1%
echo.
echo 1. Удалить одну запись
echo 2. Переименовать или сменить процесс
echo 3. Назад
choice /c 123 /n /m "Ваш выбор:"
if errorlevel 3 goto WINLOGON_SETTINGS
if errorlevel 2 call :CHANGE_PROCESS_%ITEM1%
if errorlevel 1 call :DELETE_RECORD_%ITEM1%

:MANAGE_ITEM_2
cls
echo Элемент: %ITEM2%
echo.
echo 1. Удалить одну запись
echo 2. Переименовать или сменить процесс
echo 3. Назад
choice /c 123 /n /m "Ваш выбор:"
if errorlevel 3 goto WINLOGON_SETTINGS
if errorlevel 2 call :CHANGE_PROCESS_%ITEM2%
if errorlevel 1 call :DELETE_RECORD_%ITEM2%

:DELETE_RECORD_Userinit
cls
echo Удаление конкретной записи из Userinit
echo.
set /p RECORD_NAME=Название записи для удаления: 
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Userinit /f
echo Запись удалена.
timeout /T 3 >NUL
goto WINLOGON_SETTINGS

:DELETE_RECORD_Shell
cls
echo Удаление конкретной записи из Shell
echo.
set /p RECORD_NAME=Название записи для удаления: 
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /f
echo Запись удалена.
timeout /T 3 >NUL
goto WINLOGON_SETTINGS

:CHANGE_PROCESS_Userinit
cls
echo Изменение процесса для Userinit
echo.
set /p NEW_VALUE=Новый процесс для Userinit: 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Userinit /t REG_SZ /d "%NEW_VALUE%" /f
echo Процесс изменён.
timeout /T 3 >NUL
goto WINLOGON_SETTINGS

:CHANGE_PROCESS_Shell
cls
echo Изменение процесса для Shell
echo.
set /p NEW_VALUE=Новый процесс для Shell: 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "%NEW_VALUE%" /f
echo Процесс изменён.
timeout /T 3 >NUL
goto WINLOGON_SETTINGS