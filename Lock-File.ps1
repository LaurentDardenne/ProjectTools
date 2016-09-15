<#PSScriptInfo
.VERSION 1.0
.GUID 97ec2721-cbdc-4d26-abf9-69fabe6502ac
.AUTHOR Laurent Dardenne
.COMPANYNAME
.COPYRIGHT CopyLeft
.TAGS File Lock
.LICENSEURI https://creativecommons.org/licenses/by-nc-sa/4.0
.PROJECTURI https://github.com/LaurentDardenne/ProjectTools
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES version 1.0
.DESCRIPTION Verrouille un fichier à des fins de test
#>
Function Lock-File{
#Verrouille un fichier à des fins de test
  param([string] $Path)

  New-Object System.IO.FileStream($Path, 
                                  [System.IO.FileMode]::Open, 
                                  [System.IO.FileAccess]::ReadWrite, 
                                  [System.IO.FileShare]::None)
} #Lock-File

return

&{
 try {
    $Filename="C:\Temp\t1.txt"
    $TestLockFile= Lock-File $FileName
    Test-MyFunction
  } finally {
   $TestLockFile.Close()
  }
}