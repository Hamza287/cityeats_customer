# Finding the Correct Customer App Keystore

## Current Situation

**Expected SHA1 (from Google Play):**
```
B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
```

**Current Customer App Keystore SHA1:**
```
F3:36:99:48:BB:F6:66:19:23:09:86:67:98:36:47:DF:5F:EF:DD:B1
```
❌ **Does NOT match** - This keystore was created on Jan 6, 2026

**Rider App Keystores Checked:**
- `keystore.jks`: SHA1 `35:45:E1:9E:E7:2A:98:82:CC:4C:53:F0:29:50:5A:9F:E6:A8:F6:DE` ❌
- `upload-keystore.jks`: SHA1 `8A:36:F1:91:30:54:AB:54:18:8C:FD:6B:A2:BD:E4:B6:CA:2D:B4:FF` ❌

## Where to Look for the Original Keystore

### 1. **Check Google Play Console**
- Go to Google Play Console → Your App → Release → Setup → App Signing
- If you're using **Google Play App Signing**, you can download the upload certificate
- The upload certificate SHA1 should match: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`

### 2. **Check Backup Locations**
- External hard drives
- USB drives
- Cloud storage (Google Drive, Dropbox, OneDrive, etc.)
- Email attachments (search for "keystore" or ".jks" files)
- Old project backups

### 3. **Check Team Members**
- Ask other developers who worked on the project
- Check shared team folders or repositories (if keystore was committed before .gitignore)

### 4. **Check Old Project Versions**
- Look for old project folders or archives
- Check version control history (if keystore was committed before being ignored)

### 5. **Check Common Keystore Locations**
- `C:\Users\Rimsha\` (search for *.jks and *.keystore)
- `C:\Android\` or similar Android development folders
- Desktop or Documents folders
- Downloads folder

## How to Verify a Keystore's SHA1

Once you find a potential keystore file, verify its SHA1:

```bash
keytool -list -v -keystore path/to/keystore.jks
```

Enter the keystore password when prompted, then look for the SHA1 fingerprint in the output.

## If You Find the Correct Keystore

1. **Copy it to a secure location** (make backups!)
2. **Update `android/key.properties`**:
   ```properties
   storePassword=your_keystore_password
   keyPassword=your_key_password
   keyAlias=your_key_alias
   storeFile=path/to/original/keystore.jks
   ```
3. **Rebuild the app bundle**:
   ```bash
   flutter build appbundle --release
   ```
4. **Upload to Google Play Console**

## If You Cannot Find the Original Keystore

⚠️ **This is a serious situation.** Without the original keystore, you **cannot update** the existing app on Google Play.

### Options:

1. **Request Upload Key Reset from Google Play** (Very difficult, rarely approved)
   - Go to Google Play Console → Your App → Release → Setup → App Signing
   - Request an upload key reset
   - You'll need to provide proof of ownership
   - This process can take weeks and may be denied

2. **Publish a New App** (Not recommended)
   - Create a new app with a different package name
   - Users would need to download the new app
   - You'd lose all existing users and reviews

3. **Use Google Play App Signing** (If not already enabled)
   - If you have the upload certificate, you can set up Play App Signing
   - This allows Google to manage your signing key

## Prevention for Future

- **Always backup your keystore files** in multiple secure locations
- **Use Google Play App Signing** to let Google manage your signing key
- **Document keystore locations and passwords** in a secure password manager
- **Never commit keystores to version control** (they're already in .gitignore)

## Running the Search Script

I've created `find_customer_app_keystore.bat` that will search for keystore files. Run it from the customer app directory:

```bash
cd C:\Users\Rimsha\city_eats_customer_app
find_customer_app_keystore.bat
```

Note: The script may prompt for passwords when checking keystores.

