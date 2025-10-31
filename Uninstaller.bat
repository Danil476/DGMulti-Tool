@echo off
chcp 65001 > NUL
color 0B
title DGMulti-Tool Uninstaller

REM Флаг скрытого файла состояния
set STATE_FILE=%~dp0.hidden_state.cfg

REM Чтение текущего состояния из файла (если существует)
if exist "%STATE_FILE%" (
    for /f "tokens=1,* delims==" %%A in ('type "%STATE_FILE%"') do (
        if "%%A" equ "Language" set LANGUAGE=%%B
    )
)

REM Установка языка по умолчанию, если он не задан
if not defined LANGUAGE set LANGUAGE=Russian

REM Локализация сообщений
if "%LANGUAGE%" equ "English" (
    set MSG_CONFIRM_DELETE=Do you want to remove DGMulti-Tool completely? (Y/N)
    set MSG_DELETING=Deleting program...
    set MSG_SUCCESS=Successfully removed.
    set MSG_ERROR=Error removing program.
) else if "%LANGUAGE%" equ "Russian" (
    set MSG_CONFIRM_DELETE=Хотите полностью удалить DGMulti-Tool? (Y/N)
    set MSG_DELETING=Удаляю программу...
    set MSG_SUCCESS=Удаление прошло успешно.
    set MSG_ERROR=Ошибка при удалении программы.
) else if "%LANGUAGE%" equ "ChineseSimp" (
    set MSG_CONFIRM_DELETE=您确定要彻底删除 DGMulti-Tool？（Y/N）
    set MSG_DELETING=正在卸载程序...
    set MSG_SUCCESS=卸载成功。
    set MSG_ERROR=卸载过程中出现错误。
) else if "%LANGUAGE%" equ "ChineseTrad" (
    set MSG_CONFIRM_DELETE=您確定要彻底刪除 DGMulti-Tool？（Y/N）
    set MSG_DELETING=正在移除程式...
    set MSG_SUCCESS=移除成功。
    set MSG_ERROR=移除過程中出現錯誤。
)

REM Подтверждение удаления
echo %MSG_CONFIRM_DELETE%
choice /c YN /n /m ""
if errorlevel 2 exit

REM Удаление программы
echo %MSG_DELETING%

REM Удаление каталога программы
rd /s /q "%~dp0"

REM Удаление файла состояния
del "%STATE_FILE%"

REM Сообщение об успехе или неудаче
if errorlevel 1 (
    echo %MSG_ERROR%
) else (
    echo %MSG_SUCCESS%
)

timeout /T 3 >NUL
exit
