$version = (Get-Command bin\MagicCMS.Dll).FileVersionInfo.FileVersion
nuget pack MagicCMS.4.5.symbols.nuspec -OutputDirectory ..\nuget -Symbols -Version $version
nuget pack MagicCMS.4.5.nuspec -OutputDirectory ..\nuget -Version $version