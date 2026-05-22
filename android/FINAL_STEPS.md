# Final Steps - Using waselni-key.jks

## ✅ Found the Keystore!

**File:** `C:\Users\Rimsha\waselni-key.jks`  
**Location:** Found in your user directory

## What You Need

You need the **password** for this keystore file to verify it matches the upload key.

## How to Test the Password

Once you have the password, run this command:

```powershell
keytool -list -v -keystore "C:\Users\Rimsha\waselni-key.jks" -storepass [YOUR_PASSWORD] | findstr "SHA1:"
```

**If it matches**, you should see:
```
SHA1: B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
```

## Get the Key Alias

Once you confirm the password works, get the alias:

```powershell
keytool -list -keystore "C:\Users\Rimsha\waselni-key.jks" -storepass [YOUR_PASSWORD]
```

Look for a line like:
```
waselni-key, Dec 22, 2024, PrivateKeyEntry,
```

The part before the comma (e.g., `waselni-key`) is the alias.

## Update key.properties

Once you have the password and alias, update `android/key.properties`:

```properties
storePassword=[YOUR_PASSWORD]
keyPassword=[YOUR_PASSWORD]
keyAlias=[ALIAS_FROM_ABOVE]
storeFile=../waselni-key.jks
```

**Note:** The path `../waselni-key.jks` is relative to the `android` folder, pointing to `C:\Users\Rimsha\waselni-key.jks`

## Alternative: Copy the Keystore

If you prefer, you can copy the keystore to the android folder:

```powershell
Copy-Item "C:\Users\Rimsha\waselni-key.jks" -Destination "android\waselni-key.jks"
```

Then update `key.properties`:
```properties
storePassword=[YOUR_PASSWORD]
keyPassword=[YOUR_PASSWORD]
keyAlias=[ALIAS]
storeFile=waselni-key.jks
```

## Build and Upload

After updating `key.properties`:

```powershell
flutter build appbundle --release
```

Then upload `build/app/outputs/bundle/release/app-release.aab` to Google Play Console.

## Where to Find the Password

Check:
- Password managers (LastPass, 1Password, Bitwarden, etc.)
- Secure notes or documentation
- Team shared documents
- Email attachments
- Files in `C:\Users\Rimsha\` folder (check .txt, .md, or other documentation files)

