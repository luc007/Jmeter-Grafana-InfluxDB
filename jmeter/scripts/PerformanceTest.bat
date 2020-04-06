@echo off
goto :init


:usage
    echo USAGE:
    echo   %__BAT_NAME% [-f][-d] "required argument"
    echo.
    echo.  -f <filename>   specifies jmx filename
	echo.  -d <directory>  specifies directory contains jmx files
    goto :eof

:missing_argument
    call :usage
    echo.
    echo ****                                   ****
    echo ****    MISSING "REQUIRED ARGUMENT"    ****
    echo ****                                   ****
    echo.
    goto :eof

:init

    set "__BAT_NAME=%~nx0"

    set "option="
    set "argument="

:parse
    if "%~1"=="" goto :validate

    if /i "%~1"=="/?"         call :usage "%~2" & goto :end
    if /i "%~1"=="-?"         call :usage "%~2" & goto :end
    if /i "%~1"=="--help"     call :usage "%~2" & goto :end

    if /i ("%~1"=="-f" or "%~1"=="-d")(
		set "option=%~1"
		set "argument=%~2"
	)

	if not defined argument  shift & goto :parse

:validate
    if not defined argument call :missing_argument & goto :end

:main
	set "JMETER_HOME=C:\Tools\apache-jmeter-5.2.1"
	set "PATH=%JMETER_HOME%\bin;%PATH%"
    set "JMETER_SCRIPTS=C:\dsra\dsra_performance\drsa_performance\jmeter\scripts"

    cd %JMETER_SCRIPTS%
    
    if "%option%"=="-f" (
		echo ===== Running "%argument%" ======
	    jmeter.bat -Jjmeter.save.saveservice.output_format=xml -n -t "%argument%" -f -l ../results/result.jtl	
	) 

	if "%option%"=="-d" (
		set JMX_DIR=%argument%
		for /f %%x in ('dir /b/d %JMX_DIR%') do (
		  set JMX_FILE=%JMX_DIR%\%%x
		  echo ======= Running "%JMX_FILE%" =========
			jmeter.bat -Jjmeter.save.saveservice.output_format=xml -n -t "%JMX_FILE%" -f -l ../results/result.jtl
		)
	)

:end
    call :cleanup
    exit /B

:cleanup
    REM The cleanup function is only really necessary if you
    REM are _not_ using SETLOCAL.
    set "__BAT_NAME="

    set "option="
    set "argument="

    goto :eof
