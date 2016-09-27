$version = $args[0]
nuget pack MagicCMS.4.5.csproj -Version $version -OutputDirectory ..\nuget -Exclude App_GlobalResources\**,FileBrowser\**,Themes\** -Symbols 