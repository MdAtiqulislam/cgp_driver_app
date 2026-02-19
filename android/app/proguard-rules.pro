# ========================
# Stripe SDK
# ========================
-dontwarn com.stripe.android.pushProvisioning.**

# ========================
# Jackson Databind & XML
# ========================
-dontwarn java.beans.**
-dontwarn org.w3c.dom.bootstrap.**
-dontwarn com.fasterxml.jackson.databind.ext.**
-dontwarn org.slf4j.impl.StaticLoggerBinder
-dontwarn org.slf4j.**

# Keep annotations and reflective classes
-keepattributes Signature, InnerClasses, EnclosingMethod, RuntimeVisibleAnnotations

# Keep Jackson JSON classes
-keep class com.fasterxml.jackson.** { *; }
-keep class org.codehaus.jackson.** { *; }

# Optional (helps with Pusher / Retrofit)
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn retrofit2.**
-dontwarn javax.annotation.**
