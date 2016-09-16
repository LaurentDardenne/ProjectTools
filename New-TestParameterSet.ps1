<#PSScriptInfo

.VERSION 1.4
.GUID a7b1444a-dc85-4841-84da-925f0309641c
.AUTHOR Laurent Dardenne
.COMPANYNAME
.COPYRIGHT CopyLeft
.TAGS Parameter ParameterSet Cartesian Pester Test
.LICENSEURI https://creativecommons.org/licenses/by-nc-sa/4.0
.PROJECTURI https://github.com/LaurentDardenne/ProjectTools
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES  version 1.0  le 25 mars 2013 

.DESCRIPTION Generates the cartesian product of each parameter sets of a command  (tools for Pester)   
#>

function New-TestSetParameter{
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions","",
    Justification="New-TestSetParameter do not change the system state, only the application 'context'")]
    
#Generates the cartesian product of each parameter sets of a command  (tools for Pester)
#adapted from : #http://makeyourownmistakes.wordpress.com/2012/04/17/simple-n-ary-product-generic-cartesian-product-in-powershell-20/
 [CmdletBinding()]
 [OutputType([system.string])]
 param (
   [parameter(Mandatory=$True,ValueFromPipeline=$True)]
   [ValidateNotNull()]
  [System.Management.Automation.CommandInfo] $CommandName,
    
    [ValidateNotNullOrEmpty()]
    [Parameter(Position=0,Mandatory=$false)]
  [string[]] $ParameterSetNames='__AllParameterSets',
    
    [ValidateNotNullOrEmpty()]
  [string[]] $Exclude,
  
  [switch] $All
 )       

 begin {
  function getValue{
     if ($Value -eq $false)
     {
       Write-Debug "Switch is `$false, dont add the parameter name : $Result."
       return "$result"
     }
     else
     {
       Write-Debug "Switch is `$true, add only the parameter name : $result$Bindparam"
       return "$result$Bindparam"
     }
  }#getValue
  
  function AddToAll{
   param (
     [System.Management.Automation.CommandParameterInfo] $Parameter,
     $valuesToAdd
   )
    Write-Debug "Treate '$($Parameter.Name)' parameter."
    $Bindparam=" -$($Parameter.Name)" 
      #Récupère une information du type du paramètre et pas la valeur liée au paramètre
    $isSwitch=($Parameter.parameterType.FullName -eq 'System.Management.Automation.SwitchParameter')
    Write-Debug "isSwitch=$isSwitch"
    if ($null -ne $valuesToAdd)
    {
      foreach ($value in $valuesToAdd)
      {
        Write-Debug "Add Value : $value "
        if ($Lines.Count -gt 0)
        {
          foreach ($result in $Lines)
          {
            if ($isSwitch) 
            { Write-Output (getValue) } 
            else
            {
              Write-Debug "Add parameter and value : $result$Bindparam $value"
              Write-Output "$result$Bindparam $value"
            }
          }#foreach
        }
        else
        {
           if ($isSwitch) 
           { Write-Output "$($CommandName.Name)$(getValue)" } 
           else 
           {
             Write-Debug "Add parameter and value :: $Bindparam $value"
             Write-Output  "$($CommandName.Name)$Bindparam $value"
           }
        }
      }
    }
    else
    {
      Write-Debug "ValueToAdd is `$Null :$Lines"
      Write-Output  $Lines
    }
  }#AddToAll  
 }#begin

  process {
          
   foreach ($Set in $CommandName.ParameterSets)
   {
      if (-not $All -and ($ParameterSetNames -notcontains $Set.Name)) 
      { continue }
      elseif ( $All -and ($Exclude -contains $Set.Name)) 
      {
        Write-Debug "Exclude $($Set.Name) "
        continue
      }
      
      $Lines = @()
      Write-Debug "Current set name is $($Set.Name) "
      Write-Debug "Parameter count=$($Set.Parameters.Count) "
      foreach ($parameter in $Set.Parameters)
      {
        Write-Debug "Retrieve $($Parameter.Name) from caller"
         #Module : Api V4 et >
         #$Values= $MyInvocation.MyCommand.Module.GetVariableFromCallersModule($Parameter.Name) 
        $Variable=Get-Variable -Name $Parameter.Name -Scope 1 -ea SilentlyContinue
        if ( $null -ne $Variable) 
        { $Lines = AddToAll -Parameter $Parameter $Variable.Value }
        else
        { $PSCmdlet.WriteWarning("The variable $($Parameter.Name) is not defined, processing the next parameter.") } 
      }
     New-Object PSObject -Property @{
        PSTypeName='CartesianProductOfParameters'
        CommandName=$CommandName.Name
        SetName=$Set.Name
        Lines=$Lines.Clone()
     }
   }#foreach
  }#process
} #New-TestSetParameter
