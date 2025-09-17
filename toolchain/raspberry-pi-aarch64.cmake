# ============================================================
# Cross-compile to Raspberry Pi (ARM64) with Qt5 + Python3
# ============================================================

# Target system
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Cross compiler on host (Ubuntu/WSL)
set(CMAKE_C_COMPILER   /usr/bin/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++)

# Sysroot pulled from Raspberry Pi
set(CMAKE_SYSROOT "/home/conghost/raspi-sysroot")
set(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}")

# ------------------------------------------------------------
# Include/Lib search paths inside sysroot
# ------------------------------------------------------------
set(CMAKE_LIBRARY_PATH "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu")
set(CMAKE_INCLUDE_PATH "${CMAKE_SYSROOT}/usr/include")

# RPATH for runtime search
set(CMAKE_BUILD_RPATH "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu")
set(CMAKE_INSTALL_RPATH "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu")
set(CMAKE_BUILD_RPATH_USE_LINK_PATH TRUE)

# Linker flags: prefer sysroot libs
set(CMAKE_EXE_LINKER_FLAGS
    "${CMAKE_EXE_LINKER_FLAGS} -Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu -L${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu")
set(CMAKE_SHARED_LINKER_FLAGS
    "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu -L${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu")
# Force Python library to use sysroot version
set(CMAKE_EXE_LINKER_FLAGS 
    "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-as-needed -L${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu")

# Env vars for library search
set(ENV{LIBRARY_PATH} "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu")
set(ENV{LD_LIBRARY_PATH} "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu")

# ------------------------------------------------------------
# Qt5 location
# ------------------------------------------------------------
set(Qt5_DIR "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/cmake/Qt5")
list(APPEND CMAKE_PREFIX_PATH "${Qt5_DIR}")
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/qt5")

# ------------------------------------------------------------
# pkg-config inside sysroot
# ------------------------------------------------------------
set(ENV{PKG_CONFIG_SYSROOT_DIR} "${CMAKE_SYSROOT}")
set(ENV{PKG_CONFIG_LIBDIR}
    "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:${CMAKE_SYSROOT}/usr/share/pkgconfig")

# ------------------------------------------------------------
# Python3 setup: interpreter = host, libs/includes = sysroot
# ------------------------------------------------------------
set(Python3_EXECUTABLE "/usr/bin/python3" CACHE FILEPATH "" FORCE)
set(Python3_INCLUDE_DIR "${CMAKE_SYSROOT}/usr/include/python3.10" CACHE PATH "" FORCE)
set(Python3_LIBRARY "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/libpython3.10.so" CACHE FILEPATH "" FORCE)

# ------------------------------------------------------------
# Only search includes/libs/packages inside sysroot
# ------------------------------------------------------------
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Ensure all build tools come from host, not sysroot
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
