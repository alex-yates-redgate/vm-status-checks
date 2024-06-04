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

Describe 'The following tools should be accessible via %PATH% from the command line' {
    It "<_> is in %PATH%" -ForEach (
        'flyway', 'flyway-dev', 'rgcompare.cli', 
        'sqlcompare', 'sqldatacompare', 'sqldatagenerator', 
        'rgclone', 'subsetter', 'anonymize', 
        'datagenerator', 'DataMaskerCmdLine') {
        
        Test-CommandRunsSuccessfully -command $_ | Should -BeTrue}
}
