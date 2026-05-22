# Script to find the keystore with the correct upload key SHA-1
# Expected SHA-1: B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53

$expectedSHA1 = "B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Finding Upload Key Keystore" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Expected SHA-1: $expectedSHA1" -ForegroundColor Green
Write-Host ""

$keystores = @(
    @{Path="app-release-key.jks"; Password="cityeats2024"},
    @{Path="app\keystore.jks"; Password="cityeats2024"},
    @{Path="app\upload-keystore.jks"; Password="cityeats2024"}
)

foreach ($ks in $keystores) {
    $fullPath = Join-Path $PSScriptRoot $ks.Path
    if (Test-Path $fullPath) {
        Write-Host "Checking: $($ks.Path)" -ForegroundColor Yellow
        try {
            $output = keytool -list -v -keystore $fullPath -storepass $ks.Password 2>&1
            if ($LASTEXITCODE -eq 0) {
                $sha1Match = $output | Select-String -Pattern "SHA1:\s+([A-F0-9:]+)"
                if ($sha1Match) {
                    $sha1 = $sha1Match.Matches[0].Groups[1].Value
                    Write-Host "  SHA-1: $sha1" -ForegroundColor White
                    if ($sha1 -eq $expectedSHA1) {
                        Write-Host "  ✓✓✓ MATCH FOUND! This is your upload key! ✓✓✓" -ForegroundColor Green
                        Write-Host ""
                        Write-Host "Update android/key.properties with:" -ForegroundColor Cyan
                        Write-Host "  storeFile=$($ks.Path)" -ForegroundColor White
                        Write-Host "  storePassword=$($ks.Password)" -ForegroundColor White
                        Write-Host "  (Also update keyAlias and keyPassword if different)" -ForegroundColor Gray
                        return
                    } else {
                        Write-Host "  ✗ Does not match" -ForegroundColor Red
                    }
                }
            } else {
                Write-Host "  ✗ Wrong password or error. Try a different password." -ForegroundColor Red
            }
        } catch {
            Write-Host "  ✗ Error: $_" -ForegroundColor Red
        }
        Write-Host ""
    }
}

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "No match found with default password." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Try running this command manually with different passwords:" -ForegroundColor Cyan
Write-Host "  keytool -list -v -keystore android\app\upload-keystore.jks -storepass [YOUR_PASSWORD] | findstr SHA1:" -ForegroundColor White
Write-Host ""

