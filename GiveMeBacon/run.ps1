using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Output "****Give me bacon from - baconipsum.com"

$response = ""

try {
    $queryURL = "https://baconipsum.com/api/?type=all-meat&paras=3&start-with-lorem=1&format=text"
    $response = Invoke-RestMethod -Uri $queryURL -ContentType "application/json; charset=utf-8" -Method Post -UseBasicParsing
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Output "**ERROR: *Give me bacon"
    Write-Error $ErrorMessage
}

if ($response) {
    Write-Output ("Response: " + $response)

    # We have Bacon!
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body = $response
    })
}
else {
    # Where's the Bacon?
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::NoContent
    })
}
