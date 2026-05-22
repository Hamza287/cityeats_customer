# Keystore Password - Important Information

## ❌ What It's NOT
- **NOT** your Google Play Console account password
- **NOT** your Apple Developer account password  
- **NOT** your Google account password
- **NOT** your email password

## ✅ What It IS
The keystore password is a **local password** that was set when the keystore file (`.jks` file) was created. It's used to protect the private key stored in the keystore file.

## Where to Find the Password

### 1. **Check Common Passwords**
Try these common passwords that might have been used:
- `cityeats2024` (used in key.properties)
- `cityeats2023`
- `cityeats2025`
- `cityeats`
- `waselni` (if this was the original project name)
- The same password as your `app-release-key.jks`

### 2. **Check Documentation**
- Password manager (LastPass, 1Password, Bitwarden, etc.)
- Secure notes or documentation files
- Team shared documents
- Project documentation files

### 3. **Ask Team Members**
- Other developers who worked on the project
- Project manager or team lead
- Previous developers (if any left the team)

### 4. **Check Backup Locations**
- Email attachments (search for "keystore" or "password")
- Cloud storage (Google Drive, Dropbox, OneDrive)
- Secure notes or encrypted files
- Old project documentation

### 5. **Try the Same Password as Other Keystores**
Since `app-release-key.jks` uses `cityeats2024`, try that first for `upload-keystore.jks`:

```powershell
keytool -list -v -keystore android\app\upload-keystore.jks -storepass cityeats2024 | findstr "SHA1:"
```

## How to Check if Password is Correct

Run this command (replace `[PASSWORD]` with the password you want to try):

```powershell
keytool -list -v -keystore android\app\upload-keystore.jks -storepass [PASSWORD] | findstr "SHA1:"
```

**If the password is correct**, you'll see:
```
SHA1: B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
```

**If the password is wrong**, you'll see:
```
keytool error: java.io.IOException: keystore password was incorrect
```

## If You Can't Find the Password

### Option 1: Request Upload Key Reset (Last Resort)
1. Go to **Google Play Console** → **Your App** → **Release** → **Setup** → **App Signing**
2. Click **"Request upload key reset"**
3. You'll need to provide proof of ownership
4. This process can take **weeks** and may be **denied**
5. ⚠️ **Only use this if you absolutely cannot find the keystore password**

### Option 2: Check if Password is Documented
- Search your computer for files containing "upload-keystore" or "keystore password"
- Check password managers
- Check secure team documentation

## Quick Test Script

I've created `android/find_upload_key.ps1` that will try common passwords automatically. Run it:

```powershell
cd android
powershell -ExecutionPolicy Bypass -File find_upload_key.ps1
```

## Important Notes

- ⚠️ **Never share your keystore password publicly**
- ✅ **Store passwords securely** (password manager)
- ✅ **Document passwords** in secure team locations
- ✅ **Keep backups** of keystore files in multiple secure locations

