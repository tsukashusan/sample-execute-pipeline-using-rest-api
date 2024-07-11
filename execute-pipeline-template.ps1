$script:apiUrl = "https://api.fabric.microsoft.com/v1"
$script:resourceUrl = "https://api.fabric.microsoft.com" 
$script:fabricToken = $null
$script:if = @{
    "List-Workspaces" = @("GET", "workspaces");
    "List-Data-Pipelines" = @("GET", "workspaces/{0}/dataPipelines");
    "Run-On-Demand-Item-Job" = @("POST", "workspaces/{0}/items/{1}/jobs/instances?jobType={2}")
}

Connect-AzAccount
$script:fabricToken = (Get-AzAccessToken -ResourceUrl $script:resourceUrl).Token


$fabricHeaders = @{
    'Content-Type'  = "application/json; charset=utf-8"
    'Authorization' = "Bearer {0}" -f $script:fabricToken
}
$key = "List-Workspaces"
$s = (Invoke-WebRequest -Uri "${script:apiUrl}/$(${script:if}[${key}][1])" `
                 -Headers $fabricHeaders `
                 -Method $script:if[${key}][0]).Content

Write-Output ($s | ConvertFrom-Json).value -NoEnumerate


#id          : ★
#displayName : xxxxx
#description : 
#type        : Workspace
#capacityId  : xxxxx
$key = "List-Data-Pipelines"
$workspaceId = "★"
$s = (Invoke-WebRequest -Uri "${script:apiUrl}/$(${script:if}[${key}][1] -f ${workspaceId})" `
                -Headers $fabricHeaders `
                -Method $script:if[${key}][0]).Content
Write-Output ($s | ConvertFrom-Json).value -NoEnumerate

#id          : ☆
#type        : DataPipeline
#displayName : lake2warehouse
#description : 
#workspaceId : xxxx

$key = "Run-On-Demand-Item-Job"
$workspaceId = "★"
$itemId = "☆"
$jobType = "Pipeline"
Invoke-WebRequest -Uri "${script:apiUrl}/$(${script:if}[${key}][1] -f ${workspaceId}, ${itemId}, ${jobType})" `
                -Headers $fabricHeaders `
                -Method $script:if[${key}][0]