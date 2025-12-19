#!/bin/bash

# Firebase Deployment Script
# This script deploys all Firebase rules and indexes

echo "🔥 Starting Firebase Deployment..."
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed."
    echo "Install it with: npm install -g firebase-tools"
    exit 1
fi

# Check if user is logged in
if ! firebase projects:list &> /dev/null; then
    echo "❌ Not logged in to Firebase. Please run: firebase login"
    exit 1
fi

echo "📋 Deploying Firestore Rules..."
firebase deploy --only firestore:rules
if [ $? -ne 0 ]; then
    echo "❌ Failed to deploy Firestore rules"
    exit 1
fi
echo "✅ Firestore rules deployed"
echo ""

echo "📊 Deploying Firestore Indexes..."
firebase deploy --only firestore:indexes
if [ $? -ne 0 ]; then
    echo "❌ Failed to deploy Firestore indexes"
    exit 1
fi
echo "✅ Firestore indexes deployed"
echo ""

echo "💾 Deploying Storage Rules..."
firebase deploy --only storage
if [ $? -ne 0 ]; then
    echo "❌ Failed to deploy Storage rules"
    exit 1
fi
echo "✅ Storage rules deployed"
echo ""

echo "🎉 All Firebase configurations deployed successfully!"
echo ""
echo "Next steps:"
echo "1. Wait 1-2 minutes for indexes to build"
echo "2. Restart your app"
echo "3. Try creating a post with text, image, or video"
echo ""
