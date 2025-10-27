@echo off
color 0B
title MultiTool v1.8

REM Флаги состояний
SET STATE_UAC=ON
SET STATE_EDGE=ON
SET STATE_PRIVACY=ON
SET STATE_FIREWALL=ON
SET STATE_DEFENDER=ON

REM Проверка окружения (WinRE или обычный режим)
IF DEFINED WINPE SET IN_WINRE=YES ELSE SET IN_WINRE=NO

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
echo Q. Выход
echo ==============================================
choice /c 1234QR /n /m "Ваш выбор:"
if errorlevel 6 exit
if errorlevel 5 call :RESTART_OR_EXIT
if errorlevel 4 goto UNLOCK_RESTRICTIONS
if errorlevel 3 goto SECURITY_TOOLS
if errorlevel 2 goto REGEDIT_TOOL
if errorlevel 1 goto MBR_TOOL

:UNLOCK_RESTRICTIONS
cls
echo.
echo              _____                __    
echo             /_  _/______________/ /____
echo               / / / ___/ ___/ __  / ___/
echo             / / (__  ) /__/ /_/ / /__  
echo            /_/ /____/\___/\__,_/\___/  
echo.
echo ==========================================
echo 1. Разблокировать всё
echo 2. Разблокировать панель управления
echo 3. Разблокировать поиск
echo 4. Разблокировать контекстное меню
echo 5. Разблокировать вкладку "Безопасность"
echo 6. Разблокировать настройки папок
echo 7. Отображать букву диска:%disk%:/диска
echo 8. Отображать папки и файлы
echo 9. Получить доступ к папкам и файлам
echo A. Получить доступ к диску %disk%:/
echo B. Назад
echo ==========================================
choice /c 123456789AB /n /m "Ваш выбор:"
if errorlevel 12 goto MENU
if errorlevel 11 call :GRANT_DISK_ACCESS
if errorlevel 10 call :SHOW_FILES_AND_FOLDERS
if errorlevel 9 call :GET_FOLDER_ACCESS
if errorlevel 8 call :DISPLAY_LETTER_AND_DISKS
if errorlevel 7 call :UNLOCK_ALL
if errorlevel 6 call :UNLOCK_FOLDER_SETTINGS
if errorlevel 5 call :UNLOCK_SECURITY_TAB
if errorlevel 4 call :UNLOCK_CONTEXT_MENU
if errorlevel 3 call :UNLOCK_SEARCH
if errorlevel 2 call :UNLOCK_CONTROL_PANEL
if errorlevel 1 call :UNLOCK_ALL

:UNLOCK_ALL
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoFind /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoViewContextMenu /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoSecurityTab /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoFolderOptions /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDrives /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoFileNameExtensions /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoSimpleStartMenu /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDriveTypeAutoRun /t REG_DWORD /d 0 /f
echo Все ограничения сняты!
goto UNLOCK_FINISH

:UNLOCK_CONTROL_PANEL
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoControlPanel /t REG_DWORD /d 0 /f
echo Панель управления разблокирована!
goto UNLOCK_FINISH

:UNLOCK_SEARCH
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoFind /t REG_DWORD /d 0 /f
echo Поиск разблокирован!
goto UNLOCK_FINISH

:UNLOCK_CONTEXT_MENU
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoViewContextMenu /t REG_DWORD /d 0 /f
echo Контекстное меню разблокировано!
goto UNLOCK_FINISH

:UNLOCK_SECURITY_TAB
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoSecurityTab /t REG_DWORD /d 0 /f
echo Вкладка "Безопасность" разблокирована!
goto UNLOCK_FINISH

:UNLOCK_FOLDER_SETTINGS
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoFolderOptions /t REG_DWORD /d 0 /f
echo Настройки папок разблокированы!
goto UNLOCK_FINISH

:DISPLAY_LETTER_AND_DISKS
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDrives /t REG_DWORD /d 0 /f
echo Буквы дисков и сами диски будут видны!
goto UNLOCK_FINISH

:SHOW_FILES_AND_FOLDERS
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoFileNameExtensions /t REG_DWORD /d 0 /f
echo Папки и файлы станут видимыми!
goto UNLOCK_FINISH

:GET_FOLDER_ACCESS
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoSimpleStartMenu /t REG_DWORD /d 0 /f
echo Доступ к папкам и файлам открыт!
goto UNLOCK_FINISH

:GRANT_DISK_ACCESS
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoDriveTypeAutoRun /t REG_DWORD /d 0 /f
echo Доступ к диску открыт!
goto UNLOCK_FINISH

