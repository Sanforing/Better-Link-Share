<div align="center">

# BetterLinkShare

An open-source, fully customizable, self‑hosted link‑in‑bio page. Free, no tiers, take full control of your profile.

<sup>HTML + Tailwind (CDN) + Vanilla JS (ES Modules) + Firebase Firestore</sup>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

---

## Table of Contents
1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Quick Start](#quick-start)
4. [File Structure](#file-structure)
5. [Security Rules](#security-rules)
6. [Customization](#customization)
7. [Admin Panel](#admin-panel)
8. [FAQ / Troubleshooting](#faq--troubleshooting)
9. [Contributing](#contributing)
10. [License](#license)

---

## Features
✨ **Free & Open Source** – No paid tiers or locked features  
🚀 **One-file deploy** – Host anywhere (Vercel, Netlify, GitHub Pages)  
🎨 **Rich link cards** – Image, title, and description per link  
⭐ **Spotlight section** – Highlight your latest project/video/article  
🎨 **Fully themeable** – Customize colors, gradients, and styles  
⚡ **Realtime updates** – Changes reflect instantly via Firestore  
🔒 **Secure** – Public reads, authenticated writes only  

---

## Tech Stack
| Layer | Tool |
|------|------|
| Frontend | HTML5 + Tailwind CSS (CDN) + Vanilla JS (ES Modules) |
| Backend (BaaS) | Firebase |
| Database | Firestore |
| Auth | Google Sign-In for admin panel only (public page requires no auth) |

---

## Quick Start

### 🚀 Automated Setup (Recommended)

**Windows:**
```bash
setup.bat
```

**Linux/macOS/Git Bash:**
```bash
chmod +x setup.sh
./setup.sh
```

The setup wizard will:
1. ✅ Ask for your Firebase configuration
2. ✅ Ask for your admin email  
3. ✅ Generate `generated/admin.html` with your config
4. ✅ Generate `generated/betterlinkshare.html` with your config
5. ✅ Generate `generated/firestore.rules` with your email

All generated files will be in the `generated/` folder.

Then:
1. Deploy the security rules to Firebase Console
2. Enable Google Authentication in Firebase
3. Open `generated/admin.html` to configure your page
4. Deploy `generated/betterlinkshare.html` to your hosting service

---

### 📝 Manual Setup

<details>
<summary>Click to expand manual setup instructions</summary>

1) **Create a Firebase project**  
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project

2) **Create Firestore database**  
   - Build → Firestore Database → Create database → Production mode

3) **Add security rules**  
   Go to Firestore → Rules and paste:

   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         // ✅ Public can read
         allow read: if true;
         
         // ✅ Only YOUR email can write
         allow write: if request.auth != null 
                      && request.auth.token.email == "your-email@gmail.com";
       }
     }
   }
   ```

   **Replace `your-email@gmail.com` with your Google account!**

4) **Enable Google Authentication**  
   - Authentication → Sign-in method → Enable Google

5) **Register Web App**  
   - Project Settings → Your apps → Web (</>) → Register app
   - Copy the `firebaseConfig` object

6) **Set up files**  
   - Copy `admin_clear.html` and `betterlinkshare_clear.html`
   - Paste your `firebaseConfig` in both files

7) **Configure your page**  
   - Open `admin.html` in browser
   - Sign in with your Google account
   - Add your profile, links, and customize theme

8) **Deploy**  
   - Upload `betterlinkshare.html` to your hosting service
   - Done! 🎉

</details>

---

## File Structure
```
Better-Link-Share/
├── admin_clear.html           # Admin panel template (no config)
├── betterlinkshare_clear.html # Public page template (no config)
├── setup.bat                  # Windows setup script
├── setup.sh                   # Linux/macOS setup script
├── generated/                 # Generated files folder
│   ├── README.md              # Instructions
│   ├── admin.html             # Your admin panel
│   ├── betterlinkshare.html   # Your public page
│   └── firestore.rules        # Your security rules
├── LICENSE
├── README.md
└── FIREBASE_SECURITY_SETUP.md
```

---

## Security Rules

The public page reads from `config/page` and `links` collections. Anyone can read your public content, but only your authenticated Google account can write/edit.

This ensures:
- ✅ Your page is publicly accessible
- ✅ Only you can make changes
- ✅ No unauthorized edits

See the auto-generated `generated/firestore.rules` or the manual setup section above.

---

## Customization

Use the admin panel's **Theme & Colors** tab to customize:
- Background gradients
- Text colors
- Link card styles
- Spotlight button colors
- Focus rings and hover effects

All changes are stored in Firestore and applied in realtime!

### Available CSS Variables:
- `--bg-gradient-from`, `--bg-gradient-via`, `--bg-gradient-to`
- `--text-color-primary`, `--text-color-secondary`, `--text-color-accent`
- `--link-card-bg`, `--link-card-hover-bg`, `--link-focus-ring`
- `--spotlight-button-bg`, `--spotlight-button-hover-bg`, `--spotlight-button-text-color`

---

## Admin Panel

The admin panel provides a user-friendly interface to manage your content:

### Features:
📝 **Profile & Spotlight**
- Set name, bio, and avatar
- Configure featured content
- Add custom headings

🎨 **Theme & Colors**
- Live preview of all changes
- Customize every color
- Gradient backgrounds

🔗 **Manage Links**
- Add, edit, delete links
- Drag to reorder
- Rich cards with images

### Authentication:
- Uses Google Sign-In
- Only your email (specified in Firestore rules) can access
- Public page requires NO authentication

---

## FAQ / Troubleshooting

**Q: The page shows placeholders only**  
A: Ensure your `firebaseConfig` is correct and Firestore rules allow public reads. Check that data exists at `config/page` and `links` collections.

**Q: Do I need to enable Anonymous Auth?**  
A: No. The public page requires no authentication. Only the admin panel uses Google Sign-In.

**Q: How do I order my links?**  
A: Links have an `order` field. The admin panel handles this automatically. Lower numbers appear first.

**Q: Images don't load**  
A: Check the `imageUrl` field is a valid, publicly accessible URL. CORS issues may prevent some images from loading. A placeholder is shown as fallback.

**Q: Can I self-host without Firebase?**  
A: The current version requires Firebase Firestore. You could fork and adapt to use a different backend.

**Q: How do I update my deployed page?**  
A: Just make changes in the admin panel. The public page reads from Firestore in realtime, so updates appear instantly without redeploying!

---

## Contributing

Contributions are welcome! 🎉

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Guidelines:
- Keep it simple and framework-free
- Maintain the single-file philosophy
- Add comments for complex logic
- Test your changes

**Good first issues:** accessibility (a11y), dark mode toggle, export/import functionality

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

## Support

If this project helps you, consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs or requesting features via [Issues](https://github.com/Sanforing/Better-Link-Share/issues)
- 🔀 Contributing improvements via Pull Requests

---

<div align="center">

Made with ❤️ for the open-source community

[Report Bug](https://github.com/Sanforing/Better-Link-Share/issues) · [Request Feature](https://github.com/Sanforing/Better-Link-Share/issues)

</div>
