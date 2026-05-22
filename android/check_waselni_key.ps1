# Script to check waselni-key.jks for the upload key
# Expected SHA-1: B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53

param(
    [string]$KeystorePath = "waselni-key.jks",
    [string]$Password = ""
)

$expectedSHA1 = "B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Checking waselni-key.jks" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Expected SHA-1: $expectedSHA1" -ForegroundColor Green
Write-Host ""

if (-not (Test-Path $KeystorePath)) {
    Write-Host "✗ File not found: $KeystorePath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please provide the full path to waselni-key.jks" -ForegroundColor Yellow
    Write-Host "Example: .\check_waselni_key.ps1 -KeystorePath 'C:\path\to\waselni-key.jks' -Password 'yourpassword'" -ForegroundColor Gray
    exit
}

Write-Host "✓ File found: $KeystorePath" -ForegroundColor Green
Write-Host ""

if ($Password) {
    Write-Host "Testing with provided password..." -ForegroundColor Yellow
    $output = keytool -list -v -keystore $KeystorePath -storepass $Password 2>&1
    if ($LASTEXITCODE -eq 0) {
        $sha1 = ($output | Select-String -Pattern "SHA1:\s+([A-F0-9:]+)").Matches.Groups[1].Value
        if ($sha1) {
            Write-Host "SHA-1: $sha1" -ForegroundColor White
            if ($sha1 -eq $expectedSHA1) {
                Write-Host ""
                Write-Host "✓✓✓ PERFECT MATCH! This is the upload key! ✓✓✓" -ForegroundColor Green
                Write-Host ""
                Write-Host "Get the key alias:" -ForegroundColor Cyan
                Write-Host "  keytool -list -keystore '$KeystorePath' -storepass '$Password'" -ForegroundColor White
                Write-Host ""
                Write-Host "Then update android/key.properties:" -ForegroundColor Cyan
                Write-Host "  storePassword=$Password" -ForegroundColor White
                Write-Host "  keyPassword=$Password" -ForegroundColor White
                Write-Host "  keyAlias=[ALIAS_FROM_ABOVE]" -ForegroundColor White
                Write-Host "  storeFile=[PATH_TO_KEYSTORE]" -ForegroundColor White
            } else {
                Write-Host "✗ Does not match expected SHA-1" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "✗ Wrong password or error" -ForegroundColor Red
    }
} else {
    Write-Host "Trying common passwords..." -ForegroundColor Yellow
    $passwords = @("cityeats2024", "cityeats2025", "cityeats2026", "waselni2024", "waselni2025", "waselni2026", "waselni", "waselni-key", "waselni2023")
    
    foreach ($pwd in $passwords) {
        Write-Host "  Trying: $pwd" -ForegroundColor Gray
        $output = keytool -list -v -keystore $KeystorePath -storepass $pwd 2>&1
        if ($LASTEXITCODE -eq 0) {
            $sha1 = ($output | Select-String -Pattern "SHA1:\s+([A-F0-9:]+)").Matches.Groups[1].Value
            if ($sha1) {
                Write-Host "    SHA-1: $sha1" -ForegroundColor White
                if ($sha1 -eq $expectedSHA1) {
                    Write-Host ""
                    Write-Host "✓✓✓ MATCH FOUND! Password is: $pwd ✓✓✓" -ForegroundColor Green
                    Write-Host ""
                    Write-Host "Get the key alias:" -ForegroundColor Cyan
                    Write-Host "  keytool -list -keystore '$KeystorePath' -storepass '$pwd'" -ForegroundColor White
                    exit
                } else {
                    Write-Host "    ✗ Wrong keystore (different SHA-1)" -ForegroundColor Red
                }
            }
        }
    }
    Write-Host ""
    Write-Host "✗ None of the common passwords worked" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please provide the password:" -ForegroundColor Yellow
    Write-Host "  .\check_waselni_key.ps1 -KeystorePath '$KeystorePath' -Password 'yourpassword'" -ForegroundColor White
}

