#!/bin/bash

# Configuración
GRADLE_VER="8.12"
GRADLE_FOLDER="gradle-$GRADLE_VER"
GRADLE_ZIP="gradle-$GRADLE_VER-bin.zip"
NDK_VER="27.0.12077973"
CMAKE_VER="3.22.1"

echo "--- Iniciando proceso de build para Android Opus Official ---"

# 1. Verificar si Gradle existe
if [ ! -d "$GRADLE_FOLDER" ]; then
    echo "[!] Gradle $GRADLE_VER no detectado localmente."
    if [ ! -f "$GRADLE_ZIP" ]; then
        echo "[...] Descargando Gradle $GRADLE_VER..."
        curl -L "https://services.gradle.org/distributions/$GRADLE_ZIP" -o "$GRADLE_ZIP"
    fi
    echo "[...] Descomprimiendo Gradle..."
    unzip -qo "$GRADLE_ZIP"
    rm "$GRADLE_ZIP"
    echo "[+] Gradle listo."
else
    echo "[+] Gradle $GRADLE_VER ya está presente."
fi

# 2. Ejecutar compilación en Docker
echo "[...] Lanzando contenedor Docker para compilación..."
docker run --rm -v "$(pwd):/project" -w /project thyrlian/android-sdk bash -c "
    sdkmanager 'ndk;$NDK_VER' 'cmake;$CMAKE_VER' && \
    export PATH=/project/$GRADLE_FOLDER/bin:\$PATH && \
    gradle clean :assembleRelease --no-daemon"

if [ $? -eq 0 ]; then
    echo "--- BUILD FINALIZADA CON ÉXITO ---"
    echo "Artefacto: build/outputs/aar/android-opus-official-lts-release.aar"
else
    echo "--- ERROR EN LA BUILD ---"
    exit 1
fi
