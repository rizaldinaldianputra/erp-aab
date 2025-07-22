buildscript {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://dl.google.com/dl/android/maven2") } // penting
    }

    dependencies {
        add("classpath", "com.android.tools.build:gradle:8.6.0")
        add("classpath", "com.google.gms:google-services:4.3.15") // 🔥 WAJIB untuk Firebase
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
