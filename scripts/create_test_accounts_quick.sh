#!/bin/bash

# Quick script to create test accounts
# This script provides the easiest methods to create test accounts

echo "🚀 Seervi Kshatriya Samaj Vadodara - Test Accounts Setup"
echo "=========================================================="
echo ""

echo "📋 Test Accounts to Create:"
echo ""
echo "   Account 1 (Regular User):"
echo "   Email:    officialjagdish@gmail.com"
echo "   Password: 12345678"
echo "   Role:     member"
echo ""
echo "   Account 2 (Admin User):"
echo "   Email:    aaijitechstudio@gmail.com"
echo "   Password: 12345678"
echo "   Role:     admin"
echo ""

echo "🎯 EASIEST METHOD: Use App Sign-Up"
echo "-----------------------------------"
echo ""
echo "1. Run: flutter run"
echo "2. Use Sign Up screen to create both accounts"
echo "3. Go to Firestore Console and update admin role"
echo ""
echo "   Firestore Console:"
echo "   https://console.firebase.google.com/project/seervikshatriyasamajvadodara/firestore/data"
echo ""

echo "🌐 ALTERNATIVE: Use Firebase Console"
echo "--------------------------------------"
echo ""
echo "1. Open: https://console.firebase.google.com/project/seervikshatriyasamajvadodara/authentication/users"
echo "2. Click 'Add user' for each account"
echo "3. Then create Firestore documents manually"
echo ""

echo "💻 NODE.JS METHOD (If you have Node.js installed):"
echo "---------------------------------------------------"
echo ""
echo "1. Install: npm install firebase-admin"
echo "2. Get service account key from Firebase Console"
echo "3. Run: node scripts/create_test_accounts_node.js"
echo ""

echo "✅ After creating accounts, verify in:"
echo "   - Authentication: https://console.firebase.google.com/project/seervikshatriyasamajvadodara/authentication/users"
echo "   - Firestore: https://console.firebase.google.com/project/seervikshatriyasamajvadodara/firestore/data"
echo ""

