BeforeAll {
    $flywayVersion = flyway version
}

Describe 'Checking the following tools are up to date' {
    It 'Flyway' {
        If ($flywayVersion -like "*WARNING: This version of Flyway is out of date.*"){
            $upToDate = $false
        }
        else {
            $upToDate = $true
        }
        $upToDate | Should -BeTrue
    }
}