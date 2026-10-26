@echo off
rem
rem launch.bat - init and/or run a pl.ai Haxall project from this directory.
rem Windows. Only needs Java on the machine.
rem
rem   launch.bat                         create project "pl" if missing, then run it
rem   launch.bat init [project] [opts]   create a project (prompts for su user/password/port)
rem   launch.bat run  [project] [opts]   run an existing project
rem   launch.bat start [project] [opts]  init if missing, then run (the default)
rem   launch.bat setup [project]         (re)enable the pl.* libs in a project
rem   launch.bat help
rem
rem init/start also enable the pl.* libs right after creating a project (skip
rem with: set PL_SKIP_SETUP=1).
rem
rem init opts:  -headless -suUser NAME -suPass PASS -httpPort N -httpsDisable
rem run opts:   -noAuth (auto-login as su on loopback)  -console
rem
rem A bare project name lives in .\projects\NAME; a name containing a backslash,
rem slash or colon is used as a path as-is. Set JAVA_HOME to pick a specific JVM,
rem JAVA_OPTS for extra JVM flags (e.g. set JAVA_OPTS=-Xmx4g). Quote option
rem values that contain = , ; or spaces.
rem

setlocal EnableExtensions

rem Minimum Java. make.ps1 rewrites this line to match the Fantom runtime that
rem was packaged (the class-file version of fantom\lib\java\sys.jar).
set "MIN_JAVA=26"

set "HERE=%~dp0"
if "%HERE:~-1%"=="\" set "HERE=%HERE:~0,-1%"

rem hermetic: ignore any Fantom dev environment set up in this shell
set "FAN_HOME="
set "FAN_ENV="
set "FAN_ENV_PATH="
set "FAN_CP="
set "CLASSPATH="

rem ---- arguments ----------------------------------------------------------
set "CMD=start"
set "PROJ=pl"
set "OPTS="

set "A=%~1"
if /i "%A%"=="help"   goto usage
if /i "%A%"=="-h"     goto usage
if /i "%A%"=="-help"  goto usage
if /i "%A%"=="--help" goto usage
if "%A%"=="/?"        goto usage
if "%A%"=="-?"        goto usage
if /i "%A%"=="init"  ( set "CMD=init"  & shift & goto haveCmd )
if /i "%A%"=="run"   ( set "CMD=run"   & shift & goto haveCmd )
if /i "%A%"=="start" ( set "CMD=start" & shift & goto haveCmd )
if /i "%A%"=="setup" ( set "CMD=setup" & shift & goto haveCmd )
:haveCmd

set "A=%~1"
if not defined A goto haveProj
if "%A:~0,1%"=="-" goto haveProj
set "PROJ=%~1"
shift
:haveProj

:collect
if "%~1"=="" goto collected
set OPTS=%OPTS% %1
shift
goto collect
:collected

