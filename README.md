
# Android Opus Codec

A high-performance Android library providing a native NDK build of the Opus audio codec with Kotlin/JNI bindings.

This project is based on the official upstream source code from Xiph.org (opus and libopusenc), adapted and built for modern Android environments.

---

## 🚀 Features

- Native Opus codec integration (Xiph.org: opus + libopusenc)
- Android NDK build system
- Kotlin + JNI API wrapper
- Optimized for modern Android versions (including 16KB page alignment)
- VoIP-ready audio processing:
  - CBR / VBR control
  - DTX support (bandwidth saving)
  - In-band FEC (packet loss resilience)

---

## 📁 Project Structure

| Folder | Description |
|--------|------------|
| `jni/` | Native C++ wrapper and CMake build system |
| `opus/` | Opus codec source (Xiph.org) |
| `libopusenc/` | Opus encoding library (Xiph.org) |
| `src/main/` | Kotlin API layer |

---

## 🛠 Build

### Automated
```bash
./build.sh
./build.ps1
````

### Docker

```bash
docker run --rm -v "${PWD}:/project" -w /project thyrlian/android-sdk \
bash -c "sdkmanager 'ndk;27.0.12077973' 'cmake;3.22.1' && gradle clean :assembleRelease"
```

---

## 📦 Integration

```gradle
dependencies {
    implementation files('libs/android-opus-codec-release.aar')
}
```

---

## 📱 Usage

```kotlin
val opus = Opus()

opus.encoderInit(
    Constants.SampleRate._48000(),
    Constants.Channels.mono(),
    Constants.Application.voip()
)

opus.encoderSetBitrate(Constants.Bitrate.instance(24000))
opus.encoderSetComplexity(Constants.Complexity.instance(10))

val encoded = opus.encode(pcm, Constants.FrameSize._480())

opus.encoderRelease()
```

---

## ⚖️ License

BSD-3-Clause License.

Includes upstream code from Xiph.org (opus and libopusenc), each under their respective licenses.
