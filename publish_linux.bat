
@echo off
cd /d "%~dp0"

python download_net_runtime.py linux

REM Clear out previous build.
if exist bin\publish\Linux rmdir /s /q bin\publish\Linux
if exist SS14.Launcher_Linux.zip del /f /q SS14.Launcher_Linux.zip
for /d /r %%d in (bin) do @if exist "%%d" rmdir /s /q "%%d" 2>nul

dotnet publish SS14.Launcher/SS14.Launcher.csproj /p:FullRelease=True -c Release --no-self-contained -r linux-x64 /nologo /p:RobustILLink=true
dotnet publish SS14.Loader/SS14.Loader.csproj -c Release --no-self-contained -r linux-x64 /nologo

REM Create intermediate directories.
mkdir bin\publish\Linux\bin
mkdir bin\publish\Linux\bin\loader
mkdir bin\publish\Linux\Marsey\Mods
mkdir bin\publish\Linux\Marsey\ResourcePacks
mkdir bin\publish\Linux\dotnet

copy PublishFiles\SS14.Launcher bin\publish\Linux\
copy PublishFiles\SS14.desktop bin\publish\Linux\
xcopy /s /y SS14.Launcher\bin\Release\net10.0\linux-x64\publish\* bin\publish\Linux\bin\
xcopy /s /y SS14.Loader\bin\Release\net10.0\linux-x64\publish\* bin\publish\Linux\bin\loader\
xcopy /s /e /y Dependencies\dotnet\linux\* bin\publish\Linux\dotnet\

cd bin\publish\Linux
powershell -Command "Compress-Archive -Path * -DestinationPath ..\..\..\SS14.Launcher_Linux.zip -Force"
cd ..\..\..
