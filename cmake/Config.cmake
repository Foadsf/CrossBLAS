include(CMakePackageConfigHelpers)

# Generate the Config.cmake file
set(CONFIG_INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${BLASLIB}")
configure_package_config_file(
  "${PROJECT_SOURCE_DIR}/cmake/Config.cmake.in"
  "${PROJECT_BINARY_DIR}/${BLASLIB}-config.cmake"
  INSTALL_DESTINATION "${CONFIG_INSTALL_DESTINATION}"
  PATH_VARS CMAKE_INSTALL_LIBDIR)

# Generate the ConfigVersion.cmake file
write_basic_package_version_file(
  "${PROJECT_BINARY_DIR}/${BLASLIB}-config-version.cmake"
  VERSION ${BLAS_VERSION}
  COMPATIBILITY SameMajorVersion)

# Install the Config.cmake and ConfigVersion.cmake files
install(FILES "${PROJECT_BINARY_DIR}/${BLASLIB}-config.cmake"
              "${PROJECT_BINARY_DIR}/${BLASLIB}-config-version.cmake"
        DESTINATION "${CONFIG_INSTALL_DESTINATION}")

# Install the export set for the build tree
export(EXPORT ${BLAS_INSTALL_EXPORT_NAME}
       FILE "${PROJECT_BINARY_DIR}/${BLASLIB}-targets.cmake")
