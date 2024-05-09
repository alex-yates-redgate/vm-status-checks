BeforeAll {
    $gitDirectory = "C:\git"

    function Get-LatestGitHubCommitHash {
        param (
            [string]$GitHubRepository,
            [string]$Branch
        )
    
        $url = "https://api.github.com/repos/$GitHubRepository/commits/$Branch"
        $response = Invoke-RestMethod -Uri $url
    
        return $response.sha
    }
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

    It "vm-status-checks repository should be latest version from Github" {
        $gitDirectoryLatestVersion = $false
        $latestCommitHash = Get-LatestGitHubCommitHash -GitHubRepository "alex-yates-redgate/vm-status-checks" -Branch 'main' #gets latest github commit hash
        $currentCommitHash = (git -C "$gitDirectory\vm-status-checks" log -1).Split() | Where-Object { $_.Length -eq 40 } #gets local commit hash
        If ($latestCommitHash -eq $currentCommitHash){
            $gitDirectoryLatestVersion = $true
        }
        $gitDirectoryLatestVersion | Should -BeTrue
    }

    It 'tdm-demos repository should be cloned to C:\git' {
        $gitDirectoryExists = $false
        If (Test-Path -Path "$gitDirectory\tdm-demos\.git"){
            $gitDirectoryExists = $true
        }
        $gitDirectoryExists | Should -BeTrue
    }

    It "tdm-demos repository should be latest version from Github" {
        $gitDirectoryLatestVersion = $false
        $latestCommitHash = Get-LatestGitHubCommitHash -GitHubRepository "alex-yates-redgate/tdm-demos" -Branch 'main' #gets latest github commit hash
        $currentCommitHash = (git -C "$gitDirectory\tdm-demos" log -1).Split() | Where-Object { $_.Length -eq 40 } #gets local commit hash
        If ($latestCommitHash -eq $currentCommitHash){
            $gitDirectoryLatestVersion = $true
        }
        $gitDirectoryLatestVersion | Should -BeTrue
    }

    It 'forkable-widget repository should be cloned to C:\git' {
        $gitDirectoryExists = $false
        If (Test-Path -Path "$gitDirectory\forkable-widget\.git"){
            $gitDirectoryExists = $true
        }
        $gitDirectoryExists | Should -BeTrue
    }

    It "forkable-widget repository should be latest version from Github" {
        $gitDirectoryLatestVersion = $false
        $latestCommitHash = Get-LatestGitHubCommitHash -GitHubRepository "alex-yates-redgate/forkable-widget" -Branch 'main' #gets latest github commit hash
        $currentCommitHash = (git -C "$gitDirectory\forkable-widget" log -1).Split() | Where-Object { $_.Length -eq 40 } #gets local commit hash
        If ($latestCommitHash -eq $currentCommitHash){
            $gitDirectoryLatestVersion = $true
        }
        $gitDirectoryLatestVersion | Should -BeTrue
    }
}
