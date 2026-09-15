// lib/features/shared/domain/services/audit_log_service.dart
/// Service for writing audit log entries.
library;

import 'package:drift/drift.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/database/database.dart' as db;
import '../../../../core/services/di.dart';
import '../entities/audit_log.dart';

class AuditLogService {
  final db.AppDatabase _database;

  AuditLogService() : _database = di.get<db.AppDatabase>();

  Future<void> log({
    required int userId,
    required String userName,
    required AuditAction action,
    required String entityType,
    int? entityId,
    String? oldValue,
    String? newValue,
    String? description,
  }) async {
    try {
      await _database.into(_database.auditLogs).insert(
            db.AuditLogsCompanion.insert(
              userId: userId,
              userName: userName,
              action: action.name,
              entityType: entityType,
              entityId: Value(entityId),
              oldValue: Value(oldValue),
              newValue: Value(newValue),
              description: Value(description),
              ipAddress: const Value('local'),
              timestamp: Value(DateTime.now()),
            ),
          );
    } catch (e) {
      // Silently fail — audit logging shouldn't break main operations
    }
  }

  Future<List<AuditLog>> getRecentLogs({int limit = 50}) async {
    final rows = await (_database.select(_database.auditLogs)
          ..limit(limit)
          ..orderBy([($tl) => OrderingTerm.desc($tl.timestamp)]))
        .get();

    return rows.map((row) => _fromRow(row)).toList();
  }

  AuditLog _fromRow(db.AuditLog row) => AuditLog(
        id: row.id,
        userId: row.userId,
        userName: row.userName,
        action: AuditAction.values.firstWhere(
            (e) => e.name == row.action,
            orElse: () => AuditAction.create),
        entityType: row.entityType,
        entityId: row.entityId,
        oldValue: row.oldValue,
        newValue: row.newValue,
        description: row.description,
        ipAddress: row.ipAddress,
        timestamp: row.timestamp,
      );
}