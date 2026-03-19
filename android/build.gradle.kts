allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Современный способ установки build dir в Kotlin DSL
rootProject.layout.buildDirectory.set(project.file("../build"))

subprojects {
    project.layout.buildDirectory.set(project.file("${rootProject.layout.buildDirectory.get()}/${project.name}"))
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}