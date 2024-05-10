BeforeAll {
    function Test-CommandRunsSuccessfully {
        param (
            [Parameter(Position=0,mandatory=$true)][string]$command 
        )
        try {
            $errorActionPreference = 'SilentlyContinue'
            $commandOutput = & $command | out-null
            $flywayFound = $true
        }
        catch {
            $flywayFound = $false
        }
        return $flywayFound
    }
}


Describe 'CLI tests' {
    $cliList = @(
        @{cli = "flyway"},
        @{cli = "flyway-dev"},
        @{cli = "rgcompare"},
        @{cli = "sqlcompare"},
        @{cli = "sqldatacompare"},
        @{cli = "sqldatagenerator"},
        @{cli = "rgclone"},
        @{cli = "subsetter"},
        @{cli = "anonymize"},
        @{cli = "datagenerator"},
        @{cli = "datamasker"}
    )
    
    It "<cli> should be accessible from %PATH%" -TestCases $cliList {
        param($cli)
        Test-CommandRunsSuccessfully -command $cli | Should -BeTrue
    }
}
