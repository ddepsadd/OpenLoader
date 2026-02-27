@echo off
cd /d "%~dp0"

python download_net_runtime.py windows

REM Clear out previous build.
if exist bin\publish\Windows rmdir /s /q bin\publish\Windows
if exist SS14.Launcher_Windows.zip del /f /q SS14.Launcher_Windows.zip
for /d /r %%d in (bin) do @if exist "%%d" rmdir /s /q "%%d" 2>nul

dotnet publish SS14.Launcher/SS14.Launcher.csproj /p:FullRelease=True -c Release --no-self-contained -r win-x64 /nologo /p:RobustILLink=true
dotnet publish SS14.Loader/SS14.Loader.csproj -c Release --no-self-contained -r win-x64 /nologo
dotnet publish SS14.Launcher.Strap/SS14.Launcher.Strap.csproj -c Release /nologo

python exe_set_subsystem.py "SS14.Launcher/bin/Release/net10.0/win-x64/publish/SS14.Launcher.exe" 2
python exe_set_subsystem.py "SS14.Loader/bin/Release/net10.0/win-x64/publish/SS14.Loader.exe" 2

REM Create intermediate directories.
mkdir bin\publish\Windows\bin
mkdir bin\publish\Windows\bin\loader
mkdir bin\publish\Windows\dotnet
mkdir bin\publish\Windows\Marsey\Mods
mkdir bin\publish\Windows\Marsey\ResourcePacks

xcopy /s /e /y Dependencies\dotnet\windows\* bin\publish\Windows\dotnet\
copy SS14.Launcher.Strap\bin\Release\net45\publish\Marseyloader.exe bin\publish\Windows\
copy SS14.Launcher.Strap\console.bat bin\publish\Windows\
xcopy /s /y SS14.Launcher\bin\Release\net10.0\win-x64\publish\* bin\publish\Windows\bin\
xcopy /s /y SS14.Loader\bin\Release\net10.0\win-x64\publish\* bin\publish\Windows\bin\loader\

cd bin\publish\Windows
powershell -Command "Compress-Archive -Path * -DestinationPath ..\..\..\SS14.Launcher_Windows.zip -Force"
cd ..\..\..
