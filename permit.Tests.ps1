BeforeAll {
    $permitPath = "C:\Program Files\Red Gate\Permits\permit.dat"

    function Parse-JWTtoken {
        # Function pinched from: https://www.michev.info/blog/post/2140/decode-jwt-access-and-id-tokens-via-powershell
        [cmdletbinding()]
        param([Parameter(Mandatory=$true)][string]$token)
     
        #Validate as per https://tools.ietf.org/html/rfc7519
        #Access and ID tokens are fine, Refresh tokens will not work
        if (!$token.Contains(".") -or !$token.StartsWith("eyJ")) { Write-Error "Invalid token" -ErrorAction Stop }
     
        #Header
        $tokenheader = $token.Split(".")[0].Replace('-', '+').Replace('_', '/')
        #Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
        while ($tokenheader.Length % 4) { Write-Verbose "Invalid length for a Base-64 char array or string, adding ="; $tokenheader += "=" }
        Write-Verbose "Base64 encoded (padded) header:"
        Write-Verbose $tokenheader
        #Convert from Base64 encoded string to PSObject all at once
        Write-Verbose "Decoded header:"
        #[System.Text.Encoding]::ASCII.GetString([system.convert]::FromBase64String($tokenheader)) | ConvertFrom-Json | fl | Out-Default
     
        #Payload
        $tokenPayload = $token.Split(".")[1].Replace('-', '+').Replace('_', '/')
        #Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
        while ($tokenPayload.Length % 4) { Write-Verbose "Invalid length for a Base-64 char array or string, adding ="; $tokenPayload += "=" }
        Write-Verbose "Base64 encoded (padded) payoad:"
        Write-Verbose $tokenPayload
        #Convert to Byte array
        $tokenByteArray = [System.Convert]::FromBase64String($tokenPayload)
        #Convert to string array
        $tokenArray = [System.Text.Encoding]::ASCII.GetString($tokenByteArray)
        Write-Verbose "Decoded array in JSON format:"
        Write-Verbose $tokenArray
        #Convert from JSON to PSObject
        $tokobj = $tokenArray | ConvertFrom-Json
        Write-Verbose "Decoded Payload:"
        
        return $tokobj
    }
    
    $permit = Get-Content $permitPath
    $permitData = (Parse-JWTtoken $permit)
}

Describe -Tag 'global' 'Testing permit setup' {
    It 'Permit file environment variable should exist correctly' {
        $env:REDGATE_LICENSING_PERMIT_PATH | Should -BeLike $permitPath
    }

    It 'Permit file should exist'{
        Test-Path $permitPath | Should -BeTrue 
    }
}
Describe -Tag 'global' 'Testing permit status' {
    It 'Permit should not have expired' {
        $unixExpiryDate = $permitData.exp
        # Convert to DateTime by adding seconds to the Unix epoch start date
        $epoch = [datetime]"1970-01-01T00:00:00Z"
        $expiryDate = $epoch.AddSeconds($unixExpiryDate)
        $daysRemaining = ($expiryDate - (Get-Date)).Days
        $daysRemaining | Should -BeGreaterThan 0
    }
    It 'Permit should be valid for at least 90 days' {
        $unixExpiryDate = $permitData.exp
        # Convert to DateTime by adding seconds to the Unix epoch start date
        $epoch = [datetime]"1970-01-01T00:00:00Z"
        $expiryDate = $epoch.AddSeconds($unixExpiryDate)
        $daysRemaining = ($expiryDate - (Get-Date)).Days
        $daysRemaining | Should -BeGreaterThan 90
    }
    #It 'Permit should include Flyway Enterprise (for example)' {
    #    # This should return data about the products included in the permit
    #    $products = $permitData.products
    #    # This should return data about the edition of a particular product
    #    $editionOfProduct23 = ($products.23).licenses.editionName
    #    # This test is currently set to fail by default, because I don't have a glossary of the codes for each product. When I have them I can add tests for all the relevant products and versions
    #    $true | Should -BeFalse
    #}
}
