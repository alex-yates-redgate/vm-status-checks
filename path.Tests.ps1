eforeAll {
    function Test-CommandRunsSuccessfully {
        param (
            [Parameter(Position=0,mandatory=$true)][string]$command 
        )
        try {
            $commandOutput = & $command
            $flywayFound = $true
        }
        catch {
            $flywayFound = $false
        }
        return $flywayFound
    }
}

Describe 'The following tools should be accessible via %PATH% from the command line' {
    It 'flyway' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "flyway"
        $runsSuccessfully | Should -BeTrue
    }

    It 'flyway-dev' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "flyway-dev"
        $runsSuccessfully | Should -BeTrue
    }

    It 'rgcompare' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "rgcompare"
        $runsSuccessfully | Should -BeTrue
    }

    It 'sqlcompare' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "sqlcompare"
        $runsSuccessfully | Should -BeTrue
    }

    It 'sqldatacompare' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "sqldatacompare"
        $runsSuccessfully | Should -BeTrue
    }

    It 'sqldatagenerator' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "sqldatagenerator"
        $runsSuccessfully | Should -BeTrue
    }

    It 'rgclone' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "rgclone"
        $runsSuccessfully | Should -BeTrue
    }

    It 'subsetter' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "subsetter"
        $runsSuccessfully | Should -BeTrue
    }

    It 'anonymize' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "anonymize"
        $runsSuccessfully | Should -BeTrue
    }

    It 'datagenerator' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "datagenerator"
        $runsSuccessfully | Should -BeTrue
    }

    It 'DataMaskerCmdLine' {
        $runsSuccessfully = Test-CommandRunsSuccessfully -command "DataMaskerCmdLine"
        $runsSuccessfully | Should -BeTrue
    }
}