BeforeAll {
    $gitDirectory = "C:\git"
}

Describe 'Checking the following tools are up to date' {
    It 'Git directory should exist at C:\git' {
        $gitDirectoryExists = $false
        If (Test-Path -Path $gitDirectory){
            $gitDirectoryExists = $true
        }
        $gitDirectoryExists | Should -BeTrue
    }

    It 'vm-status-checks repository should be cloned to C:\git' {
        $gitDirectoryExists = $false
        If (Test-Path -Path "$gitDirectory\vm-status-checks"){
            $gitDirectoryExists = $true
        }
        $gitDirectoryExists | Should -BeTrue
    }

    It 'tdm-demos repository should be cloned to C:\git' {
        $gitDirectoryExists = $false
        If (Test-Path -Path "$gitDirectory\tdm-demos\.git"){
            $gitDirectoryExists = $true
        }
        $gitDirectoryExists | Should -BeTrue
    }

    It 'forkable-widget repository should be cloned to C:\git' {
        $gitDirectoryExists = $false
        If (Test-Path -Path "$gitDirectory\forkable-widget\.git"){
            $gitDirectoryExists = $true
        }
        $gitDirectoryExists | Should -BeTrue
    }
}