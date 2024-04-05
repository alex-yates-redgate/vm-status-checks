BeforeAll {
    $allServices = Get-Service
    $automaticServices = $allServices | Where-Object {$_.StartType -like 'Automatic'}
    $manualServices = $allServices | Where-Object {$_.StartType -like 'Manual'}
    $disabledServices = $allServices | Where-Object {$_.StartType -like 'Disabled'}
}


Describe 'The following services should be Automatic' {
    It 'SQL Server (MSSQLSERVER)' {
        'SQL Server (MSSQLSERVER)' | Should -BeIn $automaticServices.DisplayName
    }
}

Describe 'The following services should be Manual' {
    It 'SQL Monitor Base Monitor' {
        'SQL Monitor Base Monitor' | Should -BeIn $manualServices.DisplayName
    }
    It 'SQL Monitor Web Service' {
        'SQL Monitor Web Service' | Should -BeIn $manualServices.DisplayName
    }
}

Describe 'The following services should be Disabled' {
    It 'SQL Server Browser' {
        'SQL Server Browser' | Should -BeIn $disabledServices.DisplayName
    }
}