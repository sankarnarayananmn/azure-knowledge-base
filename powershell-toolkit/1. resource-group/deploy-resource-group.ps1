# Import parameters from JSON file
$params = Get-Content -Path "parameters.json" | ConvertFrom-Json

# Convert tags from JSON object to hashtable
$tagHashtable = @{}
$params.tags.PSObject.Properties | ForEach-Object { $tagHashtable[$_.Name] = $_.Value }

# Ensure we have at least 5 tags
if ($tagHashtable.Count -lt 5) {
    Write-Error "At least 5 tags are required. Please update your parameters file."
    exit 1
}

# Login to Azure (you'll need to authenticate in the popup window)
Connect-AzAccount

# Create the resource group with tags
New-AzResourceGroup -Name $params.resourceGroupName -Location $params.location -Tag $tagHashtable

# Verify the resource group was created along with tags
$resourceGroup = Get-AzResourceGroup -Name $params.resourceGroupName
Write-Output "Resource Group created with the following tags:"
$resourceGroup.Tags