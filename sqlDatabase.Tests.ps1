BeforeAll {
    import-module dbatools
    $existingDatabases = (get-dbadatabase -sqlinstance localhost).Name
}

Describe -Tag 'global' "AutoPilot databases should NOT exist, globally" {
    Context "<_>" -ForEach 'WidgetDev',
        'WidgetTest' ,
        'WidgetProd' ,
        'WidgetZBuild' ,
        'WidgetZCheck' ,
        'WidgetZShadow' {
        It '<_> database SHOULD NOT exist on localhost' {
            $_ | Should -Not -BeIn $existingDatabases
        }
    }
}

Describe -Tag 'CustomerVM' "Databases that SHOULD exist, on CustomerVM" {
    Context "<_>" -ForEach 'AzureDevOps_Configuration' ,
        'AzureDevOps_DefaultCollection' ,
        'Northwind' ,
        'Northwind_Dev' ,
        'Northwind_Dev_redgate_SHADOW' ,
        'SQLClone_Config' ,
        'Redgate_SqlDataCatalog' ,
        'Eastwind' ,
        'Eastwind_Dev' ,
        'Eastwind_Test' ,
        'Eastwind_QA' ,
        'Eastwind_Shadow' ,
        'Eastwind_Build' ,
        'Tundra_Check_Prod' ,
        'Tundra_Dev' ,
        'Tundra_Test' ,
        'Tundra' ,
        'Tundra_Check' ,
        'Tundra_Build' ,
        'Tundra_Shadow' ,
        'Bolt_Dev' ,
        'Bolt_Test' ,
        'Bolt_Build' ,
        'Bolt_Shadow' ,
        'Bolt_Check' ,
        'Bolt' {
        It '<_> database SHOULD exist on localhost' {
            $_ | Should -BeIn $existingDatabases
        }
    }
}

Describe -Tag 'SalesDemo' "Databases that SHOULD exist, on SalesDemo" {
    Context "<_>" -ForEach 'master' ,
        'tempdb' ,
        'model' ,
        'msdb' ,
        'Northwind' ,
        'Northwind_Dev' ,
        'Northwind_Test' ,
        'Northwind_Build' ,
        'DMDatabase_Dev' ,
        'Westwind_Check_Test' ,
        'FlywayDB' ,
        'AdventureWorks' ,
        'Northwind_Shadow' ,
        'DMDatabase_TDM' ,
        'NewWorldDB' ,
        'AdventureWorks_TDM' ,
        'Westwind_Check_Prod' ,
        'NewWorldDB_Dev' ,
        'NewWorldDB_Test' ,
        'NewWorldDB_Prod2' ,
        'NewWorldDB_Check' ,
        'Eastwind' ,
        'NewWorldDB_Shadow' ,
        'NewWorldDB_Build' ,
        'VoiceOfTheDBA_Dev' ,
        'VoiceOfTheDBA_Integration' ,
        'VoiceOfTheDBA_Testing' ,
        'Westwind_SuperProd' ,
        'VoiceOfTheDBA_Production' ,
        'Northwind_Check' ,
        'Northwind_Prod1' ,
        'Northwind_Prod2' ,
        'Northwind_Prod3' ,
        'Northwind_Prod4' ,
        'DMDatabase' ,
        'z_dev' ,
        'StackOverflow' ,
        'RedGate' ,
        'Redgate_SqlDataCatalog' ,
        'VoiceOfTheDBA_Dev_redgate_SHADOW' ,
        'z' ,
        'z-new' ,
        'z2' ,
        'z-prod' ,
        'StackOverflow_Check_Prod' ,
        'AdventureWorks_Check' ,
        'aardvark_prod' ,
        'aardvark_dev' ,
        'Eastwind_Dev' ,
        'Eastwind_Build' ,
        'Eastwind_redgate_Shadow' ,
        'Eastwind_Test' ,
        'aardvark_test' ,
        'Westwind' ,
        'Westwind_Build' ,
        'Westwind_Dev' ,
        'Westwind_Shadow' ,
        'Westwind_Test' ,
        'SouthWind_Dev' ,
        'SouthWind_Build' ,
        'SouthWind_Test' ,
        'SouthWind_Shadow' ,
        'SouthWind' ,
        'aardvark_uat' ,
        'aardvark_shadow' ,
        'aardvark_check' ,
        'aardvark_build' ,
        'Aardvard_prod' {
        It '<_> database SHOULD exist on localhost' {
            $_ | Should -BeIn $existingDatabases
        }
    }
}