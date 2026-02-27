@echo off
cd /d "%~dp0"

python download_net_runtime.py mac

REM Clear out previous build.
if exist bin\publish\macOS rmdir /s /q bin\publish\macOS
if exist SS14.Launcher_macOS.zip del /f /q SS14.Launcher_macOS.zip
for /d /r %%d in (bin) do @if exist "%%d" rmdir /s /q "%%d" 2>nul

dotnet publish SS14.Launcher/SS14.Launcher.csproj /p:FullRelease=True -c Release --no-self-contained -r osx-x64 /nologo /p:RobustILLink=true
dotnet publish SS14.Loader/SS14.Loader.csproj -c Release --no-self-contained -r osx-x64 /nologo

REM Create intermediate directories.
mkdir bin\publish\macOS

xcopy /s /e /y "PublishFiles\Space Station 14 Launcher.app" "bin\publish\macOS\Space Station 14 Launcher.app\"

mkdir "bin\publish\macOS\Space Station 14 Launcher.app\Contents\Resources\dotnet"
mkdir "bin\publish\macOS\Space Station 14 Launcher.app\Contents\Resources\bin"
mkdir "bin\publish\macOS\Space Station 14 Launcher.app\Contents\MacOS\Marsey\Mods"
mkdir "bin\publish\macOS\Space Station 14 Launcher.app\Contents\MacOS\Marsey\ResourcePacks"
mkdir "bin\publish\macOS\Space Station 14 Launcher.app\Contents\Resources\bin\loader\Space Station 14.app\Contents\Resources\bin"

xcopy /s /e /y Dependencies\dotnet\mac\* "bin\publish\macOS\Space Station 14 Launcher.app\Contents\Resources\dotnet\"
xcopy /s /y SS14.Launcher\bin\Release\net10.0\osx-x64\publish\* "bin\publish\macOS\Space Station 14 Launcher.app\Contents\Resources\bin\"
xcopy /s /y SS14.Loader\bin\Release\net10.0\osx-x64\publish\* "bin\publish\macOS\Space Station 14 Launcher.app\Contents\Resources\bin\loader\Space Station 14.app\Contents\Resources\bin\"

cd bin\publish\macOS
powershell -Command "Compress-Archive -Path * -DestinationPath ..\..\..\SS14.Launcher_macOS.zip -Force"
cd ..\..\..
