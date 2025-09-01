# Firebase Console Setup Checklist

## Step 1: Create Firebase Project

1. **Go to Firebase Console**: https://console.firebase.google.com/
2. **Click "Create a project"**
3. **Project Details**:
   - Project name: `ninja-world-mmo`
   - Enable Google Analytics: ✅ (recommended)
   - Analytics account: Create new or use existing
4. **Click "Create project"**
5. **Wait for creation** and click "Continue"

## Step 2: Enable Firestore Database

1. **In Firebase Console**, go to **Firestore Database**
2. **Click "Create database"**
3. **Choose security rules**: "Start in test mode" (we'll add proper rules later)
4. **Select location**: Choose closest to your users (e.g., `us-central1`)
5. **Click "Done"**

## Step 3: Enable Authentication

1. **In Firebase Console**, go to **Authentication**
2. **Click "Get started"**
3. **Go to "Sign-in method" tab**
4. **Enable "Email/Password"**:
   - Click on "Email/Password"
   - Toggle "Enable"
   - Click "Save"

## Step 4: Get Project ID

1. **In Firebase Console**, go to **Project settings** (gear icon)
2. **Copy the Project ID** (e.g., `ninja-world-mmo-xxxxx`)

## Step 5: Run Setup Script

Once you have your Project ID, run:

```bash
dart scripts/setup_firebase.dart
```

Enter your Project ID when prompted.

## Step 6: Update main.dart

After the setup script completes, update your `main.dart` to initialize Firebase.

## Step 7: Set Up Security Rules

Copy the security rules from `DATABASE_SCHEMA.md` to your Firestore Database → Rules section.

## Step 8: Create Indexes

Create the composite indexes listed in `DATABASE_SCHEMA.md` in your Firestore Database → Indexes section.

---

**🎯 Goal**: Complete steps 1-4, then let me know your Project ID to continue!
