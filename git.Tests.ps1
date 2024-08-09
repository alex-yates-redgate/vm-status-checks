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

Describe 'Checking the following directory exists' {
    It 'C:\git' {
        $gitDirectoryExists = Test-Path -Path $gitDirectory
        $gitDirectoryExists | Should -BeTrue
    }
}

Describe "Important GitHub Repositories" {
    Context "<_>" -ForEach 'vm-status-checks','tdm-demos','forkable-widget','vm-startup-scripts','TDM-AutoMasklet','InstallTdmClisOnWindows' {
        It 'should be cloned to C:\git' {
            $repoPath = Join-Path -Path $gitDirectory -ChildPath $_
            Test-Path -Path $repoPath | Should -BeTrue
        }

        It "should be the latest version" {
            $remote = git -C C:\git\vm-status-checks remote get-url origin
            $githubAccount = ($remote -Split ('/'))[3]       
            $remoteRepoName = ((($remote -Split ('/'))[4]) -Split ('\.'))[0]
            
            $latestCommitHash = Get-LatestGitHubCommitHash -GitHubRepository "$githubAccount/$remoteRepoName" -Branch 'main' #gets latest github commit hash
            $currentCommitHash = (git -C "$gitDirectory\$_" log -1).Split() | Where-Object { $_.Length -eq 40 } #gets local commit hash
            $latestCommitHash | Should -BeExactly $currentCommitHash
        }
    }
}
