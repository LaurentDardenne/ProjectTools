﻿<#PSScriptInfo
.VERSION 1.0
.GUID 355ed1fd-1ba1-4ec6-9845-6be09c1af9fe 
.AUTHOR Laurent Dardenne
.COMPANYNAME
.COPYRIGHT CopyLeft
.TAGS File BOM
.LICENSEURI https://creativecommons.org/licenses/by-nc-sa/4.0
.PROJECTURI https://github.com/LaurentDardenne/ProjectTools
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES version 1.0
.DESCRIPTION Test la présence d'un BOM sur un fichier 
#>
param (
 [Parameter(mandatory=$true)]
 $Path
)
function ql{ $args }

$Params=@{
 Include=$(ql *.ps1,*.psm1,*.psd1,*.ps1xml,*.xml,*.txt);
 Exclude=$(ql *.bak,*.exe,*.dll,*.Cmds.Template.ps1,*.Datas.Template.ps1,*.csproj.FileListAbsolute.txt)
}
          
Get-ChildItem -Path $Path -Recurse @Params |
 Where { (-not $_.PSisContainer) -and ($_.Length -gt 0)}| 
 Foreach  {
   Write-Verbose "Test BOM for  $($_.FullName)"
  # create storage object
  $EncodingInfo = 1 | Select FileName,Encoding,BomFound,Endian
  # store file base name (remove extension so easier to read)
  $EncodingInfo.FileName = $_.FullName
  # get full encoding object
  $Encoding = Get-DTWFileEncoding $_.FullName
  # store encoding type name
  $EncodingInfo.Encoding = $EncodingTypeName = $Encoding.ToString().SubString($Encoding.ToString().LastIndexOf(".") + 1)
  # store whether or not BOM found
  $EncodingInfo.BomFound = "$($Encoding.GetPreamble())" -ne "" 
  $EncodingInfo.Endian = ""
  # if Unicode, get big or little endian
  if ($Encoding.GetType().FullName -eq ([System.Text.Encoding]::Unicode.GetType().FullName)) {
    if ($EncodingInfo.BomFound) {
      if ($Encoding.GetPreamble()[0] -eq 254) {
        $EncodingInfo.Endian = "Big"
      } else {
        $EncodingInfo.Endian = "Little"
      }
    } else {
      $FirstByte = Get-Content -Path $_.FullName -Encoding byte -ReadCount 1 -TotalCount 1
      if ($FirstByte -eq 0) {
        $EncodingInfo.Endian = "Big"
      } else {
        $EncodingInfo.Endian = "Little"
      }
    }
  }
  $EncodingInfo
}|
 #PS v2 Big Endian plante la signature de script
Where {($_.Encoding -ne "UTF8Encoding") -or ($_.Endian -eq "Big")}