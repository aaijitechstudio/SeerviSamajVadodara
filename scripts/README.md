# 📝 Scripts for Creating Test Accounts

## 🚀 Quick Start

### Easiest Method (Recommended):

```bash
# 1. Run your Flutter app
flutter run

# 2. Use Sign Up screen to create accounts
# 3. Update admin role in Firestore Console
```

### Or Use Firebase Console:

```bash
# Open Firebase Console
open https://console.firebase.google.com/project/seervikshatriyasamajvadodara/authentication/users
```

---

## 📋 Available Scripts

### 1. `create_test_accounts.dart`

Info script showing all methods.

**Run:**

```bash
dart run scripts/create_test_accounts.dart
```

### 2. `create_test_accounts_node.js`

Node.js script using Firebase Admin SDK.

**Prerequisites:**

- Node.js installed
- Service account key from Firebase Console
- Save as: `scripts/serviceAccountKey.json`

**Run:**

```bash
npm install firebase-admin
node scripts/create_test_accounts_node.js
```

### 3. `create_test_accounts_quick.sh`

Quick reference script.

**Run:**

```bash
bash scripts/create_test_accounts_quick.sh
```

---

## 📋 Test Account Details

### Account 1: Regular User

- Email: `officialjagdish@gmail.com`
- Password: `12345678`
- Role: `member`

### Account 2: Admin User

- Email: `aaijitechstudio@gmail.com`
- Password: `12345678`
- Role: `admin`

---

## 🔗 Quick Links

- **Firebase Console:** https://console.firebase.google.com/project/seervikshatriyasamajvadodara
- **Authentication:** https://console.firebase.google.com/project/seervikshatriyasamajvadodara/authentication/users
- **Firestore:** https://console.firebase.google.com/project/seervikshatriyasamajvadodara/firestore/data

---

**Recommended: Use app's Sign Up screen - it's the easiest!** 🎉
