param (
    [Parameter(Mandatory=$true)]
    [string]$TenantId,

    [Parameter(Mandatory=$true)]
    [string]$AppClientId,

    [Parameter(Mandatory=$true)]
    [string]$AppPassword,
    
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory = $true)]
    [string]$Appservice
)

# ===== Create needed Variables from script Parameters

$securePassword = ConvertTo-SecureString $AppPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($AppClientId, $securePassword)

# ===== Connect to Azure

Connect-AzAccount -ServicePrincipal -Credential $credential -Tenant $TenantId

# ===== Utils

function Is-TrafficRuleSet
{
  Get-AzWebAppTrafficRouting -ResourceGroupName $ResourceGroup -WebAppName $AppService -RuleName $slotBaseName -erroraction 'silentlycontinue'
}

# ===== Operations

try
{
  $slots = Get-AzWebAppSlot -ResourceGroupName $ResourceGroup -Name $AppService -erroraction 'Stop'
}
catch
{
  Write-Error '$ResourceGroup or $Appservice does not exist'
  exit
}

try
{
  $slot = $slots[0]
}
catch
{
  Write-Error 'No slot were found on $AppService'
  exit
}

$slotBaseName = ($slot.Name -split '/')[1]

if (-not(Is-TrafficRuleSet))
{
  echo "traffic rule not set. Setting now..."
  Add-AzWebAppTrafficRouting -ResourceGroupName $ResourceGroup -WebAppName $AppService -RoutingRule @{ActionHostName=$slot.DefaultHostName ; ReroutePercentage='100' ; Name=$slotBaseName}
}

if (Is-TrafficRuleSet)
{
  echo "Traffic Rule OK."
}
else
{
  echo "error setting traffic rule!"
  exit
}

