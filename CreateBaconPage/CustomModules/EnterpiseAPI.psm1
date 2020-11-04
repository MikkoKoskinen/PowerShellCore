function GiveMeBacon{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, HelpMessage="Amount of meat")]
        [string] $meatParas
    )

    #**Give me bacon from - baconipsum.com
    Write-Host "#*#Give me bacon from - baconipsum.com"

    $response = ""

    try {
        $queryURL = ("https://baconipsum.com/api/?type=all-meat&paras={0}&start-with-lorem=1&format=text" -f $meatParas)
        
        $response = Invoke-RestMethod -Uri $queryURL -ContentType "application/json; charset=utf-8" -Method Post -UseBasicParsing
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Host "**ERROR: #*#Give me bacon"
        Write-Error $ErrorMessage
    }

    return $response
}

Export-ModuleMember -Function GiveMeBacon