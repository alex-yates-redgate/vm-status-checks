Describe 'Checking the following tools are up to date' {
    It 'Flyway' {
        $flywayVersion = flyway version
        If ($flywayVersion -like "*WARNING: This version of Flyway is out of date.*"){
            $upToDate = $false
        }
        else {
            $upToDate = $true
        }
        $upToDate | Should -BeTrue
    }

    It 'rgclone CLI' {
        $rgcloneVersion = rgclone version
        If ($rgcloneVersion -like "*WARNING - Your current version * of the rgclone CLI is outdated.*"){
            $upToDate = $false
        }
        else {
            $upToDate = $true
        }
        $upToDate | Should -BeTrue
    }
}