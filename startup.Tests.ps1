BeforeAll {
    $startupApps = Get-CimInstance Win32_StartupCommand
    $startupTasks = Get-ScheduledTask
}

Describe -Tag 'global' 'The following apps should run on startup' {
    It 'ZoomIt' {
        'ZoomIt' | Should -BeIn $startupApps.Name
    }
}

Describe -Tag 'global' 'Scheduled tasks should exist for the following scripts' {
    It 'Run weekly jobs' {
        'Run weekly jobs' | Should -BeIn $startupTasks.TaskName
    }
    It 'StartRedgateClient' {
        'StartRedgateClient' | Should -BeIn $startupTasks.TaskName
    }
    It 'LogonScripts' {
        'LogonScripts' | Should -BeIn $startupTasks.TaskName
    }
}

Describe -Tag 'global' 'Scheduled tasks should be enabled' {
    It 'Run weekly jobs' {
        (Get-ScheduledTask  -TaskName "Run weekly jobs").Triggers[0].Enabled | Should -BeLike "True"
    }
    It 'StartRedgateClient' {
        (Get-ScheduledTask  -TaskName "StartRedgateClient").Triggers[0].Enabled | Should -BeLike "True"
    }
    It 'LogonScripts' {
        (Get-ScheduledTask  -TaskName "LogonScripts").Triggers[0].Enabled | Should -BeLike "True"
    }
}



