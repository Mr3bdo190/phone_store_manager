# ProGuard rules for Phone Store Manager

# Keep Drift database classes
-keep class io.drift.** { *; }
-keepclassmembers class * extends io.drift.Database { *.*; }

# Keep generated database classes
-keep class com.phone.storemanager.** extends io.drift.Database { *; }
-keep class com.phone.storemanager.database.** { *; }

# Keep model classes for reflection
-keepclassmembers class * {
  @io.drift.* <fields>;
}

# Keep Flutter plugins
-keep class io.flutter.plugins.** { *; }
