Param (
 # Specific to the development computer
 [string] $VcsPathRepository=''
) 

if (Test-Path env:APPVEYOR_BUILD_FOLDER)
{
  $VcsPathRepository=$env:APPVEYOR_BUILD_FOLDER
}

if (!(Test-Path $VcsPathRepository))
{
  Throw 'Configuration error, the variable $VcsPathRepository should be configured.'
}

#Variable commune à tous les postes
#todo ${env:Name with space}
if ( $null -eq [System.Environment]::GetEnvironmentVariable("ProfileProjectTools","User"))
{ 
 [Environment]::SetEnvironmentVariable("ProfileProjectTools",$VcsPathRepository, "User")
  #refresh the environment Provider
 $env:ProfileProjectTools=$VcsPathRepository 
}

 # Variable spécifiques au poste de développement
$ProjectToolsDelivery= "${env:temp}\Delivery\ProjectTools"   
$ProjectToolsLogs= "${env:temp}\Logs\ProjectTools" 

 # Variable communes à tous les postes, leurs contenu est spécifique au poste de développement
$ProjectToolsBin= "$VcsPathRepository\Bin"
$ProjectToolsHelp= "$VcsPathRepository\Documentation\Helps"
$ProjectToolsSetup= "$VcsPathRepository\Setup"
$ProjectToolsVcs= "$VcsPathRepository"
$ProjectToolsTests= "$VcsPathRepository\Tests"
$ProjectToolsTools= "$VcsPathRepository\Tools"
$ProjectToolsUrl= 'https://github.com/LaurentDardenne/ProjectTools.git'

 #PSDrive sur le répertoire du projet 
$null=New-PsDrive -Scope Global -Name ProjectTools -PSProvider FileSystem -Root $ProjectToolsVcs 

Write-Host "Settings of the variables of ProjectTools project." -Fore Green

rv VcsPathRepository

