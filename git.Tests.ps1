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
            $response = Invoke-RestMethod -Uri $url
            $lastSha = $response.history.version[0] 
            return $lastSha
        }
        else {
            $url = "https://api.github.com/repos/$GitHubRepository/commits/$Branch"
            $response = Invoke-RestMethod -Uri $url
            return $response.sha
        }
        Write-Error "Something went wrong in the Get-LatestGitHubCommitHash function. This line should never execute."
    }
}

Describe -Tag 'global' 'Checking the following directory exists' {
    It 'C:\git' {
        $gitDirectoryExists = Test-Path -Path $gitDirectory
        $gitDirectoryExists | Should -BeTrue
    }
}

Describe "Important GitHub Repositories" {
    Context "<_>" -ForEach @(    
        @{ Repo = "forkable-widget"; Tag = 'global' }
        @{ Repo = "InstallTdmClisOnWindows"; Tag = 'global' }
        @{ Repo = "TDM-AutoMasklet"; Tag = 'global' }
        @{ Repo = "tdm-demos"; Tag = 'global' }
        @{ Repo = "vm-startup-scripts"; Tag = 'global' }
        @{ Repo = "vm-status-checks"; Tag = 'global' }
        @{ Repo = "Flyway-AutoPilot-Backup-AzureDevOps"; Tag = 'SalesDemo' }
        @{ Repo = "Flyway-AutoPilot-Backup-GitHub"; Tag = 'SalesDemo' }
        @{ Repo = "Flyway-AutoPilot-FastTrack-AzureDevOps"; Tag = 'SalesDemo' }
        @{ Repo = "Flyway-AutoPilot-FastTrack-GitHub"; Tag = 'SalesDemo' }
        @{ Repo = "Flyway-AutoPilot-FastTrack"; Tag = 'CustomerVM' }
    ) {
        It -Tag $tag "$repo should be cloned to C:\git" {
            $repoPath = Join-Path -Path $gitDirectory -ChildPath $repo
            Test-Path -Path $repoPath | Should -BeTrue
        }

        It -Tag $tag "$repo should be the latest version" {
            $remote = git -C C:\git\$repo remote get-url origin
            $gist = $remote -like "https://gist.github.com/*"
            if ($gist){
                $gitHubRepo = ((($remote -Split ('/'))[3]) -Split ('\.'))[0]   
            }
            else {
                $githubAccount = ($remote -Split ('/'))[3]       
                $remoteRepoName = ((($remote -Split ('/'))[4]) -Split ('\.'))[0]
                $gitHubRepo = "$githubAccount/$remoteRepoName"
            }
            $latestCommitHash = Get-LatestGitHubCommitHash -GitHubRepository $gitHubRepo -Branch 'main' -Gist $gist #gets latest github commit hash
            $currentCommitHash = (git -C "$gitDirectory\$repo" log -1).Split() | Where-Object { $_.Length -eq 40 } #gets local commit hash
            $latestCommitHash | Should -BeExactly $currentCommitHash
        }
    }
}

Describe -Tag 'SalesDemo' "GitHub and ADO repos should be in sync" {
    Context "<_>" -ForEach 'Flyway-AutoPilot-Backup',
        'Flyway-AutoPilot-FastTrack' {
        
        It "GitHub and Azure DevOps repos should be in sync" {
            $gh_repo = Join-Path -Path $gitDirectory -ChildPath "$_-GitHub"
            $ado_repo = Join-Path -Path $gitDirectory -ChildPath "$_-AzureDevOps"

            $gh_files = Get-ChildItem -Recurse -path $gh_repo
            $ado_files = Get-ChildItem -Recurse -path $ado_repo

            $diff = Compare-Object -ReferenceObject $gh_files -DifferenceObject $ado_files -Property Name, Length

            $diff   | Should -BeNullOrEmpty
        }
    }
}