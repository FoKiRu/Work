:: v0.1
@echo off
:: Получаем путь к родительской директории скрипта (выход из \base)
set BASE_DIR=%~dp0..
:: Определяем путь к .ini файлу, ярлыку и другому .bat файлу
set INI_FILE=%BASE_DIR%\bin\win\rk7srv.ini
set EXE_FILE=%BASE_DIR%\bin\win\refsrv.exe
set BAT_FILE=%BASE_DIR%\bin\win\rk7man.bat

:: Проверяем, если USESQL=1
findstr /i "USESQL=1" "%INI_FILE%" >nul
if %errorlevel%==0 (
    echo USESQL=1 найдено, меняем на 0...
    :: Заменяем USESQL=1 на USESQL=0 в файле
    powershell -Command "(Get-Content '%INI_FILE%') -replace 'USESQL=1', 'USESQL=0' | Set-Content '%INI_FILE%'"
)

:: Запускаем refsrv.exe с параметром -desktop
echo Запуск refsrv.exe с параметром -desktop...
start "" "%EXE_FILE%" -desktop

:: Запускаем второй .bat файл
start "" "%BAT_FILE%"

exit
