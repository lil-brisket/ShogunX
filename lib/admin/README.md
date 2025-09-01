# ShogunX Admin Panel

A comprehensive administrative interface for managing the ShogunX MMO game, built with Flutter Web and Firebase.

## Features

### 🔐 Authentication & Security
- Firebase Auth integration
- Admin-only access control
- Secure Firestore rules
- Protected routes and data access

### 👥 User Management
- View all players in the game
- Search by username or email
- Edit player stats (HP, Chakra, Stamina, Rank, Level)
- Reset player cooldowns
- Add/remove items and jutsus from inventory

### 🎒 Items Management (Coming Soon)
- CRUD operations for game items
- Manage item properties and stats
- Assign items to players
- View item usage statistics

### ⚡ Jutsus Management (Coming Soon)
- CRUD operations for jutsu techniques
- Manage jutsu properties and requirements
- Assign jutsus to players
- Track jutsu mastery levels

### 📋 Quests Management (Coming Soon)
- Create and edit quests
- Manage quest requirements and rewards
- Assign quests to specific players
- Track quest completion rates

### ⚙️ Settings (Coming Soon)
- Admin panel configuration
- System logs and monitoring
- Backup and restore functionality
- Permission management

## Architecture

### 📁 Project Structure
```
lib/admin/
├── main.dart                 # Admin panel entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   └── admin_user.dart      # User model for admin operations
├── providers/                # State management
│   └── auth_provider.dart   # Authentication and admin verification
├── screens/                  # UI screens
│   ├── admin_dashboard.dart # Main dashboard with sidebar
│   ├── login_screen.dart    # Admin login
│   ├── users/               # User management screens
│   ├── items/               # Item management screens
│   ├── jutsus/              # Jutsu management screens
│   ├── quests/              # Quest management screens
│   └── settings/            # Settings screens
├── services/                 # Business logic
│   └── users_service.dart   # User data operations
└── widgets/                  # Reusable UI components
    └── admin_sidebar.dart   # Collapsible navigation sidebar
```

### 🛠️ Technology Stack
- **Flutter Web** - Cross-platform web UI
- **Riverpod** - State management
- **Firebase Auth** - Authentication
- **Cloud Firestore** - Database
- **Material 3** - UI design system

## Setup Instructions

### 1. Firebase Configuration
1. Ensure Firebase is configured in your project
2. Create an `admins` collection in Firestore
3. Add admin users to the collection with their UIDs
4. Deploy the Firestore security rules

### 2. Admin Access Setup
1. Create a user account in Firebase Auth
2. Add the user's UID to the `admins/{userId}` collection
3. The user can now log in to the admin panel

### 3. Running the Admin Panel
```bash
# Run as Flutter Web app
flutter run -d chrome --web-port 8080

# Or build for production
flutter build web
```

## Security Rules

The admin panel uses strict Firestore security rules:

- Only authenticated users can access data
- Only users in the `admins` collection can modify game data
- Players can only read their own data
- Admins have full read/write access to all collections

## Usage

### User Management
1. Navigate to the Users section
2. Use the search bar to find specific players
3. Click the edit button to modify player data
4. Use the reset cooldowns button to clear player timers

### Adding New Admins
1. Create a user account in Firebase Auth
2. Add their UID to the `admins` collection in Firestore
3. The user can now access the admin panel

## Development

### Adding New Features
1. Create new models in the `models/` directory
2. Add services in the `services/` directory
3. Create UI screens in the `screens/` directory
4. Update the sidebar navigation in `admin_dashboard.dart`

### Testing
- Test all CRUD operations thoroughly
- Verify admin access controls
- Test with different user roles
- Validate data integrity

## Deployment

### Web Deployment
1. Build the admin panel: `flutter build web`
2. Deploy to Firebase Hosting or your preferred web host
3. Ensure Firebase configuration is correct for production

### Security Considerations
- Regularly review admin access
- Monitor admin actions in Firebase logs
- Use strong authentication methods
- Keep Firebase SDKs updated

## Troubleshooting

### Common Issues
1. **Admin access denied**: Check if user UID exists in `admins` collection
2. **Firebase connection errors**: Verify Firebase configuration
3. **Data not loading**: Check Firestore security rules
4. **Build errors**: Ensure all dependencies are properly configured

### Support
For issues or questions about the admin panel, check:
- Firebase console logs
- Flutter web console
- Firestore security rules validation

## Future Enhancements

- Real-time data updates
- Advanced analytics dashboard
- Bulk operations for multiple users
- Export/import functionality
- Advanced search and filtering
- Audit logging for admin actions
- Multi-language support
- Mobile-responsive design improvements
