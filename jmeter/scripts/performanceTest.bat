@echo off
setlocal enableDelayedExpansion 

SET JMETER_HOME=C:\Tools\apache-jmeter-5.2.1
SET PATH=%JMETER_HOME%\bin;%PATH%
SET JMX_DIR=..\jmx_routing\

for /F %%x in ('dir /B/D %JMX_DIR%') do (
  set JMX_FILE=%JMX_DIR%\%%x
  echo ===========================  Search in !JMX_FILE! ===========================
	rem jmeter.bat -n -t ../jmx/mung.jmx
	jmeter.bat -n -t !JMX_FILE!
  REM c:\utils\grep motiv !JMX_FILE!
)