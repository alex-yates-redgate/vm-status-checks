BeforeAll {
    $startupApps = Get-CimInstance Win32_StartupCommand
}

Describe 'The following apps should run on startup' {
    It 'ZoomIt' {
        'ZoomIt' | Should -BeIn $startupApps.Name
    }
}