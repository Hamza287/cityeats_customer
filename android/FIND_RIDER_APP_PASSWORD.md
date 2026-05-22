# Finding Rider App Keystore Password

## Why This Might Help

If you can find the password for the **rider app's keystore**, you might be able to use a similar password for the **customer app's keystore** (`waselni-key.jks`). Often, developers use similar passwords for related apps.

## Where to Look for Rider App Password

### 1. Rider App Project Directory

Check the rider app's `android` folder:

**Location:** Usually in a folder like:
- `city_eats_rider_app/android/key.properties`
- `rider_app/android/key.properties`
- `../city_eats_rider_app/android/key.properties`

**What to look for:**
```properties
storePassword=[PASSWORD]
keyPassword=[PASSWORD]
keyAlias=[ALIAS]
storeFile=[KEYSTORE_FILE]
```

### 2. Rider App Documentation

Check for:
- README files in the rider app
- Setup guides
- Documentation files
- Team wikis or knowledge bases

### 3. Password Managers

Search for:
- "rider app keystore"
- "rider upload key"
- "city eats rider password"
- "waselni rider"

### 4. Team Communication

Check:
- Slack/Teams channels for rider app
- Email threads about rider app setup
- Shared team documents

### 5. Cloud Storage

Search in:
- Google Drive
- Dropbox
- OneDrive
- For files related to "rider app" or "keystore"

### 6. Rider App's key.properties File

If you can find the rider app project, check:
```
[rider_app_folder]/android/key.properties
```

This file will contain the password for the rider app's keystore.

## How to Use Rider App Password

Once you find the rider app's password:

### Step 1: Try the Same Password

```powershell
keytool -list -v -keystore "C:\Users\Rimsha\waselni-key.jks" -storepass [RIDER_APP_PASSWORD] | findstr "SHA1:"
```

### Step 2: Try Variations

If the same password doesn't work, try variations:
- `[rider_password]` → `[rider_password]customer`
- `[rider_password]` → `customer[rider_password]`
- `[rider_password]` → `[rider_password]2024`
- `[rider_password]` → `[rider_password]_customer`

### Step 3: Check if It Matches

Look for SHA-1: `B3:F3:37:26:7E:1E:7E:B3:69:83:30:B5:0D:58:4E:BE:36:2A:89:53`

## Quick Search Commands

### Find Rider App Directory:
```powershell
Get-ChildItem -Path "C:\Users\Rimsha" -Directory -Filter "*rider*" -Recurse -ErrorAction SilentlyContinue
```

### Find key.properties in Rider App:
```powershell
Get-ChildItem -Path "C:\Users\Rimsha" -Recurse -Filter "key.properties" -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like "*rider*" }
```

### Find Keystore Files:
```powershell
Get-ChildItem -Path "C:\Users\Rimsha" -Recurse -Filter "*.jks" -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like "*rider*" }
```

## Important Notes

- ⚠️ **Rider app and customer app are different apps** - they have different upload keys
- ✅ **But passwords might be similar** - developers often use similar patterns
- ✅ **Finding rider password can give you clues** for customer app password
- ⚠️ **Don't assume they're the same** - always test

## If You Find Rider App Password

1. **Test it on customer app keystore:**
   ```powershell
   keytool -list -v -keystore "C:\Users\Rimsha\waselni-key.jks" -storepass [RIDER_PASSWORD] | findstr "SHA1:"
   ```

2. **If it works:** Great! Update `key.properties` and build your app

3. **If it doesn't:** Try password variations or proceed with upload key reset request

## Next Steps

1. **Locate the rider app directory**
2. **Check `android/key.properties` in rider app**
3. **Try that password on customer app keystore**
4. **If it works, you're done!**
5. **If not, try variations or request upload key reset**

