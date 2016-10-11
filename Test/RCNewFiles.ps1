$PathSource='TestDrive:\RC'
md $PathSource

@'
# Test principe de base
#<DEFINE %A%>
Write-Debug "A"
#<DEFINE %B%>
Write-Debug "B"
#<DEFINE %C%>
Write-Debug "C"
#<UNDEF %C%>
Write-Debug "suite B"
#<UNDEF %B%>
Write-Debug "suite A"
#<UNDEF %A%>  
Write-Debug "Suite hors define" 
'@ | Set-Content -Path "$PathSource\Test0.ps1" -Force -Encoding UTF8

@'
# Test principe de base
Write-Debug "A"
Write-Debug "B"
Write-Debug "C"
Write-Debug "suite B"
Write-Debug "suite A"
Write-Debug "Suite hors define"
'@ | Set-Content -Path "$PathSource\Test0.new.ps1" -Force -Encoding UTF8

@'
# Test principe de base
Write-Debug "A"
Write-Debug "B"
Write-Debug "suite B"
Write-Debug "suite A"
Write-Debug "Suite hors define"
'@ | Set-Content -Path "$PathSource\Test0.newC.ps1" -Force -Encoding UTF8      

@'
# Test principe de base
Write-Debug "A"
Write-Debug "suite A"
Write-Debug "Suite hors define"
'@ | Set-Content -Path "$PathSource\Test0.newB.ps1" -Force -Encoding UTF8      


@'
# Test principe de base
Write-Debug "Suite hors define"
'@ | Set-Content -Path "$PathSource\Test0.newA.ps1" -Force -Encoding UTF8      

#--------------------


@'
# Test imbrication DEFINE erronée
#<DEFINE %A%>
Write-Debug "A"
#<DEFINE %C%>
Write-Debug "B"
#<DEFINE %B%>
Write-Debug "C"
#<UNDEF %C%>
Write-Debug "suite B"
#<UNDEF %B%>
Write-Debug "suite A"
#<UNDEF %A%>  
Write-Debug "Suite hors define" 
'@ > "$PathSource\Test01.ps1"


@'
# Test imbrication UNDEF erronée
#<DEFINE %A%>
Write-Debug "A"
#<DEFINE %B%>
Write-Debug "B"
#<DEFINE %C%>
Write-Debug "C"
#<UNDEF %B%>
Write-Debug "suite B"
#<UNDEF %C%>
Write-Debug "suite A"
#<UNDEF %A%>  
Write-Debug "Suite hors define" 
'@ > "$PathSource\Test02.ps1"

@'
# Test directive DEFINE seule
#<DEFINE %A%>
Write-Debug "A"
#<DEFINE %B%>
Write-Debug "B"
Write-Debug "suite B"
Write-Debug "suite A"
#<UNDEF %A%>  
Write-Debug "Suite hors define" 
'@ > "$PathSource\Test03.ps1"

@'
# Test directive DEFINE seule, pas imbriqué
#<DEFINE %A%>
Write-Debug "A"
Write-Debug "suite A"
#<UNDEF %A%>
#<DEFINE %B%>
Write-Debug "B"
Write-Debug "suite B"
  
Write-Debug "Suite hors define" 
'@ > "$PathSource\Test031.ps1"

@'
# Test directive UNDEF seule
#<DEFINE %A%>
Write-Debug "A"
Write-Debug "B"
Write-Debug "suite B"
#<UNDEF %B%>
Write-Debug "suite A"
#<UNDEF %A%>  
Write-Debug "Suite hors define" 
'@ > "$PathSource\Test04.ps1"

@'
# Test directive UNDEF seule, pas imbriqué
#<DEFINE %A%>
Write-Debug "A"
Write-Debug "suite A"
#<UNDEF %A%>
Write-Debug "B"
Write-Debug "suite B"
#<UNDEF %B%>
Write-Debug "Suite hors define" 
'@ > "$PathSource\Test041.ps1"

@'
# Test directive UNDEF manquante
#<DEFINE %A%>
Write-Debug "A"
#<DEFINE %B%>
Write-Debug "B"
#<DEFINE %C%>
Write-Debug "C"
#<UNDEF %C%>
Write-Debug "suite B"
#<UNDEF %B%>
Write-Debug "suite A"
Write-Debug "Suite hors define" 
'@ > "$PathSource\Test05.ps1"

@'
# Test directive UNDEF manquante
#<DEFINE %A%>
Write-Debug "A"
#<DEFINE %B%>
Write-Debug "B"
#<DEFINE %C%>
Write-Debug "C"
Write-Debug "suite B"
Write-Debug "suite A"
Write-Debug "Suite hors define" 
'@ > "$PathSource\Test06.ps1"

@'
# Test directive UNDEF manquante
Write-Debug "A"
#<UNDEF %A%>
Write-Debug "B"
#<UNDEF %B%>
Write-Debug "C"
#<UNDEF %C%>
Write-Debug "suite B"
Write-Debug "suite A"
Write-Debug "Suite hors define" 
'@ > "$PathSource\Test07.ps1"

@'
# Test directive UNDEF manquante
#<DEFINE %X%>
Write-Debug "A"
#<DEFINE %Y%>
Write-Debug "B"
#<DEFINE %Z%>
Write-Debug "A"
#<UNDEF %A%>
Write-Debug "B"
#<UNDEF %B%>
Write-Debug "C"
#<UNDEF %C%>
Write-Debug "suite B"
Write-Debug "suite A"
Write-Debug "Suite hors define" 
'@ > "$PathSource\Test08.ps1"

@'
# Inversion des directives DEFINE et UNDEF
Write-Debug "A"
#<UNDEF %A%>
Write-Debug "B"
#<UNDEF %B%>
Write-Debug "C"
#<UNDEF %C%>
Write-Debug "suite B"
Write-Debug "suite A"
#<DEFINE %A%>
Write-Debug "A"
#<DEFINE %B%>
Write-Debug "B"
#<DEFINE %C%>
Write-Debug "C"
Write-Debug "Suite hors define"
'@ > "$PathSource\Test09.ps1"
