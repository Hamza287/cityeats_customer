# How to Request Upload Key Reset in Google Play Console

## When to Use This

If you **cannot find** the original upload keystore file with SHA-1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`, you can request Google to reset your upload key.

## Important Notes

⚠️ **This process requires:**
- Proof of ownership of the app
- Access to the Google Play Console account
- May take several days to process
- Google may deny the request if you cannot prove ownership

## Step-by-Step Process

### Step 1: Navigate to App Signing

1. Go to **Google Play Console**: https://play.google.com/console
2. Select your app: **City Eats | Customer**
3. In the left sidebar, go to: **Release** → **Setup** → **App Signing**

### Step 2: Request Upload Key Reset

1. Scroll down to the **"Upload key certificate"** section
2. Click the **"Request upload key reset"** button
3. You'll see a warning about the implications

### Step 3: Provide Information

Google will ask you to provide:

1. **Reason for the request:**
   - Select: "I lost my upload key" or "I need to reset my upload key"
   
2. **Proof of ownership** (may include):
   - Access to the Google Play Console account
   - Ability to verify your identity
   - Information about when the app was first published
   - Any other verification Google requires

3. **Confirmation:**
   - You'll need to confirm that you understand:
     - The old upload key will no longer work
     - You'll receive a new upload certificate
     - You'll need to create a new keystore matching the new certificate

### Step 4: Wait for Approval

- Google will review your request
- This can take **3-7 business days** (sometimes longer)
- You'll receive an email notification when approved or denied

### Step 5: If Approved - Create New Keystore

Once approved, Google will provide you with a **new upload certificate**. You'll need to:

1. **Download the new certificate** from Google Play Console

2. **Create a new keystore** that matches the new certificate:
   ```bash
   keytool -genkey -v -keystore new-upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   
   **Important:** You'll need to match the certificate details provided by Google.

3. **Update `android/key.properties`**:
   ```properties
   storePassword=your_new_password
   keyPassword=your_new_password
   keyAlias=upload
   storeFile=new-upload-key.jks
   ```

4. **Rebuild and upload:**
   ```bash
   flutter clean
   flutter build appbundle --release
   ```

## Alternative: Check if You Can Download the Upload Certificate

Sometimes Google Play Console allows you to download the upload certificate directly:

1. Go to **App Signing** page
2. Look for a **"Download"** button next to the upload certificate
3. If available, download it
4. **Note:** Having the certificate alone is not enough - you still need the private key (keystore file) to sign the app

## What Happens After Reset

- ✅ You'll get a new upload certificate
- ✅ You can create a new keystore matching the new certificate
- ✅ You can upload new app bundles
- ❌ The old upload key will no longer work
- ❌ Any existing app bundles signed with the old key cannot be uploaded

## Prevention Tips

After resolving this issue:

1. **Backup your keystore** in multiple secure locations:
   - External hard drive
   - Cloud storage (encrypted)
   - Secure password manager
   - Team shared secure location

2. **Document the keystore information:**
   - Location
   - Password (in secure password manager)
   - Key alias
   - SHA-1 fingerprint

3. **Consider using Google Play App Signing** (you're already using this - good!)
   - This protects you if you lose your upload key
   - Google manages the app signing key securely

## Need Help?

If you're having trouble with the reset process:
- Check Google Play Console Help Center
- Contact Google Play Developer Support
- Ensure you have proper access permissions to the console

---

**Remember:** Try to find the original keystore first before requesting a reset, as the reset process can take time and may be denied if you cannot prove ownership.

