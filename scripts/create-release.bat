@echo off
setlocal enabledelayedexpansion

REM Travel Planner Release Creation Script for Windows
REM This script helps create a new release following semantic versioning

echo.
echo ==========================================
echo  Travel Planner Release Creation Script
echo ==========================================
echo.

REM Check if we're in a git repository
git status >nul 2>&1
if !errorlevel! neq 0 (
    echo Error: Not in a git repository
    exit /b 1
)

REM Check current branch
for /f "tokens=*" %%i in ('git branch --show-current') do set current_branch=%%i
if not "%current_branch%"=="main" if not "%current_branch%"=="develop" (
    echo Error: You must be on the 'main' or 'develop' branch to create a release.
    echo Current branch: %current_branch%
    exit /b 1
)

REM Check if working directory is clean
git diff-index --quiet HEAD -- >nul 2>&1
if !errorlevel! neq 0 (
    echo Error: Working directory is not clean. Please commit or stash your changes.
    exit /b 1
)

REM Get current version from app/build.gradle.kts
for /f "tokens=2 delims=^" %%i in ('findstr "versionName = " app\build.gradle.kts') do (
    set version_line=%%i
)
for /f "tokens=2 delims=^"" %%i in ("!version_line!") do set current_version=%%i

echo Current version: %current_version%
echo.

REM Parse version parts
for /f "tokens=1,2,3 delims=." %%a in ("%current_version%") do (
    set major=%%a
    set minor=%%b
    set patch=%%c
)

REM Calculate suggested versions
set /a suggested_patch_num=%patch%+1
set suggested_patch=%major%.%minor%.%suggested_patch_num%

set /a suggested_minor_num=%minor%+1
set suggested_minor=%major%.%suggested_minor_num%.0

set /a suggested_major_num=%major%+1
set suggested_major=%suggested_major_num%.0.0

echo Suggested next versions:
echo   1. Patch release (bug fixes): %suggested_patch%
echo   2. Minor release (new features): %suggested_minor%
echo   3. Major release (breaking changes): %suggested_major%
echo   4. Custom version
echo.

set /p version_choice="Choose version type (1-4): "

if "%version_choice%"=="1" (
    set new_version=%suggested_patch%
) else if "%version_choice%"=="2" (
    set new_version=%suggested_minor%
) else if "%version_choice%"=="3" (
    set new_version=%suggested_major%
) else if "%version_choice%"=="4" (
    set /p new_version="Enter custom version (e.g., 0.2.0): "
) else (
    echo Invalid choice. Exiting.
    exit /b 1
)

echo.
echo Creating release for version: %new_version%
echo.

set /p confirm="Do you want to proceed with creating release v%new_version%? (y/N): "
if /i not "%confirm%"=="y" (
    echo Release creation cancelled.
    exit /b 0
)

echo.
echo Updating version in app/build.gradle.kts...

REM Update version in build.gradle.kts (using PowerShell for reliable text replacement)
powershell -Command "(Get-Content 'app\build.gradle.kts') -replace 'versionName = \".*\"', 'versionName = \"%new_version%\"' | Set-Content 'app\build.gradle.kts'"

echo Committing version change...
git add app\build.gradle.kts CHANGELOG.md
git commit -m "chore: bump version to v%new_version%

- Updated app version to %new_version%
- Updated CHANGELOG.md with release notes"

echo Creating tag v%new_version%...
git tag -a "v%new_version%" -m "Release v%new_version%"

echo Pushing changes and tag to remote...
git push origin %current_branch%
git push origin "v%new_version%"

echo.
echo ==========================================
echo  Release v%new_version% created successfully!
echo ==========================================
echo.
echo GitHub Actions will now build the APK and create the release.
echo Check the Actions tab in your GitHub repository for build progress.
echo.

pause
