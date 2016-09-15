﻿<#PSScriptInfo
.VERSION 1.0
.GUID 75e8ddac-99c1-4dbe-8810-7b2cf3abdeb5   
.AUTHOR www.powertheshell.com
.COMPANYNAME
.COPYRIGHT 
.TAGS BalloonTip verbose information
.LICENSEURI 
.PROJECTURI 
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES version 1.0
.DESCRIPTION Affiche une bulle d'information  
#>
function Show-BalloonTip  
{
 #From : http://www.powertheshell.com/balloontip/
#HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify dword: 29 
# To configure how long to show tooltips:
# 
#     [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify]
#     BalloonTip = 3 (Time in seconds) 
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$true)]
    $Text,
   
    [Parameter(Mandatory=$true)]
    $Title,
   
    [ValidateSet('None', 'Info', 'Warning', 'Error')]
    $Icon = 'Info',

    $Timeout = 10000
  )
 
  Add-Type -AssemblyName System.Windows.Forms

  if ($script:balloon -eq $null)
  {
    $script:balloon = New-Object System.Windows.Forms.NotifyIcon
  }

  $path                    = Get-Process -id $pid | Select-Object -ExpandProperty Path
  $script:balloon.Icon            = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
  $script:balloon.BalloonTipIcon  = $Icon
  $script:balloon.BalloonTipText  = $Text
  $script:balloon.BalloonTipTitle = $Title
  $script:balloon.Visible         = $true

  $script:balloon.ShowBalloonTip($Timeout)
} 

