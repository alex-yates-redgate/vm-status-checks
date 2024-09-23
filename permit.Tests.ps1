BeforeAll {
    $permitPath = "C:\Program Files\Red Gate\Permits\permit.dat"
}

Describe -Tag 'global' 'Testing permit setup' {
    It 'Permit file environment variable should exist correctly' {
        $env:REDGATE_LICENSING_PERMIT_PATH | Should -BeLike $permitPath
    }

    It 'Permit file should exist'{
        Test-Path $permitPath | Should -BeTrue 
    }
}
