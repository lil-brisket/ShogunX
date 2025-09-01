import 'dart:io';

void main() async {
  final testDir = Directory('test');
  if (!await testDir.exists()) {
    print('Test directory not found');
    return;
  }

  final files = testDir.listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

  for (final file in files) {
    print('Processing: ${file.path}');
    String content = file.readAsStringSync();
    
    // Remove print statements
    content = content.replaceAll(RegExp(r'^\s*print\([^)]*\);?\s*$', multiLine: true), '');
    
    // Remove empty lines
    content = content.replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n');
    
    file.writeAsStringSync(content);
  }
  
  print('Test files cleaned up');
}
