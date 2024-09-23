BeforeAll {
    import-module dbatools
}

Describe -Tag 'global' 'Testing dbatools config' {
    It 'dbatools should trust the SQL Server certificate' {
        (Get-DbatoolsConfig -FullName sql.connection.trustcert).Value | Should -BeTrue
    }
    It 'dbatools should not encypt the connection to SQL Server' {
        (Get-DbatoolsConfig -FullName sql.connection.encrypt).Value | Should -BeFalse
    }
}