set "DB=%HERE%\projects\%PROJ%"
echo(%PROJ%| findstr /r /c:"[\\/:]" >nul && set "DB=%PROJ%"
set "DB=%DB:/=\%"

rem ---- sanity: is this directory complete? --------------------------------
for %%F in (
  fantom\lib\java\sys.jar
  fantom\lib\fan\sys.pod
  haxall\lib\fan\hx.pod
  haxall\fan.props
  xeto\lib\xeto\sys.xetolib
  haystack-defs\lib\fan\ph.pod
  plExts\lib\fan\plAgent.pod
) do if not exist "%HERE%\%%F" (
  echo ERROR: missing %%F - this directory is incomplete; rebuild it with make.ps1
  exit /b 1
)

rem ---- java ---------------------------------------------------------------
set "JAVA=java"
if defined JAVA_HOME if exist "%JAVA_HOME%\bin\java.exe" set "JAVA=%JAVA_HOME%\bin\java.exe"

set "JVFILE=%TEMP%\hx_javaver_%RANDOM%.txt"
"%JAVA%" -version 2>"%JVFILE%" >nul
if errorlevel 1 (
  del "%JVFILE%" >nul 2>&1
  echo ERROR: could not run Java. Install Java %MIN_JAVA% or newer, or set JAVA_HOME.
  exit /b 1
)
set "JVER="
for /f "tokens=3" %%v in ('findstr /i /c:" version " "%JVFILE%"') do if not defined JVER set "JVER=%%~v"
del "%JVFILE%" >nul 2>&1
if not defined JVER (
  echo ERROR: could not parse the Java version.
  exit /b 1
)
set "JMAJ="
for /f "tokens=1 delims=.-+_" %%m in ("%JVER%") do set "JMAJ=%%m"
if %JMAJ% LSS %MIN_JAVA% (
  echo ERROR: Java %MIN_JAVA% or newer is required, found %JVER% ^(%JAVA%^).
  echo        Set JAVA_HOME to a newer JDK/JRE.
  exit /b 1
)

rem ---- go -----------------------------------------------------------------
rem Run from haxall\ - its fan.props (path=../haystack-defs;../xeto;../plExts)
rem is what wires the whole runtime together.
pushd "%HERE%\haxall"

if /i "%CMD%"=="init"  goto doInit
if /i "%CMD%"=="run"   goto doRun
if /i "%CMD%"=="setup" goto doSetup

:doStart
if exist "%DB%\db\folio.index" goto doRun
echo Project '%DB%' does not exist - creating it.
if not exist "%HERE%\projects" mkdir "%HERE%\projects"
call :hx init "%DB%"
if errorlevel 1 ( popd & echo ERROR: init failed & exit /b 1 )
call :setupLibs
echo.
echo Note the superuser credentials above, then the server starts.
goto doRun

:doInit
if not exist "%HERE%\projects" mkdir "%HERE%\projects"
call :hx init "%DB%" %OPTS%
set "RC=%errorlevel%"
if "%RC%"=="0" call :setupLibs
popd
exit /b %RC%

:doSetup
if not exist "%DB%\db\folio.index" (
  popd
  echo ERROR: project '%DB%' does not exist - run: launch.bat init %PROJ%
  exit /b 1
)
set "PL_SKIP_SETUP="
call :setupLibs
popd
exit /b 0

rem Enable the pl.* libs by running setup.axon against the new project (a brief
rem -noAuth server + one HTTP call). Never fails the launcher. Skip with
rem set PL_SKIP_SETUP=1
:setupLibs
if defined PL_SKIP_SETUP goto :eof
powershell -NoProfile -ExecutionPolicy Bypass -File "%HERE%\setup-libs.ps1" -Java "%JAVA%" -Here "%HERE%" -ProjectDir "%DB%"
goto :eof

:doRun
if not exist "%DB%\db\folio.index" (
  popd
  echo ERROR: project '%DB%' does not exist - run: launch.bat init %PROJ%
  exit /b 1
)
echo.
echo Starting %DB%  ^(Ctrl+C to stop; default http://localhost:8080/^)
echo.
call :hx run "%DB%" %OPTS%
set "RC=%errorlevel%"
popd
exit /b %RC%

:hx
"%JAVA%" %JAVA_OPTS% --enable-native-access=ALL-UNNAMED -cp "%HERE%\fantom\lib\java\sys.jar" "-Dfan.home=%HERE%\fantom" fanx.tools.Fan hx::Main %*
exit /b %errorlevel%

:usage
echo.
echo launch.bat - init and/or run a pl.ai Haxall project from this directory.
echo.
echo   launch.bat                         create project "pl" if missing, then run it
echo   launch.bat init [project] [opts]   create a project ^(prompts for su user/password/port^)
echo   launch.bat run  [project] [opts]   run an existing project
echo   launch.bat start [project] [opts]  init if missing, then run ^(the default^)
echo   launch.bat setup [project]         ^(re^)enable the pl.* libs in a project
echo   launch.bat help
echo.
echo init/start also enable the pl.* libs right after creating a project ^(skip with
echo set PL_SKIP_SETUP=1^).
echo.
echo init opts:  -headless -suUser NAME -suPass PASS -httpPort N -httpsDisable
echo run opts:   -noAuth ^(auto-login as su on loopback^)  -console
echo.
echo A bare project name lives in .\projects\NAME; a name containing \ / or : is used
echo as a path as-is. Set JAVA_HOME to pick a JVM, JAVA_OPTS for extra JVM flags
echo ^(e.g. set JAVA_OPTS=-Xmx4g^). Quote option values that contain = , ; or spaces.
echo.
exit /b 0
