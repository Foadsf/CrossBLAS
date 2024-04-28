function(setup_macos_rpath target)
  # Updated OSX RPATH settings In response to CMake 3.0 generating warnings
  # regarding policy CMP0042, the OSX RPATH settings have been updated per
  # recommendations found in the CMake Wiki:
  # http://www.cmake.org/Wiki/CMake_RPATH_handling#Mac_OS_X_and_the_RPATH
  set(CMAKE_MACOSX_RPATH ON)
  set(CMAKE_SKIP_BUILD_RPATH FALSE)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
  list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES
       ${CMAKE_INSTALL_FULL_LIBDIR} isSystemDir)
  if("${isSystemDir}" STREQUAL "-1")
    set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_FULL_LIBDIR})
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
  endif()
  set_target_properties(${target} PROPERTIES INSTALL_RPATH_USE_LINK_PATH TRUE)
endfunction()
