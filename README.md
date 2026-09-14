# Phone Store Manager 📱

Professional offline mobile phone store management application for Android.

## Overview

**Phone Store Manager** is a comprehensive, offline-first application designed to manage all aspects of a single mobile phone retail store. Built with Flutter and SQLite (Drift), it provides everything needed to run a phone store — from inventory and POS to accounting and reporting.

### Key Features

| Category | Features |
|----------|----------|
| **Products** | Mobile phones, accessories, categories, brands, models |
| **Phones** | IMEI 1 & 2 tracking, serial numbers, storage, RAM, color |
| **Inventory** | Stock in/out, adjustments, damaged, lost, counting, movements |
| **POS / Sales** | Barcode scanning, IMEI selection, discounts, invoices |
| **Purchases** | Supplier management, IMEI registration, returns |
| **Customers** | Profiles, purchase history, debt tracking |
| **Suppliers** | Profiles, purchase history, debt tracking |
| **Repairs** | Ticket management, status tracking, technician assignment |
| **Expenses** | Categories, payment methods, history |
| **Cash** | Opening/closing, in/out, daily closing |
| **Profit** | Revenue, COGS, gross/net profit from real transactions |
| **Reports** | Daily/monthly sales, profit, expenses, debts, inventory |
| **Backup** | Full local backup, restore with validation, versioning |
| **Import/Export** | CSV export/import |
| **Security** | PIN/password, biometric, session lock, admin/employee roles |
| **Audit Log** | Login, sales, purchases, edits, deletes, stock changes |
| **Settings** | Store info, currency, invoice, theme, language |

## Technical Architecture

### Architecture
- **Clean Architecture** with Presentation / Domain / Data separation
- **Repository Pattern** for all data access
- **Service Layer** for business logic (no logic in widgets)
- **Provider** for state management (lightweight, minimal deps)
- **Drift** (SQLite) for local database

### Database
- Local SQLite database (Drift ORM)
- Foreign keys, unique constraints, indexes
- Soft delete for recoverable records
- Database transactions for multi-step operations
- Schema versioning and migrations

### Dependencies
- `drift` + `sqlite3_flutter_libs` — Database
- `provider` — State management
- `intl` — Localization
- `crypto` — Password hashing
- `flutter_secure_storage` — PIN/password storage
- `flutter_local_notifications` — Notifications
- `share_plus` + `file_picker` — Backup file operations
- `csv` — Import/export

### Project Structure
```
lib/
├── app.dart
├── main.dart
├── routes.dart
├── core/
│   ├── constants/      # Enums, app constants
│   ├── database/       # Drift tables, database, DAOs
│   ├── errors/         # Exceptions, failures
│   ├── extensions/     # Dart extensions
│   ├── helpers/        # Formatters, validators
│   ├── services/       # DI, base services
│   ├── theme/          # Colors, text styles
│   ├── utils/          # Utilities
│   └── widgets/        # Shared widgets
├── features/
│   ├── auth/           # Authentication (login, setup)
│   ├── dashboard/      # Main dashboard
│   ├── settings/       # App settings
│   ├── shared/         # Shared entities & services
│   └── (phases 2-5 added incrementally)
├── l10n/               # ARB localization files
└── (feature folders)
```

## Development Setup

### Prerequisites
- Android phone with Termux
- Git
- GitHub account (for CI/CD builds)

### Running Locally
```bash
# Clone the repository
git clone https://github.com/yourusername/phone_store_manager.git
cd phone_store_manager

# Install Flutter (use proot-distro Ubuntu for glibc compatibility)
# See: https://github.com/termux/termux-app

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run the app
flutter run

# Analyze code
flutter analyze
```

## Building APK

APK is built via **GitHub Actions** (not locally on the phone):

1. Push to `main` branch on GitHub
2. Go to **Actions** tab → **Build APK** workflow
3. Wait for completion (~5-10 minutes)
4. Download APK from the **Artifacts** section

### Manual Build
```yaml
# .github/workflows/build.yml handles:
# 1. Checkout repository
# 2. Setup Java 17
# 3. Setup Flutter stable
# 4. Cache dependencies
# 5. flutter pub get
# 6. flutter analyze
# 7. flutter test
# 8. flutter build apk --release --split-per-abi
# 9. Upload APK artifact
```

## Database

The app uses a local SQLite database via Drift ORM with the following tables:

| Table | Description |
|-------|-------------|
| `users` | Admin & employee accounts with roles |
| `settings` | Single-row store settings |
| `categories` | Product categories |
| `brands` | Product brands |
| `products` | General products (accessories) |
| `phones` | Phone-specific data (IMEI linking) |
| `imeis` | IMEI records with uniqueness constraint |
| `customers` | Customer profiles & balances |
| `suppliers` | Supplier profiles & balances |
| `sales` | Sale header records |
| `sale_items` | Items in each sale |
| `sale_payments` | Payment records for credit sales |
| `purchases` | Purchase header records |
| `purchase_items` | Items in each purchase |
| `purchase_payments` | Payments to suppliers |
| `returns` | Return header records |
| `return_items` | Items in each return |
| `inventory_movements` | Full audit trail of stock changes |
| `expenses` | Expense records |
| `cash_transactions` | Cash book entries |
| `repairs` | Repair tickets |
| `repair_photos` | Photos attached to repairs |
| `audit_logs` | System audit log |

### Migrations
Schema versioning is managed via `schemaVersion` in the database class. Each schema change increments this number and adds the appropriate migration.

### Transactions
Critical financial operations (sales, purchases, payments) are wrapped in database transactions to ensure atomicity and data consistency.

## Backup & Restore

### Backup
- Full SQLite database export
- Automatic versioning with timestamps
- User-initiated and scheduled backup options
- Backup validation before completion

### Restore
- Restore from any previous backup file
- **Safe restore**: current database is backed up before restore
- Restore validation to prevent corruption
- Never overwrites without validation

### Process
1. Navigate to **Settings → Backup**
2. Tap **Create Backup**
3. Select backup location (local storage)
4. For restore: select backup file → confirm → verify

## Testing

```bash
flutter test
```

### Test Coverage
| Category | Tests |
|----------|-------|
| **Unit** | Financial calculations (subtotal, discount, tax, total, profit) |
| **Unit** | IMEI uniqueness validation |
| **Unit** | Authentication (register, login, validation) |
| **Database** | CRUD for users, categories, brands, products |
| **Database** | Transactions, soft delete, settings |
| **Integration** | Sale → inventory decrease (Phase 3+) |
| **Integration** | Purchase → inventory increase (Phase 4+) |

## License

This project is proprietary software for store management.

---

**Built with ❤️ using Flutter + Drift | Designed for Android phones | 100% offline**
