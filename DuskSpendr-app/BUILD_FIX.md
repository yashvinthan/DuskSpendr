# Build Fix Guide

## Java Version Issue

**Error**: `Unsupported class file major version 69`

**Cause**: Your system is using Java 25 (class file version 69), but Android/Gradle build tools require Java 17 or 21.

**Quick Fix** (Choose one):

### Option 1: Set JAVA_HOME Environment Variable (Recommended)

**Windows PowerShell:**
```powershell
# Set for current session
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"

# Or make permanent (run as Administrator):
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk-17", "Machine")
```

**Windows CMD:**
```cmd
setx JAVA_HOME "C:\Program Files\Java\jdk-17" /M
```

**Verify:**
```powershell
java -version
# Should show: openjdk version "17.0.x" or "21.0.x"
```

### Option 2: Configure Gradle Properties

Edit `android/gradle.properties` and uncomment/update:
```properties
# Replace with your actual JDK 17/21 path
org.gradle.java.home=C:/Program Files/Java/jdk-17
```

**Find your JDK path:**
- Check `flutter doctor -v` for "Java binary at"
- Or check: `where java` (Windows) / `which java` (Mac/Linux)
- Navigate to parent JDK folder (not `bin` subfolder)

### Option 3: Install JDK 17/21

If you don't have JDK 17 or 21:

1. **Download:**
   - **Eclipse Temurin (Recommended)**: https://adoptium.net/temurin/releases/?version=17
   - **Oracle JDK**: https://www.oracle.com/java/technologies/downloads/#java17

2. **Install** and note the installation path (usually `C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot`)

3. **Set JAVA_HOME** (see Option 1)

---

## After Fixing

1. **Restart your IDE** (VS Code, Android Studio, Cursor)

2. **Stop Gradle daemon:**
   ```bash
   cd android
   gradlew --stop
   ```

3. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --debug
   ```

---

## Verification Checklist

- [ ] `java -version` shows 17.x or 21.x
- [ ] `echo $JAVA_HOME` (or `echo %JAVA_HOME%` on Windows) shows correct path
- [ ] IDE restarted
- [ ] Gradle daemon stopped
- [ ] Build succeeds without "class file major version 69" error

---

## Still Having Issues?

1. Check if multiple Java versions are installed:
   ```powershell
   Get-ChildItem "C:\Program Files\Java" -Directory
   ```

2. Ensure JDK 17/21 is first in PATH:
   ```powershell
   $env:PATH -split ';' | Select-String -Pattern "java"
   ```

3. Use Android Studio's JDK:
   - Android Studio → File → Settings → Build, Execution, Deployment → Build Tools → Gradle
   - Set "Gradle JDK" to "jbr-17" or "jbr-21" (JetBrains Runtime)
