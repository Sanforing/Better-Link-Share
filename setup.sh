#!/bin/bash

# Better-Link-Share Setup Script
# This script will configure your Firebase settings and generate your personalized files

echo "============================================"
echo "  Better-Link-Share Setup Wizard"
echo "============================================"
echo ""

# Check if files exist
if [ ! -f "admin_clear.html" ]; then
    echo "❌ Error: admin_clear.html not found!"
    echo "Please run this script in the Better-Link-Share directory."
    exit 1
fi

echo "This script will:"
echo "  1. Configure your Firebase settings"
echo "  2. Set your admin email for security"
echo "  3. Generate admin.html and betterlinkshare.html in 'generated' folder"
echo "  4. Generate firestore.rules with your email"
echo ""
read -p "Press Enter to continue..."
echo ""

# Create generated folder if it doesn't exist
mkdir -p generated

# ===== Step 1: Firebase Config =====
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1: Firebase Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Get your Firebase config from:"
echo "  https://console.firebase.google.com/"
echo "  → Your Project → Project Settings → General → Your apps → Web app"
echo ""

read -p "Firebase API Key: " FIREBASE_API_KEY
read -p "Firebase Auth Domain: " FIREBASE_AUTH_DOMAIN
read -p "Firebase Project ID: " FIREBASE_PROJECT_ID
read -p "Firebase Storage Bucket: " FIREBASE_STORAGE_BUCKET
read -p "Firebase Messaging Sender ID: " FIREBASE_MESSAGING_SENDER_ID
read -p "Firebase App ID: " FIREBASE_APP_ID

echo ""

# ===== Step 2: Admin Email =====
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2: Admin Email (Security)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Enter your Google account email."
echo "Only this email will be able to edit your admin panel."
echo ""
read -p "Your Email: " ADMIN_EMAIL

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Generating your files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ===== Generate admin.html =====
echo "📝 Creating generated/admin.html..."
cp admin_clear.html generated/admin.html

# Replace Firebase config in admin.html
# The template has commented config, so we need to replace the entire firebaseConfig object
sed -i '/const firebaseConfig = {/,/};/{
    /const firebaseConfig = {/!{
        /};/!d
    }
}' generated/admin.html

# Insert the actual config
sed -i "/const firebaseConfig = {/a\\
            apiKey: \"$FIREBASE_API_KEY\",\\
            authDomain: \"$FIREBASE_AUTH_DOMAIN\",\\
            projectId: \"$FIREBASE_PROJECT_ID\",\\
            storageBucket: \"$FIREBASE_STORAGE_BUCKET\",\\
            messagingSenderId: \"$FIREBASE_MESSAGING_SENDER_ID\",\\
            appId: \"$FIREBASE_APP_ID\"" generated/admin.html

# ===== Generate betterlinkshare.html =====
echo "📝 Creating generated/betterlinkshare.html..."
cp betterlinkshare_clear.html generated/betterlinkshare.html

# Replace Firebase config in betterlinkshare.html
sed -i '/const firebaseConfig = {/,/};/{
    /const firebaseConfig = {/!{
        /};/!d
    }
}' generated/betterlinkshare.html

sed -i "/const firebaseConfig = {/a\\
            apiKey: \"$FIREBASE_API_KEY\",\\
            authDomain: \"$FIREBASE_AUTH_DOMAIN\",\\
            projectId: \"$FIREBASE_PROJECT_ID\",\\
            storageBucket: \"$FIREBASE_STORAGE_BUCKET\",\\
            messagingSenderId: \"$FIREBASE_MESSAGING_SENDER_ID\",\\
            appId: \"$FIREBASE_APP_ID\"" generated/betterlinkshare.html

# ===== Generate firestore.rules =====
echo "📝 Creating generated/firestore.rules with your email..."
cat > generated/firestore.rules << EOF
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      // ✅ Public can read (for your public link page)
      allow read: if true;
      
      // ✅ Only YOUR email can write
      allow write: if request.auth != null 
                   && request.auth.token.email == "$ADMIN_EMAIL";
    }
  }
}
EOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Generated files in 'generated' folder:"
echo "  ✓ generated/admin.html (with your Firebase config)"
echo "  ✓ generated/betterlinkshare.html (with your Firebase config)"
echo "  ✓ generated/firestore.rules (with your email: $ADMIN_EMAIL)"
echo ""
echo "Next steps:"
echo ""
echo "1. 🔐 Set up Firestore Security Rules:"
echo "   → Go to: https://console.firebase.google.com/"
echo "   → Your Project → Firestore Database → Rules"
echo "   → Copy content from 'generated/firestore.rules' and paste"
echo "   → Click 'Publish'"
echo ""
echo "2. 🔑 Enable Google Authentication:"
echo "   → Firebase Console → Authentication → Sign-in method"
echo "   → Enable 'Google' provider"
echo ""
echo "3. 🚀 Deploy your files:"
echo "   → Open generated/admin.html in browser to configure your page"
echo "   → Deploy generated/betterlinkshare.html as your public page"
echo ""
echo "📚 For detailed instructions, see:"
echo "   → README.md"
echo "   → FIREBASE_SECURITY_SETUP.md"
echo ""
echo "============================================"
