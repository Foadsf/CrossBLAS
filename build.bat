RMDIR /S /Q build
MKDIR build
CD build
SET "PATH=C:\Windows\System32\;"
CALL "C:\Program Files (x86)\Intel\oneAPI\setvars.bat"
cmake -G "Ninja" .. -DCMAKE_Fortran_COMPILER=ifort
cmake --build .
@REM ctest
CD ..
