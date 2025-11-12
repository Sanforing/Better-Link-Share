# Firebase Security Rules Setup

## ⚠️ IMPORTANT SECURITY NOTICE

Your Firebase config is **public** (visible in HTML source). You **MUST** set up Firebase Security Rules to prevent unauthorized access to your admin panel.

## Architecture Understanding

**Better-Link-Share is a template:**
- Each user deploys their own copy with **their own Firebase project**
- Your Firebase config ≠ Other users' Firebase config
- Different Firebase projects = Different databases

**However, your Firebase config IS public:**
- Anyone can see it in your HTML source code
- Anyone could use Google Sign-in on your project
- **Without rules, anyone logged in can edit YOUR data**

## Security Solutions

### ✅ Option 1: Email Whitelist (Recommended)

**Best for:** Personal projects where only YOU should edit data.

**Rule:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      // Public can read (for your public link page)
      allow read: if true;
      
      // Only YOUR email can write
      allow write: if request.auth != null 
                   && request.auth.token.email == "your.email@gmail.com";
    }
  }
}
```

**Setup:**
1. Go to [Firebase Console](https://console.firebase.google.com/) → Your Project
2. Navigate to **Firestore Database** → **Rules** tab
3. Replace `"your.email@gmail.com"` with your actual Google account email
4. Click **Publish**

**Security:**
- ✅ Only you can edit data (even if someone logs in with different Google account)
- ✅ Public can view your page
- ✅ Simple and bulletproof

---

### Option 2: Any Authenticated User

**Best for:** If you want to allow multiple Google accounts to edit (less secure).

**Rule:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

**Security:**
- ⚠️ Anyone with a Google account can log in and edit your data
- Only use if you trust anyone who might log in

---

### Option 3: Multiple Specific Emails

**Best for:** Team projects with multiple admins.

**Rule:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read: if true;
      allow write: if request.auth != null 
                   && request.auth.token.email in [
                     "admin1@gmail.com",
                     "admin2@gmail.com",
                     "admin3@gmail.com"
                   ];
    }
  }
}
```

## Testing Your Security Rules

### Test 1: Verify Email Protection (If using Option 1)

1. Log in to admin panel with YOUR email → Should work ✅
2. Log out, then log in with a DIFFERENT Google account
3. Try to save changes → Should see "Permission denied" error ✅

### Test 2: Check Browser Console

```javascript
// Open browser console (F12) on your admin page
console.log(auth.currentUser.email);  // Should show your logged-in email
```

### Test 3: Firestore Rules Playground

1. In Firebase Console → Firestore → Rules → **Rules Playground**
2. Test with:
   - **Location:** `/users/testUser/config/page` (or your actual path)
   - **Authenticated:** Yes
   - **Email:** your.email@gmail.com
   - **Operation:** Write
   - Should show **"Allowed"** ✅

3. Test again with different email → Should show **"Denied"** ✅
```javascript

## Additional Security Recommendations

### 1. Restrict Authentication Providers

In Firebase Console → Authentication → Sign-in method:
- Enable **only** Google Sign-in
- Disable anonymous auth and other providers

### 2. Set Up Budget Alerts

Firebase Console → Project Settings → Usage and billing:
- Set daily quota limits
- Enable budget alerts
- Prevent abuse from unauthorized usage

### 3. Monitor Usage

Check Firestore → Usage tab regularly for:
- Unexpected read/write spikes
- Unknown authenticated users

### 4. Enable App Check (Advanced)

For production, consider [Firebase App Check](https://firebase.google.com/docs/app-check):
- Prevents API abuse
- Ensures requests come from your legitimate app

---

## Security Checklist

Before going live:

- [ ] Firestore Security Rules configured (Option 1 recommended)
- [ ] Your email hardcoded in rules (if using email whitelist)
- [ ] Rules tested in Firestore Rules Playground
- [ ] Google Authentication enabled in Firebase Console
- [ ] Other auth providers disabled
- [ ] Budget alerts set up
- [ ] Test: Different Google account CANNOT edit your data
- [ ] Test: Public page still visible to everyone

---

## Rule Syntax Reference

Common conditions:

```javascript
// Check if user is logged in
request.auth != null

// Check specific email
request.auth.token.email == "user@example.com"

// Check email in list
request.auth.token.email in ["user1@example.com", "user2@example.com"]

// Check user ID (UID)
request.auth.uid == userId

// Allow public read
allow read: if true;

// Time-based rules (expire access)
request.time < timestamp.date(2025, 12, 31);
```

---

## Troubleshooting

**Problem:** "Missing or insufficient permissions" error

**Solutions:**
1. Check you're logged in with correct email
2. Verify email in rules matches exactly (case-sensitive)
3. Click "Publish" in Firebase Console after changing rules
4. Wait 1-2 minutes for rules to propagate
5. Hard refresh browser (Ctrl+Shift+R)

**Problem:** Public page can't load data

**Solution:**
- Ensure `allow read: if true;` in your rules
- Public page should NOT require authentication to READ data

**Problem:** Can't save from admin panel

**Solutions:**
1. Check browser console for exact error
2. Verify you're logged in (`auth.currentUser` should exist)
3. Verify your email matches the rule
4. Check Firestore path matches rule pattern

---

## Need Help?

If security rules aren't working:

1. Check browser console for errors (F12)
2. Test in Firebase Rules Playground
3. Verify rules are published (not just saved)
4. Check authentication state: `console.log(auth.currentUser)`
```

## Additional Security Recommendations

### 1. Restrict Authentication Methods
In Firebase Console → **Authentication** → **Sign-in method**:
- Only enable Google Sign-in
- Consider adding authorized domains if needed

### 2. Monitor Usage
- Go to **Firestore Database** → **Usage** tab
- Check for unusual activity

### 3. Set Up Budget Alerts
- Go to Firebase Console → **Settings** → **Usage and billing**
- Set up budget alerts to prevent unexpected costs

## For Your Public Page (`betterlinkshare_clear.html`)

When users visit your public page, they need to:
1. Know your UID (User ID)
2. The page reads from `users/{YOUR_UID}/config/page`

You can add a URL parameter like:
```
https://yoursite.com/betterlinkshare.html?user=YOUR_UID
```

Or hardcode your UID in the public page if it's only for you.

## Quick Checklist

- [ ] Set up Firestore Security Rules (see Step 1)
- [ ] Test that you can only access your own data
- [ ] Test that public visitors can view your page
- [ ] Test that unauthorized users cannot edit your data
- [ ] Set up budget alerts in Firebase Console

## Need Help?

If you see permission errors after setting rules:
1. Make sure you're signed in with Google
2. Check that `currentUid` matches `request.auth.uid`
3. Check browser console for error messages
4. Verify rules are published in Firebase Console

---

**Remember**: The code is already multi-user ready. You just need to add Security Rules to enforce it! 🔒
