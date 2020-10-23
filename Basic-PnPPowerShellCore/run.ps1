using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Basic-PnPPowerShellCore example program
Write-Host "Basic-PnPPowerShellCore example program."
Write-Host " "

$connClientId = $env:ConnClientId
$connSecret = $env:ConnSecret
$siteURL = "https://mikkokoskinen.sharepoint.com/sites/PnPPowerShellCore"

$response = ""

try {
    Connect-PnPOnline -Url https://mikkokoskinen-admin.sharepoint.com -ClientId $connClientId -ClientSecret $connSecret

    $ctx = Get-PnPContext

    $response = $ctx.Url

    Disconnect-PnPOnline
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host "**ERROR: *Basic-PnPPowerShellCore"
    Write-Error $ErrorMessage
}

if ($response) {
    Write-Host ("Response: " + $response)

    # Site details found!
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body = $response
    })
}
else {
    # No site details found
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::NoContent
    })
}

