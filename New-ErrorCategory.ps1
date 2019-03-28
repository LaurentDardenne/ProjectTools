#Requires -Version 3

Function New-ErrorCategory {
 param (
  [switch] $AsGroup
 )          

  Function New-ErrorCategories { 
  $ErrorCategories=[ordered]@{}
  $ErrorCategory.GetEnumerator()|
   Foreach {
      $Current=$_
       #ResourceUnavailable -> ' Resource Unavailable' -> Resource 
      $Name=(($_.Name -creplace "[A-Z]"," $&") -split ' ')[1]
      if ($ErrorCategories.Contains($Name) -eq $false)
      { $ErrorCategories.$Name =New-Object System.Collections.Arraylist 32 }
      $ErrorCategories.$Name +=$Current 
   }
  $ErrorCategories
  }#New-ErrorCategories
 
  #Extrait le 06/08/2014 de :
  #  http://msdn.microsoft.com/en-us/library/system.management.automation.errorcategory%28v=vs.85%29.aspx
  $ErrorCategory=[ordered]@{
    AuthenticationError = "An error that occurs when the user cannot be authenticated by the service. This could mean that the credentials are invalid or that the authentication system is not functioning properly."
    CloseError = "An error that occurs during closing."
    ConnectionError = "An error that occurs when a network connection that the operation depends on cannot be established or maintained."
    DeadlockDetected = "An error that occurs when a deadlock is detected."
    DeviceError = "An error that occurs when a device reports an error."
    FromStdErr = "An error that occurs when a non-Windows PowerShell command reports an error to its STDERR pipe."
    InvalidArgument = "An error that occurs when an argument that is not valid is specified."
    InvalidData = "An error that occurs when data that is not valid is specified."
    InvalidOperation = "An error that occurs when an operation that is not valid is requested."
    InvalidResult = "An error that occurs when a result that is not valid is returned."
    InvalidType = "An error that occurs when a .NET Framework type that is not valid is specified."
    LimitsExceeded = "An error that occurs when internal limits prevent the operation from being executed."
    MetadataError = "An error that occurs when metadata contains an error."
    NotEnabled = "An error that occurs when the operation attempts to use functionality that is currently disabled."
    NotImplemented = "An error that occurs when a referenced application programming interface (API) is not implemented."
    NotInstalled = "An error that occurs when an item is not installed."
    NotSpecified = "An unspecified error. Use only when not enough is known about the error to assign it to another error category. Avoid using this category if you have any information about the error, even if that information is incomplete."
    ObjectNotFound = "An error that occurs when an object cannot be found."
    OpenError = "An error that occurs during opening."
    OperationStopped = "An error that occurs when an operation has stopped. For example, the user interrupts the operation."
    OperationTimeout = "An error that occurs when an operation has exceeded its timeout limit."
    ParserError = "An error that occurs when a parser encounters an error."
    PermissionDenied = "An error that occurs when an operation is not permitted."
    ProtocolError = "An error that occurs when the contract of a protocol is not being followed. This error should not happen with well-behaved components."
    QuotaExceeded = "An error that occurs when controls on the use of traffic or resources prevent the operation from being executed."
    ReadError = "An error that occurs during reading."
    ResourceBusy = "An error that occurs when a resource is busy."
    ResourceExists = "An error that occurs when a resource already exists."
    ResourceUnavailable = "An error that occurs when a resource is unavailable."
    SecurityError = "An error that occurs when a security violation occurs. This field is introduced in Windows PowerShell 2.0."
    SyntaxError = "An error that occurs when a command is syntactically incorrect."
    WriteError = "An error that occurs during writing."   
  }
  if (([system.Enum]::GetValues([System.Management.Automation.ErrorCategory])).count -ne $ErrorCategory.Keys.Count)
  {throw "Contrôler le nombre d'entrées de l'énumération System.Management.Automation.ErrorCategory" }
  
  if ($AsGroup) 
  {Write-Output (New-ErrorCategories) }
  else
  {Write-Output $ErrorCategory }

}#Function New-ErrorCategory
