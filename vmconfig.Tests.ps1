Describe -Tag 'global' 'VM_CONFIG tests' {
    It 'VM_CONFIG environment variable should exist' {
        $exists = Test-Path "Env:\VM_Config" # checks if the environment variable exists in the Env: provider
        $exists | Should -Be $true
    }

    It 'VM_CONFIG should be either SalesDemo or CustomerVM' {
        $expectedValues = @('SalesDemo', 'CustomerVM')
        $env:VM_CONFIG | Should -BeIn $expectedValues
    }
}