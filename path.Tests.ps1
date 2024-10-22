BeforeAll {
    function Test-CommandRunsSuccessfully {
        param (
            [Parameter(Position=0,mandatory=$true)][string]$command 
        )
        try {
            # Attempt to run the command
            & $Command > $null 2>&1
            return $true
        }
        catch {
            return $false
        }
    }
}

Describe -Tag 'global' 'The following tools should be accessible via %PATH% from the command line' {
    It "<_> is in %PATH%" -ForEach (
        'DataMaskerCmdLine',
        'flyway', 
        'flyway-dev', 
        'git',
        'rganonymize', 
        'rgclone', 
        'rgcompare.cli', 
        'rggenerate',
        'rgsubset', 
        'sqlcompare', 
        'sqldatacompare', 
        'sqldatagenerator'
    ) {
    Test-CommandRunsSuccessfully -command $_ | Should -BeTrue}
}
