$DTWVersion=(Import-ManifestData "$ProjectToolsVcs\Modules\DTW.PS.FileSystem\DTW.PS.FileSystem.psd1").ModuleVersion
$Source='https://www.myget.org/F/ottomatt/api/v2/package'

nuspec 'DTW.PS.FileSystem' $DTWVersion -DevelopmentDependency {
    properties @{
            Authors='Dan Ward'
            Description="Module de vérification de l'encodage de fichiers."
            title='DTW.PS.FileSystem'
            summary="Module de vérification de l'encodage de fichiers."
            owners='Dan Ward'
            copyright='Dan Ward - (c) DTW consulting'
            licenseUrl='http://www.dtwconsulting.com/PS/Module_FileSystem.htm'
            projectUrl='http://www.dtwconsulting.com/PS/Module_FileSystem.htm'
            releaseNotes='none'
            tags='File Encoding Analyze'
    }
    files {
        file -src "$ProjectToolsVcs\Modules\DTW.PS.FileSystem\DTW.PS.FileSystem.Encoding.psm1"
        file -src "$ProjectToolsVcs\Modules\DTW.PS.FileSystem\DTW.PS.FileSystem.psd1"
        file -src "$ProjectToolsVcs\Modules\DTW.PS.FileSystem\Readme.MD"
    }        
}|Foreach  { 
   $PkgName=$_.metadata.id
   $PkgVersion=$_.metadata.version
   $PathNuspec="$ProjectToolsDelivery\$PkgName.nuspec"
   
   Write-verbose "Save-Nuspec '$PathNuspec'"
   Save-Nuspec -Object $_ -FileName $PathNuspec
   
   cd $env:Temp
   nuget pack $PathNuspec
   Write-verbose "push '$env:Temp\$PkgName.$PkgVersion.nupkg'"
    #-requires : Apikey est sauvegardé sur le poste local
   nuget push "$env:Temp\$PkgName.$PkgVersion.nupkg" -Source $source
}

'Replace-String','Lock-File','Remove-Conditionnal',
'Show-BalloonTip','Test-BOMFile','Using-Culture'|% {
  Publish-Script -Path "$ProjectToolsVcs\$_.ps1" -Repository OttoMatt -NuGetApiKey $(throw "Todo apikey")
}
