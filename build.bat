RMDIR /S /Q build
MKDIR build
CD build
@REM SET "PATH=C:\Windows\System32\;"
@REM CALL "C:\Program Files (x86)\Intel\oneAPI\setvars.bat"
cmake -G "Ninja" .. -DCMAKE_Fortran_COMPILER=ifort
cmake --build .
ctest
CD ..
