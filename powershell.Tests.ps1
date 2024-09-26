Describe -Tag 'global' 'PowerShell version' {
    It 'pwsh should execute successfully' {
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
    It 'pwsh -verion should return 7.x' {
        $psVersion = & pwsh -Version
        $psVersion | Should -Match '7\.\d+'
    }
}