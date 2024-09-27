BeforeAll {
    $gitDirectory = "C:\git"

    function Get-LatestRemoteCommitHash {
        param (
            [string]$remote
        )

        $gist = $remote -like "https://gist.github.com/*"
        $github = $remote -like "https://github.com/*"
        $ado = $remote -like "*:8080/tfs*"

        if ($gist){
            $repo = ((($remote -Split ('/'))[3]) -Split ('\.'))[0] 
            $url = "https://api.github.com/gists/$repo"
            $response = Invoke-RestMethod -Uri $url
            $lastSha = $response.history.version[0] 
            return $lastSha
        }

        if ($ado){
            $remoteProjet = ($remote -Split "/_git/")[0]
            $remoteDatabase = ($remote -Split "/_git/")[1]
            $url = "$remoteProjet/_apis/git/repositories/$remoteDatabase/refs?filter=heads/&api-version=6.1-preview.1"
            try {
                $response = Invoke-RestMethod -Uri $url -Method Get -UseDefaultCredentials
            }
            catch {
                Write-Error "Following API call failed: $url"
                Write-Error "Error was:"
                Write-Error $error[0]
            }
            return $response.value[0].objectId
        }
        
        if ($github) {
            $githubAccount = ($remote -Split ('/'))[3]       
            $remoteRepoName = ((($remote -Split ('/'))[4]) -Split ('\.'))[0]
            $url = "https://api.github.com/repos/$githubAccount/$remoteRepoName/commits/main"
            try {
                $response = Invoke-RestMethod -Uri $url
            }
            catch {
                Write-Error "Following API call failed: $url"
                Write-Error "Error was:"
                Write-Error $error[0]
            }
            return $response.sha
        }
        Write-Error "Remote repo appears to be neither a GitHub repo, a GitHub gist, or a local Azure DevOps repo. Don't know how to get the latest commit hash."
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
            $latestCommitHash = Get-LatestRemoteCommitHash -remote $remote #gets latest github commit hash
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