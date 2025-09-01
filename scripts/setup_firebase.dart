import 'dart:io';

void main() async {
  print('🔥 Firebase Setup Script for Ninja World MMO');
  print('=============================================\n');
  
  print('This script will help you configure Firebase for your project.');
  print('Make sure you have:');
  print('1. Created a Firebase project at https://console.firebase.google.com/');
  print('2. Enabled Firestore Database');
  print('3. Enabled Authentication (Email/Password)');
  print('\n');
  
  stdout.write('Enter your Firebase project ID: ');
  String? projectId = stdin.readLineSync();
  
  if (projectId == null || projectId.isEmpty) {
    print('❌ Project ID is required. Please run the script again.');
    exit(1);
  }
  
  print('\n🚀 Starting Firebase configuration...');
  
  try {
    // Configure Firebase for Flutter
    print('📱 Configuring Firebase for Flutter...');
    final result = await Process.run('flutterfire', [
      'configure',
      '--project=$projectId',
      '--platforms=android,ios,web'
    ]);
    
    if (result.exitCode == 0) {
      print('✅ Firebase configuration completed successfully!');
      print('\n📋 Next steps:');
      print('1. Update your main.dart to initialize Firebase');
      print('2. Set up Firestore security rules');
      print('3. Create database indexes');
      print('4. Run the data migration script');
    } else {
      print('❌ Firebase configuration failed:');
      print(result.stderr);
    }
  } catch (e) {
    print('❌ Error during Firebase configuration: $e');
    print('\n💡 Make sure you have:');
    print('- Created the Firebase project');
    print('- Enabled Firestore Database');
    print('- Enabled Authentication');
  }
}
