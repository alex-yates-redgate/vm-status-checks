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

    It 'anonymize timebomb' {
        $anonymizeOutput = anonymize
        If ($anonymizeOutput -like "*This version of the Anonymization tool has expired*"){
            $upToDate = $false
        }
        else {
            $upToDate = $true
        }
        $upToDate | Should -BeTrue
    }

    It 'subset timebomb' {
        $subsetOutput = subsetter
        If ($subsetOutput -like "*This version of the Subsetter tool has expired*"){
            $upToDate = $false
        }
        else {
            $upToDate = $true
        }
        $upToDate | Should -BeTrue
    }

    It 'datagenerator timebomb' {
        $datageneratorOutput = datagenerator
        If ($datageneratorOutput -like "*This version of the Data Generator tool has expired*"){
            $upToDate = $false
        }
        else {
            $upToDate = $true
        }
        $upToDate | Should -BeTrue
    }
}
