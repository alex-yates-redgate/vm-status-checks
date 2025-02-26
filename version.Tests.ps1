BeforeAll {
    function Find-LatestVersion {
        param (
            [Parameter(Position=0,mandatory=$true)]$xml
        )
        # Parsing the XML to find all the available versions
        $versions = @()
        ($xml -Split "<Key>") | ForEach {
            $versions += ((($_ -split ".zip")[0] -split "_")[1]) 
        }
    
        # Remove duplicates
        $uniqueVersions = @()
        $uniqueVersions += $versions | Select-Object -Unique
    
        # Sort versions, based on [System.Version]. More info: https://learn.microsoft.com/en-us/dotnet/api/system.version.parse?view=net-8.0
        $sortedVersions = @()
        $sortedVersions += $uniqueVersions | Sort-Object {
            [System.Version]::Parse($_)
        } -Descending
    
        # Return the biggest version
        return $sortedVersions[0].ToString()
    }
}


Describe -Tag 'global' 'Checking the following tools are up to date' {
    It 'Flyway' {
        $flywayVersion = (flyway version | Out-String).Trim()
        If (($flywayVersion -like "*WARNING: This version of Flyway is out of date.*") -or ($flywayVersion -like "*A more recent version of Flyway is available.*")){
            $upToDate = $false
        }
        else {
            $upToDate = $true
        }
        $upToDate | Should -BeTrue
    }

    It 'rgclone CLI' {
        $rgcloneVersion = (rgclone version | Out-String).Trim()
        If ($rgcloneVersion -like "*WARNING - Your current version * of the rgclone CLI is outdated.*"){
            $upToDate = $false
        }
        else {
            $upToDate = $true
        }
        $upToDate | Should -BeTrue
    }

    It 'rganonymize' {
        $rganonymizeVersionsXml = (Invoke-WebRequest "https://redgate-download.s3.eu-west-1.amazonaws.com/?delimiter=/&prefix=EAP/AnonymizeWin64/").Content
        $latestRganonymize = Find-LatestVersion $rganonymizeVersionsXml
        $installedRganonymize = (rganonymize --version | Out-String).Trim()
        $installedRganonymize | Should -BeLike  "*$latestRganonymize*"
    }

    It 'rgsubset' {
        $rgsubsetVersionsXml = (Invoke-WebRequest "https://redgate-download.s3.eu-west-1.amazonaws.com/?delimiter=/&prefix=EAP/SubsetterWin64/").Content
        $latestRgsubset = Find-LatestVersion $rgsubsetVersionsXml
        $installedRgsubset = (rgsubset --version | Out-String).Trim()
        $installedRgsubset | Should -BeLike  "*$latestRgsubset*"
    }

}
