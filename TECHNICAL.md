# Technical Documentation: Android Opus Official LTS

This document provides an in-depth look at the internal architecture, design decisions, and technical specifications of the Android Opus Official LTS library.

---

## 1. Architecture Overview

The library follows a layered architecture to bridge the high-performance C source code of Opus with the Android JVM:

1.  **Core Layer (C)**: Official `xiph/opus` and `xiph/libopusenc` sources. These are included as submodules/directories and compiled directly into the binary.
2.  **Abstraction Layer (C++)**: `jni/CodecOpus.cpp` and `jni/SamplesConverter.cpp`. This layer wraps the raw C API into a more manageable C++ object-oriented structure.
3.  **JNI Bridge (C++)**: `jni/easyopus.cpp`. This acts as the translation layer between Java/Kotlin types (`ByteArray`, `ShortArray`) and C++ pointers.
4.  **Kotlin API**: `com.theeasiestway.opus.Opus`. A clean, high-level interface for Android developers.

---

## 2. JNI Memory Management

To ensure maximum performance and avoid overhead:

-   **Direct Memory Access**: The library uses `malloc` for internal Opus state structures (Encoder/Decoder). These are persistent across calls until `release()` is explicitly called.
-   **Buffer Conversion**: 
    -   PCM audio is often handled as `ShortArray` (16-bit linear PCM). 
    -   Encoded data is handled as `ByteArray`.
    -   The `SamplesConverter` class handles the conversion between these types efficiently, minimizing copies where possible.

---

## 3. Android 15+ & 16KB Page Size

Starting with Android 15, devices may support a memory page size of 16 KB instead of the traditional 4 KB. If a native library is not properly aligned, the application will crash on these devices.

**Our Implementation:**
In `jni/CMakeLists.txt`, we enforce 16KB alignment using the following linker flag:
```cmake
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,max-page-size=16384")
```
This ensures the library is future-proof and compatible with high-performance memory management in newer Android versions.

---

## 4. Codec Configuration (config.h)

The `jni/config.h` file defines the build-time constants for the Opus engine:

-   **FLOAT_APPROX**: Enabled. Provides a better balance between quality and performance on modern ARM processors with NEON support.
-   **VAR_ARRAYS**: Enabled. Uses variable-length arrays for stack-allocated buffers, reducing memory overhead.
-   **Package Version**: Locked to `1.5.2-official`.

---

## 5. Optimized VoIP Settings

The library is pre-configured for high-reliability VoIP communication:

-   **In-band FEC (Forward Error Correction)**: When enabled, the encoder adds redundant data to the stream.
-   **Packet Loss Optimization**: The JNI layer is configured to assume a baseline packet loss (default 10%) when FEC is active, forcing the encoder to be more aggressive with redundancy.
-   **DTX (Discontinuous Transmission)**: Reduces bitrate during silence, critical for conserving battery and bandwidth in mobile environments.

---

## 6. Build Toolchain Specs

-   **NDK Version**: 27.0.12077973 (r27b LTS).
-   **ABIs Supported**: `arm64-v8a`, `armeabi-v7a`, `x86_64`.
-   **C++ Standard**: C++17.
-   **Optimization Level**: `-O3` (Maximum optimization for speed).

---

## 7. Safety & Stability

-   **Null Safety**: The JNI layer performs rigorous checks before accessing encoder/decoder pointers. If a method is called before initialization, the library logs a descriptive error and returns gracefully instead of crashing the JVM.
-   **Error Mapping**: Opus C error codes are mapped and logged via the Android Logcat (`CodecOpus` tag) for easier debugging during development.
