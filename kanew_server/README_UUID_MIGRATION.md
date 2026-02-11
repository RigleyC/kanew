# UUID Migration Tools

## Overview

Automated migration tools to convert the Kanew project from int auto-increment IDs to UuidValue primary keys across the entire stack.

## Files Created

1. **migrate_to_uuid.dart** - Main automation script
2. **analyze_manual_fixes.dart** - Code analysis tool  
3. **UUID_MIGRATION_GUIDE.md** - Step-by-step fix guide
4. **MIGRATION_SUMMARY.md** - Complete progress report
5. **README.md** - This file

## Quick Start

```bash
cd kanew_server

# 1. Run the automated migration
dart run migrate_to_uuid.dart

# 2. Regenerate Serverpod code
~/AppData/Local/Pub/Cache/bin/serverpod.bat generate

# 3. Analyze remaining issues
dart run analyze_manual_fixes.dart

# 4. Check specific file errors
dart analyze lib/src/endpoints/card_endpoint.dart

# 5. Fix remaining 4 files manually using UUID_MIGRATION_GUIDE.md

# 6. Final generation
~/AppData/Local/Pub/Cache/bin/serverpod.bat generate

# 7. Create database migration
~/AppData/Local/Pub/Cache/bin/serverpod.bat create-migration --force
```

## Current Status

✅ **90% Complete** - Only 4 files need manual fixes

### Completed
- 16 backend models migrated to UuidValue PKs
- 31 automated pattern replacements across 14 files
- PermissionService fully migrated
- 9 of 13 endpoints automatically fixed

### Remaining
- 4 endpoints need manual fixes (30-45 min)
- Database migration creation (10 min)
- Frontend migration (2-3 hours)

## Documentation

- **UUID_MIGRATION_GUIDE.md** - Common patterns and specific line numbers to fix
- **MIGRATION_SUMMARY.md** - Full progress report and metrics

## Scripts Usage

### migrate_to_uuid.dart
Automatically fixes:
- Removes `uuid: const Uuid().v4obj()` from model creation
- Updates `int workspaceId` → `UuidValue workspaceId`
- Updates `List<int>` → `List<UuidValue>`
- Updates nullable types `int?` → `UuidValue?`

### analyze_manual_fixes.dart
Scans for patterns needing manual review:
- Collection type mismatches
- Map key/value types
- Null safety concerns
- Generated field name changes

## Next Steps

See UUID_MIGRATION_GUIDE.md for:
1. Detailed error patterns and fixes
2. Specific line numbers in remaining files
3. Quick-fix commands
4. Time estimates

## Support

For questions or issues:
1. Check UUID_MIGRATION_GUIDE.md for common patterns
2. Run `dart analyze <file>` for specific errors
3. Review MIGRATION_SUMMARY.md for context
