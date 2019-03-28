function Get-AST {
#from http://becomelotr.wordpress.com/2011/12/19/powershell-vnext-ast/
<#
.Synopsis
   Function to generate AST (Abstract Syntax Tree) for PowerShell code.

.DESCRIPTION
   This function will generate Abstract Syntax Tree for PowerShell code, either from file or direct input.
   Abstract Syntax Tree is a new feature of PowerShell 3 that should make parsing PS code easier.
   Because of nature of resulting object(s) it may be hard to read (different object types are mixed in output).

.EXAMPLE
   $AST = Get-AST -FilePath MyScript.ps1
   $AST will contain syntax tree for MyScript script. Default are used for list of tokens ($Tokens) and errors ($Errors).

.EXAMPLE
   Get-AST -Input 'function Foo { param ($Foo) Write-Host $Foo }' -Tokens MyTokens -Errors MyErors | Format-Custom
   Display function's AST in Custom View. $MyTokens contain all tokens, $MyErrors would be empty (no errors should be recorded).

.INPUTS
   System.String

.OUTPUTS
   System.Management.Automation.Languagage.Ast

.NOTES
   Just concept of function to work with AST. Needs a polish and shouldn't polute Global scope in a way it does ATM.

#>

[CmdletBinding(
    DefaultParameterSetName = 'File'
)]
param (
    # Path to file to process.
    [Parameter(
        Mandatory,
        HelpMessage = 'Path to file to process',
        ParameterSetName = 'File'
    )]
    [Alias('Path','PSPath')]
    [ValidateScript({
        if (Test-Path -LiteralPath $_ -ErrorAction SilentlyContinue) {
            $true
        } else {
            throw "File does not exist!"
        }
    })]
    [string]$FilePath,
    
    # Input string to process.
    [Parameter(
        Mandatory,
        HelpMessage = 'String to process',
        ParameterSetName = 'Input'

    )]
    [Alias('Script','IS')]
    [string]$InputScript,

    # Name of the list of Errors.
    [Alias('EL')]
    [ValidateScript({$_ -ne 'ErrorsList'})] 
    [string]$ErrorsList = 'ErrorsAst',
    
    # Name of the list of Tokens.
    [Alias('TL')]
    [ValidateScript({$_ -ne 'TokensList'})]
    [string]$TokensList = 'Tokens',
    [switch] $Strict
)
     #Chaque appel de l'API crée une nouvelle instance
    New-Variable -Name $ErrorsList -Value $null -Scope Global -Force
    New-Variable -Name $TokensList -Value $null -Scope Global -Force

    switch ($psCmdlet.ParameterSetName) {
        File {
            $ParseFile = (Resolve-Path -LiteralPath $FilePath).ProviderPath
            [System.Management.Automation.Language.Parser]::ParseFile(
                $ParseFile, 
                [ref](Get-Variable -Name $TokensList),
                [ref](Get-Variable -Name $ErrorsList)
            )
        }
        Input {
           [System.Management.Automation.Language.Parser]::ParseInput(
                $InputScript, 
                [ref](Get-Variable -Name $TokensList),
                [ref](Get-Variable -Name $ErrorsList)
            )
        }
    }
   if ( (Get-Variable $ErrorsList).Value.Count -gt 0  )
   {
      $Er= New-Object System.Management.Automation.ErrorRecord(
              (New-Object System.ArgumentException("La syntaxe du code est erronée. $ParseFile")), 
              "InvalidSyntax", 
              "InvalidData",
              "[AST]"
             )  

      if ($Strict) 
      { $PSCmdlet.ThrowTerminatingError($Er)}
      else
      { $PSCmdlet.WriteError($Er)}
   }
} #Get-AST
