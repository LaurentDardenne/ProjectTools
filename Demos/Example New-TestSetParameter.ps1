#Démos de New-TestSetParameter

. ..\New-TestParameterSet.ps1

 #Get the metadata of a command ( unction/cmdlet)
$cmd=Get-Command Test-Path

#1- The command Test-path declare the follwinf parameters
#   $cmd.Parameters.keys
#   Path
#   LiteralPath
#   Filter
#   Include
#   Exclude
#   PathType
#   IsValid
#   Credential
#   OlderThan

 #2 -New-TestSetParameter search if the caller declare one or more variable having name of those parameters
 # No variable declared
$result=New-TestSetParameter -command $Cmd  -ParameterSetNames Path
 #No variable having a name of those parameters
 #no result 

$result.lines.count
#0
 
 #I want can include the 'Path' parameter in the result lines.
 #I create a 'Path' variable to include it into the cartesian product  
 #Each value inside the array create a 'Line'
 
 #For   "'c:\temp\unknow.zip'", the function create the following line :
 #  Test-Path -Path 'c:\temp\unknow.zip' 
$Path=@(
  "'c:\temp\unknow.zip'",
  "'Test.zip'",
  "(dir variable:OutputEncoding)",
  "'A:\test.zip'",
  "(Get-Item 'c:\temp')",
  "(Get-Service Winmgmt)",
  'Wsman:\*.*',
  'hklm:\SYSTEM\CurrentControlSet\services\Winmgmt'
)

 #The parameter 'PathType' is a enum
$PathType=@("'Container'", "'Leaf'")

 #Generate the combinations of the parameter set of named 'Path'
$result=New-TestSetParameter -command $Cmd  -ParameterSetNames Path
 #The parameters that are not associated with a variable, generate a warning.
 #   WARNING: The variable Filter is not defined, processing the next parameter.
 #   WARNING: The variable Include is not defined, processing the next parameter.
 #   WARNING: The variable Exclude is not defined, processing the next parameter.
 #   WARNING: The variable IsValid is not defined, processing the next parameter.

 #Number of built lines
$result.lines.count
#16

$result
# CommandName SetName Lines
# ----------- ------- -----
# Test-Path   Path    {Test-Path -Path 'c:\temp\unknow.zip' -PathType 'Container', Test-Path -Path 'Test.zip' -PathTyp...


#Invoke the lines, *** Test-path have no impact ***  on the FileSystem
$result.lines|% {Write-host $_ -fore green;$_}|Invoke-Expression

#On ajoute le paramètre 'iSValide' de type booléen
$isValid= @($true,$false)

#Génére les combinaisons du jeu de paramètre nommée 'Path'
$result=New-TestSetParameter -command $Cmd  -ParameterSetNames Path -WarningAction 'SilentlyContinue'
$result.lines.count
#32

#génère :
# Test-Path -Path 'c:\temp\unknow.zip' -PathType 'Container' -IsValid
# Test-Path -Path 'A:\test.zip' -PathType 'Container' -IsValid
# Test-Path -Path 'A:\test.zip' -PathType 'Leaf' -IsValid
# Test-Path -Path 'A:\test.zip' -PathType 'Container'
# Test-Path -Path 'A:\test.zip' -PathType 'Leaf'
# ...

#$Result.lines|Sort-Object|% {Write-host $_ -fore green;$_}|Invoke-Expression

#On peut aussi générer du code de test pour Pester ou un autre module de test :
$Template=@'
#
    It "Test ..TO DO.." {
        try{
          `$result = $_ -ea Stop
        }catch{
            Write-host "Error : `$(`$_.Exception.Message)" -ForegroundColor Yellow
             `$result=`$false
        }
        `$result | should be (`$true)
    }
'@
$Result.Lines| % { $ExecutionContext.InvokeCommand.ExpandString($Template) }
#génère :
#     It "Test ..TO DO.." {
#         try{
#           $result = Test-Path -Path 'c:\temp\unknow.zip' -PathType 'Container' -IsValid -ea Stop
#         }catch{
#             Write-host "Error : $($_.Exception.Message)" -ForegroundColor Yellow
#             $result=$false
#         }
#         $result | should be ($true)
#     }
