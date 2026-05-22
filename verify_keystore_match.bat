@echo off
echo ========================================
echo Verifying Keystore SHA-1 Match
echo Expected SHA-1: B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
echo ========================================
echo.

set EXPECTED_SHA1=B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53

echo Checking customer app keystore...
if exist "android\app-release-key.jks" (
    echo.
    echo Found: android\app-release-key.jks
    echo Getting SHA-1...
    keytool -list -v -keystore android\app-release-key.jks -storepass cityeats2024 2>nul | findstr /C:"SHA1" > temp_sha1.txt
    type temp_sha1.txt
    findstr /C:"%EXPECTED_SHA1%" temp_sha1.txt >nul
    if %errorlevel% == 0 (
        echo.
        echo ========================================
        echo *** MATCH FOUND! ***
        echo This keystore matches the expected SHA-1!
        echo ========================================
    ) else (
        echo.
        echo This keystore does NOT match.
    )
    del temp_sha1.txt
    echo.
)

echo.
echo ========================================
echo To check other keystore files manually:
echo keytool -list -v -keystore path\to\keystore.jks
echo.
echo Then look for the SHA-1 fingerprint and compare with:
echo %EXPECTED_SHA1%
echo ========================================
pause

