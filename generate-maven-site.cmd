@echo off

pushd "%~dp0"
title %~nx0 - %~dp0

if exist target\site rmdir /q /s target\site

:repeat
echo Generating Maven-Site with PlantUML images...
call mvn clean com.github.jeluard:plantuml-maven-plugin:generate site --define maven.test.skip=true --non-recursive

echo Copying Maven-Site...
robocopy /mir /njh /njs target\site maven-site.tmp

echo Opening last modified site in browser...
for /f " usebackq" %%i IN (`dir /b /o-d src\site\markdown\*.md`) do set file=%%~ni& goto open
:open
start "" maven-site.tmp\%file%.html

echo To repeat just press enter.
echo To exit script write something and then press enter.
set INPUT=
set /p INPUT=
if "%INPUT%"=="" (
  cls
  goto repeat
) else (
  popd
  exit /b 0
)
