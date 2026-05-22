# Finding the Upload Key Certificate

## Important Distinction

You showed me the **App Signing Key Certificate** (SHA-1: `27:15:65:6D:01:3B:AF:92:6A:E1:90:5B:13:13:DA:AA:DF:FF:EB:09`)

But we need the **Upload Key Certificate** (SHA-1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`)

## The Difference

- **App Signing Key**: Google uses this to sign your app for users. You don't have access to this private key.
- **Upload Key**: YOU use this to sign your app bundle before uploading. You need the keystore file with this private key.

## What You Actually Need

You need the **keystore file** (`.jks` or `.keystore`) that contains the private key matching the upload certificate SHA-1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`

## Where to Find It

### Option 1: Check if Google Play Console Allows Download

1. Go to **Google Play Console** → **App Signing**
2. In the **"Upload key certificate"** section
3. Look for a **"Download"** button or link
4. If available, download the certificate file

**Note:** Even if you download the certificate, you still need the **private key** (keystore file) to sign your app. The certificate alone is not enough.

### Option 2: Search for the Keystore File

The keystore file that matches the upload certificate should be somewhere on your system. Common locations:

1. **Project folders:**
   - `city_eats_customer_app/android/`
   - `city_eats_customer_app/` (root)
   - Old project backups

2. **Backup locations:**
   - External drives
   - USB drives
   - Cloud storage (Google Drive, Dropbox, OneDrive)
   - Email attachments

3. **Common keystore names:**
   - `upload-keystore.jks`
   - `release-key.jks`
   - `customer-app-key.jks`
   - `city-eats-upload.jks`
   - `keystore.jks`

4. **Team members:**
   - Ask other developers who worked on the project
   - Check shared team folders

### Option 3: Check Certificate Files

If you have certificate files (`.cer`, `.pem`, `.crt`), you can check their SHA-1:

```bash
keytool -printcert -file certificate.cer
```

Look for SHA-1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`

## If You Can't Find the Keystore

If you cannot find the keystore file with the upload key private key, you have two options:

### Option A: Request Upload Key Reset (Recommended)

1. Go to **Google Play Console** → **App Signing**
2. Click **"Request upload key reset"**
3. Follow the process to prove ownership
4. Google will provide a new upload certificate
5. Create a new keystore matching the new certificate

See `UPLOAD_KEY_RESET_GUIDE.md` for detailed steps.

### Option B: Search More Thoroughly

- Check all backup locations
- Search entire computer for `.jks` and `.keystore` files
- Check with all team members
- Look in old email attachments
- Check version control history (if keystore was committed before .gitignore)

## Quick Verification

To verify if a keystore matches the upload certificate:

```bash
keytool -list -v -keystore path/to/keystore.jks
```

Look for SHA-1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`

## Summary

- ❌ The certificate you showed is the **App Signing Key** (Google's key)
- ✅ You need the **Upload Key** keystore file (your key)
- 🔍 Search for `.jks` or `.keystore` files that match SHA-1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`
- 🔄 If not found, request an upload key reset from Google Play Console

