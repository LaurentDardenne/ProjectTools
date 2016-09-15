<#PSScriptInfo
.VERSION 1.0
.GUID 355ed1fd-1ba1-4ec6-9845-6be09c1af9fe 
.AUTHOR Keith Hill
.COMPANYNAME
.COPYRIGHT CopyLeft
.TAGS Culture
.LICENSEURI 
.PROJECTURI 
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES version 1.0
.DESCRIPTION Exécute un scriptbloc en modifiant localement la culture du thread  
#>
#http://keithhill.spaces.live.com/Blog/cns!5A8D2641E0963A97!7132.entry
function Using-Culture ([System.Globalization.CultureInfo]$culture =(throw "USAGE: Using-Culture -Culture culture -Script {scriptblock}"),
                        [ScriptBlock]$script=(throw "USAGE: Using-Culture -Culture culture -Script {scriptblock}"))
{    
    $OldCulture = [System.Threading.Thread]::CurrentThread.CurrentCulture
    $OldUICulture = [System.Threading.Thread]::CurrentThread.CurrentUICulture
    try {
        [System.Threading.Thread]::CurrentThread.CurrentCulture = $culture
        [System.Threading.Thread]::CurrentThread.CurrentUICulture = $culture        
        Invoke-Command $script    
    }    
    finally {        
        [System.Threading.Thread]::CurrentThread.CurrentCulture = $OldCulture        
        [System.Threading.Thread]::CurrentThread.CurrentUICulture = $OldUICulture    
    }    
}

