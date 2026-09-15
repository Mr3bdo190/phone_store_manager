// lib/core/constants/enums.dart
/// Application-wide enums used across domain and data layers.
library;

/// Role assigned to a [User].
enum UserRole {
  admin,
  employee,
}

/// Display label extension for [UserRole].
extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'مدير';
      case UserRole.employee:
        return 'موظف';
    }
  }

  String get key => name;

  static UserRole fromKey(String key) => UserRole.values
      .firstWhere((e) => e.name == key, orElse: () => UserRole.employee);
}

/// Gender for [Customer] or [Supplier].
enum Gender { male, female, other, unknown }

extension GenderLabel on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return 'ذكر';
      case Gender.female:
        return 'أنثى';
      case Gender.other:
        return 'أخرى';
      case Gender.unknown:
        return 'غير محدد';
    }
  }
}

/// Payment method for sales, purchases, expenses.
enum PaymentMethod {
  cash,
  bankTransfer,
  card,
  credit,
  other,
}

extension PaymentMethodLabel on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return 'نقداً';
      case PaymentMethod.bankTransfer:
        return 'تحويل بنكي';
      case PaymentMethod.card:
        return 'بطاقة';
      case PaymentMethod.credit:
        return 'دين';
      case PaymentMethod.other:
        return 'أخرى';
    }
  }
}

/// Status of a [Phone] device throughout its lifecycle.
enum PhoneStatus {
  inStock,
  sold,
  outOfOrder,
  inRepair,
  lost,
}

extension PhoneStatusLabel on PhoneStatus {
  String get label {
    switch (this) {
      case PhoneStatus.inStock:
        return 'متاح';
      case PhoneStatus.sold:
        return 'مباع';
      case PhoneStatus.outOfOrder:
        return ' معيق';
      case PhoneStatus.inRepair:
        return ' في الصيانة';
      case PhoneStatus.lost:
        return 'ضائع';
    }
  }
}

/// Repair status enumeration.
enum RepairStatus {
  received,
  diagnosing,
  waitingForParts,
  inRepair,
  ready,
  delivered,
  cancelled,
}

extension RepairStatusLabel on RepairStatus {
  String get label {
    switch (this) {
      case RepairStatus.received:
        return 'مستلم';
      case RepairStatus.diagnosing:
        return 'قيد التشخيص';
      case RepairStatus.waitingForParts:
        return 'في انتظار قطع الغيار';
      case RepairStatus.inRepair:
        return 'قيد الإصلاح';
      case RepairStatus.ready:
        return 'جاهز';
      case RepairStatus.delivered:
        return 'مُسلّم';
      case RepairStatus.cancelled:
        return 'ملغى';
    }
  }
}

/// Transaction type for [InventoryMovement].
enum MovementType {
  stockIn,
  stockOut,
  adjustment,
  sale,
  purchase,
  returnIn,
  returnOut,
  damaged,
  lost,
  transfer,
}

extension MovementTypeLabel on MovementType {
  String get label {
    switch (this) {
      case MovementType.stockIn:
        return 'دخول مخزون';
      case MovementType.stockOut:
        return 'خروج مخزون';
      case MovementType.adjustment:
        return 'تعديل';
      case MovementType.sale:
        return 'بيع';
      case MovementType.purchase:
        return 'شراء';
      case MovementType.returnIn:
        return 'إرجاع وارد';
      case MovementType.returnOut:
        return 'إرجاع صادر';
      case MovementType.damaged:
        return 'تالف';
      case MovementType.lost:
        return 'ضائع';
      case MovementType.transfer:
        return 'نقل';
    }
  }
}

/// Audit log action types.
enum AuditAction {
  login,
  logout,
  create,
  update,
  delete,
  sale,
  purchase,
  payment,
  return_,
  expense,
  salary,
  backup,
  restore,
  settingsChange,
  stockAdjustment,
  repairStatusChange,
}

extension AuditActionLabel on AuditAction {
  String get label {
    switch (this) {
      case AuditAction.login:
        return 'تسجيل دخول';
      case AuditAction.logout:
        return 'تسجيل خروج';
      case AuditAction.create:
        return 'إنشاء';
      case AuditAction.update:
        return 'تعديل';
      case AuditAction.delete:
        return 'حذف';
      case AuditAction.sale:
        return 'بيع';
      case AuditAction.purchase:
        return 'شراء';
      case AuditAction.payment:
        return 'دفعة';
      case AuditAction.return_:
        return 'إرجاع';
      case AuditAction.expense:
        return 'مصروف';
      case AuditAction.salary:
        return 'راتب';
      case AuditAction.backup:
        return 'نسخة احتياطية';
      case AuditAction.restore:
        return 'استعادة';
      case AuditAction.settingsChange:
        return 'تغيير الإعدادات';
      case AuditAction.stockAdjustment:
        return 'تعديل مخزون';
      case AuditAction.repairStatusChange:
        return 'تغيير حالة الصيانة';
    }
  }
}

/// Expense category type.
enum ExpenseType {
  rent,
  utilities,
  salaries,
  supplies,
  repairs,
  marketing,
  other,
}

extension ExpenseTypeLabel on ExpenseType {
  String get label {
    switch (this) {
      case ExpenseType.rent:
        return 'إيجار';
      case ExpenseType.utilities:
        return 'مرافق';
      case ExpenseType.salaries:
        return 'رواتب';
      case ExpenseType.supplies:
        return 'لوازم';
      case ExpenseType.repairs:
        return 'إصلاحات';
      case ExpenseType.marketing:
        return 'تسويق';
      case ExpenseType.other:
        return 'أخرى';
    }
  }
}
