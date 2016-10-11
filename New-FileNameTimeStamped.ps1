<#PSScriptInfo

.VERSION 1.0
.GUID 841992ac-d4d2-4ac4-a837-31f2864faad5
.AUTHOR Laurent Dardenne
.COMPANYNAME
.COPYRIGHT CopyLeft
.TAGS Timestamp
.LICENSEURI https://creativecommons.org/licenses/by-nc-sa/4.0
.PROJECTURI https://github.com/LaurentDardenne/ProjectTools
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES  version 1.0 Le 25 octobre 2012  

.DESCRIPTION Create from a file name a new time stamped name 
#>

function New-FileNameTimeStamped{
 param(
  [parameter(Mandatory=$True)]
  [string] $FileName,
  [System.DateTime] $Date=(Get-Date),
  [string] $Format='dd-MM-yyyy-HH-mm-ss')

  $SF=New-object System.IO.FileInfo $FileName 
  "{0}\{1}-{2:$Format}{3}" -F $SF.Directory,$SF.BaseName,$Date,$SF.Extension
}#New-FileNameTimeStamped
