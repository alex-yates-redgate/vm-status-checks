Describe 'Redgate telemetry should be disabled' {
    It 'REDGATE_DISABLE_TELEMETRY environment variable should be set to true' {
        $telemetry = $env:REDGATE_DISABLE_TELEMETRY
        'true' | Should -Be $telemetry
    }
}