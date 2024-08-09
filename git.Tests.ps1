BeforeAll {
    $gitDirectory = "C:\git"

    function Get-LatestGitHubCommitHash {
        param (
            [string]$GitHubRepository,
            [string]$Branch,
            [bool]$Gist = $false
        )
        if ($Gist){
            $url = "https://api.github.com/gists/$GitHubRepository"
            Write-Warning "url: $url"
            $response = Invoke-RestMethod -Uri $url
            $lastSha = $response.history.version[0] 
            return $lastSha
        }
        else {
            $url = "https://api.github.com/repos/$GitHubRepository/commits/$Branch"
            Write-Warning "url: $url"
            $response = Invoke-RestMethod -Uri $url
            return $response.sha
        }
        Write-Error "Something went wrong in the Get-LatestGitHubCommitHash function. This line should never execute."
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
            $remote = git -C C:\git\$_ remote get-url origin
            $gist = $remote -like "https://gist.github.com/*"
            if ($gist){
                $gitHubRepo = ($remote -Split ('/'))[3]   
            }
            else {
                $githubAccount = ($remote -Split ('/'))[3]       
                $remoteRepoName = ((($remote -Split ('/'))[4]) -Split ('\.'))[0]
                $gitHubRepo = "$githubAccount/$remoteRepoName"
            }
            $latestCommitHash = Get-LatestGitHubCommitHash -GitHubRepository $gitHubRepo -Branch 'main' -Gist $gist #gets latest github commit hash
            $currentCommitHash = (git -C "$gitDirectory\$_" log -1).Split() | Where-Object { $_.Length -eq 40 } #gets local commit hash
            $latestCommitHash | Should -BeExactly $currentCommitHash
        }
    }
}
