$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

. "$here\RCNewFiles.ps1"
$PathSource='TestDrive:\RC'

$TestCases=@(
 @{File"$PathSource\Test0.ps1";New="$PathSource\Test0.newC.ps1";Key='C'}
 @{File"$PathSource\Test0.ps1";New="$PathSource\Test0.newB.ps1";Key='B'}
 @{File"$PathSource\Test0.ps1";New="$PathSource\Test0.newA.ps1";Key='A'}
)

$ErrorCases=@(
 @{File"$PathSource\Test05.ps1";Key='C'}
 @{File"$PathSource\Test06.ps1";Key='C'}
 @{File"$PathSource\Test07.ps1";Key='C'}
 @{File"$PathSource\Test09.ps1";Key='C'}
)

function Compare{
 param([string[]]$Generate,[string[]]$Expected)         
 
 $set1 = New-Object System.Collections.Generic.HashSet[String](,$Generate)
 return ( $set1.SetEquals($Expected) ) 
}

Describe "Remove-Conditionnal" {
 
 Context "When there is no error" {
  
  It "basic principle -Clean"{
    [string[]]$A=Get-Content -Path "$PathSource\Test0.ps1"  -ReadCount 0 -Encoding UTF8 | Remove-Conditionnal -Clean 
    [string[]]$B=Get-Content -Path "$PathSource\Test0.new.ps1" -ReadCount 0 -Encoding UTF8        
  
    Compare $A $b | Should Be $true
  } 

  It "basic principle -ConditionnalsKeyWord" -TestCase $TestCases {
    Param(
      [string]$File,
      [string]$New,
      [string]$Key
     )  

    [string[]]$A=Get-Content -Path $File -ReadCount 0 -Encoding UTF8 |
                  Remove-Conditionnal -ConditionnalsKeyWord $Key |
                  Remove-Conditionnal -Clean 
     
    [string[]]$B=Get-Content -Path $New -ReadCount 0 -Encoding UTF8        
  
    Compare $A $b | Should Be $true
  } 
 }

 Context "When there error" {
  
  It "basic principle -ConditionnalsKeyWord. Nesting 'DEFINE' erroneous "{
   #peut importe la clé, la fonction valide l'ensemble des déclarations 
    $Error.Clear()
    {Get-Content -Path "$PathSource\Test01.ps1"  -ReadCount 0 -Encoding UTF8 |
      Remove-Conditionnal -ConditionnalsKeyWord 'A' } | Should Throw
    $Error.Count | Should be 1        
  }
  
  It "basic principle -ConditionnalsKeyWord. Nesting 'UNDEF' erroneous "{
   #peut importe la clé, la fonction valide l'ensemble des déclarations 
    $Error.Clear()
    {Get-Content -Path "$PathSource\Test02.ps1"  -ReadCount 0 -Encoding UTF8 |
      Remove-Conditionnal -ConditionnalsKeyWord 'A' } | Should Throw
    $Error.Count | Should be 1        
  }

  It "basic principle -ConditionnalsKeyWord. Nesting 'DEFINE' orphan"{
   #peut importe la clé, la fonction valide l'ensemble des déclarations 
    $Error.Clear()
    {Get-Content -Path "$PathSource\Test03.ps1"  -ReadCount 0 -Encoding UTF8 |
      Remove-Conditionnal -ConditionnalsKeyWord 'A' } | Should Throw
    $Error.Count | Should be 1        
  }  

  It "basic principle -ConditionnalsKeyWord. 'DEFINE' is not nested, but orphan"{
   #peut importe la clé, la fonction valide l'ensemble des déclarations 
    $Error.Clear()
    {Get-Content -Path "$PathSource\Test031.ps1"  -ReadCount 0 -Encoding UTF8 |
      Remove-Conditionnal -ConditionnalsKeyWord 'A' } | Should Throw
    $Error.Count | Should be 1        
  }  

  It "basic principle -ConditionnalsKeyWord. Nesting 'UNDEF' orphan"{
   #peut importe la clé, la fonction valide l'ensemble des déclarations 
    $Error.Clear()
    {Get-Content -Path "$PathSource\Test04.ps1"  -ReadCount 0 -Encoding UTF8 |
      Remove-Conditionnal -ConditionnalsKeyWord 'A' } | Should Throw
    $Error.Count | Should be 1        
  }  

  It "basic principle -ConditionnalsKeyWord. 'UNDEF' is not nested, but orphan"{
   #peut importe la clé, la fonction valide l'ensemble des déclarations 
    $Error.Clear()
    {Get-Content -Path "$PathSource\Test041.ps1"  -ReadCount 0 -Encoding UTF8 |
      Remove-Conditionnal -ConditionnalsKeyWord 'A' } | Should Throw
    $Error.Count | Should be 1        
  } 

  It "basic principle -ConditionnalsKeyWord. 'UNDEF' missing" -Testcase $ErrorCases{
    Param(
      [string]$File,
      [string]$Key
     )      
   #peut importe la clé, la fonction valide l'ensemble des déclarations 
    $Error.Clear()
    {Get-Content -Path $File  -ReadCount 0 -Encoding UTF8 |
      Remove-Conditionnal -ConditionnalsKeyWord $Key } | Should Throw
    $Error.Count | Should be 1        
  } 

#     
#     It "does something useful" {
# $Code=@'
# #Test Imbrication de directive
# Filter Test {
# param (
#     [String]$ConditionnalsKeyWord
# )
# Write-Host "Code de la fonction"
# 
# #<DEFINE %DEBUG%>
# Write-Debug "$TempFile"
# Write-Debug "$FullPath" 
# #<UNDEF %DEBUG%>    
# 
# #<DEFINE %TEST%>     
# Set-Location C:\Temp
# #<DEFINE %DEBUG%>
#   Write-Debug "Fin"
# #<UNDEF %DEBUG%>     
# "Remove-Conditionnal.ps1"|Remove-Conditionnal  "TEST"
# #<UNDEF %TEST%>     
# } #test
# '@ > "$PathSource\Test4.ps1"     #bug avec Debug ET Test
#         $true | Should Be $false
#     }
# 
# 
# 
# 
#     It "does something useful" {
# $Code=@'
# #Test erreur : Une directive sans mot clé de fin
# Filter Test {
# param (
#     [String]$ConditionnalsKeyWord
# )
# Write-Host "Code de la fonction"
# 
# Write-Debug "$TempFile"
# Write-Debug "$FullPath" 
# #<UNDEF %DEBUG%>   
# } #test
# '@ > "$PathSource\TestErr0-1.ps1"   #bug pas détectée
# 
#         $true | Should Be $false
#     }
# 
# 
#     It "does something useful" {
# 
#         $true | Should Be $false
#     }
# $Code=@'
# #Test erreur : deux directives. La première directive Debug est associè à la seconde directive Debug.
# Filter Test {
# param (
#     [String]$ConditionnalsKeyWord
# )
# Write-Host "Code de la fonction"
# 
# #<DEFINE %DEBUG%>
# Write-Debug "$TempFile"
# Write-Debug "$FullPath" 
# #<UN DEF %DEBUG%>    
# 
# #Imbrication de directive
# #<DEFINE %TEST%>     
# Set-Location C:\Temp
# #<DE FINE %DEBUG%>
#   Write-Debug "bug"
# #<UNDEF %DEBUG%>     
# "Remove-Conditionnal.ps1"|Remove-Conditionnal  "TEST"
# #<UNDEF %TEST%>   
#  
# #<DEFINE %DEBUG%>
#   Write-Debug "Fin"
# #<UNDEF %DEBUG%>     
#    
# } #test
# '@ > "$PathSource\TestErr3.ps1"  #Todo cas de bug 
# # todo bug avec 'Debug' la directive %Test% n'est pas analysée car elle n'est pas dans la liste des directives
# #on doit analyser le pattern est gérer $isDirectiveBloc seulement si la directive trouvée est dans celle demandée
# #On teste le imbrication et le filtre séparément, ainsi on sait si la construction d'imbrication est correcte
# 
#         $true | Should Be $false
#     }
# 
# 
#     It "does something useful" {
# $Code=@'
# #Test erreur : deux directives. La première directive Debug est associè à la seconde directive Debug.
# Filter Test {
# param (
#     [String]$ConditionnalsKeyWord
# )
# Write-Host "Code de la fonction"
# 
# #<DEFINE %DEBUG%>
# Write-Debug "$TempFile"
# Write-Debug "$FullPath" 
# #<UNDEF %DEBUG%>    
# 
# #Imbrication de directive
# #<DEFINE %TEST%>     
# Set-Location C:\Temp
# #<DEFINE %DEBUG%>
#   Write-Debug "bug"
# #<UNDEF %DEBUG%>     
# "Remove-Conditionnal.ps1"|Remove-Conditionnal  "TEST"
# #<UNDEF %TEST%>   
#  
# #<DEFINE %DEBUG%>
#   Write-Debug "Fin"
# #<UNDEF %DEBUG%>     
#    
# } #test
# '@ > "$PathSource\TestErr4.ps1"  
#         $true | Should Be $false
#     }
# 
#     It "does something useful" {
# 
#         $true | Should Be $false
#     }
# 
#     It "does something useful" {
# 
#         $true | Should Be $false
#     }
}
