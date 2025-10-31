# Flutter Build & Install Script (PowerShell)
# Save as BuildInstall.ps1
# Ustawienie UTF-8 i TrueType fontu w konsoli
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# ----------------------------
# Ustawienia
# ----------------------------
$DEVICE = "5200d78bfa479449"
$APK_PATH = "..\build\app\outputs\flutter-apk\app-release.apk"

# ----------------------------
# Funkcja do kolorowego echo
# ----------------------------
function Write-Info($msg) {
    Write-Host $msg -ForegroundColor Cyan
}
function Write-Success($msg) {
    Write-Host $msg -ForegroundColor Green
}
function Write-Warn($msg) {
    Write-Host $msg -ForegroundColor Yellow
}
function Write-ErrorMsg($msg) {
    Write-Host $msg -ForegroundColor Red
}

# ----------------------------
# Start
# ----------------------------
Clear-Host
Write-Host "======================================"
Write-Host "  Flutter Build + Install + Reverse"
Write-Host "======================================"

# ----------------------------
# Step 1: Build APK
# ----------------------------
Write-Info "`nBuilding release APK for android-arm..."
$build = flutter build apk --release --target-platform=android-arm --dart-define=DART_VM_PRODUCT=true

if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg " Build failed!"
    Read-Host "Press Enter to exit..."
    exit
}

# ----------------------------
# Step 2: Install APK
# ----------------------------
Write-Info "`n Installing APK on device $DEVICE..."
if (-Not (Test-Path $APK_PATH)) {
    Write-ErrorMsg "APK not found at $APK_PATH"
    Read-Host "Press Enter to exit..."
    exit
}

$install = adb -s $DEVICE install -r $APK_PATH

if ($LASTEXITCODE -ne 0) {
    Write-ErrorMsg "Installation failed!"
} else {
    Write-Success "Installation successful!"
}

# ----------------------------
# Step 3: Setup reverse TCP
# ----------------------------
Write-Info "`n Setting up reverse TCP for 8081..."
adb -s $DEVICE reverse tcp:8081 tcp:8081

# ----------------------------
# Done
# ----------------------------
Write-Success "`n All done! Device: $DEVICE"
Read-Host "Press Enter to exit..."