:UNLOCK_FINISH
if "%IN_WINRE%"=="YES" (
    echo Некоторые изменения вступят в силу после входа в систему.
) else (
    echo Некоторые изменения вступят в силу после перезагрузки.
)
timeout /T 3 >NUL
goto MENU

:SECURITY_TOOLS
cls
echo.
echo              _____                __    
echo             /_  _/______________/ /____
echo               / / / ___/ ___/ __  / ___/
echo             / / (__  ) /__/ /_/ / /__  
echo            /_/ /____/\___/\__,_/\___/  
echo.
echo ============================================
echo 1. %STATE_UAC%-Контроль Учётных Записей (UAC)
echo 2. %STATE_EDGE%-защита браузера Edge
echo 3. %STATE_PRIVACY%-Политика приватности приложений
echo 4. %STATE_FIREWALL%-Windows Firewall
echo 5. %STATE_DEFENDER%-Защитник Windows (Defender)
echo B. Назад
echo ============================================
choice /c 12345B /n /m "Ваш выбор:"
if errorlevel 6 goto MENU
if errorlevel 5 call :TOGGLE_DEFENDER
if errorlevel 4 call :TOGGLE_FIREWALL
if errorlevel 3 call :TOGGLE_PRIVACY
if errorlevel 2 call :TOGGLE_EDGE
if errorlevel 1 call :TOGGLE_UAC

:TOGGLE_UAC
if "%STATE_UAC%"=="ON" (
    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system /v EnableLUA /t REG_DWORD /d 0 /f
    SET STATE_UAC=OFF
    echo Контроль учетных записей отключён!
) else (
    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system /v EnableLUA /t REG_DWORD /d 1 /f
    SET STATE_UAC=ON
    echo Контроль учетных записей включен!
)
goto SECURITY_TOOLS_FINISH

:TOGGLE_EDGE
if "%STATE_EDGE%"=="ON" (
    reg add HKLM\SOFTWARE\Policies\Microsoft\Edge /v SmartScreenEnabled /t REG_SZ /d Off /f
    SET STATE_EDGE=OFF
    echo Защита Edge отключена!
) else (
    reg add HKLM\SOFTWARE\Policies\Microsoft\Edge /v SmartScreenEnabled /t REG_SZ /d On /f
    SET STATE_EDGE=ON
    echo Защита Edge включена!
)
goto SECURITY_TOOLS_FINISH

:TOGGLE_PRIVACY
if "%STATE_PRIVACY%"=="ON" (
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy /v LetAppsAccessCamera /t REG_DWORD /d 0 /f
    SET STATE_PRIVACY=OFF
    echo Политика приватности отключена!
) else (
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy /v LetAppsAccessCamera /t REG_DWORD /d 1 /f
    SET STATE_PRIVACY=ON
    echo Политика приватности включена!
)
goto SECURITY_TOOLS_FINISH

:TOGGLE_FIREWALL
if "%STATE_FIREWALL%"=="ON" (
    netsh advfirewall set allprofiles state off
    SET STATE_FIREWALL=OFF
    echo Windows Firewall отключён!
) else (
    netsh advfirewall set allprofiles state on
    SET STATE_FIREWALL=ON
    echo Windows Firewall включён!
)
goto SECURITY_TOOLS_FINISH

:TOGGLE_DEFENDER
if "%STATE_DEFENDER%"=="ON" (
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows Defender /v DisableAntiSpyware /t REG_DWORD /d 1 /f
    SET STATE_DEFENDER=OFF
    echo Защитник Windows отключён!
) else (
    reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows Defender /v DisableAntiSpyware /f
    SET STATE_DEFENDER=ON
    echo Защитник Windows включён!
)
goto SECURITY_TOOLS_FINISH

:SECURITY_TOOLS_FINISH
if "%IN_WINRE%"=="YES" (
    echo Некоторые изменения вступят в силу после входа в систему.
) else (
    echo Некоторые изменения вступят в силу после перезагрузки.
)
timeout /T 3 >NUL
goto MENU

:REGEDIT_TOOL
cls
echo.
echo              _____                __    
echo             /_  _/______________/ /____
echo               / / / ___/ ___/ __  / ___/
echo             / / (__  ) /__/ /_/ / /__  
echo            /_/ /____/\___/\__,_/\___/  
echo.
echo ================================================
echo 1. Показать ключи реестра
echo 2. Изменить ключ реестра
echo 3. Удалить ключ реестра
echo 4. Импортировать файл (.reg)
echo B. Назад
echo ================================================
choice /c 1234B /n /m "Ваш выбор:"
if errorlevel 5 goto MENU
if errorlevel 4 goto IMPORT_REG_FILE
if errorlevel 3 goto DELETE_KEY
if errorlevel 2 goto MODIFY_KEY
if errorlevel 1 goto SHOW_KEYS

