# UUID Migration - Remaining Manual Fixes

## Summary

The automated migration script (`migrate_to_uuid.dart`) has completed successfully, reducing errors from 11 endpoint files to just 4.

**Remaining files with errors:**
1. `card_endpoint.dart` - 21 issues
2. `checklist_endpoint.dart`
3. `invite_endpoint.dart`
4. `label_endpoint.dart`

## Common Error Patterns & Fixes

### 1. Set<int> → Set<UuidValue>
**Error:** `The argument type 'Set<UuidValue>' can't be assigned to the parameter type 'Set<int>'`

**Fix:** Change internal collections to use UuidValue:
```dart
// BEFORE
final existingIds = <int>{};
final Map<int, CardLabel> = {};

// AFTER
final existingIds = <UuidValue>{};
final Map<UuidValue, CardLabel> = {};
```

### 2. .uuid field access (removed)
**Error:** `The getter 'uuid' isn't defined for the type 'CardTable'`

**Fix:** Use `.id` instead of `.uuid`:
```dart
// BEFORE
where: (c) => c.uuid.equals(cardUuid)

// AFTER
where: (c) => c.id.equals(cardUuid)
```

### 3. Method parameter type mismatches
**Error:** `The argument type 'int' can't be assigned to the parameter type 'UuidValue'`

**Fix:** Update all method signatures and calls:
```dart
// BEFORE
Future<void> someMethod(int cardId) async {}

// AFTER  
Future<void> someMethod(UuidValue cardId) async {}
```

### 4. List/Set operations with mixed types
**Error:** `The argument type 'Set<UuidValue>' can't be assigned to the parameter type 'Set<int>'`

**Fix:** Ensure consistent types in Set operations:
```dart
// BEFORE
final toAdd = grantedIds.difference(existingIds);  // Where types mismatch

// AFTER
final toAdd = grantedIds.difference(existingIds);  // Both Set<UuidValue>
```

## Detailed Fix Locations

### card_endpoint.dart (21 issues)

Lines to fix:
- **542**: Method call parameter type
- **577**: Method call parameter type (nullable)
- **602-603**: ActivityService call parameters
- **863, 870**: Set contains() operations
- **907**: Change `.uuid` to `.id`
- **963, 969, 973-974**: Set type declarations
- **983, 986, 989-990**: Set operations
- **1075**: Set<int> to Set<UuidValue>
- **1086**: Map key type
- **1089, 1091**: Collection operations

### Quick Fix Script

Run this to see exact error locations:
```bash
cd kanew_server
dart analyze lib/src/endpoints/card_endpoint.dart 2>&1 | grep "error"
dart analyze lib/src/endpoints/checklist_endpoint.dart 2>&1 | grep "error"
dart analyze lib/src/endpoints/invite_endpoint.dart 2>&1 | grep "error"
dart analyze lib/src/endpoints/label_endpoint.dart 2>&1 | grep "error"
```

## Next Steps

1. Fix the 4 remaining endpoints manually using patterns above
2. Run `serverpod generate` again
3. If successful, proceed to Phase 3.5: Create migration
4. Then tackle frontend migration (Phase 3.6-3.7)

## Estimated Time

- 30-45 minutes to fix remaining 4 files
- 10 minutes to create migration
- Total: ~1 hour to complete backend UUID migration
