# Android Opus Official LTS (1.5.2+)

A standalone Android Library project providing a high-security, high-performance build of the **Opus Interactive Audio Codec**. This fork is based 100% on the official Xiph.org source code.

## Key Features
- **Official Engine**: Built from official `xiph/opus` and `xiph/libopusenc` repositories.
- **NDK r27b LTS**: Compiled with the latest stable Long-Term Support NDK for maximum security.
- **16KB Alignment**: Fully compatible with Android 15+ memory management (16 KB page size support).
- **VoIP Optimization**: Native JNI support for:
  - **CBR/VBR** control.
  - **DTX** (Discontinuous Transmission) toggle.
  - **FEC** (Forward Error Correction) with packet loss optimization.

## Project Structure
- `opus/`: Official C source from Xiph.
- `libopusenc/`: Official C source from Xiph.
- `jni/`: JNI wrapper and CMake build scripts.
- `src/`: Kotlin interface for easy Android integration.

## Reproducible Build (Docker)
This project is designed to be built in a clean environment to ensure binary integrity.

```bash
docker run --rm -v "${PWD}:/project" -w /project thyrlian/android-sdk bash -c "
    sdkmanager \"ndk;27.0.12077973\" \"cmake;3.22.1\" && \
    wget -q https://services.gradle.org/distributions/gradle-8.12-bin.zip && \
    unzip -qo gradle-8.12-bin.zip && \
    export PATH=\$PWD/gradle-8.12/bin:\$PATH && \
    gradle clean :assembleRelease"
```

The resulting AAR will be located at `build/outputs/aar/official-opus-release.aar`.

## Integration
Add the `.aar` to your project's `libs` folder and call it from Kotlin/Java using the `Opus` class.

## License
This project follows the official Opus (BSD) and Xiph.org licenses.
