# Configuración
$GRADLE_VER = "8.12"
$GRADLE_FOLDER = "gradle-$GRADLE_VER"
$GRADLE_ZIP = "gradle-$GRADLE_VER-bin.zip"
$NDK_VER = "26.1.10909125"
$CMAKE_VER = "3.22.1"

Write-Host "--- Iniciando proceso de build para Android Opus Official ---" -ForegroundColor Cyan

# 1. Verificar si Gradle existe
if (-not (Test-Path $GRADLE_FOLDER)) {
    Write-Host "[!] Gradle $GRADLE_VER no detectado localmente." -ForegroundColor Yellow
    if (-not (Test-Path $GRADLE_ZIP)) {
        Write-Host "[...] Descargando Gradle $GRADLE_VER..."
        Invoke-WebRequest -Uri "https://services.gradle.org/distributions/$GRADLE_ZIP" -OutFile $GRADLE_ZIP
    }
    Write-Host "[...] Descomprimiendo Gradle..."
    Expand-Archive -Path $GRADLE_ZIP -DestinationPath "."
    Remove-Item $GRADLE_ZIP
    Write-Host "[+] Gradle listo." -ForegroundColor Green
} else {
    Write-Host "[+] Gradle $GRADLE_VER ya está presente." -ForegroundColor Green
}

# 2. Ejecutar compilación en Docker
Write-Host "[...] Lanzando contenedor Docker para compilación..." -ForegroundColor Cyan
$PWD_PATH = (Get-Location).Path

# Usamos backtick para escapar el $ de PATH para que llegue literal al bash de Docker
docker run --rm -v "${PWD_PATH}:/project" -w /project thyrlian/android-sdk bash -c "sdkmanager 'ndk;$NDK_VER' 'cmake;$CMAKE_VER' && export PATH=/project/$GRADLE_FOLDER/bin:`$PATH && gradle clean :assembleRelease --no-daemon"

if ($LASTEXITCODE -eq 0) {
    Write-Host "--- BUILD FINALIZADA CON ÉXITO ---" -ForegroundColor Green
    Write-Host "Artefacto: build/outputs/aar/android-opus-official-lts-release.aar"
} else {
    Write-Host "--- ERROR EN LA BUILD ---" -ForegroundColor Red
    exit 1
}
