@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Better-Link-Share Setup Script for Windows
:: This script will configure your Firebase settings and generate your personalized files

echo ============================================
echo   Better-Link-Share Setup Wizard
echo ============================================
echo.

:: Check if files exist
if not exist "admin_clear.html" (
    echo ❌ Error: admin_clear.html not found!
    echo Please run this script in the Better-Link-Share directory.
    pause
    exit /b 1
)

echo This script will:
echo   1. Configure your Firebase settings
echo   2. Set your admin email for security
echo   3. Generate admin.html and betterlinkshare.html in 'generated' folder
echo   4. Generate firestore.rules with your email
echo.
pause
echo.

:: Create generated folder if it doesn't exist
if not exist "generated\" mkdir generated

:: ===== Step 1: Firebase Config =====
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo Step 1: Firebase Configuration
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Get your Firebase config from:
echo   https://console.firebase.google.com/
echo   → Your Project → Project Settings → General → Your apps → Web app
echo.

set /p FIREBASE_API_KEY="Firebase API Key: "
set /p FIREBASE_AUTH_DOMAIN="Firebase Auth Domain: "
set /p FIREBASE_PROJECT_ID="Firebase Project ID: "
set /p FIREBASE_STORAGE_BUCKET="Firebase Storage Bucket: "
set /p FIREBASE_MESSAGING_SENDER_ID="Firebase Messaging Sender ID: "
set /p FIREBASE_APP_ID="Firebase App ID: "

echo.

:: ===== Step 2: Admin Email =====
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo Step 2: Admin Email (Security)
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Enter your Google account email.
echo Only this email will be able to edit your admin panel.
echo.
set /p ADMIN_EMAIL="Your Email: "

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo Generating your files...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

:: ===== Generate admin.html =====
echo 📝 Creating generated/admin.html...
copy /y admin_clear.html generated\admin.html >nul

:: Replace Firebase config in admin.html using PowerShell
powershell -Command "$content = Get-Content 'generated\admin.html' -Raw; $content = $content -replace '(?s)(const firebaseConfig = \{)[^\}]+(        \};)', ('$1' + [Environment]::NewLine + '            apiKey: \"%FIREBASE_API_KEY%\",' + [Environment]::NewLine + '            authDomain: \"%FIREBASE_AUTH_DOMAIN%\",' + [Environment]::NewLine + '            projectId: \"%FIREBASE_PROJECT_ID%\",' + [Environment]::NewLine + '            storageBucket: \"%FIREBASE_STORAGE_BUCKET%\",' + [Environment]::NewLine + '            messagingSenderId: \"%FIREBASE_MESSAGING_SENDER_ID%\",' + [Environment]::NewLine + '            appId: \"%FIREBASE_APP_ID%\"' + [Environment]::NewLine + '$2'); Set-Content 'generated\admin.html' $content"

:: ===== Generate betterlinkshare.html =====
echo 📝 Creating generated/betterlinkshare.html...
copy /y betterlinkshare_clear.html generated\betterlinkshare.html >nul

:: Replace Firebase config in betterlinkshare.html
powershell -Command "$content = Get-Content 'generated\betterlinkshare.html' -Raw; $content = $content -replace '(?s)(const firebaseConfig = \{)[^\}]+(        \};)', ('$1' + [Environment]::NewLine + '            apiKey: \"%FIREBASE_API_KEY%\",' + [Environment]::NewLine + '            authDomain: \"%FIREBASE_AUTH_DOMAIN%\",' + [Environment]::NewLine + '            projectId: \"%FIREBASE_PROJECT_ID%\",' + [Environment]::NewLine + '            storageBucket: \"%FIREBASE_STORAGE_BUCKET%\",' + [Environment]::NewLine + '            messagingSenderId: \"%FIREBASE_MESSAGING_SENDER_ID%\",' + [Environment]::NewLine + '            appId: \"%FIREBASE_APP_ID%\"' + [Environment]::NewLine + '$2'); Set-Content 'generated\betterlinkshare.html' $content"

:: ===== Generate firestore.rules =====
echo 📝 Creating generated/firestore.rules with your email...
setlocal disabledelayedexpansion
(
echo rules_version = '2';
echo service cloud.firestore {
echo   match /databases/{database}/documents {
echo     match /{document=**} {
echo       // ✅ Public can read ^(for your public link page^)
echo       allow read: if true;
echo.      
echo       // ✅ Only YOUR email can write
echo       allow write: if request.auth != null 
echo                    ^&^& request.auth.token.email == "%ADMIN_EMAIL%";
echo     }
echo   }
echo }
) > generated\firestore.rules
endlocal

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ Setup Complete!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Generated files in 'generated' folder:
echo   ✓ generated/admin.html (with your Firebase config)
echo   ✓ generated/betterlinkshare.html (with your Firebase config)
echo   ✓ generated/firestore.rules (with your email: %ADMIN_EMAIL%)
echo.
echo Next steps:
echo.
echo 1. 🔐 Set up Firestore Security Rules:
echo    → Go to: https://console.firebase.google.com/
echo    → Your Project → Firestore Database → Rules
echo    → Copy content from 'generated/firestore.rules' and paste
echo    → Click 'Publish'
echo.
echo 2. 🔑 Enable Google Authentication:
echo    → Firebase Console → Authentication → Sign-in method
echo    → Enable 'Google' provider
echo.
echo 3. 🚀 Deploy your files:
echo    → Open generated/admin.html in browser to configure your page
echo    → Deploy generated/betterlinkshare.html as your public page
echo.
echo 📚 For detailed instructions, see:
echo    → README.md
echo    → FIREBASE_SECURITY_SETUP.md
echo.
echo ============================================
echo.
pause
