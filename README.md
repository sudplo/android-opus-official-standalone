# Android Opus Official LTS (v1.5.2+)

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Android](https://img.shields.io/badge/Platform-Android-green.svg)]()
[![NDK](https://img.shields.io/badge/NDK-r27b%20LTS-orange.svg)]()

A high-performance, standalone Android Library providing a secure and optimized build of the **Opus Interactive Audio Codec**. This project is built 100% upon the official source code from Xiph.org, specifically tailored for modern Android requirements.

---

## 🚀 Key Features

*   **Official Engine**: Up-to-date implementation using `xiph/opus` and `xiph/libopusenc`.
*   **Next-Gen Compatibility**: Fully optimized for **Android 15+** with mandatory **16KB page size alignment**.
*   **Modern Toolchain**: Compiled using **NDK r27b LTS** (the most recent stable Long-Term Support version).
*   **VoIP & Pro Audio Ready**:
    *   Full control over **CBR (Constant Bitrate)** and **VBR (Variable Bitrate)**.
    *   **DTX (Discontinuous Transmission)** support for bandwidth saving.
    *   **In-band FEC (Forward Error Correction)** for high-quality audio under packet loss.

---

## 📁 Project Architecture

| Folder | Description |
| :--- | :--- |
| `jni/` | High-performance C++ wrapper and CMake build configuration. |
| `opus/` | Official Opus core source code (Xiph.org). |
| `libopusenc/` | Official Opus Encoding library source (Xiph.org). |
| `src/main/` | Clean Kotlin interface for seamless JVM/Android integration. |

---

## 🛠 Building the Project

This project emphasizes **reproducibility**. We provide automated scripts and Docker support to ensure binary integrity across different environments.

### 1. Automated Build (Recommended)
Run the script corresponding to your operating system. It will automatically check for dependencies (Gradle), download them if necessary, and execute the build inside a Docker container.

*   **Windows (PowerShell):**
    ```powershell
    ./build.ps1
    ```
*   **Linux / macOS (Bash):**
    ```bash
    chmod +x build.sh
    ./build.sh
    ```

### 2. Manual Docker Execution
If you prefer to run it manually:
```bash
docker run --rm -v "${PWD}:/project" -w /project thyrlian/android-sdk bash -c "sdkmanager 'ndk;27.0.12077973' 'cmake;3.22.1' && export PATH=/project/gradle-8.12/bin:\$PATH && gradle clean :assembleRelease --no-daemon"
```

> **Result:** The generated artifact will be available at:  
> `build/outputs/aar/android-opus-official-lts-release.aar`

---

## 📦 Integration

1.  Copy the generated `.aar` file to your project's `libs/` folder.
2.  Add the dependency in your `build.gradle`:
    ```gradle
    dependencies {
        implementation files('libs/android-opus-official-lts-release.aar')
    }
    ```

### Usage Example (Kotlin)

```kotlin
import com.theeasiestway.opus.Opus
import com.theeasiestway.opus.Constants

val opus = Opus()

// 1. Initialize the Encoder (e.g., 48kHz, Mono, VoIP mode)
opus.encoderInit(
    Constants.SampleRate._48000(), 
    Constants.Channels.mono(), 
    Constants.Application.voip()
)

// 2. Configure Bitrate & Complexity
opus.encoderSetBitrate(Constants.Bitrate.instance(24000))
opus.encoderSetComplexity(Constants.Complexity.instance(10))

// 3. Process Audio (PCM ByteArray to Opus)
val encoded: ByteArray? = opus.encode(pcmByteArray, Constants.FrameSize._480())

// 4. Release Resources
opus.encoderRelease()
```

---

## ⚖️ License

This project is licensed under the **BSD 3-Clause License**. It incorporates source code from the Opus and libopusenc projects, which are subject to their respective licenses by Xiph.org.
