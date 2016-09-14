$DTWVersion=(Import-ManifestData "$ProjectToolsVcs\Modules\DTW.PS.FileSystem\DTW.PS.FileSystem.psd1").ModuleVersion

nuspec 'ProjectTools' '1.0' -DevelopmentDependency {
   properties @{
        Authors='Dardenne Laurent'
        Description="Scripts utilisés lors de la construction d'un projet Powershell."
        title='ProjectTools'
        summary='Dépendances'
        copyright='Copyleft'
        language='fr-FR'
        licenseUrl='https://creativecommons.org/licenses/by-nc-sa/4.0/'
        projectUrl='https://github.com/LaurentDardenne/ProjectTools'
        iconUrl='https://github.com/LaurentDardenne/ProjectTools/blob/master/icon/ProjectTools.png'
        releaseNotes=''
        tags=$null
   }
   dependencies {
        #Force l'installation, n'est pas une dépendance mais un prérequis
       dependency 'Nuspec' '[0.2,)'

     #On construit l'ordre de création
     #En fin de traitement on inverse le tableau de résultat
     #afin de publier dans l'ordre
       nuspec 'ProjectToolsEncoding' $DTWVersion -DevelopmentDependency {
        properties @{
                Authors='Dan Ward'
                Description="Module de vérification de l'encodage de fichiers."
                title='ProjectTools'
                summary='Dépendances'
                owners='Dan Ward'
                copyright='Dan Ward - (c) DTW consulting'
                licenseUrl='http://www.dtwconsulting.com/PS/Module_FileSystem.htm'
                projectUrl='https://github.com/LaurentDardenne/ProjectTools'
                iconUrl='https://github.com/LaurentDardenne/ProjectTools/blob/master/icon/Encoding.png'
                releaseNotes=''
                tags='DTW.PS.FileSystem.Encoding.psm1'
        }
        files {
            file -src "$ProjectToolsVcs\Modules\DTW.PS.FileSystem\DTW.PS.FileSystem.Encoding.psm1"
            file -src "$ProjectToolsVcs\Modules\DTW.PS.FileSystem\DTW.PS.FileSystem.psd1"
            file -src "$ProjectToolsVcs\Modules\DTW.PS.FileSystem\Readme.MD"
        }        
       }#ProjectToolsEncoding

       nuspec 'ProjectToolsScripts' '1.0' -DevelopmentDependency {
        properties @{
                Authors='Dardenne Laurent'
                Description='Scripts nécessaires a une tâche de build PSake.'
                title='ProjectTools'
                summary='Dépendances'
                copyright='Copyleft'
                language='fr-FR'
                licenseUrl='https://creativecommons.org/licenses/by-nc-sa/4.0/'
                projectUrl='https://github.com/LaurentDardenne/ProjectTools'
                iconUrl='https://github.com/LaurentDardenne/ProjectTools/blob/master/icon/ProjectTools.png'
                releaseNotes=''
                tags='Lock-File.ps1 Remove-Conditionnal.ps1 Replace-String.ps1 Show-BalloonTip.ps1 Test-BOMFile.ps1 Using-Culture.ps1'
        }
        files {
            #nuget warning : PowerShell file outside tools folder.
            #!!! DO NOT move this files into the 'tools' folder !!!
            file -src "$ProjectToolsVcs\Lock-File.ps1"
            file -src "$ProjectToolsVcs\Remove-Conditionnal.ps1"
            file -src "$ProjectToolsVcs\Replace-String.ps1"
            file -src "$ProjectToolsVcs\Show-BalloonTip.ps1"
            file -src "$ProjectToolsVcs\Test-BOMFile.ps1"
            file -src "$ProjectToolsVcs\Using-Culture.ps1"
        }
      }#ProjectToolsScripts
   }#Dependencies
}|
Foreach -Begin {
     $Source='https://www.myget.org/F/ottomatt/api/v2/package'
  } -process { 
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
