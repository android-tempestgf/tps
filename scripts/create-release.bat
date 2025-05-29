@echo off
setlocal enabledelayedexpansion

REM Script de Creación de Releases para Travel Planner para Windows
REM Este script ayuda a crear un nuevo release siguiendo versionado semántico

echo.
echo ==========================================
echo  Script de Creación de Releases
echo  Travel Planner
echo ==========================================
echo.

REM Verificar si estamos en un repositorio git
git status >nul 2>&1
if !errorlevel! neq 0 (
    echo Error: No estamos en un repositorio git
    exit /b 1
)

REM Verificar rama actual
for /f "tokens=*" %%i in ('git branch --show-current') do set current_branch=%%i
if not "%current_branch%"=="main" if not "%current_branch%"=="develop" (
    echo Error: Debes estar en la rama 'main' o 'develop' para crear un release.
    echo Rama actual: %current_branch%
    exit /b 1
)

REM Verificar si el directorio de trabajo está limpio
git diff-index --quiet HEAD -- >nul 2>&1
if !errorlevel! neq 0 (
    echo Error: El directorio de trabajo no está limpio. Por favor confirma o guarda tus cambios.
    exit /b 1
)

REM Obtener versión actual de app/build.gradle.kts
for /f "tokens=2 delims=^" %%i in ('findstr "versionName = " app\build.gradle.kts') do (
    set version_line=%%i
)
for /f "tokens=2 delims=^"" %%i in ("!version_line!") do set current_version=%%i

echo Versión actual: %current_version%
echo.

REM Parsear partes de la versión
for /f "tokens=1,2,3 delims=." %%a in ("%current_version%") do (
    set major=%%a
    set minor=%%b
    set patch=%%c
)

REM Calcular versiones sugeridas
set /a suggested_patch_num=%patch%+1
set suggested_patch=%major%.%minor%.%suggested_patch_num%

set /a suggested_minor_num=%minor%+1
set suggested_minor=%major%.%suggested_minor_num%.0

set /a suggested_major_num=%major%+1
set suggested_major=%suggested_major_num%.0.0

echo Próximas versiones sugeridas:
echo   1. Release de parche (correcciones): %suggested_patch%
echo   2. Release menor (nuevas funcionalidades): %suggested_minor%
echo   3. Release mayor (cambios incompatibles): %suggested_major%
echo   4. Versión personalizada
echo.

set /p version_choice="Elige tipo de versión (1-4): "

if "%version_choice%"=="1" (
    set new_version=%suggested_patch%
) else if "%version_choice%"=="2" (
    set new_version=%suggested_minor%
) else if "%version_choice%"=="3" (
    set new_version=%suggested_major%
) else if "%version_choice%"=="4" (
    set /p new_version="Introduce versión personalizada (ej., 0.2.0): "
) else (
    echo Opción inválida. Saliendo.
    exit /b 1
)

echo.
echo Creando release para la versión: %new_version%
echo.

set /p confirm="¿Quieres proceder con crear el release v%new_version%? (s/N): "
if /i not "%confirm%"=="s" (
    echo Creación de release cancelada.
    exit /b 0
)

echo.
echo Actualizando versión en app/build.gradle.kts...

REM Actualizar versión en build.gradle.kts (usando PowerShell para reemplazo de texto confiable)
powershell -Command "(Get-Content 'app\build.gradle.kts') -replace 'versionName = \".*\"', 'versionName = \"%new_version%\"' | Set-Content 'app\build.gradle.kts'"

echo Confirmando cambio de versión...
git add app\build.gradle.kts CHANGELOG.md
git commit -m "chore: actualizar versión a v%new_version%

- Versión de app actualizada a %new_version%
- CHANGELOG.md actualizado con notas del release"

echo Creando tag v%new_version%...
git tag -a "v%new_version%" -m "Release v%new_version%"

echo Subiendo cambios y tag al remoto...
git push origin %current_branch%
git push origin "v%new_version%"

echo.
echo ==========================================
echo  ¡Release v%new_version% creado exitosamente!
echo ==========================================
echo.
echo GitHub Actions ahora construirá el APK y creará el release.
echo Verifica la pestaña Actions en tu repositorio de GitHub para el progreso.
echo.

pause
