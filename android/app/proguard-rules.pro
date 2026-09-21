# ------------------------------
# Flutter & Plugins
# ------------------------------
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.view.** { *; }
-keep class dev.flutter.pigeon.** { *; }

# ------------------------------
# Geolocator & Firebase
# ------------------------------
-keep class com.baseflow.geolocator.** { *; }
-keep class com.google.firebase.** { *; }

# ------------------------------
# Stripe SDK
# ------------------------------
-dontwarn com.stripe.android.**
-keep class com.stripe.android.** { *; }

# ------------------------------
# Jackson & XML
# ------------------------------
-dontwarn com.fasterxml.jackson.**
-dontwarn org.codehaus.jackson.**
-dontwarn java.beans.**
-keep class com.fasterxml.jackson.** { *; }

# ------------------------------
# Network & Retrofit
# ------------------------------
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn retrofit2.**
-dontwarn javax.annotation.**
-dontwarn org.slf4j.**
-dontwarn com.google.android.gms.**

# ------------------------------
# Mapbox
# ------------------------------
-keep class com.eopeter.fluttermapboxnavigation.** { *; }
-dontwarn com.eopeter.fluttermapboxnavigation.**




# ------------------------------
# Play Core / Deferred Components
# ------------------------------
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**


# ------------------------------
# General R8 fix
# ------------------------------
-ignorewarnings
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod