#!/usr/bin/env dart

import 'dart:io';

/// Phase 2 migration script for manual review items
/// This script identifies complex cases that need manual fixing

void main() async {
  print('🔍 Analyzing remaining manual fixes needed...\n');
  
  final files = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
  
  final issues = <String>[];
  
  for (final file in files) {
    final content = await file.readAsString();
    final filePath = file.path.replaceAll('\\', '/');
    
    // Check for workspaceId parameter name issues (missing 'workspaceUuid' in some generated models)
    if (RegExp(r'workspaceId:\s*\w+\.id!?\s*[,)]').hasMatch(content)) {
      issues.add('📌 $filePath: Check if workspaceId parameter should be used (line contains workspaceId: someVar.id)');
    }
    
    // Check for .id! access that might need null checking
    if (RegExp(r'\.id!\s*[,;\)]').hasMatch(content) && !filePath.contains('generated')) {
      issues.add('⚠️  $filePath: Contains .id! - verify null safety');
    }
    
    // Check for Map<int, with UUID keys
    if (RegExp(r'Map<int,').hasMatch(content)) {
      issues.add('🔧 $filePath: Map<int, ... might need to be Map<UuidValue, ...');
    }
    
    // Check for findById with wrong type
    if (RegExp(r'\.findById\s*\(\s*session\s*,\s*\w+\s*\)').hasMatch(content) && !filePath.contains('generated')) {
      issues.add('🔍 $filePath: Check findById() parameter types');
    }
  }
  
  if (issues.isEmpty) {
    print('✅ No obvious manual fixes needed!');
  } else {
    print('Found ${issues.length} items to review:\n');
    for (final issue in issues.take(20)) {  // Show first 20
      print(issue);
    }
    
    if (issues.length > 20) {
      print('\n... and ${issues.length - 20} more');
    }
  }
  
  print('\n📝 Common manual fixes needed:');
  print('1. Replace `uuid: const Uuid().v4obj()` with nothing (let id auto-generate)');
  print('2. Replace `workspaceId: workspace.id` might need to stay as-is');
  print('3. Check error messages about missing parameters like `workspaceUuid`');
  print('4. Update service calls to use UuidValue instead of int');
}
