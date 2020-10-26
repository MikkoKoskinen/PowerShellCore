using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$newsTitle = $Request.Query.newsTitle
$newsBody = $Request.Query.newsBody
$meatParas = $Request.Query.meatParas
$meatType = $Request.Query.meatType

#***Create SharePoint News Development
Write-Host " "
Write-Host "***Create SharePoint News Development"

#App internal parameters
$username = $env:O365UserName
$password = $env:O365Password
[System.Security.SecureString]$password = $password | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
$siteURL = $env:O365DemoURL
$haveMainParameters = $false

#Get custom modules
$SP_ModulePath = $PSScriptRoot + "\CustomModules"
Import-Module "$SP_ModulePath\EnterpiseAPI.psm1" -Force

#Open the necessary connections
try {
    #Connect to SharePoint
    Write-Host " "
    Write-Host "*Connect to SharePoint"

    $spConn = Connect-PnPOnline -Url $siteURL -Credentials $credential -ReturnConnection
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host "**ERROR: *Connect to SharePoint"
    Write-Error $ErrorMessage
}

#Check the parameters necessary for the application
Write-Host " "
Write-Host "*Check the parameters necessary for the application"
If($spConn -and $newsTitle -and $newsBody -and $meatParas -and $meatType){
    #Parameters are available
    $haveMainParameters = $true
}
else {
    #Missign some parameters
    $haveMainParameters = $false
}

#Main program section
If($haveMainParameters){
    try {
        Write-Host " "
        Write-Host "*Create the new page"

        #Create basic section
        Write-Host "..create basic section"

        $newsPage = Add-PnPClientSidePage -Name $newsTitle -PromoteAs NewsArticle -Connection $spConn
        Add-PnPClientSideText -Page $newsPage -Text $newsBody -Connection $spConn

        #Connect to enterpise service
        $baconText = GiveMeBacon -meatParas $meatParas -meatType $meatType
    
        #Add related section
        Write-Host "..add related section"

        Add-PnPClientSidePageSection -Page $newsPage -SectionTemplate OneColumn -ZoneEmphasis 2 -Connection $spConn
        Add-PnPClientSideText -Page $newsPage -Column 1 -Section 2 -Text "<h3>Related Info</h3>" -Connection $spConn

        Add-PnPClientSideText -Page $newsPage -Column 1 -Section 2 -Text $baconText -Connection $spConn
        
        #Add related section
        Write-Host "..publish the page"
        Set-PnPClientSidePage -Identity $newsPage -Publish -Connection $spConn
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Host "**ERROR: *Create SharePoint News"
        Write-Error $ErrorMessage
    }
}

#Close the possible connections
try {
    #SharePoint Connection
    Disconnect-PnPOnline -Connection $spConn
}
catch {

}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = "Bacon SharePoint New Published"
})
