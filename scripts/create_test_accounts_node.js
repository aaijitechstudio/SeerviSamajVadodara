/**
 * Node.js script to create test accounts using Firebase Admin SDK
 * 
 * Prerequisites:
 * 1. Install Node.js
 * 2. Run: npm install firebase-admin
 * 3. Download service account key from Firebase Console
 * 4. Place it as: scripts/serviceAccountKey.json
 * 
 * Run: node scripts/create_test_accounts_node.js
 */

const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const auth = admin.auth();
const firestore = admin.firestore();

async function createTestAccounts() {
  console.log('🚀 Creating Test Accounts...\n');

  try {
    // Create Regular User
    console.log('Creating regular user...');
    const user1 = await auth.createUser({
      email: 'officialjagdish@gmail.com',
      password: '12345678',
      displayName: 'Jagdish Kumar',
      phoneNumber: '+918947038661',
    });

    await firestore.collection('users').doc(user1.uid).set({
      name: 'Jagdish Kumar',
      email: 'officialjagdish@gmail.com',
      phone: '8947038661',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isVerified: false,
      isActive: true,
      role: 'member',
    });

    console.log('✅ Regular user created!');
    console.log(`   UID: ${user1.uid}\n`);

    // Create Admin User
    console.log('Creating admin user...');
    const user2 = await auth.createUser({
      email: 'aaijitechstudio@gmail.com',
      password: '12345678',
      displayName: 'Aaiji Tech',
      phoneNumber: '+918947038662',
    });

    await firestore.collection('users').doc(user2.uid).set({
      name: 'Aaiji Tech',
      email: 'aaijitechstudio@gmail.com',
      phone: '8947038662',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isVerified: false,
      isActive: true,
      role: 'admin',
    });

    console.log('✅ Admin user created!');
    console.log(`   UID: ${user2.uid}\n`);

    console.log('✅ All test accounts created successfully!\n');
    console.log('📋 Account Details:');
    console.log('\n   Account 1 (Regular):');
    console.log('   Email: officialjagdish@gmail.com');
    console.log('   Password: 12345678');
    console.log('   Role: member');
    console.log('\n   Account 2 (Admin):');
    console.log('   Email: aaijitechstudio@gmail.com');
    console.log('   Password: 12345678');
    console.log('   Role: admin\n');

  } catch (error) {
    console.error('❌ Error creating accounts:', error.message);
    if (error.code === 'auth/email-already-exists') {
      console.log('   User already exists. Skipping...');
    }
  }

  process.exit(0);
}

createTestAccounts();

