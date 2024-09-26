Describe -Tag 'global' 'PowerShell version' {
    It 'PowerShell 7.x should be installed' {
        try {
            # Check if Flyway is already installed
            & pwsh -Version > $null 2>&1
            $ps7Installed = $true
        }
        catch {
            $ps7Installed = $false
        }
        $ps7Installed | Should -Be $true
    }
}