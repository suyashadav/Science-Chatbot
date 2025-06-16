import org.jetbrains.kotlin.gradle.plugin.KotlinPluginWrapper

plugins {
    id("com.android.application") apply false
    id("com.google.gms.google-services") apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// buildscript {
//     ext.kotlin_version = '2.1.0'

//     dependencies {
//         classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
//         // other classpaths...
//     }
// }