#Extract from Plaster project
Microsoft.PowerShell.Utility\Import-LocalizedData LocalizedData -FileName Plaster.Resources.psd1 -ErrorAction SilentlyContinue
# Dot source the module command scripts
. $PSScriptRoot\TestPlasterManifest.ps1
. $PSScriptRoot\InvokePlaster.ps1

Export-ModuleMember -Function *-*
