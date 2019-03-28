function New-MatchesObject{
 #A partir d'une chaîne de caractères,
 #construit un objet personnalisé à l'aide d'une regex
 #utilisant des captures nommées.
 
  #Exemple :
  #   #hashtable de paramètrages
  # $MyObject=@{
  #   #hashtable de création d'objets
  #  SMB=@{ 
  #      #Ces entrées portent les mêmes noms 
  #      #que les paramètres de la fonction New-MatchesObject. 
  #      #Ce qui autorise le splatting
  #      
  #      #Hashtable de création d'un objet
  #      #Exemple : analyse d'attribut AD extensionAttributeN 
  #     Res_CN=@{
  #        #Nom du type affiché par Get-member ou $Variable.PsObject.TypeNames
  #      TypeName='MY.SMB.Res_CN'
  #       #Expression régulière contenant des captures nommées
  #       #celles-ci seront utilisées pour construire des propriètés d'objets PS personnalisés 
  #      Regex='^extensionAttribute(?<Type>1)#CN=(?<CN>.*?),'
  #       #On supprime dans la variable automatique $Matches les clés indiquées
  #      Keys=0,1
  #     }
  #     
  #     Res_DN=@{
  #       TypeName='MY.SMB.Res_DN'
  #       Regex='^extensionAttribute(?<Type>1)#(?<DistinguishedName>.*$)'
  #       Keys=0,1
  #     }
  #  };
  #  #Others=@{...} 
  # }#$MyObject
  # 
  # $S="extensionAttribute1#CN=MyCN,..."
  # 
  #  #Le splatting ne fonctionne avec @Myobject.SMB.Res_CN 
  # $Parameters=$Myobject.SMB.Res_CN
  # $o=New-MatchesObject $S @Parameters
  # $o|gm
  # $O
  # 
  # $S2="extensionAttribute1#MyDN"
  # $Parameters=$Myobject.SMB.Res_DN
  # $o2=New-MatchesObject $S2 @Parameters
  # $o2|gm
  # $O2
 
 param (
       #Objet sur lequel on exécute la regex
      [Parameter(Mandatory=$true,position=0)]
      [ValidateNotNullOrEmpty()]
     $InputObject, 
     
       #Nom du type de l'objet PS
      [Parameter(Mandatory=$true,position=1)]
      [ValidateNotNullOrEmpty()]
    [String] $TypeName,
      
       #Expression régulière appliquée sur le paramètre InputObject
      [Parameter(Mandatory=$true,position=2)]
      [ValidateNotNullOrEmpty()]
    [String] $Regex,
      
       #En cas de succès de la regex,
       #on supprime les noms de clé indiquées dans la hashtable $Matches
       #celles-ci sont des groupes de capture
      [Parameter(Mandatory=$false,position=3)]
      [ValidateNotNullOrEmpty()]
       #la clé 0 contient l'intégralité de ligne analysée
    [Object[]] $Keys=0
 )
 Function Select-NamedCapture {
  #Extrait les noms de capture présent dans la regex
   Param( [string] $RegexStr )          
    $Pattern='\?\<(.*?)\>'
    $Regex = new-object regex $Pattern

    $CurrentMatch = $Regex.match($RegexStr)

    if (!$CurrentMatch.Success)
    { Write-debug "Echec :$RegexStr" }
    else 
    { $CurrentMatch.Groups[1].Value }

    while ($CurrentMatch.Success)
    {
      $CurrentMatch = $CurrentMatch.NextMatch()
      if ($CurrentMatch.Success)
      { $CurrentMatch.Groups[1].Value }
    }          
 }#Select-NamedCapture
 Write-debug "New-MatchesObject"
 
 $NamesOfCaptures=Select-NamedCapture -RegexStr $Regex
 if ($InputObject -match $Regex)
 {
   #Conflit possible entre un nom de capture numérique ('1') et le numéro d'un groupe : 1
   #dans ce cas on 'perd la capture :
   #  #$Str="^(?<11>toto) (titi)"
   #  $Str="^(?'1'toto) (titi)"
   #  'toto titi' -match $str
   Write-Debug "$($matches.GetEnumerator()|% {"{0}={1}" -f $_.key,$_.Value})"
    
   $Keys|
    Foreach {
      Write-Debug "Remove key : $_"
       #Pour les captures optionnelles, 
       #si la clé n'existe pas il n'y a pas d'erreur
      $matches.Remove($_)
    }
   #Si des captures sont optionnelles, exemple "^(?<Vide>(ab){0,1})",
   # on compléte les propriétés manquantes. todo redondant ?  $Matches contient la capture 'vide' 
   Compare-Object ([string[]]$Matches.Keys) $NamesOfCaptures|
    Select -ExpandProperty InputObject|
    Foreach-Object {
     Write-Debug "Add optionnal key : $_"                   
     $Matches.Add($_,$Null)
    }

   Write-debug "Construction d'un objet de type : $($TypeName)"
   $Object=New-Object PSCustomObject -Property $Matches
   $Object.PsObject.TypeNames.Insert(0,$TypeName)
   Write-Output $Object
  } #sinon on ne renvoi pas d'objet ayant toutes ses propriété à $null
}#New-MatchesObject