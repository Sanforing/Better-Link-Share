<div align="center">

# BetterLinkShare

An open-source, fully customizable, self‑hosted link‑in‑bio page. Free, no tiers, take full control of your profile.

<sup>HTML + Tailwind (CDN) + Vanilla JS (ES Modules) + Firebase Firestore (+ optional Auth)</sup>

</div>

---

## Table of Contents
1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Quick Start (5 min)](#quick-start-5-min)
4. [File Structure](#file-structure)
5. [Security Rules](#security-rules)
6. [Customization](#customization)
7. [Admin Panel (optional)](#admin-panel-optional)
8. [FAQ / Troubleshooting](#faq--troubleshooting)
9. [Contributing](#contributing)
10. [License](#license)

---

## Features
- Free & Open Source – No paid tiers or locked features.
- One-file deploy – Host the public page anywhere (Vercel, Netlify, GitHub Pages).
- Rich link cards – Image, title, and description per link.
- Spotlight section – Highlight your latest project/video/article.
- Themeable – CSS variables for colors, gradients, and focus rings.
- Realtime updates – Powered by Firestore.

## Tech Stack
| Layer | Tool |
|------|------|
| Frontend | HTML5 + Tailwind CSS (CDN) + Vanilla JS (ES Modules) |
| Backend (BaaS) | Firebase |
| Database | Firestore |
| Auth | Optional (Anonymous read or Google Auth depending on your rules) |

---

## Quick Start (5 min)

### 🚀 Automated Setup (Easiest)

**For Linux/macOS/Git Bash:**
```bash
./setup.sh
```

**For Windows:**
```bash
setup.bat
```

The setup wizard will:
1. ✅ Ask for your Firebase configuration
2. ✅ Ask for your admin email
3. ✅ Generate `admin.html` with your config
4. ✅ Generate `betterlinkshare.html` with your config
5. ✅ Generate `firestore.rules` with your email

Then follow the on-screen instructions to:
- Copy `firestore.rules` to Firebase Console
- Enable Google Authentication
- Deploy your files

---

### 📝 Manual Setup

If you prefer manual setup or the scripts don't work:

1) **Create a Firebase project**  
   - Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.

2) **Create a Firestore database**  
   - Build → Firestore Database → Create database → Production mode.  
   - Leave the Rules tab open for the next step.

3) **⚠️ CRITICAL: Add security rules (multi-user with auth)**  
   Paste the following rules into Firestore → Rules and **Publish**:

   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Users can only read/write their own data
       match /users/{userId}/{document=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       
       // Allow anyone to read public pages (for your public-facing page)
       // But only the owner can write
       match /users/{userId}/config/page {
         allow read: if true;  // Anyone can view public profiles
         allow write: if request.auth != null && request.auth.uid == userId;
       }
       
       match /users/{userId}/links/{linkId} {
         allow read: if true;  // Anyone can view public links
         allow write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

   **This ensures each user can ONLY edit their own data!** 🔒

4) **Enable Google Authentication**  
   - Authentication → Get started → Sign-in method → Enable Google

5) **Register a Web App and get your firebaseConfig**  
   - Project Settings → Your apps → Web (</>) → Register app → copy the `firebaseConfig` object.

6) **Set up admin panel**  
   - Open `admin_clear.html` (or `admin.html` if you already have config)
   - Paste your `firebaseConfig` in the designated section
   - Open in browser and sign in with Google
   - Your Google account UID will be used to store YOUR data in `users/{your-uid}/...`

7) **Configure and publish your content**  
   - Use the admin panel to set up Profile, Spotlight, Theme, and Links
   - All changes save to `users/{your-uid}/config/page` and `users/{your-uid}/links`

8) **Deploy your public page**  
   - Open `betterlinkshare_clear.html`
   - Update the Firebase config
   - Change the code to read from `users/{YOUR_UID}/...` instead of root collections
   - Deploy to any static host (Vercel, Netlify, GitHub Pages)

📖 **See [FIREBASE_SECURITY_SETUP.md](./FIREBASE_SECURITY_SETUP.md) for detailed security configuration!**

---

### Legacy Single-User Setup (Not Recommended)

<details>
<summary>Click to expand legacy setup instructions</summary>

If you want a simple single-user setup without authentication:

3) Add security rules (public reads)  
Paste the following rules into Firestore → Rules and Publish:

```rules
rules_version = '2';
service cloud.firestore {
	match /databases/{database}/documents {
		// Public read for the single-tenant variant
		match /config/page {
			allow read: if true;
		}
		match /links/{linkId} {
			allow read: if true;
		}
		// No writes from the public site
		allow write: if false;
	}
}
```

**Note:** This setup doesn't support the admin panel. You'll need to manually edit Firestore data.

</details>

---

## File Structure
```text
betterlinkshare_clear.html  # Public, single-tenant page (deploy this)
admin_clear.html            # Optional admin (see notes below)
LICENSE
README.md
```

---

## Security Rules
The included public page reads from root collections `config/page` and `links`. Keep writes disabled for public users. If you later add an authenticated admin, scope write access accordingly.

See the sample rules in [Quick Start](#quick-start-5-min).

---

## Customization
Adjust CSS variables (theme colors, gradients, focus rings) by writing values into the `theme` map in Firestore. Fields starting with `--` map directly to CSS variables, for example:
- `--bg-gradient-from`, `--bg-gradient-via`, `--bg-gradient-to`
- `--text-color-primary`, `--text-color-secondary`, `--text-color-accent`
- `--link-card-bg`, `--link-card-hover-bg`, `--link-focus-ring`
- `--spotlight-button-bg`, `--spotlight-button-hover-bg`, `--spotlight-button-text-color`

You can also change copy and images from the `profile`, `links`, and `spotlight` fields.

---

## Admin Panel (optional)
This repo includes `admin_clear.html`, an experimental admin built with Google Sign-In that saves under a namespaced schema: `users/{uid}/config/page` and `users/{uid}/links`.

Important:
- The default public page (`betterlinkshare_clear.html`) reads from root `config/page` and `links`. It does NOT read from `users/{uid}`.  
- If you want to use the admin as-is, you’ll need a matching public page that reads from `users/{uid}` (not included), or adapt either file so they use the same paths.  
- For the single-tenant demo, the simplest workflow is to edit data directly in the Firebase Console as described above.

Auth: The public page doesn’t require auth for reads if your rules allow it. The admin uses Google Auth for writes.

---

## FAQ / Troubleshooting
- The page shows placeholders only  
	Ensure `firebaseConfig` is pasted into `betterlinkshare_clear.html` and your Firestore rules allow reads. Verify data exists at `config/page` and `links`.
- Do I need to enable Anonymous Auth?  
	No. The page attempts anonymous sign-in but will still work with public-read rules.
- I want ordered links  
	Add a numeric `order` field to each link and sort in the query (see code comments for `orderBy`).
- Images don’t load  
	Check `imageUrl` and CORS. A placeholder image is used as a fallback.

---

## Contributing
Issues and PRs are welcome:
1. Fork the repo
2. Create a branch: `feature/your-change`
3. Open a PR describing the motivation and changes
4. Keep the footprint small and framework-free

Good first issues: accessibility (a11y), dark mode, small unit tests.

---

## License
MIT License — see `LICENSE`.

---

If this project helps you, a ⭐ on the repo is appreciated!

