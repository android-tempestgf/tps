@echo off
setlocal enabledelayedexpansion

REM Script de Verificación de Release para Travel Planner - Windows
REM Este script verifica el estado de un release y sus assets

echo.
echo ========================================
echo  Travel Planner - Verificador de Releases
echo ========================================
echo.

REM Verificar que estamos en un repositorio git
git rev-parse --git-dir >nul 2>&1
if !errorlevel! neq 0 (
    echo Error: No estás en un repositorio git
    exit /b 1
)

:menu
echo.
echo 1. Listar todos los releases
echo 2. Verificar un release específico
echo 3. Verificar estado de workflows
echo 4. Mostrar información del proyecto
echo 5. Salir
echo.

set /p choice="Selecciona una opción (1-5): "

if "%choice%"=="1" goto list_releases
if "%choice%"=="2" goto verify_release
if "%choice%"=="3" goto check_workflows
if "%choice%"=="4" goto project_info
if "%choice%"=="5" goto exit
echo Opción inválida. Por favor selecciona 1-5.
goto menu

:list_releases
echo.
echo 📦 Tags/Releases disponibles:
echo.
git tag -l --sort=-version:refname
echo.
pause
goto menu

:verify_release
echo.
set /p version="Introduce la versión del release a verificar (ej. v0.1.0): "

echo.
echo 🔍 Verificando release %version%...
echo.

REM Verificar si el tag existe
git rev-parse %version% >nul 2>&1
if !errorlevel! neq 0 (
    echo ❌ Tag %version% no encontrado
    pause
    goto menu
)

echo ✅ Tag %version% encontrado
echo.

echo 📋 Información del tag:
git show %version% --no-patch --format="Autor: %%an%%nFecha: %%ad%%nMensaje: %%s%%n%%n%%b"
echo.

echo 📁 Archivos en el commit:
git ls-tree -r --name-only %version% | findstr /E ".kt .xml .md .yml .gradle"
echo.

pause
goto menu

:check_workflows
echo.
echo 🔄 Verificando archivos de workflow...
echo.

if exist ".github\workflows\release.yml" (
    echo ✅ Workflow de release encontrado
) else (
    echo ❌ Workflow de release no encontrado
)

if exist ".github\workflows\pr-workflow.yml" (
    echo ✅ Workflow de PR encontrado
) else (
    echo ❌ Workflow de PR no encontrado
)

echo.
echo 📊 Para ver el estado en GitHub Actions:
echo https://github.com/android-tempestgf/tps/actions
echo.

pause
goto menu

:project_info
echo.
echo 📱 Información del Proyecto Travel Planner
echo ==========================================
echo.

REM Leer versión del build.gradle.kts
for /f "tokens=2 delims=^"" %%i in ('findstr "versionName = " app\build.gradle.kts 2^>nul') do (
    echo Versión actual: %%i
)

REM Mostrar rama actual
for /f "tokens=*" %%i in ('git branch --show-current') do (
    echo Rama actual: %%i
)

REM Mostrar último commit
echo.
echo Último commit:
git log -1 --oneline

REM Mostrar estructura principal
echo.
echo 📁 Estructura principal:
if exist "app\" echo   ✅ app/ - Código de la aplicación
if exist "docs\" echo   ✅ docs/ - Documentación
if exist "scripts\" echo   ✅ scripts/ - Scripts de utilidades
if exist ".github\" echo   ✅ .github/ - Workflows y templates
if exist "CHANGELOG.md" echo   ✅ CHANGELOG.md - Historial de cambios
if exist "CONTRIBUTING.md" echo   ✅ CONTRIBUTING.md - Guía de contribución

echo.
pause
goto menu

:exit
echo.
echo ¡Hasta luego!
echo.
exit /b 0
