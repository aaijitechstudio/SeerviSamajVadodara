#!/bin/bash

# Script to clean and rebuild Flutter app with Firebase configuration
# This fixes the "Firebase has not been correctly initialized" error

echo "🧹 Cleaning Flutter build cache..."
flutter clean

echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "🍎 Installing iOS CocoaPods dependencies..."
cd ios
pod deintegrate
pod install
cd ..

echo "✅ Clean rebuild complete!"
echo ""
echo "Now run: flutter run"
echo ""
echo "If you're still seeing Firebase errors, try:"
echo "1. Delete the app from your device/simulator"
echo "2. Run: flutter run --release (for release mode)"
echo "3. Or run: flutter run --debug (for debug mode)"
