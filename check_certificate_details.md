# How to Check Certificate SHA-1 Fingerprint

## From the Certificate Dialog

1. **Click the "Details" tab** in the certificate dialog
2. **Scroll down** to find "Thumbprint" or "SHA1" field
3. **Look for the SHA-1 value** - it should be in format: `XX:XX:XX:XX:...`

## Expected SHA-1

The upload key certificate should have SHA-1:
```
B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53
```

## If You Have a Certificate File

If you have the certificate file (`.cer`, `.pem`, or `.crt`), you can check it using:

```bash
keytool -printcert -file certificate.cer
```

Or on Windows:
```bash
certutil -dump certificate.cer
```

## Important Note

The certificate you're showing appears to be:
- **Issued to:** Android
- **Issued by:** Android
- **Type:** CA Root certificate

This is **NOT** the upload key certificate we need. The upload key certificate should be:
- **Issued to:** Your app/company name (like "City Eats" or similar)
- **Issued by:** Your organization
- **Type:** Code signing certificate

## Next Steps

1. **Check the Details tab** of the certificate you have - does the SHA-1 match `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`?

2. **If it doesn't match**, this is not the right certificate. You'll need to:
   - Find the actual upload key certificate file
   - Or request an upload key reset from Google Play Console

3. **If you have a `.jks` or `.keystore` file**, we can check that directly using:
   ```bash
   keytool -list -v -keystore path/to/keystore.jks
   ```

