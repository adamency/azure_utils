param (
    #[Parameter(Mandatory=$true)]
    #[string]$TenantId,

    #[Parameter(Mandatory=$true)]
    #[string]$AppClientId,

    #[Parameter(Mandatory=$true)]
    #[string]$AppPassword,
    
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory = $true)]
    [string]$Appservice
)

$app_service_json = $(az webapp config appsettings list -g $ResourceGroup -n $Appservice -o json)

$num_elements = $(echo $app_service_json | jq '. | length' -)

echo "{"
for ($i = 0 ; $i -lt $num_elements ; $i ++)
{
  $name = $(echo $app_service_json | jq "  .[$i].name" -)
  $value = $(echo $app_service_json | jq "  .[$i].value" -)
  if ($i -eq ($num_elements - 1))
  {
    echo "${name}: ${value}"
  }
  else
  {
    echo "${name}: ${value},"
  }
}
echo "}"
