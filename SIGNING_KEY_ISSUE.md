# Android App Bundle Signing Key Mismatch

## Problem
Your uploaded app bundle is signed with a different key than what Google Play expects:

- **Expected SHA1**: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`
- **Uploaded SHA1**: `F3:36:99:48:BB:F6:66:19:23:09:86:67:98:36:47:DF:5F:EF:DD:B1`

## Why This Happens
This occurs when:
1. You're using a different keystore file than the one originally used to publish the app
2. The keystore file was lost or replaced
3. You're using a debug keystore instead of the release keystore

## Solution

### Option 1: Use the Correct Keystore (Recommended)
You need to find and use the **original keystore file** that was used to publish the first version of your app to Google Play.

**Steps:**
1. Locate the original keystore file (the one with SHA1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`)
2. Update your `android/key.properties` file to point to the correct keystore:
   ```properties
   storePassword=your_keystore_password
   keyPassword=your_key_password
   keyAlias=your_key_alias
   storeFile=path/to/your/original/keystore.jks
   ```
3. Rebuild your app bundle:
   ```bash
   flutter build appbundle --release
   ```
4. Upload the new bundle to Google Play Console

### Option 2: Verify Current Keystore
To check which SHA1 your current keystore has, run:
```bash
cd android
keytool -list -v -keystore app-release-key.jks
```
(You'll need to enter your keystore password)

Look for the SHA1 fingerprint in the output. If it doesn't match the expected one, you need to use the original keystore.

### Option 3: Contact Google Play Support (If Keystore is Lost)
⚠️ **WARNING**: If you've lost the original keystore file, you **cannot** update your existing app on Google Play. You would need to:
- Contact Google Play Support to request a key reset (this is very difficult and rarely approved)
- Or publish a new app with a different package name

## Important Notes
- **NEVER lose your release keystore file** - keep multiple secure backups
- The keystore file should be kept in a secure location (not in version control)
- If you're working in a team, ensure all developers know which keystore to use
- Consider using Google Play App Signing, which allows Google to manage your signing key

## Checking Your Current Setup
Your current setup uses:
- Keystore file: `android/app-release-key.jks` (referenced in `key.properties`)
- Configuration: `android/key.properties` (not in git - as expected for security)

Make sure `android/key.properties` points to the correct keystore file that matches the expected SHA1.

