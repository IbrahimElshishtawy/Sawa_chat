pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version("4.3.15") apply false
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")

// Workaround for plugins without namespace attribute (AGP 8.0+)
gradle.beforeProject {
    if (this != rootProject) {
        afterEvaluate {
            val androidExtension = extensions.findByName("android")
            if (androidExtension != null && !this.plugins.hasPlugin("com.android.application")) {
                try {
                    val extension = androidExtension as com.android.build.gradle.BaseExtension
                    if (extension.namespace == null) {
                        val pkgName = if (plugins.hasPlugin("com.android.library")) {
                            "com.example.${this.name.replace(":", ".")}"
                        } else {
                            "com.example.${this.name.replace(":", ".")}"
                        }
                        extension.namespace = pkgName
                    }
                } catch (e: Exception) {
                    // Ignore if extension cannot be cast
                }
            }
        }
    }
}
