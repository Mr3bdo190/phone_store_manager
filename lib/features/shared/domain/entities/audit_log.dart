// lib/features/shared/domain/entities/audit_log.dart
/// Audit log entry — records critical system actions.
library;

import '../../../core/constants/enums.dart';

class AuditLog {
  final int? id;
  final int userId;
  final String userName;
  final AuditAction action;
  final String entityType;
  final int? entityId;
  final String? oldValue;
  final String? newValue;
  final String? description;
  final String ipAddress;
  final DateTime timestamp;

  AuditLog({
    this.id,
    required this.userId,
    required this.userName,
    required this.action,
    required this.entityType,
    this.entityId,
    this.oldValue,
    this.newValue,
    this.description,
    this.ipAddress = 'local',
    required this.timestamp,
  });
}
