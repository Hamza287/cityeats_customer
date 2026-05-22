# Fix Customer App Signing Key Issue

## ✅ Confirmed Information from Google Play Console

**Expected Upload Key SHA-1:**
```
B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
```

**Current Keystore SHA-1 (Does NOT match):**
```
F3:36:99:48:BB:F6:66:19:23:09:86:67:98:36:47:DF:5F:EF:DD:B1
```

## What This Means

Your app is using **Google Play App Signing**, which means:
- Google manages the **app signing key** (used to sign releases for users)
- You need your own **upload key** (used to sign bundles before uploading)
- The upload key certificate shown in Google Play Console matches: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`

## Solution: Find the Original Upload Keystore

You need to find the keystore file that has SHA-1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`

### Step 1: Check Common Locations

I've found these keystore files on your system. Check each one:

1. **`C:\Users\Rimsha\waselni-key.jks`** - Check this one first (might be a shared keystore)
2. **`C:\Users\Rimsha\city_eats_customer_app\android\app-release-key.jks`** - Already checked, doesn't match
3. **`C:\Users\Rimsha\city_eats_rider_app\android\app\keystore.jks`** - Already checked, doesn't match
4. **`C:\Users\Rimsha\city_eats_rider_app\android\app\upload-keystore.jks`** - Already checked, doesn't match

### Step 2: Verify a Keystore's SHA-1

To check if a keystore matches, run:
```bash
keytool -list -v -keystore path/to/keystore.jks
```

Enter the keystore password when prompted, then look for:
```
SHA1: B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
```

### Step 3: Check Other Locations

If the keystores above don't match, check:

1. **Backup Locations:**
   - External hard drives
   - USB drives
   - Cloud storage (Google Drive, Dropbox, OneDrive)
   - Email attachments (search for "keystore" or ".jks")

2. **Team Members:**
   - Ask other developers who worked on the project
   - Check shared team folders

3. **Old Project Versions:**
   - Old project folders or archives
   - Version control history (if keystore was committed before .gitignore)

4. **Common Keystore Names to Search For:**
   - `upload-keystore.jks`
   - `release-key.jks`
   - `customer-app-key.jks`
   - `city-eats-key.jks`
   - `keystore.jks`

### Step 4: Once You Find the Correct Keystore

1. **Copy it to a secure location** (make multiple backups!)

2. **Update `android/key.properties`** in the customer app:
   ```properties
   storePassword=your_keystore_password
   keyPassword=your_key_password
   keyAlias=your_key_alias
   storeFile=path/to/original/keystore.jks
   ```
   
   If the keystore is in the `android` folder, use:
   ```properties
   storeFile=app-release-key.jks
   ```
   
   If it's in the project root, use:
   ```properties
   storeFile=../keystore-name.jks
   ```

3. **Rebuild the app bundle:**
   ```bash
   cd C:\Users\Rimsha\city_eats_customer_app
   flutter clean
   flutter build appbundle --release
   ```

4. **Upload to Google Play Console:**
   - The bundle will be in: `build\app\outputs\bundle\release\app-release.aab`
   - Upload this file to Google Play Console

## If You Cannot Find the Original Keystore

⚠️ **This is serious.** Without the original upload keystore, you cannot update the app.

### Option 1: Request Upload Key Reset (Recommended)

1. Go to **Google Play Console** → **Your App** → **Release** → **Setup** → **App Signing**
2. Click **"Request upload key reset"**
3. Follow the process to prove ownership
4. Google will provide a new upload certificate
5. You'll need to create a new keystore matching the new certificate

**Note:** This process can take time and requires proof of ownership.

### Option 2: Download Upload Certificate (If Available)

If Google Play Console allows you to download the upload certificate:
1. Download the certificate
2. You'll still need the private key (keystore file) to sign the app
3. If you only have the certificate, you'll need to request a key reset

## Prevention for Future

- ✅ **Backup your keystore files** in multiple secure locations
- ✅ **Use Google Play App Signing** (you're already using this - good!)
- ✅ **Document keystore locations and passwords** in a secure password manager
- ✅ **Never commit keystores to version control** (already in .gitignore - good!)

## Quick Check Script

I've created `check_all_keystores.bat` that will check the common keystore files. Run it from your user directory:

```bash
cd C:\Users\Rimsha
check_all_keystores.bat
```

**Note:** The script will prompt for passwords for keystores that don't use the default passwords.

## Next Steps

1. **First, check `waselni-key.jks`** - This might be the original keystore
2. **Search your backups and cloud storage** for keystore files
3. **Ask team members** if they have the original keystore
4. **If not found, request upload key reset** from Google Play Console

Good luck! Once you find the correct keystore, updating the app will be straightforward.

