enable_testing()

# Set up test executables
if(BUILD_SINGLE)
  add_executable(xblat1s sblat1.f)
  target_link_libraries(xblat1s ${BLASLIB})
  add_test(NAME BLAS-xblat1s COMMAND xblat1s)

  add_executable(xblat2s sblat2.f)
  target_link_libraries(xblat2s ${BLASLIB})
  add_test(NAME BLAS-xblat2s COMMAND xblat2s)

  add_executable(xblat3s sblat3.f)
  target_link_libraries(xblat3s ${BLASLIB})
  add_test(NAME BLAS-xblat3s COMMAND xblat3s)
endif()

if(BUILD_DOUBLE)
  add_executable(xblat1d dblat1.f)
  target_link_libraries(xblat1d ${BLASLIB})
  add_test(NAME BLAS-xblat1d COMMAND xblat1d)

  add_executable(xblat2d dblat2.f)
  target_link_libraries(xblat2d ${BLASLIB})
  add_test(NAME BLAS-xblat2d COMMAND xblat2d)

  add_executable(xblat3d dblat3.f)
  target_link_libraries(xblat3d ${BLASLIB})
  add_test(NAME BLAS-xblat3d COMMAND xblat3d)
endif()

if(BUILD_COMPLEX)
  add_executable(xblat1c cblat1.f)
  target_link_libraries(xblat1c ${BLASLIB})
  add_test(NAME BLAS-xblat1c COMMAND xblat1c)

  add_executable(xblat2c cblat2.f)
  target_link_libraries(xblat2c ${BLASLIB})
  add_test(NAME BLAS-xblat2c COMMAND xblat2c)

  add_executable(xblat3c cblat3.f)
  target_link_libraries(xblat3c ${BLASLIB})
  add_test(NAME BLAS-xblat3c COMMAND xblat3c)
endif()

if(BUILD_COMPLEX16)
  add_executable(xblat1z zblat1.f)
  target_link_libraries(xblat1z ${BLASLIB})
  add_test(NAME BLAS-xblat1z COMMAND xblat1z)

  add_executable(xblat2z zblat2.f)
  target_link_libraries(xblat2z ${BLASLIB})
  add_test(NAME BLAS-xblat2z COMMAND xblat2z)

  add_executable(xblat3z zblat3.f)
  target_link_libraries(xblat3z ${BLASLIB})
  add_test(NAME BLAS-xblat3z COMMAND xblat3z)
endif()