:SHOW_KEYS
cls
echo Введите путь ключа реестра (пример: HKLM\SOFTWARE\Microsoft):
set /P key_path=Key Path:
reg query "%key_path%"
pause
goto REGEDIT_TOOL

:MODIFY_KEY
cls
echo Введите полный путь ключа реестра (пример: HKCU\Software\MyApp):
set /P modify_key=Key Path:
echo Введите имя параметра:
set /P param_name=Parameter Name:
echo Введите новое значение параметра:
set /P new_value=New Value:
reg add "%modify_key%" /v "%param_name%" /d "%new_value%" /f
if ERRORLEVEL 1 echo Ошибка добавления ключа в реестр! && pause && goto REGEDIT_TOOL
echo Параметр успешно изменён!
pause
goto REGEDIT_TOOL

:DELETE_KEY
cls
echo Введите полный путь ключа реестра (пример: HKCU\Software\MyApp):
set /P delete_key=Key Path:
reg delete "%delete_key%" /f
if ERRORLEVEL 1 echo Ошибка удаления ключа из реестра! && pause && goto REGEDIT_TOOL
echo Ключ успешно удалён!
pause
goto REGEDIT_TOOL

:IMPORT_REG_FILE
cls
echo Введите путь к файлу .reg (полностью):
set /P file_path=File Path:
reg import "%file_path%"
if ERRORLEVEL 1 echo Ошибка импорта файла реестра! && pause && goto REGEDIT_TOOL
echo Файл реестра импортирован успешно!
pause
goto REGEDIT_TOOL

:MBR_TOOL
cls
echo.
echo                  ____                 __     
echo                 / __ \_________ _____/ /_____
echo                / /_/ / ___/ __ `/ __  / ___/
echo               / _, _(__  ) /_/ / /_/ / /__  
echo              /_/ |_/____/\__,_/\__,_/\___/  
echo.
echo ======================================
echo 1. Сделать резервную копию MBR
echo 2. Восстановить MBR
echo B. Назад
echo ======================================
choice /c 12B /n /m "Ваш выбор:"
if errorlevel 3 goto MENU
if errorlevel 2 call :RESTORE_MBR
if errorlevel 1 call :BACKUP_MBR

:DISK_SELECTION
cls
echo Выбор физического диска:
wmic diskdrive list brief
echo.
echo 1. //.\PhysicalDrive0
echo 2. //.\PhysicalDrive1
echo 3. //.\PhysicalDrive2
echo X. Вернуться назад
choice /c 123X /n /m "Выберите номер диска:"
if errorlevel 4 goto MBR_TOOL
if errorlevel 3 set DISK=//.\PhysicalDrive2&goto :NEXT
if errorlevel 2 set DISK=//.\PhysicalDrive1&goto :NEXT
if errorlevel 1 set DISK=//.\PhysicalDrive0&goto :NEXT
goto DISK_SELECTION

:NEXT
goto %1%

:BACKUP_MBR
call :DISK_SELECTION BACKUP_MBR
echo Backing up MBR from %DISK% to mbr_backup.bin...
dd if=%DISK% of="%~dp0mbr_backup.bin" bs=512 count=1 conv=notrunc
if ERRORLEVEL 1 echo Ошибка при создании резервной копии MBR! && goto MBR_TOOL
echo Резервная копия успешно создана!
timeout /T 3 >NUL
goto MBR_TOOL

:RESTORE_MBR
call :DISK_SELECTION RESTORE_MBR
if not exist "%~dp0mbr_backup.bin" echo Файл резервной копии MBR не найден! && timeout /T 3 >NUL & goto MBR_TOOL
echo Внимание! Вы собираетесь восстановить MBR на диск %DISK%. Эта операция необратима!
choice /c YN /n /m "Продолжить операцию?"
if errorlevel 2 goto MBR_TOOL
echo Restoring MBR from mbr_backup.bin to %DISK%...
dd if="%~dp0mbr_backup.bin" of=%DISK% bs=512 count=1 conv=notrunc
if ERRORLEVEL 1 echo Ошибка при восстановлении MBR! && goto MBR_TOOL
echo MBR успешно восстановлена!
timeout /T 3 >NUL
goto MBR_TOOL

:RESTART_OR_EXIT
if "%IN_WINRE%"=="YES" (
    shutdown /r /fw /t 0
    exit
) else (
    shutdown /r /t 0
    exit
)