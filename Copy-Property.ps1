# Copy-Property
# Copie les propriétés d'un objet dans un autre
#
# Origine : http://dverweij.spaces.live.com/ 

function Copy-Property ($From, $To, $PropertyName ="*")
{
   foreach ($p in Get-Member -In $From -MemberType Property -Name $propertyName)
   {  trap {
         Add-Member -In $To -MemberType NoteProperty -Name $p.Name -Value $From.$($p.Name) -Force
         continue
      }
      $To.$($P.Name) = $From.$($P.Name)
   }
}

