# Google Play Console Setup - What You Need to Do

## ✅ Good News: You DON'T Need to Upload Any Certificate!

Google Play Console **already has your upload key certificate registered**. You can see it in:
- **Google Play Console** → **Your App** → **Release** → **Setup** → **App Signing**
- Under **"Upload key certificate"** section
- SHA-1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`

## What Google Play Console Already Has

✅ **Upload Key Certificate** - Already registered (you showed me this)  
✅ **App Signing Key** - Google manages this automatically  
✅ **Certificate Fingerprints** - Already on file

## What You Need to Do

### Step 1: Use the Correct Keystore Locally

Update `android/key.properties` to use the keystore that matches the registered certificate:

```properties
storePassword=[PASSWORD_FOR_UPLOAD_KEYSTORE]
keyPassword=[PASSWORD_FOR_UPLOAD_KEYSTORE]
keyAlias=[ALIAS]
storeFile=app/upload-keystore.jks
```

### Step 2: Build Your App Bundle

```powershell
flutter build appbundle --release
```

This creates: `build/app/outputs/bundle/release/app-release.aab`

### Step 3: Upload the .aab File

1. Go to **Google Play Console**
2. Navigate to: **Your App** → **Production** (or **Testing**)
3. Click **"Create new release"** or **"Edit release"**
4. Click **"Upload"** button
5. Select: `build/app/outputs/bundle/release/app-release.aab`
6. Wait for upload to complete

### Step 4: Google Play Console Will Automatically

- ✅ Verify the signature matches the registered upload key certificate
- ✅ Show an error if it doesn't match (like you're seeing now)
- ✅ Accept the upload if the signature matches
- ✅ Re-sign with the app signing key for distribution

## What Happens When You Upload

1. **You upload:** `app-release.aab` (signed with your upload keystore)
2. **Google Play Console checks:** Does the signature match the registered upload certificate?
   - ✅ **If YES:** Accepts the upload and processes it
   - ❌ **If NO:** Shows error "Your Android App Bundle is signed with the wrong key"
3. **Google Play Console re-signs:** Uses the app signing key to create the final APK/AAB for users

## Current Problem

You're getting this error because:
- Your `key.properties` is using `app-release-key.jks` (wrong keystore)
- This keystore has SHA-1: `F3:36:99:48:BB:F6:66:19:23:09:86:67:98:36:47:DF:5F:EF:DD:B1`
- But Google Play Console expects SHA-1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`

## Solution

1. **Find the password** for `android/app/upload-keystore.jks`
2. **Update `key.properties`** to use `app/upload-keystore.jks`
3. **Rebuild** the app bundle
4. **Upload** the new `.aab` file

## Summary

- ❌ **DON'T upload:** Any certificate files (.cer, .pem, .crt, .jks)
- ✅ **DO upload:** The signed `.aab` file
- 🔑 **Google already has:** Your upload key certificate registered
- ✅ **You just need:** To sign your app with the matching keystore locally

## No Action Needed on Play Console Side

You don't need to:
- Upload any certificates
- Register any keys
- Change any settings in Play Console
- Contact Google support (unless you can't find the keystore password)

Just use the correct keystore locally, build, and upload!

