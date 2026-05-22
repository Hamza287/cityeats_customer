@echo off
echo ========================================
echo Checking All Keystore Files for Match
echo Expected SHA-1: B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
echo ========================================
echo.

set EXPECTED_SHA1=B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
set FOUND=0

echo [1/9] Checking: waselni-key.jks
if exist "C:\Users\Rimsha\waselni-key.jks" (
    keytool -list -v -keystore "C:\Users\Rimsha\waselni-key.jks" 2>nul | findstr /C:"SHA1" > temp_sha1.txt
    type temp_sha1.txt
    findstr /C:"%EXPECTED_SHA1%" temp_sha1.txt >nul
    if %errorlevel% == 0 (
        echo *** MATCH FOUND! ***
        set FOUND=1
    )
    del temp_sha1.txt
    echo.
)

echo [2/9] Checking: city_eats_customer_app\android\app-release-key.jks
if exist "C:\Users\Rimsha\city_eats_customer_app\android\app-release-key.jks" (
    keytool -list -v -keystore "C:\Users\Rimsha\city_eats_customer_app\android\app-release-key.jks" -storepass cityeats2024 2>nul | findstr /C:"SHA1" > temp_sha1.txt
    type temp_sha1.txt
    findstr /C:"%EXPECTED_SHA1%" temp_sha1.txt >nul
    if %errorlevel% == 0 (
        echo *** MATCH FOUND! ***
        set FOUND=1
    )
    del temp_sha1.txt
    echo.
)

echo [3/9] Checking: city_eats_rider_app\android\app\keystore.jks
if exist "C:\Users\Rimsha\city_eats_rider_app\android\app\keystore.jks" (
    keytool -list -v -keystore "C:\Users\Rimsha\city_eats_rider_app\android\app\keystore.jks" -storepass E3Graphy7793 2>nul | findstr /C:"SHA1" > temp_sha1.txt
    type temp_sha1.txt
    findstr /C:"%EXPECTED_SHA1%" temp_sha1.txt >nul
    if %errorlevel% == 0 (
        echo *** MATCH FOUND! ***
        set FOUND=1
    )
    del temp_sha1.txt
    echo.
)

echo [4/9] Checking: city_eats_rider_app\android\app\upload-keystore.jks
if exist "C:\Users\Rimsha\city_eats_rider_app\android\app\upload-keystore.jks" (
    keytool -list -v -keystore "C:\Users\Rimsha\city_eats_rider_app\android\app\upload-keystore.jks" -storepass E3Graphy7793 2>nul | findstr /C:"SHA1" > temp_sha1.txt
    type temp_sha1.txt
    findstr /C:"%EXPECTED_SHA1%" temp_sha1.txt >nul
    if %errorlevel% == 0 (
        echo *** MATCH FOUND! ***
        set FOUND=1
    )
    del temp_sha1.txt
    echo.
)

echo ========================================
if %FOUND% == 1 (
    echo SUCCESS: Matching keystore found!
) else (
    echo No matching keystore found in checked locations.
    echo.
    echo Next steps:
    echo 1. Check backup locations (external drives, cloud storage)
    echo 2. Check with team members
    echo 3. Check email attachments or old project archives
    echo 4. If using Google Play App Signing, you may need to request upload key reset
)
echo ========================================
pause

