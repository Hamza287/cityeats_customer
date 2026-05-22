# How to Upload Your App to Google Play Console

## ⚠️ Important: You DON'T Upload the Keystore File!

**You DO NOT upload the keystore file (`.jks`) to Google Play Console.**

Instead:
1. **Use the keystore locally** to sign your app bundle
2. **Upload the signed app bundle** (`.aab` file) to Google Play Console
3. **Google Play Console** handles the app signing automatically

## Step-by-Step Process

### Step 1: Find the Correct Keystore Password

First, you need to find the password for `android/app/upload-keystore.jks` that matches SHA-1:
```
B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
```

### Step 2: Update key.properties

Once you have the password, update `android/key.properties`:

```properties
storePassword=[YOUR_UPLOAD_KEYSTORE_PASSWORD]
keyPassword=[YOUR_UPLOAD_KEY_PASSWORD]
keyAlias=[YOUR_KEY_ALIAS]
storeFile=app/upload-keystore.jks
```

**To find the key alias**, run:
```powershell
keytool -list -keystore android\app\upload-keystore.jks -storepass [YOUR_PASSWORD]
```

### Step 3: Build the Signed App Bundle

Run this command to build a signed app bundle:

```powershell
flutter build appbundle --release
```

This will create a file at:
```
build/app/outputs/bundle/release/app-release.aab
```

### Step 4: Upload the .aab File to Google Play Console

1. **Go to Google Play Console:**
   - Navigate to: **Your App** → **Production** (or **Testing** track)
   - Click **"Create new release"** or **"Edit release"**

2. **Upload the .aab file:**
   - Click **"Upload"** or drag and drop
   - Select the file: `build/app/outputs/bundle/release/app-release.aab`
   - Wait for upload to complete

3. **Google Play Console will:**
   - ✅ Automatically verify the signature
   - ✅ Use your upload key to verify it's from you
   - ✅ Re-sign it with the app signing key for distribution
   - ✅ Show an error if the signature doesn't match

### Step 5: Complete the Release

- Fill in release notes
- Review the release
- Click **"Save"** and then **"Review release"**
- Submit for review

## What Files Are Involved?

### Files You Use Locally (NOT uploaded):
- ✅ `android/app/upload-keystore.jks` - Your upload keystore file
- ✅ `android/key.properties` - Configuration file (kept local, not in git)

### Files You Upload to Google Play Console:
- ✅ `app-release.aab` - The signed app bundle file

### Files Google Play Console Uses (Already set up):
- ✅ App Signing Key - Google manages this (you don't have access)
- ✅ Upload Key Certificate - Google has this (matches your keystore)

## Current Problem

Right now, you're using the **wrong keystore** (`app-release-key.jks`) which has SHA-1:
```
F3:36:99:48:BB:F6:66:19:23:09:86:67:98:36:47:DF:5F:EF:DD:B1
```

But Google Play Console expects SHA-1:
```
B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
```

## Solution

1. **Find the password** for `android/app/upload-keystore.jks`
2. **Update `android/key.properties`** to use `app/upload-keystore.jks`
3. **Rebuild** the app bundle
4. **Upload** the new `.aab` file

## Quick Reference Commands

**Check keystore SHA-1:**
```powershell
keytool -list -v -keystore android\app\upload-keystore.jks -storepass [PASSWORD] | findstr "SHA1:"
```

**List key aliases:**
```powershell
keytool -list -keystore android\app\upload-keystore.jks -storepass [PASSWORD]
```

**Build signed app bundle:**
```powershell
flutter build appbundle --release
```

**Find the built .aab file:**
```powershell
Get-ChildItem -Path build\app\outputs\bundle\release\*.aab
```

## Summary

- ❌ **DON'T upload:** `.jks` keystore files
- ✅ **DO upload:** `.aab` app bundle file
- 🔑 **Use locally:** Keystore file to sign your app
- 📤 **Upload to Play Console:** Signed app bundle (.aab file)

