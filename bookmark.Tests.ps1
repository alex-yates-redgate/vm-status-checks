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

    $expectedSalesDemoUrls = @(
        'http://win2016:15156/sqlserverinstances'
    )

    $expectedCustomerVMUrls = @(
        'http://redgate-demo/DefaultCollection/Tundra', 
        'http://redgate-demo/DefaultCollection/_git/Bolt',
        'http://redgate-demo/DefaultCollection/_git/Pagila',
        'http://redgate-demo/', 
        'http://redgate-demo:14145/', 
        'https://documentation.red-gate.com/clone/files/119669277/119669278/1/1545065894288/SQLCloneArchitectureImage2.jpg', 
        'https://monitor.red-gate.com/GlobalDashboard', 
        'http://redgate-demo:15156/sqlserverinstances', 
        'https://download.red-gate.com/'
    )
}


Describe -Tag 'SalesDemo' 'The following bookmarks should exist in Chrome on the CustomerVM' {
    foreach ($expectedUrl in $expectedSalesDemoUrls) {
        It "Bookmark for $expectedUrl should exist" {
            $expectedUrl | Should -BeIn $bookmarks
        }
    }
}

Describe -Tag 'CustomerVM' 'The following bookmarks should exist in Chrome on the CustomerVM' {
    foreach ($expectedUrl in $expectedCustomerVMUrls) {
        It "Bookmark for $expectedUrl should exist" {
            $expectedUrl | Should -BeIn $bookmarks
        }
    }
}