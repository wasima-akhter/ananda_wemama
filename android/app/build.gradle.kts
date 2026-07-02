import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// ─── Load key.properties ───────────────────────────────────────────────────
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties().apply {
    load(FileInputStream(keyPropertiesFile))
}

android {
    namespace = "com.app.wemama"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.app.wemama"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ─── Signing Configs ────────────────────────────────────────────────────
    signingConfigs {
        getByName("debug") {
            storeFile = file(keyProperties.getProperty("debugStoreFile"))
            storePassword = keyProperties.getProperty("debugStorePassword")
            keyAlias = keyProperties.getProperty("debugKeyAlias")
            keyPassword = keyProperties.getProperty("debugKeyPassword")
        }

        create("release") {
            storeFile = file(keyProperties["releaseStoreFile"] as String)
            storePassword = keyProperties["releaseStorePassword"] as String
            keyAlias = keyProperties["releaseKeyAlias"] as String
            keyPassword = keyProperties["releaseKeyPassword"] as String
        }
    }

    // ─── Build Types ────────────────────────────────────────────────────────
    buildTypes {
         getByName("debug") {
        signingConfig = signingConfigs.getByName("debug")
        }
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // ─── Packaging ──────────────────────────────────────────────────────────
    packaging {
        jniLibs {
            pickFirsts.addAll(
                listOf(
                    "lib/arm64-v8a/libaosl.so",
                    "lib/armeabi-v7a/libaosl.so",
                    "lib/x86/libaosl.so",
                    "lib/x86_64/libaosl.so"
                )
            )
        }
    }
}

flutter {
    source = "../.."
}

// ─── Dependencies ───────────────────────────────────────────────────────────
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.android.gms:play-services-auth:21.2.0")

    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
