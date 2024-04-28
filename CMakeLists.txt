cmake_minimum_required(VERSION 3.2)

project(
  BLAS
  VERSION 3.12.0.1
  LANGUAGES Fortran)

set(CMAKE_CONFIGURATION_TYPES "Debug" "Release" "MinSizeRel" "RelWithDebInfo"
                              "Coverage")

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE
      "Release"
      CACHE STRING "Choose the type of build." FORCE)
  message(STATUS "Setting build type to 'Release' as none was specified.")
endif()

# Set the Fortran compilation flags depending on the compiler
if(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O3 -Wall -Wextra")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
  set(CMAKE_Fortran_FLAGS
      "${CMAKE_Fortran_FLAGS} /Qipo /MP /Qdiag-disable:10448")
endif()

# Add the CMake directory for custom CMake modules
set(CMAKE_MODULE_PATH "${BLAS_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

# specify the standard of Fortran if needed
if(NOT CMAKE_Fortran_STANDARD)
  set(CMAKE_Fortran_STANDARD 95)
  set(CMAKE_Fortran_STANDARD_REQUIRED True)
endif()

# Add subdirectories add_subdirectory(src)

# Configuration for building shared libraries
option(BUILD_SHARED_LIBS "Build as a shared library" OFF)

# Coverage
set(_is_coverage_build 0)
set(_msg "Checking if build type is 'Coverage'")
message(STATUS "${_msg}")
if(NOT CMAKE_CONFIGURATION_TYPES)
  string(TOLOWER ${CMAKE_BUILD_TYPE} _build_type_lc)
  if(${_build_type_lc} STREQUAL "coverage")
    set(_is_coverage_build 1)
  endif()
endif()
message(STATUS "${_msg}: ${_is_coverage_build}")

if(_is_coverage_build)
  message(STATUS "Adding coverage")
  find_package(codecov)
endif()

include(CTest)
enable_testing()
add_subdirectory(tests)

# Export all symbols on Windows when building shared libraries
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)

# By default build index32 library
option(BUILD_INDEX64 "Build Index-64 API libraries" OFF)
if(BUILD_INDEX64)
  set(BLASLIB "blas64")
  set(CMAKE_C_FLAGS
      "${CMAKE_C_FLAGS} -DWeirdNEC -DLAPACK_ILP64 -DHAVE_LAPACK_CONFIG_H")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fdefault-integer-8")
else()
  set(BLASLIB "blas")
endif()

# --------------------------------------------------
set(BLAS_INSTALL_EXPORT_NAME ${BLASLIB}-targets)

macro(blas_install_library lib)
  install(
    TARGETS ${lib}
    EXPORT ${BLAS_INSTALL_EXPORT_NAME}
    ARCHIVE DESTINATION lib COMPONENT Development
    LIBRARY DESTINATION lib COMPONENT RuntimeLibraries
    RUNTIME DESTINATION lib COMPONENT RuntimeLibraries)
endmacro()

set(PKG_CONFIG_DIR lib/pkgconfig)

# --------------------------------------------------
# Precision to build By default all precisions are generated
option(BUILD_SINGLE "Build single precision real" ON)
option(BUILD_DOUBLE "Build double precision real" ON)
option(BUILD_COMPLEX "Build single precision complex" ON)
option(BUILD_COMPLEX16 "Build double precision complex" ON)
message(STATUS "Build single precision real: ${BUILD_SINGLE}")
message(STATUS "Build double precision real: ${BUILD_DOUBLE}")
message(STATUS "Build single precision complex: ${BUILD_COMPLEX}")
message(STATUS "Build double precision complex: ${BUILD_COMPLEX16}")

if(NOT
   (BUILD_SINGLE
    OR BUILD_DOUBLE
    OR BUILD_COMPLEX
    OR BUILD_COMPLEX16))
  message(
    FATAL_ERROR
      "Nothing to build, no precision selected.
  Please enable at least one of these:
  BUILD_SINGLE, BUILD_DOUBLE, BUILD_COMPLEX, BUILD_COMPLEX16.")
endif()

include(GNUInstallDirs)
include(PlatformSpecificSettings)
include(PreventInSourceBuilds)
include(PreventInBuildInstalls)

# --------------------------------------------------
# Check for any necessary platform specific compiler flags
include(CheckLAPACKCompilerFlags)
checklapackcompilerflags("-recursive" _recursiveFlag)
checklapackcompilerflags("-frecursive" _frecursiveFlag)
checklapackcompilerflags("-Mrecursive" _MrecursiveFlag)

# Add recursive flag
if(_recursiveFlag)
  string(REGEX MATCH "-recursive" output_test <string> "${CMAKE_Fortran_FLAGS}")
  if(NOT output_test)
    set(CMAKE_Fortran_FLAGS
        "${CMAKE_Fortran_FLAGS} -recursive"
        CACHE STRING "Recursive flag must be set" FORCE)
  endif()
elseif(_frecursiveFlag)
  string(REGEX MATCH "-frecursive" output_test <string>
               "${CMAKE_Fortran_FLAGS}")
  if(NOT output_test)
    set(CMAKE_Fortran_FLAGS
        "${CMAKE_Fortran_FLAGS} -frecursive"
        CACHE STRING "Recursive flag must be set" FORCE)
  endif()
elseif(_MrecursiveFlag)
  string(REGEX MATCH "-Mrecursive" output_test <string>
               "${CMAKE_Fortran_FLAGS}")
  if(NOT output_test)
    set(CMAKE_Fortran_FLAGS
        "${CMAKE_Fortran_FLAGS} -Mrecursive"
        CACHE STRING "Recursive flag must be set" FORCE)
  endif()
endif()

set(BLAS_LIBRARIES ${BLASLIB})

# ##############################################################################
# This is the makefile to create a library for the BLAS. The files are grouped
# as follows:
#
# SBLAS1 -- Single precision real BLAS routines CBLAS1 -- Single precision
# complex BLAS routines DBLAS1 -- Double precision real BLAS routines ZBLAS1 --
# Double precision complex BLAS routines
#
# CB1AUX -- Real BLAS routines called by complex routines ZB1AUX -- D.P. real
# BLAS routines called by d.p. complex routines
#
# ALLBLAS -- Auxiliary routines for Level 2 and 3 BLAS
#
# SBLAS2 -- Single precision real BLAS2 routines CBLAS2 -- Single precision
# complex BLAS2 routines DBLAS2 -- Double precision real BLAS2 routines ZBLAS2
# -- Double precision complex BLAS2 routines
#
# SBLAS3 -- Single precision real BLAS3 routines CBLAS3 -- Single precision
# complex BLAS3 routines DBLAS3 -- Double precision real BLAS3 routines ZBLAS3
# -- Double precision complex BLAS3 routines
#
# ##############################################################################

# ---------------------------------------------------------
# Level 1 BLAS
# ---------------------------------------------------------

file(GLOB CB1AUX "src/l1/CB1AUX/*")

file(GLOB SBLAS1 "src/l1/SBLAS1/*" ${CB1AUX})

file(GLOB CBLAS1 "src/l1/CBLAS1/*")

file(GLOB ZB1AUX "src/l1/ZB1AUX/*")

file(GLOB DBLAS1 "src/l1/DBLAS1/*" ${ZB1AUX})

file(GLOB ZBLAS1 "src/l1/ZBLAS1/*")

# ---------------------------------------------------------------------
# Auxiliary routines needed by both the Level 2 and Level 3 BLAS
# ---------------------------------------------------------------------

file(GLOB ALLBLAS "src/aux_/*")

# ---------------------------------------------------------
# Level 2 BLAS
# ---------------------------------------------------------

file(GLOB SBLAS2 "src/l2/SBLAS2/*")

file(GLOB CBLAS2 "src/l2/CBLAS2/*")

file(GLOB DBLAS2 "src/l2/DBLAS2/*")

file(GLOB ZBLAS2 "src/l2/ZBLAS2/*")

# ---------------------------------------------------------
# Level 3 BLAS
# ---------------------------------------------------------
file(GLOB SBLAS3 "src/l3/SBLAS3/*")

file(GLOB CBLAS3 "src/l3/CBLAS3/*")

file(GLOB DBLAS3 "src/l3/DBLAS3/*")

file(GLOB ZBLAS3 "src/l3/ZBLAS3/*")

set(SINGLE_SOURCES)
set(DOUBLE_SOURCES)
set(COMPLEX_SOURCES)
set(COMPLEX16_SOURCES)

if(BUILD_SINGLE)
  list(APPEND SINGLE_SOURCES ${SBLAS1} ${ALLBLAS} ${SBLAS2} ${SBLAS3})
endif()

if(BUILD_DOUBLE)
  list(APPEND DOUBLE_SOURCES ${DBLAS1} ${ALLBLAS} ${DBLAS2} ${DBLAS3})
endif()

if(BUILD_COMPLEX)
  list(
    APPEND
    COMPLEX_SOURCES
    ${CBLAS1}
    ${CB1AUX}
    ${ALLBLAS}
    ${CBLAS2}
    ${CBLAS3})
endif()

if(BUILD_COMPLEX16)
  list(
    APPEND
    COMPLEX16_SOURCES
    ${ZBLAS1}
    ${ZB1AUX}
    ${ALLBLAS}
    ${ZBLAS2}
    ${ZBLAS3})
endif()

# Include the make.inc file include(${BLAS_SOURCE_DIR}/make.inc)

add_library(${BLASLIB} ${ALLBLAS}) # Add ALLBLAS sources unconditionally

if(BUILD_SINGLE)
  target_sources(${BLASLIB} PRIVATE ${SINGLE_SOURCES})
endif()

if(BUILD_DOUBLE)
  target_sources(${BLASLIB} PRIVATE ${DOUBLE_SOURCES})
endif()

if(BUILD_COMPLEX)
  target_sources(${BLASLIB} PRIVATE ${COMPLEX_SOURCES})
endif()

if(BUILD_COMPLEX16)
  target_sources(${BLASLIB} PRIVATE ${COMPLEX16_SOURCES})
endif()

set_target_properties(${BLASLIB} PROPERTIES VERSION ${PROJECT_VERSION}
                                            SOVERSION ${PROJECT_VERSION_MAJOR})

setup_macos_rpath(${BLASLIB})

# Export the library target
install(
  TARGETS ${BLASLIB}
  EXPORT ${BLAS_INSTALL_EXPORT_NAME}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Add custom targets for building test executables
add_custom_target(single DEPENDS xblat1s xblat2s xblat3s)
add_custom_target(double DEPENDS xblat1d xblat2d xblat3d)
add_custom_target(complex DEPENDS xblat1c xblat2c xblat3c)
add_custom_target(complex16 DEPENDS xblat1z xblat2z xblat3z)
add_custom_target(build_all DEPENDS single double complex complex16)
