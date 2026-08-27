$ErrorActionPreference = "Stop"

$sdkDir = "C:\Users\Growth\AppData\Local\Android\Sdk"
$buildToolsDir = "$sdkDir\build-tools\35.0.0"
$platformJar = "$sdkDir\platforms\android-36\android.jar"
$jbrDir = "C:\Program Files\Android\Android Studio\jbr"
$javaExe = "$jbrDir\bin\java.exe"
$javacExe = "$jbrDir\bin\javac.exe"
$keytoolExe = "$jbrDir\bin\keytool.exe"
$aaptExe = "$buildToolsDir\aapt.exe"
$zipalignExe = "$buildToolsDir\zipalign.exe"
$d8Bat = "$buildToolsDir\d8.bat"
$apksignerBat = "$buildToolsDir\apksigner.bat"

$projectDir = "C:\Users\Growth\.gemini\antigravity\scratch\bbtype"
$appDir = "$projectDir\app"
$buildDir = "$projectDir\build_output"

Write-Host "=== 1. Cleaning & preparing build directory ==="
if (Test-Path $buildDir) { Remove-Item -Recurse -Force $buildDir }
New-Item -ItemType Directory -Force -Path "$buildDir\gen" | Out-Null
New-Item -ItemType Directory -Force -Path "$buildDir\bin\classes" | Out-Null
New-Item -ItemType Directory -Force -Path "$buildDir\bin\dex" | Out-Null
New-Item -ItemType Directory -Force -Path "$buildDir\dist" | Out-Null

Write-Host "=== 2. Generating R.java with aapt ==="
& $aaptExe package -f -m `
    -J "$buildDir\gen" `
    -M "$appDir\src\main\AndroidManifest.xml" `
    -S "$appDir\src\main\res" `
    -I $platformJar

Write-Host "=== 3. Compiling Java sources with javac ==="
$javaFiles = Get-ChildItem -Path "$appDir\src\main\java", "$buildDir\gen" -Filter "*.java" -Recurse | Select-Object -ExpandProperty FullName
& $javacExe -source 8 -target 8 -bootclasspath $platformJar -d "$buildDir\bin\classes" $javaFiles

Write-Host "=== 4. Dexing classes with D8 (min-api 18) ==="
$classFiles = Get-ChildItem -Path "$buildDir\bin\classes" -Filter "*.class" -Recurse | Select-Object -ExpandProperty FullName
$env:JAVA_HOME = $jbrDir
& $d8Bat --min-api 18 --lib $platformJar --output "$buildDir\bin\dex" $classFiles

Write-Host "=== 5. Packaging initial APK with aapt ==="
& $aaptExe package -f `
    -M "$appDir\src\main\AndroidManifest.xml" `
    -S "$appDir\src\main\res" `
    -A "$appDir\src\main\assets" `
    -I $platformJar `
    -F "$buildDir\bin\unaligned_no_dex.apk"

Write-Host "=== 6. Adding classes.dex to APK ==="
Copy-Item "$buildDir\bin\unaligned_no_dex.apk" "$buildDir\bin\unaligned.apk"
Push-Location "$buildDir\bin\dex"
& $aaptExe add "$buildDir\bin\unaligned.apk" "classes.dex"
Pop-Location

Write-Host "=== 7. Aligning APK with zipalign ==="
& $zipalignExe -f -p 4 "$buildDir\bin\unaligned.apk" "$buildDir\dist\BBType-uncompressed.apk"

Write-Host "=== 8. Creating keystore & signing with v1 and v2 ==="
$keystore = "$projectDir\bbtype-debug.keystore"
if (-not (Test-Path $keystore)) {
    & $keytoolExe -genkeypair -v `
        -keystore $keystore `
        -storepass bbtypepass `
        -alias bbtype `
        -keypass bbtypepass `
        -keyalg RSA `
        -keysize 2048 `
        -validity 10000 `
        -dname "CN=BBType, OU=Mobile, O=BBType, L=Waterloo, S=ON, C=CA"
}

& $apksignerBat sign `
    --ks $keystore `
    --ks-pass pass:bbtypepass `
    --ks-key-alias bbtype `
    --key-pass pass:bbtypepass `
    --min-sdk-version 18 `
    --v1-signing-enabled true `
    --v2-signing-enabled true `
    --out "$projectDir\BBType.apk" `
    "$buildDir\dist\BBType-uncompressed.apk"

Write-Host "=== 9. Verifying APK signature ==="
& $apksignerBat verify --verbose "$projectDir\BBType.apk"

Write-Host "`nSUCCESS! APK built at: $projectDir\BBType.apk"
