# Firebase Setup Guide for Ninja World MMO

## Overview

This guide will help you set up Firebase for your Ninja World MMO project, including authentication, Firestore database, and storage.

## Prerequisites

- Flutter SDK 3.9+
- Firebase account
- Android Studio / VS Code
- Git

## Step 1: Create Firebase Project

1. **Go to Firebase Console**
   - Visit [https://console.firebase.google.com/](https://console.firebase.google.com/)
   - Click "Create a project" or "Add project"

2. **Project Setup**
   - **Project name**: `ninja-world-mmo` (or your preferred name)
   - **Enable Google Analytics**: Optional (recommended for tracking)
   - **Analytics account**: Create new or use existing
   - Click "Create project"

3. **Project Configuration**
   - Wait for project creation to complete
   - Click "Continue" to proceed to the project dashboard

## Step 2: Enable Firebase Services

### Authentication
1. In Firebase Console, go to **Authentication** → **Get started**
2. Click **Sign-in method** tab
3. Enable **Email/Password** authentication
4. Click **Save**

### Firestore Database
1. Go to **Firestore Database** → **Create database**
2. Choose **Start in test mode** (we'll add security rules later)
3. Select **Cloud Firestore location** closest to your users
4. Click **Done**

### Storage (Optional)
1. Go to **Storage** → **Get started**
2. Choose **Start in test mode**
3. Select **Storage location** (same as Firestore)
4. Click **Done**

## Step 3: Add Flutter App to Firebase

### Install Firebase CLI
```bash
npm install -g firebase-tools
```

### Login to Firebase
```bash
firebase login
```

### Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### Configure Flutter App
```bash
# Navigate to your project directory
cd /path/to/ninja_world_mmo

# Configure Firebase for your Flutter app
flutterfire configure --project=ninja-world-mmo
```

This will:
- Create platform-specific Firebase configuration files
- Update your `pubspec.yaml` with Firebase dependencies
- Generate `lib/firebase_options.dart`

## Step 4: Platform-Specific Setup

### Android Setup

1. **Update android/app/build.gradle.kts**
   ```kotlin
   android {
       compileSdkVersion 34
       
       defaultConfig {
           minSdkVersion 21  // Required for Firebase
           targetSdkVersion 34
       }
   }
   ```

2. **Update android/build.gradle.kts**
   ```kotlin
   buildscript {
       dependencies {
           classpath("com.google.gms:google-services:4.4.0")
       }
   }
   ```

3. **Update android/app/build.gradle.kts**
   ```kotlin
   plugins {
       id("com.google.gms.google-services")
   }
   ```

### iOS Setup

1. **Update ios/Podfile**
   ```ruby
   platform :ios, '12.0'  # Minimum iOS version for Firebase
   ```

2. **Install pods**
   ```bash
   cd ios
   pod install
   cd ..
   ```

### Web Setup

No additional setup required - Firebase works out of the box with Flutter web.

## Step 5: Initialize Firebase in Your App

### Update main.dart
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}
```

## Step 6: Set Up Firestore Security Rules

### Go to Firestore Database → Rules
Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Characters can only be accessed by their owner
    match /characters/{characterId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // Public read-only data
    match /villages/{villageId} {
      allow read: if true;
      allow write: if false; // Only admins can modify
    }
    
    match /missions/{missionId} {
      allow read: if true;
      allow write: if false;
    }
    
    match /jutsus/{jutsuId} {
      allow read: if true;
      allow write: if false;
    }
    
    match /items/{itemId} {
      allow read: if true;
      allow write: if false;
    }
    
    // Chat messages - users can read all, write their own
    match /chat/{chatId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.resource.data.characterId == get(/databases/$(database)/documents/characters/$(request.resource.data.characterId)).data.userId;
    }
    
    // Battles - users can read all, write their own
    match /battles/{battleId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.resource.data.participants.characterId.hasAny([get(/databases/$(database)/documents/characters/$(request.resource.data.participants.characterId)).data.userId]);
    }
    
    // Transactions - users can only access their own
    match /transactions/{transactionId} {
      allow read, write: if request.auth != null && 
        resource.data.characterId == get(/databases/$(database)/documents/characters/$(resource.data.characterId)).data.userId;
    }
    
    // Training sessions - users can only access their own
    match /training_sessions/{sessionId} {
      allow read, write: if request.auth != null && 
        resource.data.characterId == get(/databases/$(database)/documents/characters/$(resource.data.characterId)).data.userId;
    }
    
    // Hospital records - users can only access their own
    match /hospital_records/{recordId} {
      allow read, write: if request.auth != null && 
        (resource.data.patientId == get(/databases/$(database)/documents/characters/$(resource.data.patientId)).data.userId ||
         resource.data.medicId == get(/databases/$(database)/documents/characters/$(resource.data.medicId)).data.userId);
    }
    
    // Game updates - read-only for all authenticated users
    match /game_updates/{updateId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins can modify
    }
    
    // Clans - read for all, write for members
    match /clans/{clanId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (resource.data.leader.characterId == get(/databases/$(database)/documents/characters/$(resource.data.leader.characterId)).data.userId ||
         resource.data.advisors.characterId.hasAny([get(/databases/$(database)/documents/characters/$(resource.data.advisors.characterId)).data.userId]));
    }
    
    // World - read for all, write for admins only
    match /world/{worldId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins can modify
    }
  }
}
```

## Step 7: Create Firestore Indexes

### Go to Firestore Database → Indexes
Create the following composite indexes:

1. **Characters by village and rank**
   - Collection: `characters`
   - Fields: `village` (Ascending), `ninjaRank` (Ascending)

2. **Missions by village and rank**
   - Collection: `missions`
   - Fields: `village` (Ascending), `rank` (Ascending), `isAvailable` (Ascending)

3. **Chat messages by type and timestamp**
   - Collection: `chat`
   - Fields: `type` (Ascending), `lastMessageAt` (Descending)

4. **Battles by participant and timestamp**
   - Collection: `battles`
   - Fields: `participants.characterId` (Ascending), `startedAt` (Descending)

5. **Transactions by character and timestamp**
   - Collection: `transactions`
   - Fields: `characterId` (Ascending), `timestamp` (Descending)

## Step 8: Populate Initial Data

### Create a Data Migration Script

Create `scripts/populate_firestore.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../lib/services/stub_data.dart';
import '../lib/models/models.dart';

class FirestoreDataPopulator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StubDataService _stubData = StubDataService();

  Future<void> populateInitialData() async {
    print('Starting data population...');

    // Populate villages
    await _populateVillages();
    
    // Populate missions
    await _populateMissions();
    
    // Populate jutsus
    await _populateJutsus();
    
    // Populate items
    await _populateItems();
    
    // Populate world map
    await _populateWorld();
    
    print('Data population completed!');
  }

  Future<void> _populateVillages() async {
    final villages = [
      {
        'id': 'Konoha',
        'name': 'Konohagakure',
        'description': 'The Hidden Leaf Village',
        'worldPosition': {'x': 12, 'y': 12},
        'population': 0,
        'activePlayers': 0,
        'settings': {
          'missionRefreshRate': 3600,
          'hospitalHealingRate': 100,
          'trainingBonus': 1.2
        },
        'lastUpdated': FieldValue.serverTimestamp(),
      },
      // Add other villages...
    ];

    for (final village in villages) {
      await _firestore.collection('villages').doc(village['id']).set(village);
      print('Created village: ${village['id']}');
    }
  }

  // Add similar methods for other data types...
}
```

### Run the Migration
```bash
dart scripts/populate_firestore.dart
```

## Step 9: Update Your Services

### Replace Stub Services with Firebase

1. **Update AuthService**
   ```dart
   import 'firebase_service.dart';
   
   class AuthService {
     final FirebaseService _firebase = FirebaseService();
     
     Future<bool> login(String email, String password) async {
       try {
         await _firebase.signInWithEmailAndPassword(email, password);
         return true;
       } catch (e) {
         print('Login error: ${_firebase.handleFirebaseError(e)}');
         return false;
       }
     }
   }
   ```

2. **Update GameService**
   ```dart
   import 'firebase_service.dart';
   
   class GameService {
     final FirebaseService _firebase = FirebaseService();
     
     Future<Character?> getCharacter(String characterId) async {
       return await _firebase.getCharacter(characterId);
     }
   }
   ```

## Step 10: Test Your Setup

### Run the App
```bash
flutter run
```

### Test Authentication
1. Try to register a new user
2. Try to log in with the created user
3. Verify user data is stored in Firestore

### Test Database Operations
1. Create a character
2. Update character stats
3. Verify real-time updates work

## Step 11: Environment Configuration

### Create Environment Files

Create `.env` file:
```
FIREBASE_PROJECT_ID=ninja-world-mmo
FIREBASE_API_KEY=your_api_key_here
```

### Add to .gitignore
```
.env
google-services.json
GoogleService-Info.plist
firebase_options.dart
```

## Troubleshooting

### Common Issues

1. **Firebase not initialized**
   - Ensure `Firebase.initializeApp()` is called before `runApp()`
   - Check that `firebase_options.dart` is generated correctly

2. **Permission denied errors**
   - Verify Firestore security rules are set correctly
   - Check that user is authenticated before accessing protected data

3. **Platform-specific issues**
   - Android: Ensure `google-services.json` is in `android/app/`
   - iOS: Ensure `GoogleService-Info.plist` is in `ios/Runner/`

4. **Build errors**
   - Run `flutter clean` and `flutter pub get`
   - Check that all Firebase dependencies are compatible

### Debug Mode

Enable Firebase debug mode:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Enable debug mode
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
  runApp(MyApp());
}
```

## Next Steps

1. **Implement real-time features** using Firestore streams
2. **Add offline support** with Firestore persistence
3. **Set up Firebase Analytics** for user tracking
4. **Configure Firebase Storage** for avatar uploads
5. **Add push notifications** with Firebase Cloud Messaging
6. **Set up automated backups** and monitoring

## Cost Optimization

### Monitor Usage
- Set up Firebase usage alerts
- Monitor Firestore read/write operations
- Track storage usage

### Optimize Queries
- Use composite indexes efficiently
- Limit query results with `.limit()`
- Use pagination for large datasets

### Caching Strategy
- Enable Firestore offline persistence
- Cache frequently accessed data locally
- Use `SharedPreferences` for user settings

## Security Best Practices

1. **Never expose API keys** in client-side code
2. **Use security rules** to protect data
3. **Validate data** on both client and server
4. **Implement rate limiting** for sensitive operations
5. **Regular security audits** of your rules

---

**🎮 Your Ninja World MMO is now ready for Firebase! 🥷**

Follow this guide step by step, and you'll have a fully functional Firebase backend for your MMO game.
