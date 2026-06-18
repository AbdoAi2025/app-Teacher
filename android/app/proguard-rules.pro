# Paymob SDK - keep all classes to prevent navigation graph inflation crash
-keep class com.paymob.** { *; }
-keepclassmembers class com.paymob.** { *; }
-keepnames class com.paymob.** { *; }
-dontwarn com.paymob.**

# Keep Fragment subclasses referenced by navigation graphs
-keep public class * extends androidx.fragment.app.Fragment
-keep public class * extends android.app.Fragment

# Keep navigation component classes
-keep class androidx.navigation.** { *; }
-keepclassmembers class androidx.navigation.** { *; }

# Flutter
-keep class io.flutter.** { *; }
-keepclassmembers class io.flutter.** { *; }
-dontwarn io.flutter.**