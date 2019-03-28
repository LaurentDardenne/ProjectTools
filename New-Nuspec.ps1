$XsdFile='G:\PS\Nuget\nuspec.2011.8.xsd'
$Filename='G:\PS\Nuget\TestNuget.nuspec'  
Add-type -path G:\PS\Nuget\NugetSchemas.dll
ipmo G:\PS\XSD\XMLTool.psd1

#Demo_Nuget_Feed : cf. https://github.com/anpur/powershellget-module
Publish-Script -Path "$pwd\Replace-String.ps1" -Repository Demo_Nuget_Feed

install-Script -name 'Replace-String' -Repository Demo_Nuget_Feed -Scope allusers -verbose

'Replace-String','Lock-File','Remove-Conditionnal',
'Show-BalloonTip','Test-BOMFile','Using-Culture'|% {
 install-Script -name "$_" -Repository OttoMatt -Scope allusers 
}