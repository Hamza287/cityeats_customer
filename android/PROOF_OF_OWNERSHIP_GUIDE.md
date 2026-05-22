# Proof of Ownership - Upload Key Reset

## Where to Provide Proof of Ownership

When you request an upload key reset in Google Play Console, Google will typically ask for proof of ownership as part of the request process.

## Step-by-Step Process

### Step 1: Navigate to App Signing

1. Go to **Google Play Console**: https://play.google.com/console
2. Select your app: **City Eats | Customer**
3. Navigate to: **Release** → **Setup** → **App Signing**

### Step 2: Find Upload Key Reset Option

1. Scroll down to the **"Upload key certificate"** section
2. Look for a link/button that says:
   - **"Request upload key reset"**
   - **"Reset upload key"**
   - **"Contact support"** (if reset option isn't directly available)

### Step 3: Submit the Request

When you click "Request upload key reset", you'll typically see:

1. **A form or dialog** asking for:
   - Reason for the reset request
   - Details about the situation
   - **Proof of ownership** (upload section)

2. **File upload section** where you can attach:
   - Documents proving ownership
   - Previous app bundle files (if available)
   - Business registration documents
   - Other supporting documents

## What Counts as Proof of Ownership

### Primary Proof (Strong Evidence):

1. **Previous App Bundle Files (.aab)**
   - If you have any previously uploaded `.aab` files
   - These prove you had access to the upload key before

2. **Business Registration Documents**
   - Company registration certificate
   - Business license
   - Tax documents showing business name

3. **Account Ownership Proof**
   - Email confirmation from when the app was created
   - Payment receipts for Google Play Developer account
   - Account verification documents

### Secondary Proof (Supporting Evidence):

1. **App Development Evidence**
   - Source code repository access
   - Development team documentation
   - Project files showing your involvement

2. **Domain/Website Ownership**
   - If your app is associated with a website
   - Domain registration documents
   - Website ownership verification

3. **Previous Communications**
   - Emails from Google Play Console
   - Previous support tickets
   - Account activity history

## What to Include in Your Request

### When filling out the form, explain:

1. **Your Situation:**
   ```
   I have the upload keystore file (waselni-key.jks) but have lost 
   the password. I need to reset the upload key to continue 
   publishing app updates.
   ```

2. **What You Have:**
   - Upload keystore file: `waselni-key.jks`
   - Upload certificate: `upload_cert.der` (SHA-1: B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53)
   - App signing certificate (deployment_cert.der)

3. **What You Need:**
   - Ability to create a new upload key
   - Register the new upload key with Google Play

4. **Why You Need It:**
   - To publish app updates
   - To maintain the app on Google Play Store

## If "Request Upload Key Reset" Button is Not Visible

Sometimes the option might not be directly visible. In that case:

1. **Contact Google Play Support:**
   - Go to: **Help** → **Contact us** in Play Console
   - Select: **App signing and keys** → **Upload key issues**
   - Explain your situation and request upload key reset

2. **Alternative Path:**
   - Go to: **Policy** → **App content** → **Contact us**
   - Select issue related to app signing
   - Request upload key reset

## What Happens After Submission

1. **Google Reviews Your Request:**
   - Typically takes 1-2 weeks
   - May ask for additional information
   - May verify your account details

2. **Possible Outcomes:**
   - ✅ **Approved:** You'll be able to create a new upload key
   - ❌ **Denied:** If they can't verify ownership, you may need to provide more evidence
   - ⏳ **Pending:** May request additional documentation

3. **If Approved:**
   - You'll receive instructions to create a new upload key
   - You'll need to register the new key with Google Play
   - Then you can sign and upload new app bundles

## Tips for Success

- ✅ **Be clear and detailed** in your explanation
- ✅ **Provide all available evidence** upfront
- ✅ **Respond promptly** if Google asks for more information
- ✅ **Be patient** - the process can take time
- ✅ **Keep documentation** of your request and responses

## Important Notes

- ⚠️ **This is a security measure** - Google needs to ensure you own the app
- ⚠️ **Process can take 1-2 weeks** or longer
- ⚠️ **You cannot publish updates** until this is resolved
- ✅ **This is the official way** to handle lost upload keys

## Quick Checklist

Before submitting your request, make sure you have:

- [ ] Keystore file location documented
- [ ] Certificate files available
- [ ] Business/account ownership documents ready
- [ ] Previous app bundle files (if available)
- [ ] Clear explanation of your situation
- [ ] All supporting evidence prepared

