
#region Make sure encoding module is loaded
$EncodingModuleName = "DTW.PS.FileSystem"
$EncodingModule = Get-Module | Where-Object { $_.Name -eq $EncodingModuleName }
if ($null -eq $EncodingModule) {
  Write-Error "Module $EncodingModuleName containing command Get-DTWFileEncoding is not loaded; load this module."
  exit
}
#endregion

#region Get sample files for testing encoding
# test files are located in subfolder SampleFiles under folder containing script
$CurrentFolder = Split-Path -Parent $MyInvocation.MyCommand.Definition
$TestFilesPath = Join-Path -Path $CurrentFolder -ChildPath SampleFiles
$Files = dir -Path $TestFilesPath 
#endregion

#region Analyze files and create PSObjects
$Files | % {
   Write-Verbose "Test BOM for  $($_.FullName)"
  # create storage object
  $EncodingInfo = 1 | Select FileName,Encoding,BomFound,Endian
  # store file base name (remove extension so easier to read)
  $EncodingInfo.FileName = $_.BaseName
  # get full encoding object
  $Encoding = Get-DTWFileEncoding $_.FullName
  # store encoding type name
  $EncodingInfo.Encoding = $EncodingTypeName = $Encoding.ToString().SubString($Encoding.ToString().LastIndexOf(".") + 1)
  # store whether or not BOM found
  $EncodingInfo.BomFound = "$($Encoding.GetPreamble())" -ne "" 
  $EncodingInfo.Endian = ""
  # if Unicode, get big or little endian
  if ($Encoding.GetType().FullName -eq ([System.Text.Encoding]::Unicode.GetType().FullName)) {
    if ($EncodingInfo.BomFound) {
      if ($Encoding.GetPreamble()[0] -eq 254) {
        $EncodingInfo.Endian = "Big"
      } else {
        $EncodingInfo.Endian = "Little"
      }
    } else {
      $FirstByte = Get-Content -Path $_.FullName -Encoding byte -ReadCount 1 -TotalCount 1
      if ($FirstByte -eq 0) {
        $EncodingInfo.Endian = "Big"
      } else {
        $EncodingInfo.Endian = "Little"
      }
    }
  }
  $EncodingInfo
}
#endregion
