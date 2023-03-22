Param(
    [Parameter(Mandatory = $true)]
    # Azure Organization
    [string]$Organization,
    [Parameter(Mandatory = $true)]
    # Azure Project
    [string]$Project,
    [Parameter(Mandatory = $true)]
    # Personal Access Token with Read access to the Azure API
    [string]$StartBuild,
    [Parameter(Mandatory = $true)]
    # Personal Access Token with Read access to the Azure API
    [string]$EndBuild,
    [Parameter(Mandatory = $true)]
    # Personal Access Token with Read access to the Azure API
    [string]$BuildPersonalAccessToken
)

# Work Items
# https://learn.microsoft.com/en-us/rest/api/azure/devops/build/builds/get-work-items-between-builds?view=azure-devops-rest-7.0
# Commits
# https://learn.microsoft.com/en-us/rest/api/azure/devops/build/builds/get-changes-between-builds?view=azure-devops-rest-7.0

# ===== FUNCTIONS =====

function Create-BasicAuthHeader {
    # Create HTTP header with authentication via the personal access token for HTTP Request to the Azure API
    Param(
        [Parameter(Mandatory = $true)]
        # Personal Access Token with Read access to the Azure API
        [string]$PersonalAccessToken
    )
    $Auth = "Boiler Plate:$PersonalAccessToken"
    $Auth = [System.Text.Encoding]::UTF8.GetBytes($Auth)
    $Auth = [System.Convert]::ToBase64String($Auth)
    $Header = @{Authorization = ("Basic {0}" -f $Auth) }
    $Header
}

function Http-Get {
    # Send Authenticated HTTP Get Request to specified URL
    Param(
        [Parameter(Mandatory = $true)]
        [string]$url
    )
    Write-Host "Get resource: $url"
    return (Invoke-WebRequest -Uri $url -Headers (Create-BasicAuthHeader $BuildPersonalAccessToken) -UseBasicParsing -Method Get).Content;
}

function Get-WorkItemsBetweenBuilds {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$StartBuild,
        [Parameter(Mandatory = $true)]
        [string]$EndBuild
    )
    $latestBuildResponse = Http-Get -url ("https://dev.azure.com/$Organization/$Project/_apis/build/workitems?fromBuildId={0}&toBuildId={1}&api-version=7.0" -f $StartBuild , $EndBuild ) | ConvertFrom-Json

    #if (-Not $latestBuildResponse.value.id) {
        #Write-Error "Failed to get the latest build id";
        ##exit 2
    #}

    return $latestBuildResponse
}

# ===== WORK =====

Get-WorkItemsBetweenBuilds $StartBuild $EndBuild
