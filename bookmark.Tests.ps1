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

Describe 'The following boomarks should run on startup' {
    It 'SQL Data Catalog' {
        'http://win2016:15156' | Should -BeIn $bookmarks
    }
}