BeforeAll {
    $startupApps = Get-CimInstance Win32_StartupCommand
    $startupTasks = Get-ScheduledTask
}

Describe -Tag 'global' 'The following apps should run on startup' {
    It 'ZoomIt' {
        'ZoomIt' | Should -BeIn $startupApps.Name
    }
}

Describe -Tag 'global' 'Scheduled tasks should exist Globally' {
    It 'Run weekend-scripts from vm-startup-scripts' {
        'Run weekend-scripts from vm-startup-scripts' | Should -BeIn $startupTasks.TaskName
    }
    It 'Run logon-scripts from vm-startup-scripts' {
        'Run logon-scripts from vm-startup-scripts' | Should -BeIn $startupTasks.TaskName
    }
}

Describe -Tag 'global' 'Scheduled tasks should be enabled Globally' {
    It 'Run weekend-scripts from vm-startup-scripts' {
        (Get-ScheduledTask  -TaskName "Run weekend-scripts from vm-startup-scripts").Triggers[0].Enabled | Should -BeLike "True"
    }
    It 'Run logon-scripts from vm-startup-scripts' {
        (Get-ScheduledTask  -TaskName "Run logon-scripts from vm-startup-scripts").Triggers[0].Enabled | Should -BeLike "True"
    }
}

Describe -Tag 'SalesDemo' 'Scheduled tasks should exist on the SalesDemo VM' {
    It 'StartRedgateClient' {
        'StartRedgateClient' | Should -BeIn $startupTasks.TaskName
    }
}

Describe -Tag 'SalesDemo' 'Scheduled tasks should be enabled on the SalesDemo VM' {
    It 'StartRedgateClient' {
        (Get-ScheduledTask  -TaskName "StartRedgateClient").Triggers[0].Enabled | Should -BeLike "True"
    }
}



