:: v0.1.2
@echo off
:: Кириллица - 65001, тк исходники в UTF-8 кодировке.
chcp 65001 
:: Получаем путь к родительской директории скрипта (выход из \base)
set BASE_DIR=%~dp0..
:: Проверяем, что скрипт находится в каталоге \base
if not exist "%BASE_DIR%\bin\win\rk7srv.ini" (
    echo Скрипт не находится в \base. Убедитесь, что он находится в правильной директории.
    timeout /t 10 /nobreak
    exit /b
)

:: Определяем путь к .ini файлу, ярлыку и другому .bat файлу
set INI_FILE=%BASE_DIR%\bin\win\rk7srv.ini
set EXE_FILE=%BASE_DIR%\bin\win\refsrv.exe
set BAT_FILE=%BASE_DIR%\bin\win\rk7man.bat

:: Запрашиваем пользователя, с каким параметром USESQL запускать
echo С каким параметром USESQL запускать?
echo Введите 1 для USESQL=1 или 0 для USESQL=0:
set /p USESQL_VALUE="Параметр USESQL (1 или 0): "

:: Если ничего не введено, устанавливается USESQL=0 по умолчанию
if "%USESQL_VALUE%"=="" set USESQL_VALUE=0 

:: Проверка, введено ли значение 1 или 0
if "%USESQL_VALUE%"=="1" (
    echo Запускаем с USESQL=1...
    :: Заменяем USESQL=0 на USESQL=1 в файле
    powershell -Command "(Get-Content '%INI_FILE%') -replace 'USESQL=0', 'USESQL=1' | Set-Content '%INI_FILE%'"
) else if "%USESQL_VALUE%"=="0" (
    echo Запускаем с USESQL=0...
    :: Заменяем USESQL=1 на USESQL=0 в файле
    powershell -Command "(Get-Content '%INI_FILE%') -replace 'USESQL=1', 'USESQL=0' | Set-Content '%INI_FILE%'"
) else (
    echo Ошибка! Введено некорректное значение. Используйте 1 или 0.
    timeout /t 10 /nobreak
    exit /b
)
 
:: Запускаем refsrv.exe с параметром -desktop
echo Запуск refsrv.exe с параметром -desktop...
start "" "%EXE_FILE%" -desktop

:: Пауза в 5 секунд перед запуском второго .bat файла
timeout /t 5 /nobreak

:: Запускаем второй .bat файл
echo Запуск rk7man.bat...
start "" "%BAT_FILE%"

exit
