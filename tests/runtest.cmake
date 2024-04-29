# runtest.cmake
set(TEST_PROGRAM ${CMAKE_ARGV3}/${CMAKE_ARGV0})
set(TEST_INPUT ${CMAKE_ARGV1})
set(CONFIG ${CMAKE_ARGV2})

if(TEST_INPUT)
  execute_process(
    COMMAND ${TEST_PROGRAM}
    INPUT_FILE ${TEST_INPUT}
    RESULT_VARIABLE result)
else()
  execute_process(COMMAND ${TEST_PROGRAM} RESULT_VARIABLE result)
endif()

if(NOT result EQUAL 0)
  message(FATAL_ERROR "Test failed: ${TEST_PROGRAM}")
endif()
