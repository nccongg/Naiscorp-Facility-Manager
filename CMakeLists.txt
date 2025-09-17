cmake_minimum_required(VERSION 3.14)

# Toolchain cho cross-compile Raspberry Pi
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/toolchain/raspberry-pi-aarch64.cmake")

project(Naiscorp_Facility_Manager LANGUAGES CXX)

# C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Tìm Qt5
find_package(Qt5 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)

# Ép Qt tools chạy bản host
set(Qt5Core_MOC_EXECUTABLE "/usr/bin/moc" CACHE FILEPATH "" FORCE)
set(Qt5Core_RCC_EXECUTABLE "/usr/bin/rcc" CACHE FILEPATH "" FORCE)
set(Qt5Core_UIC_EXECUTABLE "/usr/bin/uic" CACHE FILEPATH "" FORCE)

if (TARGET Qt5::moc)
  set_property(TARGET Qt5::moc PROPERTY IMPORTED_LOCATION "/usr/bin/moc")
endif()
if (TARGET Qt5::rcc)
  set_property(TARGET Qt5::rcc PROPERTY IMPORTED_LOCATION "/usr/bin/rcc")
endif()
if (TARGET Qt5::uic)
  set_property(TARGET Qt5::uic PROPERTY IMPORTED_LOCATION "/usr/bin/uic")
endif()

message(STATUS "Qt tools (host): moc=/usr/bin/moc rcc=/usr/bin/rcc uic=/usr/bin/uic")

# Bật autogen
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC OFF)  # Tắt AUTORCC để compile manual
set(CMAKE_AUTOUIC ON)

# Tránh test chạy binary ARM khi configure
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Include dirs
include_directories(include)

# Source code
set(SOURCES
    src/main.cpp
    src/DatabaseManager.cpp
    src/AuthController.cpp
)

# Tạo moc files thủ công (do AUTOMOC không hoạt động với cross-compile)
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/moc_DatabaseManager.cpp
    COMMAND /usr/bin/moc ${CMAKE_CURRENT_SOURCE_DIR}/include/DatabaseManager.h -o ${CMAKE_CURRENT_BINARY_DIR}/moc_DatabaseManager.cpp
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/include/DatabaseManager.h
    COMMENT "Generating moc_DatabaseManager.cpp"
)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/moc_AuthController.cpp
    COMMAND /usr/bin/moc ${CMAKE_CURRENT_SOURCE_DIR}/include/AuthController.h -o ${CMAKE_CURRENT_BINARY_DIR}/moc_AuthController.cpp
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/include/AuthController.h
    COMMENT "Generating moc_AuthController.cpp"
)

# Thêm moc files vào sources
list(APPEND SOURCES 
    "${CMAKE_CURRENT_BINARY_DIR}/moc_DatabaseManager.cpp"
    "${CMAKE_CURRENT_BINARY_DIR}/moc_AuthController.cpp"
)

# Header có Q_OBJECT sẽ được AUTOMOC tự động xử lý
# Chỉ cần include header vào add_executable là đủ

# Compile QRC manually thay vì dùng AUTORCC
set(QRC_SOURCE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/src/qml.qrc")
set(QRC_OUTPUT_FILE "${CMAKE_CURRENT_BINARY_DIR}/qrc_qml.cpp")

add_custom_command(
    OUTPUT ${QRC_OUTPUT_FILE}
    COMMAND /usr/bin/rcc -o ${QRC_OUTPUT_FILE} ${QRC_SOURCE_FILE}
    DEPENDS ${QRC_SOURCE_FILE} ${CMAKE_CURRENT_SOURCE_DIR}/forms/Main.qml
    COMMENT "Generating qrc_qml.cpp from qml.qrc"
)

set(QRC_SOURCES ${QRC_OUTPUT_FILE})

# Executable
add_executable(${PROJECT_NAME}
    ${SOURCES}
    ${QRC_SOURCES}  # Sử dụng QRC_SOURCES thay vì RESOURCES
    # Thêm header có Q_OBJECT vào đây nếu cần:
    include/DatabaseManager.h
    include/AuthController.h
)

# Link Qt
target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
)

# Copy assets/forms khi build
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/assets")
  file(COPY assets DESTINATION ${CMAKE_BINARY_DIR})
endif()
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/forms")
  file(COPY forms DESTINATION ${CMAKE_BINARY_DIR})
endif()
