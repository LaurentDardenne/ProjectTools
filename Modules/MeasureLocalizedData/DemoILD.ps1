
#SUPPOSE ici une seule déclaration de Import-LocalizedData dans le code source
#TODO

 #Un fichier, exemple un module 
 #( le code est assemblé )
$Module='..\Test\Plaster\Plaster.psm1' 
$ILD=Search-ASTImportLocalizedData -Path $Module|
      Update-ASTLocalizedData -passthru 



 #Plusieurs fichiers, exemple un module avec plusieurs scripts en dotsource
 #( le code est désassemblé ) 
$Module='..\Test\Plaster\Plaster.psm1'
$Functions=@(
  '..\Test\Plaster\InvokePlaster.ps1',
  '..\Test\Plaster\TestPlasterManifest.ps1'
)

Test-ImportLocalizedData -Primary $Module -Secondary $Functions 