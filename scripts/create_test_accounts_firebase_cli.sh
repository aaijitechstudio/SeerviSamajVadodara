#!/bin/bash

# Script to create test accounts using Firebase CLI
#
# Prerequisites:
# 1. Install Firebase CLI: npm install -g firebase-tools
# 2. Login: firebase login
# 3. Set project: firebase use seervikshatriyasamajvadodara
#
# Run: bash scripts/create_test_accounts_firebase_cli.sh

echo "🚀 Creating Test Accounts using Firebase CLI..."
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed."
    echo "   Install with: npm install -g firebase-tools"
    exit 1
fi

echo "⚠️  Note: Firebase CLI doesn't support creating Auth users directly."
echo "   Use one of these methods instead:"
echo ""
echo "📋 Method 1: Firebase Console (Easiest)"
echo "   1. Go to: https://console.firebase.google.com/project/seervikshatriyasamajvadodara/authentication/users"
echo "   2. Click 'Add user' for each account"
echo ""
echo "📋 Method 2: Use App Sign-Up"
echo "   1. Run: flutter run"
echo "   2. Use Sign Up screen"
echo ""
echo "📋 Method 3: Use Node.js script"
echo "   1. Run: node scripts/create_test_accounts_node.js"
echo ""
echo "✅ Test Account Details:"
echo ""
echo "   Account 1 (Regular User):"
echo "   Email: officialjagdish@gmail.com"
echo "   Password: 12345678"
echo "   Role: member"
echo ""
echo "   Account 2 (Admin User):"
echo "   Email: aaijitechstudio@gmail.com"
echo "   Password: 12345678"
echo "   Role: admin"
echo ""

exit 0

