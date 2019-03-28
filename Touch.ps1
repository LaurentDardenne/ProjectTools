# Touch.ps1
# Modifie la date d'accés d'une liste de fichiers 

function touch([string] $path = ".\", [string] $name) 
{    $file = $path + $name 
   $result = test-path $file 
   if($result -eq $true) 
   { 
      ##"Changing LastWriteTime" 
      gci $file | foreach{$_.lastwritetime = $(get-date)} 
   } 
   else 
   { 
      ##"Creating new file" 
      new-item $file -type file 
   } 
}
