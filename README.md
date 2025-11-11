BetterLinkShare

Your own open-source, fully customizable 'link-in-bio' page. Stop paying for subscriptions and take full control of your online presence.

Tired of paying monthly subscription fees for basic "pro" features on services like Linktree? BetterLinkShare is a free, open-source template that gives you a powerful, 100% self-hosted "link-in-bio" solution.

It's built with simple HTML, CSS (Tailwind), and a free Firebase Firestore backend, giving you complete control over your links, theme, and content—all managed through your own secure admin panel.

Features

Free & Open Source: No monthly fees. No "pro" tiers. Ever.

Full Admin Panel: An admin.html page with secure Google Authentication lets you edit everything without touching the code.

Total Customization: Control all colors, text, and your profile from the admin panel. Your brand, your rules.

Featured "Spotlight": A dedicated section to showcase your latest project, video, article, or new game.

Rich Link Cards: Go beyond simple buttons. Add images, titles, and descriptions to your links to drive engagement.

Real-time & Secure: Powered by Firestore for instant updates and secure rules (public read, private write).

Simple to Deploy: The public links.html is a single static file that can be hosted for free on services like Vercel, Netlify, or GitHub Pages.

Tech Stack

Frontend: HTML5, Tailwind CSS (via CDN), Vanilla JavaScript (ES Modules)

Backend: Firebase

Firestore: As the database.

Firebase Authentication: To secure the admin panel.

🚀 5-Minute Setup Guide

Follow these steps to get your own BetterLinkShare page up and running.

1. Create your Firebase Project

Go to the Firebase Console and create a new project.

Give it a name (e.g., "my-link-page").

2. Set Up Authentication

In your new Firebase project, go to the Authentication section.

Click "Get started".

Under "Sign-in method", click Google and Enable it. Save your changes.

3. Set Up Firestore

Go to the Firestore Database section.

Click Create database.

Start in Production mode.

Choose a location (it doesn't matter which).

Go to the Rules tab in Firestore.

4. Upload Security Rules

Open the firestore.rules file from this repository.

Copy its entire contents.

Paste the contents into the Rules tab in Firebase, replacing all existing text.

Click Publish.

5. Get your Firebase Config

Go to your Project Settings (click the ⚙️ icon next to "Project Overview").

Scroll down to "Your apps".

Click the Web icon (</>) to create a new Web App.

Give it a nickname (e.g., "Web") and click Register app.

Firebase will show you a firebaseConfig object. Copy this entire object.

6. Configure admin.html

Open the admin.html file in your code editor.

Find the firebaseConfig = { ... } object near the top of the <script> tag.

Paste your firebaseConfig object here.

7. Get your User ID (UID)

Open the admin.html file in your browser.

Click the "Sign In with Google" button and log in with the Google account you want to use as the admin.

After logging in, the admin panel will show your email and your User ID (UID).

Copy this UID string.

8. Configure links.html

Open the links.html file in your code editor.

Find the 🚀 SETUP GUIDE 🚀 section near the top of the <script> tag.

Paste your firebaseConfig object into STEP 7.

Paste your UID (from the previous step) into STEP 9.

9. Customize & Go Live!

Use admin.html (which you can run locally) to add your profile info, customize your theme, and add your links. All changes are saved to the database instantly.

You are done! Upload the links.html file to your hosting provider (Netlify, Vercel, GitHub Pages, etc.). Your page is now live and will automatically fetch the content you manage from your admin panel.

File Structure

links.html: Your public-facing "link-in-bio" page. This is the only file you need to host.

admin.html: Your private admin panel. Run this file locally in your browser (or host it on a private URL) to manage your content.

firestore.rules: The security rules you must upload to Firebase for the app to work securely.

README.md: This file.

License

This project is open-source and available under the MIT License.
