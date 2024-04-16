Write-Output "If Pester is not updated to at least v5.5.0, upgrading..."
if (Test-Path "C:\Program Files\WindowsPowerShell\Modules\Pester\5.5.0"){
  Write-Output "  Pester v5.5.0 is already installed!"
}
else {
  Write-Output "  Pester v5.5.0 is not installed. Installing latest version of Pester..."
  Save-Module -Name Pester -Path "C:\Program Files\WindowsPowerShell\Modules"
  if (Test-Path "C:\Program Files\WindowsPowerShell\Modules\Pester\5.5.0"){
    Write-Output "  Pester v5.5.0 is now installed!"
  }
  else {
    Write-Error "FAILED TO INSTALL PESTER!"
  }
}
