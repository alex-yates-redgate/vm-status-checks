BeforeAll {
    $username = "redgate"
    $bookmarkData = Get-ChildItem -Path "C:\Users\$username\AppData\Local\Google\Chrome\User Data\Default\" -Filter *. | Where-Object {$_.Name -match 'Bookmark'} | Get-Content | ConvertFrom-Json

    # Recursive function that gets all the chrome bookmarks in all folders
    Function Get-Urls {
        param (
            $childItems
        )
        $urls = @()
        foreach ($childItem in $childItems){
            if ($childItem.type -like "url"){
                $urls += $childItem.url
            }
            else {
                $childUrls = @()
                $childUrls += Get-Urls $childItem.children
                $urls += $childUrls
            }
        }
        return $urls
    }

    $bookmarks = @()
    $bookmarks += Get-Urls $bookmarkData.roots.bookmark_bar.children
}


Describe -Tag 'SalesDemo' 'The following bookmarks should exist in Chrome on the SalesDemoVM' {

    Context 'Chrome bookmark <expectedUrl>' -ForEach @(
        @{ ExpectedUrl = 'https://www.red-gate.com/' }
        @{ ExpectedUrl = 'https://documentation.red-gate.com/home' }
        @{ ExpectedUrl = 'https://download.red-gate.com/installers' }
        @{ ExpectedUrl = 'http://win2016:8080/tfs/DefaultCollection/DatabaseProjects/_build' }
        @{ ExpectedUrl = 'https://app.snowflake.com/vxfrtpn/rv88946/#/data/databases' }
        @{ ExpectedUrl = 'https://github.com/red-gate/Flyway-Sample-Pipelines/tree/main/' }
        @{ ExpectedUrl = 'https://github.com/red-gate/OctoPilot' }
        @{ ExpectedUrl = 'http://localhost:8085/app#/Spaces-1/projects/octopilot/deployments' }
        @{ ExpectedUrl = 'http://win2016:8080/tfs/DefaultCollection/WestWind/_build' }
        @{ ExpectedUrl = 'http://win2016:8080/tfs/DefaultCollection/_git/Southwind' }
        @{ ExpectedUrl = 'https://app.snowflake.com/vxfrtpn/rv88946/worksheets' }
        @{ ExpectedUrl = 'https://stackoverflow.com/questions/68957199/conditionally-set-environment-azure-devops' }
        @{ ExpectedUrl = 'http://localhost:8082/' }
        @{ ExpectedUrl = 'http://localhost:8081/' }
        @{ ExpectedUrl = 'http://localhost:8082/blue/organizations/jenkins/pipelines' }
        @{ ExpectedUrl = 'https://tdm-internal.red-gate.com/' }
        @{ ExpectedUrl = 'https://documentation.red-gate.com/testdatamanager/command-line-interface-cli-222627793.html' }
        @{ ExpectedUrl = 'https://documentation.red-gate.com/testdatamanager/getting-started/architecture' }
        @{ ExpectedUrl = 'http://win2016:14145/dashboard' }
        @{ ExpectedUrl = 'https://documentation.red-gate.com/clone/files/119669277/119669278/1/1545065894288/SQLCloneArchitectureImage2.jpg' }
        @{ ExpectedUrl = 'http://monitor.red-gate.com/GlobalDashboard#Critical=false&Warning=false&Healthy=false&Group=&HistoryGroup=&HistoryTimespan=1440' }
        @{ ExpectedUrl = 'http://win2016:501/' }
        @{ ExpectedUrl = 'https://documentation.red-gate.com/sm/overview-and-licensing/what-is-sql-monitor' }
        @{ ExpectedUrl = 'https://download.red-gate.com/maven/release/org/flywaydb/enterprise/flyway-commandline' }
        @{ ExpectedUrl = 'http://win2016:15156/sqlserverinstances' }
    ) {
        It 'should exist'  {
            $expectedUrl | Should -BeIn $bookmarks
        }
    }
}


Describe -Tag 'CustomerVM' 'The following bookmarks should exist in Chrome on the CustomerVM' {

    Context 'Chrome bookmark <expectedUrl>' -ForEach @(
        @{ ExpectedUrl = 'http://redgate-demo/DefaultCollection/Tundra' }
        @{ ExpectedUrl = 'http://redgate-demo/DefaultCollection/_git/Bolt' }
        @{ ExpectedUrl = 'http://redgate-demo/DefaultCollection/_git/Pagila' }
        @{ ExpectedUrl = 'http://redgate-demo/' }
        @{ ExpectedUrl = 'http://redgate-demo:14145/' }
        @{ ExpectedUrl = 'https://documentation.red-gate.com/clone/files/119669277/119669278/1/1545065894288/SQLCloneArchitectureImage2.jpg' }
        @{ ExpectedUrl = 'https://monitor.red-gate.com/GlobalDashboard' }
        @{ ExpectedUrl = 'http://redgate-demo:15156/sqlserverinstances' }
        @{ ExpectedUrl = 'https://download.red-gate.com/' }
    ) {
        It 'should exist'  {
            $expectedUrl | Should -BeIn $bookmarks
        }
    }
}
