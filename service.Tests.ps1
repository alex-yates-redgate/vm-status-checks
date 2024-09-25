BeforeAll {
    $allServices = Get-Service
    $automaticServices = $allServices | Where-Object {$_.StartType -like 'Automatic'}
    $manualServices = $allServices | Where-Object {$_.StartType -like 'Manual'}
    $disabledServices = $allServices | Where-Object {$_.StartType -like 'Disabled'}
}

Describe -Tag 'Global' 'Validating Startup Type for various Windows Services, regardless of VM' {
    Context 'Service <expectedService> ' -ForEach @(
        @{ expectedService = 'SQL Clone Server' }
        @{ expectedService = 'SQL Clone Agent 5.4.21.6541' }
        @{ expectedService = 'Redgate SQL Data Catalog Service' }
        @{ expectedService = 'Azure DevOps Server Background Job Agent' }

        @{ expectedService = 'Redgate Client' }
    ) {
        It 'should have Startup Type set to AUTOMATIC'  {
            $expectedService | Should -BeIn $automaticServices.DisplayName
        }
    }

    Context 'Service <expectedService> ' -ForEach @(
        @{ expectedService = 'Azure DevOps Ssh Service' }
    ) {
        It 'should have Startup Type set to MANUAL' {
            $expectedService | Should -BeIn $manualServices.DisplayName
        }
    }
}

Describe -Tag 'SalesDemo' 'Validating Startup Type for various Windows Services on the SalesDemo VM' {
    Context 'Service <expectedService> ' -ForEach @(
        @{ expectedService = 'SQL Server (MSSQLSERVER)' }
        @{ expectedService = 'SQL Server (TOOLS)' }
        @{ expectedService = 'VSTS Agent (localhost.WIN2016-TFS18)' }
    ) {
        It 'should have Startup Type set to AUTOMATIC'  {
            $expectedService | Should -BeIn $automaticServices.DisplayName
        }
    }

    Context 'Service <expectedService> ' -ForEach @(
        @{ expectedService = 'Redgate Monitor Base Monitor' }
        @{ expectedService = 'Redgate Monitor Web Service' }
        @{ expectedService = 'Atlassian Bamboo Bamboo' }
        @{ expectedService = 'DLM Dashboard Monitoring Service' }
        @{ expectedService = 'DLM Dashboard Storage Service' }
        @{ expectedService = 'DLM Dashboard Web Server' }
        @{ expectedService = 'OctopusDeploy' }
        @{ expectedService = 'OctopusDeploy Tentacle' }
        @{ expectedService = 'OracleServiceORCL' }
        @{ expectedService = 'OracleServiceDEVADO' }
        @{ expectedService = 'OracleServiceDEVADOSHADOW' }
        @{ expectedService = 'OracleServiceHRDEV1ADO' }
        @{ expectedService = 'OracleServiceHRDEVADO' }
        @{ expectedService = 'SQL Backup Agent' }
        @{ expectedService = 'SQL Backup Agent-TOOLS' }
        @{ expectedService = 'TeamCity Build Agent' }
        @{ expectedService = 'TeamCity Server' }
        @{ expectedService = 'VSO Agent (WIN2016.Agent-WIN2016)' }
    ) {
        It 'should have Startup Type set to MANUAL' {
            $expectedService | Should -BeIn $manualServices.DisplayName
        }
    }

    Context 'Service <expectedService> ' -ForEach @(
        @{ expectedService = 'SQL Server Browser' }

    ) {
        It 'should have Startup Type set to DISABLED'  {
            $expectedService | Should -BeIn $disabledServices.DisplayName
        }
    }
}



Describe -Tag 'CustomerVM' 'Validating Startup Type for various Windows Services on the Customer VM' {
    Context 'Service <expectedService> ' -ForEach @(
        @{ expectedService = 'SQL Server (SQLEXPRESS)' }
        @{ expectedService = 'Azure Pipeline Agent (redgate-demo.Default.REDGATE-DEMO)' }
    ) {
        It 'should have Startup Type set to AUTOMATIC'  {
            $expectedService | Should -BeIn $automaticServices.DisplayName
        }
    }
}