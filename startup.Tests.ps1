BeforeAll {
    $startupApps = Get-CimInstance Win32_StartupCommand
    $startupTasks = Get-ScheduledTask
}

Describe 'The following apps should run on startup' {
    It 'ZoomIt' {
        'ZoomIt' | Should -BeIn $startupApps.Name
    }
}

Describe 'Scheduled tasks should exist for the following scripts' {
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

Describe 'Scheduled tasks should be enabled' {
    It 'GitPullAll' {
        (Get-ScheduledTask  -TaskName "GitPullAll").Triggers[0].Enabled | Should -BeLike "True"
    }
    It 'StartRedgateClient' {
        (Get-ScheduledTask  -TaskName "StartRedgateClient").Triggers[0].Enabled | Should -BeLike "True"
    }
    It 'UpdateRgClone' {
        (Get-ScheduledTask  -TaskName "UpdateRgClone").Triggers[0].Enabled | Should -BeLike "True"
    }
}



