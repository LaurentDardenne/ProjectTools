#todo Flags :  http://www.indented.co.uk/2013/09/23/new-enum/

Function New-Enum(
 [System.Collections.IDictionary] $Enums,
 [switch] $PassThru #Permet d'insérer le code généré : $(New-Enum $Enums -pass)
 ) {
#Adapté de http://thepowershellguy.com/blogs/posh/archive/2008/06/02/powershell-v2-ctp2-making-custom-enums-using-add-type.aspx
  #Compiling of one or more enums in an assembly.
  #The underlying type of the enum is always Int.
  #
  #example :
  # $Enums=@{} 
  # $Enums.NiveauSeuil=@("Normal","Critique","Danger")
  # $Enums.Visibilité=@("Visible","Masqué")
  # New-Enum $Enums
  # [Visibilité]::Visible
  # [NiveauSeuil]::Critique -As [int]
  #

 if ($Enums -eq $Null -or $Enums.Count -eq 0) 
 { Write-Error "L'énumération ne contient aucune entrée." }
 else 
 { 
  $Code= New-Object System.Text.StringBuilder
  $Enums.GetEnumerator()|
   Where {$_.Value.Count -ne 0}| 
   Foreach {
     if ( $DebugPreference -ne "SilentlyContinue")  
      { Write-debug "[New-Enum] $($_.Key)" }
  [void]$Code.Append( @"
    `r`n
    public enum  $($_.Key) : int 
    {
      $($_.value -join ",`r`n`t")   
    }
"@)
   } #foreach
 
   if ($Passthru)
   {$Code.ToString()}
   else
   {
     #Un seul ajout d'assembly par session, peu importe le nombre d'apppel de cette méthode avec une même énumération 
     Add-Type $Code.ToString() 
   }
 }#else
}#New-Enum