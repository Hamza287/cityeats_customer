@echo off
echo ========================================
echo Searching for Customer App Keystore
echo Expected SHA1: B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
echo ========================================
echo.

echo Checking common locations...
echo.

REM Check customer app directory
if exist "android\app-release-key.jks" (
    echo Found: android\app-release-key.jks
    echo Checking SHA1...
    keytool -list -v -keystore android\app-release-key.jks -storepass cityeats2024 2>nul | findstr /C:"SHA1"
    echo.
)

REM Check for other .jks files in customer app
echo Searching for .jks files in customer app directory...
for /r "C:\Users\Rimsha\city_eats_customer_app" %%f in (*.jks) do (
    echo Found: %%f
    echo Attempting to check SHA1 (may require password)...
    keytool -list -v -keystore "%%f" 2>nul | findstr /C:"SHA1"
    echo.
)

REM Check for .keystore files
echo Searching for .keystore files...
for /r "C:\Users\Rimsha\city_eats_customer_app" %%f in (*.keystore) do (
    echo Found: %%f
    echo Attempting to check SHA1 (may require password)...
    keytool -list -v -keystore "%%f" 2>nul | findstr /C:"SHA1"
    echo.
)

echo ========================================
echo Search complete.
echo.
echo If no matching keystore was found, you may need to:
echo 1. Check backup locations (external drives, cloud storage)
echo 2. Check with team members who may have the original keystore
echo 3. Check Google Play Console for App Signing certificate (if using Play App Signing)
echo ========================================
pause

