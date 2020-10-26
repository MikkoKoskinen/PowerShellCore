function GiveMeBacon{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, HelpMessage="Amount of meat")]
        [string] $meatParas,
        [Parameter(Mandatory = $true, HelpMessage="Type of meat")]
        [string] $meatType
    )

    #**Give me bacon from - baconipsum.com
    Write-Host "#*#Give me bacon from - baconipsum.com"

    $response = ""

    try {
        $queryURL = ("https://baconipsum.com/api/?type={0}&paras={1}&start-with-lorem=1&format=text" -f $meatType, $meatParas)
        
        $response = Invoke-RestMethod -Uri $queryURL -ContentType "application/json; charset=utf-8" -Method Post -UseBasicParsing
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Host "**ERROR: #*#Give me bacon"
        Write-Error $ErrorMessage
    }

    return $response
}
